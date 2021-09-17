Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D5040FA7D
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343801AbhIQOme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50889 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244786AbhIQOm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 22FEF5C0039;
        Fri, 17 Sep 2021 10:41:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 17 Sep 2021 10:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=DBEJzUDOaGSBgbiqu7unRQ7qCihUgz9H///DUtD+Bwo=; b=O+zhk0Ei
        sOO9JAyVtK0lm3hsn5w5fFMtnygxUnMOh+COHIrZq+qo0k6cxwopCZIvv3uD0A/+
        Hzzrk2MKqvo6rc4Gr1jndCZkKzOg8NNF/NO+tblqx4tNP5pVUsJ1+mhB9DMkOK4E
        hA5xf2S+SR04jFjZOen+95WOSnPE8igiWlxnmYnXMgeBpZ5+iAaRXq8VZhu5BbWZ
        8T4RVxCx5V0oPyPQ7r7+fQ7+fm3ItXvIbIPpFEb3Y1apjbf6PfFRG0sjPTUlFm8d
        VhPFBl8h5CRLujSdNPXiJ3DONgkB1h+0MUsdTxbwjdBRkwbfvgN/oe1h/bwo5VE8
        gdN9Vkran65iaw==
X-ME-Sender: <xms:A6lEYdZDXTVfO60SF4hH6ky_DK5jnfIZ-2ClSggyePg74Q3SB5Yq3g>
    <xme:A6lEYUZC5uiNZjKEylMaLybRbxPYuZ9aD1xo3ylZOZuPLcci22gq-zL7FZzUFk_cM
    4v9qrKNYY4ieWQ>
X-ME-Received: <xmr:A6lEYf9zfc29nsHwEF1yhfdRaZazg67LEcjr-s85lRRVGYVTVIkULJfX6CEbfs2IYRf4mt2VhcXbu_gn-RbrRBzDFliB_r6Izg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:A6lEYbrpmIrgarT4lQXMaCQyI2ZJ118b6ScTyj9NYzImmMXjJ0NhNw>
    <xmx:A6lEYYpk1GTWWFG3ideCQHzwOm70BsolLmO0A47LLbweJe_e_nHHFQ>
    <xmx:A6lEYRRn4ZwZomr2q0Yub24HR9lbwj1EM-XqLw0O_7EQLvC874PYbQ>
    <xmx:A6lEYRnTDEM7aIF0nDlHeBq-B-q-_QeJzifylMCmZIXlFvTeew5WsA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:41:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 3/7] cmis: Correct comment
Date:   Fri, 17 Sep 2021 17:40:39 +0300
Message-Id: <20210917144043.566049-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The file is concerned with CMIS support, not QSFP-DD which is the
physical form factor.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmis.c b/cmis.c
index 7fa7da87a92a..b85250a96a95 100644
--- a/cmis.c
+++ b/cmis.c
@@ -1,7 +1,7 @@
 /**
  * Description:
  *
- * This module adds QSFP-DD support to ethtool. The changes are similar to
+ * This module adds CMIS support to ethtool. The changes are similar to
  * the ones already existing in qsfp.c, but customized to use the memory
  * addresses and logic as defined in the specification's document.
  *
-- 
2.31.1

