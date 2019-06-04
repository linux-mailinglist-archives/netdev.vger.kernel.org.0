Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73984349E8
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfFDOSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:18:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52570 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbfFDOSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dhO3igvxIrcqM2bITRvLnPGN4GI5urZRLFU+88zCRl4=; b=CbxVc21JdLEkl0FXEV2FwrXHbE
        aK8sdLMTmQioUaiN5FMija5UFkoQqIuFVWCG/MDjmQkbP13PTElegFIY5obDo5hFHZKHutXYUNSiK
        M8sByLx38c/LyOcgNcMQn+eHslUqV8/PXmBmSqhkpiQum1Z7k9Vb9FEbiV5ND8VK5HLEJKAi6wTm+
        5j9Tp9BehAdbSBtHw5Kh6YzQoUTACOG4NjbDsy/QvtEZ3f6/6pu5BniJxuhS/MneESKh828Voiaik
        L4SgFCqwLOkt6FVRmNSC+cLLz/HQKhAvxIXvI+4iOJB2+nMtmKbx4K8ztiaPJCdOWTPLJM8+u3/gF
        CbuE0bRA==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Rp-Ud; Tue, 04 Jun 2019 14:18:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002kv-KM; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v2 05/22] docs: bpf: get rid of two warnings
Date:   Tue,  4 Jun 2019 11:17:39 -0300
Message-Id: <72cc48d5e25c9fb2b8729111db82abce8b25ee1b.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/bpf/btf.rst:154: WARNING: Unexpected indentation.
Documentation/bpf/btf.rst:163: WARNING: Unexpected indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
---
 Documentation/bpf/btf.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 35d83e24dbdb..4d565d202ce3 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -151,6 +151,7 @@ for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
 
 The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
 for this int. For example, a bitfield struct member has:
+
  * btf member bit offset 100 from the start of the structure,
  * btf member pointing to an int type,
  * the int type has ``BTF_INT_OFFSET() = 2`` and ``BTF_INT_BITS() = 4``
@@ -160,6 +161,7 @@ from bits ``100 + 2 = 102``.
 
 Alternatively, the bitfield struct member can be the following to access the
 same bits as the above:
+
  * btf member bit offset 102,
  * btf member pointing to an int type,
  * the int type has ``BTF_INT_OFFSET() = 0`` and ``BTF_INT_BITS() = 4``
-- 
2.21.0

