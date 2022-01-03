Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613F648370B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235874AbiACSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbiACSgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1458C061799;
        Mon,  3 Jan 2022 10:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dkBtKqpQqy6FnXC+2071cnCfXFMaEXuDdAHnYiHoYDg=; b=e5AdriocHOagnC/Eihbz09ZKkt
        XdK4/K8wZN/umkcRnPF8zeqN/fACqB+gMLjOWcJ/9xMrL6xo9I0+k+QvpFLCSKnn6/nZsVZsb/FuX
        XA6iOYX8ine9/je/8KuhTUmbnIsjdRzRhIE1bUK8VKfJPLmQeCPIvm7EAGSTcazXKX5B93gfhIRYo
        tSzBALnesvisyQXjM70UQ5+F0zj005Gdk6qJFeNvRXZpVsrXKhTrcJtv7TSEkANI9/NRe7pzGHdg9
        D+ZUydXf34XNwIcJOaWBWnQT7Ol5jZ20RJHgI1Pq+tY+DBOLuTdZIG18wR7QN/ivbLtthayhK6HtH
        Ua/ZUrQw==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBl-009qSE-9c; Mon, 03 Jan 2022 18:36:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 3/6] bpf, docs: Document the opcode classes
Date:   Mon,  3 Jan 2022 19:35:53 +0100
Message-Id: <20220103183556.41040-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description for each opcode class.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 03bf3c6c55771..2987cbb07f7f6 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -38,18 +38,18 @@ Instruction classes
 
 The three LSB bits of the 'opcode' field store the instruction class:
 
-  ========= =====
-  class     value
-  ========= =====
-  BPF_LD    0x00
-  BPF_LDX   0x01
-  BPF_ST    0x02
-  BPF_STX   0x03
-  BPF_ALU   0x04
-  BPF_JMP   0x05
-  BPF_JMP32 0x06
-  BPF_ALU64 0x07
-  ========= =====
+  =========  =====  ===============================
+  class      value  description
+  =========  =====  ===============================
+  BPF_LD     0x00   non-standard load operations
+  BPF_LDX    0x01   load into register operations
+  BPF_ST     0x02   store from immediate operations
+  BPF_STX    0x03   store from register operations
+  BPF_ALU    0x04   32-bit arithmetic operations
+  BPF_JMP    0x05   64-bit jump operations
+  BPF_JMP32  0x06   32-bit jump operations
+  BPF_ALU64  0x07   64-bit arithmetic operations
+  =========  =====  ===============================
 
 Arithmetic and jump instructions
 ================================
-- 
2.30.2

