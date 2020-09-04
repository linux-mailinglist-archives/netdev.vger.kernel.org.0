Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362DF25DF9A
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgIDQPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgIDQPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:15:05 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A43C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:15:04 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so7314556wrm.2
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BBYLUoYlj8u523gup0UCdQOvwoIvjJKPEyrX8VuLejU=;
        b=NpGUsgc7fT5ls21oLp+qt2TjtIDc1LZECdzqThtnsyWmwpmuwahZVDJYS45FWRZLaM
         RmkXLxiKrHXp07sjDVAzvZeqZT69Mx6IATZ8ihHoSCgY5PrsgC8PI96rJnEmHpbr5HQ5
         Qj5Eswl7whb/h7LUr4QA7ARWfEXdvCciXoymEpMIrDe7yhwf7cj76U+fzaOogosor7d/
         FF03vg8XWUTaifRptgXyrQ48DTKJp/PzMsAr+fN1DL91Ub/+iq5ZCv97Yz27Iv8dI7ir
         7TX4qlV5Bze5IxWWPQRb13s8HMj5dRo212DrbM+xhjaZJVdgxn42v9bOXmzMB2gX8XTR
         8cJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BBYLUoYlj8u523gup0UCdQOvwoIvjJKPEyrX8VuLejU=;
        b=ehKhmKP4vm8MCesG2a9xH4jk4MS5MyMTxGuOek1FdjCG5eSz89GvCIBcMy7W/hA0Bg
         DGQcLnaomUXb4ckTVvDk+RcefXvMaDV6QK+I7ZUNb2Ne61apLlQb9VoPzuQ6K8EwgCmb
         Js5cWC527FqrKE141TDkMRaLC8jQZqtB3zlrx8GnAbqGwQNxRQUOWbFyY570EdU9S4JC
         dBxLrWQI1BfhuvGW1XpmuC2+0eNCxbLtMG2ZSeKM3Rp6Wp5n+2t9wrVdT3FTI+wAbNhs
         hktbuw90PRWiCXLmafnyvbJty/Usb3U4bCt0CqMonYlujHoBr+cnNEuY3zHwJZF8JxoB
         tSfQ==
X-Gm-Message-State: AOAM533aSf1ifBrmCttpNRUPIcJL33z2QPPqc5lSzWG+HcL121cn3gGa
        yhFtyJnXrJ7L2fB+TUr9qZmPvQ==
X-Google-Smtp-Source: ABdhPJwbLzI1TkL6B/iHqWlZx9LYEP2Zxrud+YfY4kfdLH0Vc7Vii5Hfsz0qzY6DpXtnqVIGDpGoig==
X-Received: by 2002:adf:e6c8:: with SMTP id y8mr9071208wrm.229.1599236102986;
        Fri, 04 Sep 2020 09:15:02 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.187])
        by smtp.gmail.com with ESMTPSA id p1sm28859352wma.0.2020.09.04.09.15.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:15:02 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 2/3] bpf: fix formatting in documentation for BPF helpers
Date:   Fri,  4 Sep 2020 17:14:53 +0100
Message-Id: <20200904161454.31135-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200904161454.31135-1-quentin@isovalent.com>
References: <20200904161454.31135-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a formatting error in the description of bpf_load_hdr_opt() (rst2man
complains about a wrong indentation, but what is missing is actually a
blank line before the bullet list).

