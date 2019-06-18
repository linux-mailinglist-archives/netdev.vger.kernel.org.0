Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00974A15A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbfFRNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:01:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43505 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728845AbfFRNA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:00:59 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so13008089ljv.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyxRHAwiW1X+AdyTZC4hhjZjc3nc+3Iv3di3JvLFcQU=;
        b=vPXWGUAziHI6OmtFWH7I43Z2cnFeQ1tCM9JgWySko4/RP6bnWfxujQNZz3qHPIcPsu
         LOUylHkuUjqF+6f/DMvebK6+td7+ZQ9DVkh/fS4pHyBf66SMNoRueU7DoX7yiVXmJxyk
         ewQt1421rY/+1kGXiVgF8fn+9pEV9D1OD/N2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyxRHAwiW1X+AdyTZC4hhjZjc3nc+3Iv3di3JvLFcQU=;
        b=ZJnLkSBCqOlaemVRNhcFcvf8me27I4yl935Vv2XQHMHeseDQsNuS9AQNIE9Q3CXJb0
         SgaqtAY94QdKhnh0XSNeSwq8vZiWs18CMb67nX68TIzoq4H31+LF0LoslMwC48KudhSj
         aN7fgT6goxnZAA65KeiFPe9y61H+f7lpKJ7MPxF3icHPiyQT/xO62jCeGwpDHpCB+mXt
         99hgb17u6AJP5GLW92M693GdRMmmKUO3K6HRQd4q/lbqFd5CYBABCo3MuIdtPsA2waIA
         tNJmMa6dB5h9B2hLWqO2P6Fhkl4gLYX6Xc3u6tS1NQ14CgW+OVWamK9iArQFOkzpRJYS
         ZihQ==
X-Gm-Message-State: APjAAAUN+tmcIQMpOo6YU8WqkYrJ6rApue1y1xpj2lwR6fefC/hjqIOA
        LBdJlAWV1DrsQrQmqqxgKc67sjAYyUXoqQ==
X-Google-Smtp-Source: APXvYqxHHc/J1lzFC6ni6K8Qnt0cLje9z/7OX1DkHv6EVQtmWbFzBu5ZZjw5C5IukhY2k2CADEfsaw==
X-Received: by 2002:a2e:760f:: with SMTP id r15mr46748015ljc.18.1560862857192;
        Tue, 18 Jun 2019 06:00:57 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id u22sm2880369ljd.18.2019.06.18.06.00.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:56 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC bpf-next 4/7] bpf: Sync linux/bpf.h to tools/
Date:   Tue, 18 Jun 2019 15:00:47 +0200
Message-Id: <20190618130050.8344-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newly added program and context type is needed for tests in subsequent
patches.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d0a23476f887..7776f36a43d1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_INET_LOOKUP,
 };
 
 enum bpf_attach_type {
@@ -192,6 +193,7 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_INET_LOOKUP,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3066,6 +3068,31 @@ struct bpf_tcp_sock {
 				 */
 };
 
+/* User accessible data for inet_lookup programs.
+ * New fields must be added at the end.
+ */
+struct bpf_inet_lookup {
+	__u32 family;
+	__u32 remote_ip4;	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip4;	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_ip6[4];	/* Allows 1,2,4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_ip6[4];	/* Allows 1,2,4-byte read and 4-byte write.
+				 * Stored in network byte order.
+				 */
+	__u32 remote_port;	/* Allows 4-byte read but no write.
+				 * Stored in network byte order.
+				 */
+	__u32 local_port;	/* Allows 4-byte read and write.
+				 * Stored in host byte order.
+				 */
+};
+
 struct bpf_sock_tuple {
 	union {
 		struct {
-- 
2.20.1

