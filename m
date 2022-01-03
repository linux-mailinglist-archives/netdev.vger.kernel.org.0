Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70051483717
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbiACSgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235919AbiACSg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:36:29 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C43C061394;
        Mon,  3 Jan 2022 10:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bq5JLgDM3t8BkrOTMe1SQwbqoVsrqTMzIyC33K4R1uk=; b=oBkEjgAqF7FRXTYDvwnv1mpZzB
        DCxEujsulSn/6eHyj43SIeTXqIWRJHc+Oo89mSx9+Sa4aNiJ1bfNIsPq+pUTSbfF9SH/GRIzpwGtI
        gBD4eEGSuMpYffuAvFK7T4tclIOqvqx7i5tvwjh9lMp+UM2bEVtgGfhM4UORkx1snnFV8cipq4XG4
        YbuPaYUW2+KM3T+waONpNi0LnkmALB9dG6gEAiG6JjT9pjMavTB3p06YCuD6nGLa+BXnsBw2PROeM
        KKv0+YJZHZS54YAbaGjb4oV2hF1q0ZcwAcU0FOAwwMuNpX36Ec2nUXRFlV9LBdy7eG/SG7bYnV+Vu
        5SgD96gA==;
Received: from [2001:4bb8:184:3f95:b8f7:97d6:6b53:b9be] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4SBt-009qUs-Gv; Mon, 03 Jan 2022 18:36:18 +0000
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
Subject: [PATCH 6/6] bpf, docs: Fully document the JMP mode modifiers
Date:   Mon,  3 Jan 2022 19:35:56 +0100
Message-Id: <20220103183556.41040-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220103183556.41040-1-hch@lst.de>
References: <20220103183556.41040-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a description for all the modifiers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index 88e8d6a9195cd..3704836fe6df6 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -173,15 +173,15 @@ The size modifier is one of:
 
 The mode modifier is one of:
 
-  =============  =====  =====================
+  =============  =====  ====================================
   mode modifier  value  description
-  =============  =====  =====================
+  =============  =====  ====================================
   BPF_IMM        0x00   used for 64-bit mov
-  BPF_ABS        0x20
-  BPF_IND        0x40
-  BPF_MEM        0x60
+  BPF_ABS        0x20   legacy BPF packet access
+  BPF_IND        0x40   legacy BPF packet access
+  BPF_MEM        0x60   all normal load and store operations
   BPF_ATOMIC     0xc0   atomic operations
-  =============  =====  =====================
+  =============  =====  ====================================
 
 BPF_MEM | <size> | BPF_STX means::
 
-- 
2.30.2