Fix and harmonise the formatting for other helpers.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 include/uapi/linux/bpf.h | 87 +++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8dda13880957..90359cab501d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3349,38 +3349,38 @@ union bpf_attr {
  *	Description
  *		Dynamically cast a *sk* pointer to a *tcp6_sock* pointer.
  *	Return
- *		*sk* if casting is valid, or NULL otherwise.
+ *		*sk* if casting is valid, or **NULL** otherwise.
  *
  * struct tcp_sock *bpf_skc_to_tcp_sock(void *sk)
  *	Description
  *		Dynamically cast a *sk* pointer to a *tcp_sock* pointer.
  *	Return
- *		*sk* if casting is valid, or NULL otherwise.
+ *		*sk* if casting is valid, or **NULL** otherwise.
  *
  * struct tcp_timewait_sock *bpf_skc_to_tcp_timewait_sock(void *sk)
  * 	Description
  *		Dynamically cast a *sk* pointer to a *tcp_timewait_sock* pointer.
  *	Return
- *		*sk* if casting is valid, or NULL otherwise.
+ *		*sk* if casting is valid, or **NULL** otherwise.
  *
  * struct tcp_request_sock *bpf_skc_to_tcp_request_sock(void *sk)
  * 	Description
  *		Dynamically cast a *sk* pointer to a *tcp_request_sock* pointer.
  *	Return
- *		*sk* if casting is valid, or NULL otherwise.
+ *		*sk* if casting is valid, or **NULL** otherwise.
  *
  * struct udp6_sock *bpf_skc_to_udp6_sock(void *sk)
  * 	Description
  *		Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
  *	Return
- *		*sk* if casting is valid, or NULL otherwise.
+ *		*sk* if casting is valid, or **NULL** otherwise.
  *
  * long bpf_get_task_stack(struct task_struct *task, void *buf, u32 size, u64 flags)
  *	Description
  *		Return a user or a kernel stack in bpf program provided buffer.
  *		To achieve this, the helper needs *task*, which is a valid
- *		pointer to struct task_struct. To store the stacktrace, the
- *		bpf program provides *buf* with	a nonnegative *size*.
+ *		pointer to **struct task_struct**. To store the stacktrace, the
+ *		bpf program provides *buf* with a nonnegative *size*.
  *
  *		The last argument, *flags*, holds the number of stack frames to
  *		skip (from 0 to 255), masked with
@@ -3410,12 +3410,12 @@ union bpf_attr {
  * long bpf_load_hdr_opt(struct bpf_sock_ops *skops, void *searchby_res, u32 len, u64 flags)
  *	Description
  *		Load header option.  Support reading a particular TCP header
- *		option for bpf program (BPF_PROG_TYPE_SOCK_OPS).
+ *		option for bpf program (**BPF_PROG_TYPE_SOCK_OPS**).
  *
  *		If *flags* is 0, it will search the option from the
- *		sock_ops->skb_data.  The comment in "struct bpf_sock_ops"
+ *		*skops*\ **->skb_data**.  The comment in **struct bpf_sock_ops**
  *		has details on what skb_data contains under different
- *		sock_ops->op.
+ *		*skops*\ **->op**.
  *
  *		The first byte of the *searchby_res* specifies the
  *		kind that it wants to search.
@@ -3435,7 +3435,7 @@ union bpf_attr {
  *		[ 254, 4, 0xeB, 0x9F, 0, 0, .... 0 ].
  *
  *		To search for the standard window scale option (3),
- *		the searchby_res should be [ 3, 0, 0, .... 0 ].
+ *		the *searchby_res* should be [ 3, 0, 0, .... 0 ].
  *		Note, kind-length must be 0 for regular option.
  *
  *		Searching for No-Op (0) and End-of-Option-List (1) are
@@ -3445,27 +3445,30 @@ union bpf_attr {
  *		of a header option.
  *
  *		Supported flags:
+ *
  *		* **BPF_LOAD_HDR_OPT_TCP_SYN** to search from the
  *		  saved_syn packet or the just-received syn packet.
  *
  *	Return
- *		>0 when found, the header option is copied to *searchby_res*.
- *		The return value is the total length copied.
+ *		> 0 when found, the header option is copied to *searchby_res*.
+ *		The return value is the total length copied. On failure, a
+ *		negative error code is returned:
  *
- *		**-EINVAL** If param is invalid
+ *		**-EINVAL** if a parameter is invalid.
  *
- *		**-ENOMSG** The option is not found
+ *		**-ENOMSG** if the option is not found.
  *
- *		**-ENOENT** No syn packet available when
- *			    **BPF_LOAD_HDR_OPT_TCP_SYN** is used
+ *		**-ENOENT** if no syn packet is available when
+ *		**BPF_LOAD_HDR_OPT_TCP_SYN** is used.
  *
- *		**-ENOSPC** Not enough space.  Only *len* number of
- *			    bytes are copied.
+ *		**-ENOSPC** if there is not enough space.  Only *len* number of
+ *		bytes are copied.
  *
- *		**-EFAULT** Cannot parse the header options in the packet
+ *		**-EFAULT** on failure to parse the header options in the
+ *		packet.
  *
- *		**-EPERM** This helper cannot be used under the
- *			   current sock_ops->op.
+ *		**-EPERM** if the helper cannot be used under the current
+ *		*skops*\ **->op**.
  *
  * long bpf_store_hdr_opt(struct bpf_sock_ops *skops, const void *from, u32 len, u64 flags)
  *	Description
@@ -3483,44 +3486,44 @@ union bpf_attr {
  *		by searching the same option in the outgoing skb.
  *
  *		This helper can only be called during
- *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *		**BPF_SOCK_OPS_WRITE_HDR_OPT_CB**.
  *
  *	Return
  *		0 on success, or negative error in case of failure:
  *
- *		**-EINVAL** If param is invalid
+ *		**-EINVAL** If param is invalid.
  *
- *		**-ENOSPC** Not enough space in the header.
- *			    Nothing has been written
+ *		**-ENOSPC** if there is not enough space in the header.
+ *		Nothing has been written
  *
- *		**-EEXIST** The option has already existed
+ *		**-EEXIST** if the option already exists.
  *
- *		**-EFAULT** Cannot parse the existing header options
+ *		**-EFAULT** on failrue to parse the existing header options.
  *
- *		**-EPERM** This helper cannot be used under the
- *			   current sock_ops->op.
+ *		**-EPERM** if the helper cannot be used under the current
+ *		*skops*\ **->op**.
  *
  * long bpf_reserve_hdr_opt(struct bpf_sock_ops *skops, u32 len, u64 flags)
  *	Description
  *		Reserve *len* bytes for the bpf header option.  The
- *		space will be used by bpf_store_hdr_opt() later in
- *		BPF_SOCK_OPS_WRITE_HDR_OPT_CB.
+ *		space will be used by **bpf_store_hdr_opt**\ () later in
+ *		**BPF_SOCK_OPS_WRITE_HDR_OPT_CB**.
  *
- *		If bpf_reserve_hdr_opt() is called multiple times,
+ *		If **bpf_reserve_hdr_opt**\ () is called multiple times,
  *		the total number of bytes will be reserved.
  *
  *		This helper can only be called during
- *		BPF_SOCK_OPS_HDR_OPT_LEN_CB.
+ *		**BPF_SOCK_OPS_HDR_OPT_LEN_CB**.
  *
  *	Return
  *		0 on success, or negative error in case of failure:
  *
- *		**-EINVAL** if param is invalid
+ *		**-EINVAL** if a parameter is invalid.
  *
- *		**-ENOSPC** Not enough space in the header.
+ *		**-ENOSPC** if there is not enough space in the header.
  *
- *		**-EPERM** This helper cannot be used under the
- *			   current sock_ops->op.
+ *		**-EPERM** if the helper cannot be used under the current
+ *		*skops*\ **->op**.
  *
  * void *bpf_inode_storage_get(struct bpf_map *map, void *inode, void *value, u64 flags)
  *	Description
@@ -3560,9 +3563,9 @@ union bpf_attr {
  *
  * long bpf_d_path(struct path *path, char *buf, u32 sz)
  *	Description
- *		Return full path for given 'struct path' object, which
- *		needs to be the kernel BTF 'path' object. The path is
- *		returned in the provided buffer 'buf' of size 'sz' and
+ *		Return full path for given **struct path** object, which
+ *		needs to be the kernel BTF *path* object. The path is
+ *		returned in the provided buffer *buf* of size *sz* and
  *		is zero terminated.
  *
  *	Return
@@ -3573,7 +3576,7 @@ union bpf_attr {
  * long bpf_copy_from_user(void *dst, u32 size, const void *user_ptr)
  * 	Description
  * 		Read *size* bytes from user space address *user_ptr* and store
- * 		the data in *dst*. This is a wrapper of copy_from_user().
+ * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
  * 	Return
  * 		0 on success, or a negative error in case of failure.
  */
-- 
2.20.1

