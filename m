Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0CD1FB97
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 22:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfEOUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 16:41:49 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46420 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfEOUlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 16:41:47 -0400
Received: by mail-qk1-f193.google.com with SMTP id a132so849535qkb.13
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 13:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kg1n8ch+1wA87OiEFAfI96fJso57ZzvAcXPwSbk3CDs=;
        b=0xAz5jjrdhYxpnLQDq8EiefBoCmkYBU4l99wUeIsQmah2bF2sD5dtCF4s0cjlZGneo
         eEN8VdC3XCpZOYy2HrGRp8BmYh/OFRBz9bFBTSt0nkOplpRHAqDXK8szIAt6OKf52by6
         VoUCtO5I9z0pYoIDMIiKvA7/NsaSCMVIzk7ZxL4HyChaNOUje96flT9tHq9gTpYKiNKw
         iOD65Ol4V7hviOTXIUVAHbjt0T6M+XqShZcQhuVFH22vEEFLEHW9Cb418mZO6UrFcF+7
         x2CdRyObYVcOsRfyviNJ7KjXXyAR3DA6ScOWvHLrvYIe8C+A1SJ9dEy9fsJ0j66jdvkc
         Ak4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kg1n8ch+1wA87OiEFAfI96fJso57ZzvAcXPwSbk3CDs=;
        b=b56Zl0/8tQbUgorQiNe98SrIqFDszPIJJwLJ9Cr0bldoPkDSSZBZbS3S60dw317Yia
         2uZA3nEd8MXdG/SXo2HiTizMkOaPxvPCJbKTkgCt3mCumLFvEAbJLSCASwdqY0lwYA81
         ZcfoVlXwVXA1iXLr5HchJqwvfwjmfuc2R2KQeKYtkhiUu4DVMdtPgsjEeT6fcS4TATIM
         U+zZ4iH0ilHw0ZNM+9bsEIqxMCBvO5q5PKAVnSrbYwyofNRNNtM+1rbdaGZEIWoxXJr8
         eHIurq1txpsCs96n6wslAmC0JRuKdHvfrBbYYkcwMCuBpb65dMOKQRaGyJF8jM2dPKYa
         lUSA==
X-Gm-Message-State: APjAAAVfJ5mWu4clY+EvI/XdDg8an7dVo99GH5LhNq/O7+vW5eJ8lnK1
        I4lHEGVOS3VeChaoEJEf43SgtA==
X-Google-Smtp-Source: APXvYqzn8zBNRP2VestCSaQwT3mOx76TLPXIe5oN1kG908iKqKTpBYwbCJFo9RiyujVzwhuCi0jBvw==
X-Received: by 2002:a05:620a:16b4:: with SMTP id s20mr35369224qkj.34.1557952906483;
        Wed, 15 May 2019 13:41:46 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t6sm1732172qkt.25.2019.05.15.13.41.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 13:41:45 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net 2/3] Documentation: tls: RSTify the ktls documentation
