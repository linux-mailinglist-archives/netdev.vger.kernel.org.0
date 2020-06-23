Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5347920562C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733109AbgFWPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732977AbgFWPjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:39:55 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E12C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:39:54 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 22so2550347wmg.1
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 08:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9ozNhUdhTvoDo2UDE/WIR6fJuBHsCc1YFhc4yTa3xM=;
        b=XQTkjdNVdRu3QtuwwbKoABMuENO7Mkfjn9WBzUQ+/tHgp0ZmZHFYwUMV06NW0nxmEr
         qrM8NVtviiHVX1LnjtHB/OV9zlLZFyNoWwXiq3i/OdltX01HAFxViMkjU5i9gn5OvZUB
         XfugnODZxO7YTCK75d4Yn93Gg+0KueyyGPkrmWNbVrixKcGzCyd3P7i+8ml6CDC+IjaN
         /S8ocZwgEfSiM437sJLK818CcaU3CX7EVtC/zZFtoBoBXXl/LSEJTXYINT5xFThqp8Ws
         QiQ51/dfvZyZ4v0rwJ/YPUlOyN6/NwXlBzriwNc9ozq+WRI9qjTDQi9GGkpfddUJr9oh
         lOrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D9ozNhUdhTvoDo2UDE/WIR6fJuBHsCc1YFhc4yTa3xM=;
        b=oD01ozh/A0x+fekXQC0jHqPEbcdf6UUK+K1vjz5fzKwvgLHFUcV9BNIFfOMjaBFM+7
         f7K/3ez3P7cBI9w0xHePJGkbnTa1IF3suFUO4YN51L2cbraXnbUM3wFGmsLzt4UUzYmv
         o/zD9NwsWq2MuMwv3oTuKieCZObhFJAa4dXADPwy7kb5z9qoyyYThWgyXwy+Ada9BZD5
         oE0rZhpcQrUK/p5Dpoi3guoOvQcsutH7lUJSu+m9YZwySKOQ+6uHgwKGSfRPuREOf6no
         S9qSPeSvsnt7tTLF+Ly/qQnFG21tJNkkEXRuktKDxh/J9VBeoWIsUktq5Vkc9UY+6Dvj
         azBA==
X-Gm-Message-State: AOAM530QAt0tMYhJirnNnTyj8L84mdLHw9YCPGzPsp49C2i9tIo8x4MK
        bnjHBhdG0kYqY5SoSkPexZpdkw==
X-Google-Smtp-Source: ABdhPJwTVRx1uQKeadWlbGeCtkA0hLxkH0Fs1zv2RSql0K4biwZQMI07KsIi2jmGYOqR7AwV2+BEWg==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr24474689wmg.88.1592926793024;
        Tue, 23 Jun 2020 08:39:53 -0700 (PDT)
Received: from localhost.localdomain ([194.53.184.63])
        by smtp.gmail.com with ESMTPSA id l17sm4310662wmi.16.2020.06.23.08.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 08:39:52 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf] bpf: fix formatting in documentation for BPF helpers
Date:   Tue, 23 Jun 2020 16:39:35 +0100
Message-Id: <20200623153935.6215-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When producing the bpf-helpers.7 man page from the documentation from
the BPF user space header file, rst2man complains:

    <stdin>:2636: (ERROR/3) Unexpected indentation.
    <stdin>:2640: (WARNING/2) Block quote ends without a blank line; unexpected unindent.

Let's fix formatting for the relevant chunk (item list in
bpf_ringbuf_query()'s description), and for a couple other functions.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 include/uapi/linux/bpf.h | 41 ++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 974a71342aea..8bd33050b7bb 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3171,13 +3171,12 @@ union bpf_attr {
  * int bpf_ringbuf_output(void *ringbuf, void *data, u64 size, u64 flags)
  * 	Description
  * 		Copy *size* bytes from *data* into a ring buffer *ringbuf*.
- * 		If BPF_RB_NO_WAKEUP is specified in *flags*, no notification of
- * 		new data availability is sent.
- * 		IF BPF_RB_FORCE_WAKEUP is specified in *flags*, notification of
- * 		new data availability is sent unconditionally.
+ * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
+ * 		of new data availability is sent.
+ * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent unconditionally.
  * 	Return
- * 		0, on success;
- * 		< 0, on error.
+ * 		0 on success, or a negative error in case of failure.
  *
  * void *bpf_ringbuf_reserve(void *ringbuf, u64 size, u64 flags)
  * 	Description
@@ -3189,20 +3188,20 @@ union bpf_attr {
  * void bpf_ringbuf_submit(void *data, u64 flags)
  * 	Description
  * 		Submit reserved ring buffer sample, pointed to by *data*.
- * 		If BPF_RB_NO_WAKEUP is specified in *flags*, no notification of
- * 		new data availability is sent.
- * 		IF BPF_RB_FORCE_WAKEUP is specified in *flags*, notification of
- * 		new data availability is sent unconditionally.
+ * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
+ * 		of new data availability is sent.
+ * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent unconditionally.
  * 	Return
  * 		Nothing. Always succeeds.
  *
  * void bpf_ringbuf_discard(void *data, u64 flags)
  * 	Description
  * 		Discard reserved ring buffer sample, pointed to by *data*.
- * 		If BPF_RB_NO_WAKEUP is specified in *flags*, no notification of
- * 		new data availability is sent.
- * 		IF BPF_RB_FORCE_WAKEUP is specified in *flags*, notification of
- * 		new data availability is sent unconditionally.
+ * 		If **BPF_RB_NO_WAKEUP** is specified in *flags*, no notification
+ * 		of new data availability is sent.
+ * 		If **BPF_RB_FORCE_WAKEUP** is specified in *flags*, notification
+ * 		of new data availability is sent unconditionally.
  * 	Return
  * 		Nothing. Always succeeds.
  *
@@ -3210,16 +3209,18 @@ union bpf_attr {
  *	Description
  *		Query various characteristics of provided ring buffer. What
  *		exactly is queries is determined by *flags*:
- *		  - BPF_RB_AVAIL_DATA - amount of data not yet consumed;
- *		  - BPF_RB_RING_SIZE - the size of ring buffer;
- *		  - BPF_RB_CONS_POS - consumer position (can wrap around);
- *		  - BPF_RB_PROD_POS - producer(s) position (can wrap around);
- *		Data returned is just a momentary snapshots of actual values
+ *
+ *		* **BPF_RB_AVAIL_DATA**: Amount of data not yet consumed.
+ *		* **BPF_RB_RING_SIZE**: The size of ring buffer.
+ *		* **BPF_RB_CONS_POS**: Consumer position (can wrap around).
+ *		* **BPF_RB_PROD_POS**: Producer(s) position (can wrap around).
+ *
+ *		Data returned is just a momentary snapshot of actual values
  *		and could be inaccurate, so this facility should be used to
  *		power heuristics and for reporting, not to make 100% correct
  *		calculation.
  *	Return
- *		Requested value, or 0, if flags are not recognized.
+ *		Requested value, or 0, if *flags* are not recognized.
  *
  * int bpf_csum_level(struct sk_buff *skb, u64 level)
  * 	Description
-- 
2.20.1

