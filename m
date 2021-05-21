Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746AD38C7F6
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhEUN2E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbhEUN1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:27:34 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD3CC061344
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:54 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id f18so301936ejq.10
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 06:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=50Utje+lwICfZ7DSSa634bw91I/MdeDUooc9Pjb8Qd4=;
        b=p/Qj866/b6CFR7FAI8FUXoNfii9//Svpr4+X6d8N2Y67esPijjXUsrLWh53OBtfBLy
         yb64KFcAe87vzCbHr8H3Sbr4ltrJTWFiTMkiZyvL5tCYu/pVqRWPdlY3hjXarZ1yuHtr
         j6vYkiokcU+BdqNxyHlhpu94Dj10qirhy2faXs7yGpQKlq1mEN9E7NG27zgr+JikWRkc
         WEhs1naAXcWsFFLweCrQ0CPvwJWCD3c1HlF23dH1IfGJVN/nOPs8XE27Ysc74bnogZqF
         XTHeyIwfOzB3JWN2VMX9UVYbNFIt+0UYDo4NvGYmQ09U5Q55KhFY7o/pigP+S5X1fKGW
         Pptg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=50Utje+lwICfZ7DSSa634bw91I/MdeDUooc9Pjb8Qd4=;
        b=VM+FeoH1kCTqW1Sz+H4Ni2JyNsKHkAyWGHS7iQWR1Yi+SiOOMoLF2v5bOjAPzlNTl7
         78zMDjRPO8Q56EqVO/JDRtS/DSHawG4VnyHg2F9o7RtTCjkoelVbWm4+vurEKItgtg1D
         Ydi60xADjjCHNaE3nympMUQ74JeT1xJtNCwIhrqd5Azk2QAjcKAiIfgch2SzQX38wUs7
         FczUmG1mkx1VNe15+iZUZIX2iA7mnwuQuD1UxIZHOznnnD/sQdN8hxIgdQ1s0ZGT6Kcy
         c9UytecLXpqxk8YCBMKOdV43R2g53e6BuipBAgxb3A001Bz8lR8R7D6WGrknNtZpm6a6
         cKBA==
X-Gm-Message-State: AOAM530SRNwF3n/xdlgY+MLxZbMsq23tLeXoZsVJ07I4mJVB3Rinr0V1
        3nhAq6gDO13RL3lxkh8bFh4=
X-Google-Smtp-Source: ABdhPJyxIHHq/QkhHfxwDs9CNNItOn02jaZp3ajCSPQQ8vFMNpFmIcRqyx61rtKaz22G7xa3mJWdPg==
X-Received: by 2002:a17:906:2b8c:: with SMTP id m12mr7041089ejg.358.1621603553248;
        Fri, 21 May 2021 06:25:53 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id s21sm3950439edy.23.2021.05.21.06.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 06:25:52 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/2] dpaa2-eth: name the debugfs directory after the DPNI object
Date:   Fri, 21 May 2021 16:25:30 +0300
Message-Id: <20210521132530.2784829-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210521132530.2784829-1-ciorneiioana@gmail.com>
References: <20210521132530.2784829-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Name the debugfs directory after the DPNI object instead of the netdev
name since this can be changed after probe by udev rules.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index b87db0846e10..8356af4631fd 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -121,10 +121,14 @@ DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_ch);
 
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
+	struct fsl_mc_device *dpni_dev;
 	struct dentry *dir;
+	char name[10];
 
 	/* Create a directory for the interface */
-	dir = debugfs_create_dir(priv->net_dev->name, dpaa2_dbg_root);
+	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
+	snprintf(name, 10, "dpni.%d", dpni_dev->obj_desc.id);
+	dir = debugfs_create_dir(name, dpaa2_dbg_root);
 	priv->dbg.dir = dir;
 
 	/* per-cpu stats file */
-- 
2.31.1

