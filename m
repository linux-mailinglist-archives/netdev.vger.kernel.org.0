Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF171783A1
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgCCUFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:05:21 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46145 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgCCUFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 15:05:21 -0500
Received: by mail-qk1-f194.google.com with SMTP id u124so4680767qkh.13;
        Tue, 03 Mar 2020 12:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BBmw/UX0VgIhrLNJLpPiyKyhv4geuqZ+eY7wOsUvtx4=;
        b=oF1uBcGjIEzdTF6dkCqJ6UKbUUQLUSBAKq4QYr8JsXqT3wFhUi6/yRRYGi9bmI58ps
         +6r5mYWiy46Pw6CcqPYlYt/CW51QTVg4VknaFE1mqmsmb0phz75wKLa/lsEBZJOtyU4g
         A0elYX5SuzfYOOHSITlyxrlNcsxcBsFn+T4svFRZQHK5fLO3eJ1DH7f2tWCJDNGTY5I1
         J1OVCZ5PH4JKc8q3pF4OE/vlnP1Z/TsTarRk4hyqBMoF6kuoXhwFcan2LU1Y5gFtG7lB
         k/vLIL/1UCIcHFks1VdOoppsdkFq5GhpjTkY+3bbTV8/CB32n1ELgpYIGpoZFmRHhFy4
         7A6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BBmw/UX0VgIhrLNJLpPiyKyhv4geuqZ+eY7wOsUvtx4=;
        b=CUnP/CFz2pUWyiuTeb1CAXFrPQ36ExGE0DgVRqrWD66dlYU/ajPYN3BJIcfFr05TSK
         D0zpclbve4GstMC9nxumL4tIBBsXuJjlPf5MpCZftwq39qS1JWMrYx5ekJqa4VlT6jUL
         1o2wazq+9vbs/KMOIyn1yBtobl1Wn5EPp6fcGbQVtdyKi5ivjXgRei/r3Qa7mzlN/wqI
         EZzo2K9tKhYl7M0vi6CF87niI5RgsCG8SM81J6nN1Ei0ptlm5pfsXzFYDsGjz0bzJIdr
         ZV+ho7iJS7qrVLo6VqXeNl11xacfkNcU3m1tL4654Y0ZTpQHOh1PGr/EY3mc/l3PnlL6
         EB+g==
X-Gm-Message-State: ANhLgQ2FuLT78Mr9iJl1QVLBT/9hD5acf3wRB04SLUfiwjhPJofs0cE5
        eYKHOE1xipI3eys6oVxMSaW9KNmn
X-Google-Smtp-Source: ADFU+vsZjmqtRHaYEreD+iBY933i5X6oFoca9/amTEaSNN3ADNvYD7JRd2AeRD2vtSWW3RNKo522KA==
X-Received: by 2002:a05:620a:21c9:: with SMTP id h9mr5775948qka.29.1583265920089;
        Tue, 03 Mar 2020 12:05:20 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id d7sm9846281qkg.62.2020.03.03.12.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 12:05:19 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
Date:   Tue,  3 Mar 2020 15:05:02 -0500
Message-Id: <20200303200503.226217-3-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
In-Reply-To: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
References: <20200303200503.226217-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

sync tools/include/uapi/linux/bpf.h to match include/uapi/linux/bpf.h

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/include/uapi/linux/bpf.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 906e9f2752db..7c689f4552dd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3176,6 +3176,7 @@ struct __sk_buff {
 	__u32 wire_len;
 	__u32 gso_segs;
 	__bpf_md_ptr(struct bpf_sock *, sk);
+	__u32 gso_size;
 };
 
 struct bpf_tunnel_key {
-- 
2.25.0.265.gbab2e86ba0-goog

