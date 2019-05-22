Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFE25BD2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbfEVB5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:57:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40323 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVB5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 21:57:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id k24so530957qtq.7
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 18:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kg1n8ch+1wA87OiEFAfI96fJso57ZzvAcXPwSbk3CDs=;
        b=GT2AKWEfX6hgbYppPRalLvYaBlB9pDFfry4iNGNUbbfaPWZl1Splw2r7Q1jUexDVoU
         3NXLLzRqzy/vd0LKdc2NgjTJghosysi3Ev+xTU3A2rDQPAVx+w71di1oefzCIftMfdX2
         JfbKp9bb5zUlxAnUZwnTDBQWnzZLzM6gQQNFejTfTwtU69LzRwI6zlQv5wDSf6C2Wfdq
         rxrjMZSONm7LeEt8/GZOpbl31IM9S2eK46TrFvXxiYibODVVNOqD4ysc+vbOdVMiq70T
         rmQ/xu1GqtFwoE+NBzBw/9GSuCmqF+cFBu1S7nqeBxZyisf/86LxAiLmUAOb7t9xDqZS
         +Tag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kg1n8ch+1wA87OiEFAfI96fJso57ZzvAcXPwSbk3CDs=;
        b=hmMsWegJzT418swsoRPqrPiTResB2LpzpWl7AIUTpZp+11V/aIvW8RSTZKRfsF4AO6
         wxkmYfz3q6+xRfgN8dijyrhz2wbc0C++p6wpL3vxuR3ujf10ZN9R+BijEXvtpQQo+wsr
         9nbtQW+xO2AODAtIBWRjbAZcVm2qefCQjB/THpM+jEJQNUPaW+5nagrN3qeVUzxOJF/w
         soj6G6AZafPjw/vR7NIs3m/woMxYAq30eMVhWzGJqgTuD6EnlECU2+sfbJ0mbmyFh1QL
         jn5s3byHehM+aUnPWXX7/HkgBponzOR6czBZGO6MQbDZ5e7TBXnZpgTG671iiwN3BqjO
         n1Mw==
X-Gm-Message-State: APjAAAUNM46nZ+qGiwC9bOBwyWgeTFPmyhqkreyCcijA6KAy3uZduCNB
        +Dwq9R3XczptOMAePtGOnymSUw==
X-Google-Smtp-Source: APXvYqzMcfE60h4snOuEJWYdugSoMhH2X/y2FZyOnvxSU3FIGMlO55u32KA60/smF1zZ7ouCiJpuBw==
X-Received: by 2002:ac8:5549:: with SMTP id o9mr71859797qtr.386.1558490249296;
        Tue, 21 May 2019 18:57:29 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l16sm9614901qtj.60.2019.05.21.18.57.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 18:57:28 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net v2 2/3] Documentation: tls: RSTify the ktls documentation
Date:   Tue, 21 May 2019 18:57:13 -0700
Message-Id: <20190522015714.4077-3-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522015714.4077-1-jakub.kicinski@netronome.com>
References: <20190522015714.4077-1-jakub.kicinski@netronome.com>
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

