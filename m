Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6757631D38E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbhBQBJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:09:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhBQBJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364DAC061574;
        Tue, 16 Feb 2021 17:08:30 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z7so6498834plk.7;
        Tue, 16 Feb 2021 17:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vA7yf0zk+T/kB8pnBChx/NJnOYZDQH1veo7XbeOKZhg=;
        b=SYS1iA85ZA6CTQnNjd1kT0S7tKOPvrWT5jfcqRekx8PY7g0esCw/OGukvmYuOZcYlA
         98VnNk79O3XfWIzcyXz4aYqL6siGdPzgAH6lu7bKKRosbbA3u4HWuMlpw8DvfMZ8MdvY
         zc4Z879xdDgaEqGlWJvT8ytlLKyV4El5ZSE9fgf4JE//9N6jtf8w2/67o+avlFI6Um3y
         WHi0vd+XXfuUau7DYX8kuz2IvpwnTRLZ+f+hit2yrtG7PTNJM9Zl6UNhXYyaPuqYBPGM
         Ebvzg5nCQ14R5Wxt4ebdZvpJB1WM9soacfHh1ul/fjbciTSCst+8uJx5b7YVFUYFkNDy
         Wx3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vA7yf0zk+T/kB8pnBChx/NJnOYZDQH1veo7XbeOKZhg=;
        b=muSrxyTEjt+FM48zeKhDn+eQ9qz+HZAh7DNR6C38rj7y3RUnFPvd2CCXyLGBfgnPRu
         xsmRayZ2ig1uDPy02gtgAOsHjhVHutnYbyDCRMZweV404JfBztDiPCUKkfV7QjaS9Mfg
         NrwDWMXuQHX+2GmpaGyS9ksjrZRtqdHDYnCL1rOX1bNIhGvsUkvTWkw0Djs8YIB2uxYK
         a4mF3/Gjf7/sGbrezQCkVgpYGP3Ow2gmNjN4vLCfqWwDfz74r2k6NTrbnIvhcOa4GpVF
         2qdXAVlGo5IB3eZxMbqwdBWujCP21kKD1A81nZ4WByFMkDBh1aCcM+mGVNETNKy5uRB2
         9ozQ==
X-Gm-Message-State: AOAM533ZEgrENX4h0tu4397iNSVJxkUx1Kw81eILuVN1HnH5n3Fw9FrR
        fLaziePdoBlEmt/HiHpgmw1RSKrJnsq0fA==
X-Google-Smtp-Source: ABdhPJxP/4NPeq90Q/Bm7YXAygVT/vf/FljHYezElmVReu02o328iYnecKlVaROM/6rfOi8qZfMzTg==
X-Received: by 2002:a17:902:8349:b029:df:d13d:bf83 with SMTP id z9-20020a1709028349b02900dfd13dbf83mr180546pln.69.1613524109369;
        Tue, 16 Feb 2021 17:08:29 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:28 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 01/17] bpf: Import syscall arg documentation
Date:   Tue, 16 Feb 2021 17:08:05 -0800
Message-Id: <20210217010821.1810741-2-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

These descriptions are present in the man-pages project from the
original submissions around 2015-2016. Import them so that they can be
kept up to date as developers extend the bpf syscall commands.

These descriptions follow the pattern used by scripts/bpf_helpers_doc.py
so that we can take advantage of the parser to generate more up-to-date
man page writing based upon these headers.

Some minor wording adjustments were made to make the descriptions
more consistent for the description / return format.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Co-authored-by: Alexei Starovoitov <ast@kernel.org>
Co-authored-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 include/uapi/linux/bpf.h | 119 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4c24daa43bac..56d7db0f3daf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -93,7 +93,124 @@ union bpf_iter_link_info {
 	} map;
 };
 