Date:   Wed, 15 May 2019 13:41:22 -0700
Message-Id: <20190515204123.5955-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515204123.5955-1-jakub.kicinski@netronome.com>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the TLS doc to RST.  Use C code blocks for the code
samples, and mark hyperlinks.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Dave Watson <davejwatson@fb.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 Documentation/networking/{tls.txt => tls.rst} | 42 +++++++++++++------
 2 files changed, 30 insertions(+), 13 deletions(-)
 rename Documentation/networking/{tls.txt => tls.rst} (88%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 7a2bfad6a762..f0f97eef091c 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -28,6 +28,7 @@ Linux Networking Documentation
    checksum-offloads
    segmentation-offloads
    scaling
+   tls
 
 .. only::  subproject
 
diff --git a/Documentation/networking/tls.txt b/Documentation/networking/tls.rst
similarity index 88%
rename from Documentation/networking/tls.txt
rename to Documentation/networking/tls.rst
index 58b5ef75f1b7..482bd73f18a2 100644
--- a/Documentation/networking/tls.txt
+++ b/Documentation/networking/tls.rst
@@ -1,3 +1,7 @@
+==========
+Kernel TLS
+==========
+
 Overview
 ========
 
@@ -12,6 +16,8 @@ Creating a TLS connection
 
 First create a new TCP socket and set the TLS ULP.
 
+.. code-block:: c
+
   sock = socket(AF_INET, SOCK_STREAM, 0);
   setsockopt(sock, SOL_TCP, TCP_ULP, "tls", sizeof("tls"));
 
@@ -21,6 +27,8 @@ handshake is complete, we have all the parameters required to move the
 data-path to the kernel. There is a separate socket option for moving
 the transmit and the receive into the kernel.
 
+.. code-block:: c
+
   /* From linux/tls.h */
   struct tls_crypto_info {
           unsigned short version;
@@ -58,6 +66,8 @@ After setting the TLS_TX socket option all application data sent over this
 socket is encrypted using TLS and the parameters provided in the socket option.
 For example, we can send an encrypted hello world record as follows:
 
+.. code-block:: c
+
   const char *msg = "hello world\n";
   send(sock, msg, strlen(msg));
 
@@ -67,6 +77,8 @@ to the encrypted kernel send buffer if possible.
 The sendfile system call will send the file's data over TLS records of maximum
 length (2^14).
 
+.. code-block:: c
+
   file = open(filename, O_RDONLY);
   fstat(file, &stat);
   sendfile(sock, file, &offset, stat.st_size);
@@ -89,6 +101,8 @@ After setting the TLS_RX socket option, all recv family socket calls
 are decrypted using TLS parameters provided.  A full TLS record must
 be received before decryption can happen.
 
+.. code-block:: c
+
   char buffer[16384];
   recv(sock, buffer, 16384);
 
@@ -97,12 +111,12 @@ large enough, and no additional allocations occur.  If the userspace
 buffer is too small, data is decrypted in the kernel and copied to
 userspace.
 
-EINVAL is returned if the TLS version in the received message does not
+``EINVAL`` is returned if the TLS version in the received message does not
 match the version passed in setsockopt.
 
-EMSGSIZE is returned if the received message is too big.
+``EMSGSIZE`` is returned if the received message is too big.
 
-EBADMSG is returned if decryption failed for any other reason.
+``EBADMSG`` is returned if decryption failed for any other reason.
 
 Send TLS control messages
 -------------------------
@@ -113,9 +127,11 @@ These messages can be sent over the socket by providing the TLS record type
 via a CMSG. For example the following function sends @data of @length bytes
 using a record of type @record_type.
 
-/* send TLS control message using record_type */
+.. code-block:: c
+
+  /* send TLS control message using record_type */
   static int klts_send_ctrl_message(int sock, unsigned char record_type,
-                                  void *data, size_t length)
+                                    void *data, size_t length)
   {
         struct msghdr msg = {0};
         int cmsg_len = sizeof(record_type);
@@ -151,6 +167,8 @@ type passed via cmsg.  If no cmsg buffer is provided, an error is
 returned if a control message is received.  Data messages may be
 received without a cmsg buffer set.
 
+.. code-block:: c
+
   char buffer[16384];
   char cmsg[CMSG_SPACE(sizeof(unsigned char))];
   struct msghdr msg = {0};
@@ -186,12 +204,10 @@ Integrating in to userspace TLS library
 At a high level, the kernel TLS ULP is a replacement for the record
 layer of a userspace TLS library.
 
-A patchset to OpenSSL to use ktls as the record layer is here:
-
-https://github.com/Mellanox/openssl/commits/tls_rx2
-
-An example of calling send directly after a handshake using
-gnutls.  Since it doesn't implement a full record layer, control
-messages are not supported:
+A patchset to OpenSSL to use ktls as the record layer is
+`here <https://github.com/Mellanox/openssl/commits/tls_rx2>`_.
 
-https://github.com/ktls/af_ktls-tool/commits/RX
+`An example <https://github.com/ktls/af_ktls-tool/commits/RX>`_
+of calling send directly after a handshake using gnutls.
+Since it doesn't implement a full record layer, control
+messages are not supported.
-- 
2.21.0

