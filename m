Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D44F2E93A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 01:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfE2XZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 19:25:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49136 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfE2XYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 19:24:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GuRApsTHKHRm35pYDPJVOOpxLQPAfK9zSYMx81HUKXE=; b=MbDfc3XdcpZjOoZSr+ZRM1zxYz
        lZGU489ttKjY+QRV4zlBaMZrDhQwHYdNiMRNezRDKxh8aXYsaSXtIEJx79iUMbc7oPPk9IWG0Rfm4
        3/YaBAEkXDQozUp9eyCxfR+iqfNapR/9MBCE1GV0ti1E3aBzeZwr7bKlLxm6IDyj+dEM0SltjW6f1
        bfqhJmJqn17Vf2ehOFhaCfL/G638neZQpNK0go4gR0nGuOzB8uYDW9RZS3kzOpW8AvZB5dAR/GvR5
        YmJxKgcWOHUov4djDnKrMEAEkpKc3ZffrNE3Vils2X9JSVu8FmkkGTzWZm3cPSkAf4GAsiZdJa+AK
        8SXiXF6Q==;
Received: from 177.132.232.81.dynamic.adsl.gvt.net.br ([177.132.232.81] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hW7vL-0005Rg-3g; Wed, 29 May 2019 23:23:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hW7vI-0007xE-Mh; Wed, 29 May 2019 20:23:56 -0300
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
Subject: [PATCH 08/22] docs: bpf: get rid of two warnings
Date:   Wed, 29 May 2019 20:23:39 -0300
Message-Id: <f2f40f306acbd3d834746fe9acb607052e82a1ee.1559171394.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559171394.git.mchehab+samsung@kernel.org>
References: <cover.1559171394.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation/bpf/btf.rst:154: WARNING: Unexpected indentation.
Documentation/bpf/btf.rst:163: WARNING: Unexpected indentation.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/bpf/btf.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 8820360d00da..4ae022d274ab 100644
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