-/* BPF syscall commands, see bpf(2) man-page for details. */
+/* BPF syscall commands, see bpf(2) man-page for more details.
+ *
+ * The operation to be performed by the **bpf**\ () system call is determined
+ * by the *cmd* argument. Each operation takes an accompanying argument,
+ * provided via *attr*, which is a pointer to a union of type *bpf_attr* (see
+ * below). The size argument is the size of the union pointed to by *attr*.
+ *
+ * Start of BPF syscall commands:
+ *
+ * BPF_MAP_CREATE
+ *	Description
+ *		Create a map and return a file descriptor that refers to the
+ *		map. The close-on-exec file descriptor flag (see **fcntl**\ (2))
+ *		is automatically enabled for the new file descriptor.
+ *
+ *		Applying **close**\ (2) to the file descriptor returned by
+ *		**BPF_MAP_CREATE** will delete the map (but see NOTES).
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * BPF_MAP_LOOKUP_ELEM
+ *	Description
+ *		Look up an element with a given *key* in the map referred to
+ *		by the file descriptor *map_fd*.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_UPDATE_ELEM
+ *	Description
+ *		Create or update an element (key/value pair) in a specified map.
+ *
+ *		The *flags* argument should be specified as one of the
+ *		following:
+ *
+ *		**BPF_ANY**
+ *			Create a new element or update an existing element.
+ *		**BPF_NOEXIST**
+ *			Create a new element only if it did not exist.
+ *		**BPF_EXIST**
+ *			Update an existing element.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		May set *errno* to **EINVAL**, **EPERM**, **ENOMEM**,
+ *		**E2BIG**, **EEXIST**, or **ENOENT**.
+ *
+ *		**E2BIG**
+ *			The number of elements in the map reached the
+ *			*max_entries* limit specified at map creation time.
+ *		**EEXIST**
+ *			If *flags* specifies **BPF_NOEXIST** and the element
+ *			with *key* already exists in the map.
+ *		**ENOENT**
+ *			If *flags* specifies **BPF_EXIST** and the element with
+ *			*key* does not exist in the map.
+ *
+ * BPF_MAP_DELETE_ELEM
+ *	Description
+ *		Look up and delete an element by key in a specified map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ * BPF_MAP_GET_NEXT_KEY
+ *	Description
+ *		Look up an element by key in a specified map and return the key
+ *		of the next element. Can be used to iterate over all elements
+ *		in the map.
+ *
+ *	Return
+ *		Returns zero on success. On error, -1 is returned and *errno*
+ *		is set appropriately.
+ *
+ *		The following cases can be used to iterate over all elements of
+ *		the map:
+ *
+ *		* If *key* is not found, the operation returns zero and sets
+ *		  the *next_key* pointer to the key of the first element.
+ *		* If *key* is found, the operation returns zero and sets the
+ *		  *next_key* pointer to the key of the next element.
+ *		* If *key* is the last element, returns -1 and *errno* is set
+ *		  to **ENOENT**.
+ *
+ *		May set *errno* to **ENOMEM**, **EFAULT**, **EPERM**, or
+ *		**EINVAL** on error.
+ *
+ * BPF_PROG_LOAD
+ *	Description
+ *		Verify and load an eBPF program, returning a new file
+ *		descriptor associated with the program.
+ *
+ *		Applying **close**\ (2) to the file descriptor returned by
+ *		**BPF_PROG_LOAD** will unload the eBPF program (but see NOTES).
+ *
+ *		The close-on-exec file descriptor flag (see **fcntl**\ (2)) is
+ *		automatically enabled for the new file descriptor.
+ *
+ *	Return
+ *		A new file descriptor (a nonnegative integer), or -1 if an
+ *		error occurred (in which case, *errno* is set appropriately).
+ *
+ * NOTES
+ *	eBPF objects (maps and programs) can be shared between processes.
+ *	For example, after **fork**\ (2), the child inherits file descriptors
+ *	referring to the same eBPF objects. In addition, file descriptors
+ *	referring to eBPF objects can be transferred over UNIX domain sockets.
+ *	File descriptors referring to eBPF objects can be duplicated in the
+ *	usual way, using **dup**\ (2) and similar calls. An eBPF object is
+ *	deallocated only after all file descriptors referring to the object
+ *	have been closed.
+ */
 enum bpf_cmd {
 	BPF_MAP_CREATE,
 	BPF_MAP_LOOKUP_ELEM,
-- 
2.27.0

