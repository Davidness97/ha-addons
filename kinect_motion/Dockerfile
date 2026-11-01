FROM debian:bookworm-slim

# Dipendenze di sistema e di compilazione
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cmake pkg-config \
    ca-certificates git \
    libusb-1.0-0-dev libturbojpeg0-dev \
    python3 python3-dev python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Compilazione libfreenect2 senza backend GPU e senza esempi
RUN git clone --depth 1 https://github.com/OpenKinect/libfreenect2.git /opt/libfreenect2 \
    && cmake -S /opt/libfreenect2 -B /opt/libfreenect2/build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DENABLE_OPENGL=OFF \
        -DENABLE_OPENCL=OFF \
        -DENABLE_CUDA=OFF \
        -DBUILD_EXAMPLES=OFF \
    && cmake --build /opt/libfreenect2/build --parallel 2 \
    && cmake --install /opt/libfreenect2/build \
    && ldconfig

# Ambiente Python dedicato
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:${PATH}"
ENV LIBFREENECT2_INSTALL_PREFIX=/usr/local
ENV LD_LIBRARY_PATH="/usr/local/lib:/usr/local/lib64"

RUN python3 -m venv /opt/venv \
    && python -m pip install --no-cache-dir \
        "pip<25" "setuptools<70" wheel \
    && python -m pip install --no-cache-dir \
        "numpy<2" "Cython<3" paho-mqtt

# Il setup del wrapper necessita di NumPy e Cython già disponibili
RUN python -m pip install --no-cache-dir --no-build-isolation \
    git+https://github.com/r9y9/pylibfreenect2.git

# Verifica dell'estensione Python e delle librerie native
RUN python -c "import numpy; import paho.mqtt.client; import pylibfreenect2"

WORKDIR /app
COPY run.sh motion.py /app/

RUN sed -i 's/\r$//' /app/run.sh /app/motion.py \
    && chmod a+x /app/run.sh

CMD ["/bin/bash", "/app/run.sh"]
