Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E4846F904
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhLJCUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235682AbhLJCUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:20:02 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8692BC0617A1;
        Thu,  9 Dec 2021 18:16:28 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id q17so5280603plr.11;
        Thu, 09 Dec 2021 18:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vILFs48YezHx1KEwLGCib1UaqUg6sXTypNHDs6lRMU=;
        b=eiqFaXAarweFPC8NhoXEwTojVq4rWX4qebgApsWYRS1DuxkzFu0rc2InlX6t96oMnY
         OO3w1Ps444oZSDf2FdRWmNBG2Y4UTWbaMkYq7z8GCE/alhBkGiniSJlyj/2ihXjPF0/d
         WGaB7hbQkmLZ4SL3HcJemGY59Ss3PoK3ntBYtNecuKtVvA7Ox/ULUYBA6XchFUf0ITSg
         Q+3vudZ0kYwjatotD5kF2CEoAHesSkPANPfww8akj3Q5vgrEwZBvxrv3YZn3ZHWmGx9M
         /3QCilV1OJ75lV+ZvMs64tdhSOsrYw93cvH4bmqnvVx7V8GQv9WTXKz3QJDD7cup7Nrz
         RycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vILFs48YezHx1KEwLGCib1UaqUg6sXTypNHDs6lRMU=;
        b=xAzEZPm8dHLqqLzMhJk0Lf18bZHNsm9HVEzzh8vYaj97QPMna9ituPUDsZeVCSv1Ho
         5HWolakwIRybLnwucyt/7cVInHWYiwMpJuYTq5t+nFEqlzYRoN3KYGKAB9ur2U33t5UD
         aQ+VTwjD2NnYTrYdath4T92KXm1YKCesu7MEPsrTwpXyphT8uxj8FsLw4UP/WG7uhrud
         cOu/NarUTzjTYSpVFR9B0mpwwpqU5siPE8eg8WK1z0fTc7xfdlTMKLuCSODkl3yMqdwy
         5eHH7f8PzQoWKhsGTvrpwJpGHakwYLt/wegaz6awNIRp+fuQgooFbtYT9uf6ydO5abik
         DCOQ==
X-Gm-Message-State: AOAM531XC+nhPfauPI3+0ROW6NO1XaRURiOD8vsn4XsCkfNbNtbssl/9
        wvwI3F7pCAREGFeM0IP05mM=
X-Google-Smtp-Source: ABdhPJwUMCRYs3n4NOa/dkaQR5MswxyDQZgwr2M8ahQsaJ7v5ONdW09RA2CV5KuXw5Hxx/KuhGlWgw==
X-Received: by 2002:a17:90b:1a88:: with SMTP id ng8mr19786360pjb.180.1639102588155;
        Thu, 09 Dec 2021 18:16:28 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id lr6sm935264pjb.0.2021.12.09.18.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:16:27 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     sgoutham@marvell.com
Cc:     lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] ethernet:octeontx2:remove unneeded variable
Date:   Fri, 10 Dec 2021 02:16:21 +0000
Message-Id: <20211210021621.423665-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return status directly from function called.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 2ca182a4ce82..05694cd5ed15 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -815,12 +815,10 @@ int rvu_mbox_handler_cgx_features_get(struct rvu *rvu,
 u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 {
 	struct mac_ops *mac_ops;
-	u32 fifo_len;
 
 	mac_ops = get_mac_ops(rvu_first_cgx_pdata(rvu));
-	fifo_len = mac_ops ? mac_ops->fifo_len : 0;
 
-	return fifo_len;
+	return mac_ops ? mac_ops->fifo_len : 0;
 }
 
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
-- 
2.25.1

