Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9CE447AA5
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 07:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhKHHCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 02:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbhKHHCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 02:02:31 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4002FC061570
        for <netdev@vger.kernel.org>; Sun,  7 Nov 2021 22:59:47 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c8so41652691ede.13
        for <netdev@vger.kernel.org>; Sun, 07 Nov 2021 22:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koJuV+anaKzRo02V7w28WUDtF7aRFbAjSggml6U2+Xw=;
        b=GRDx9gRmeVycVmIPuiwjcDkvIdbk+22wqXYEGQq45H5mmr6E3vzKgpV5Yw/FwGGBWX
         9wLYEzolaxdBVJ5w3zYJwi0CbfgPcXBjKw++PO+Gyp6PNvK8XU41QoDAebl/bYtuf5MQ
         S1jbbeUsfs38S4hCzAnYhyJmZx49n7ObCS2SfpE8HFNGi0eJeWEeQPOtqsgjtblWvqUT
         EWsSnSy1tnJsUndemA1Hc3bvLibvZumxGE4Q5x1Meh4luu965BvAGkLwb+3M5/ZvWTrB
         QCSLV7nVPej7kBa5dFKvZr20lQjZeYHs3gmFOmPP29voQUJbEe7ZktLlY/86PUvcvIam
         9RQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=koJuV+anaKzRo02V7w28WUDtF7aRFbAjSggml6U2+Xw=;
        b=sytC0e9lcS3VGn06lyso2LFND8Ue+Q+BvouzlniUsfBNEdvAJZ+O4vzIPTp3eOe0Fr
         0ylgyYxRIpPIKUmcJi4jO3d9YDIz7sIxgsV3me6q6wfuuWRxou6/6yC4huQmJMdMVKCM
         74FReDQqVt5tvt+PosrJrrA8vTNGMDx/IN/85tvVjEE5gl8eXyLmewzjPL6Lqr+jZ3Uy
         K+AZIakeA40DhLUuM/JW4LAXqWSxkOaSblURk7vrrtNg3T2BlbHZbDzLnSpiPB9DQyRf
         M4SGQH4jA/0qpmvlGenhGMWYkozXJMUuNVwQXr4HS34t8cL3ytpnvPx+FfPVk8CEYDFC
         YFfg==
X-Gm-Message-State: AOAM532UQi4MtkUhMsU8gwvuMbeb9tZehrhEwgrGGJ4534iLGdYMS91i
        MRbZ4195mVHcGXf+fiFUCVc=
X-Google-Smtp-Source: ABdhPJzQdY+buQaTeBTkargwqqKCyHxevG3JI6VICwVPKrrBqSAdjH9tEKRcgTzGXKTl5AT8z3qxUw==
X-Received: by 2002:a17:906:2506:: with SMTP id i6mr93845869ejb.186.1636354785952;
        Sun, 07 Nov 2021 22:59:45 -0800 (PST)
Received: from localhost ([185.247.225.73])
        by smtp.gmail.com with ESMTPSA id bn20sm7589204ejb.5.2021.11.07.22.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 22:59:45 -0800 (PST)
From:   =?UTF-8?q?J=CE=B5an=20Sacren?= <sakiwit@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jens@de.ibm.com,
        jeff@garzik.org, linas@austin.ibm.com, arnd.bergmann@de.ibm.com,
        netdev@vger.kernel.org
Subject: [PATCH net] net: sungem_phy: fix code indentation
Date:   Sun,  7 Nov 2021 23:59:41 -0700
Message-Id: <20211108065941.2548-1-sakiwit@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jean Sacren <sakiwit@gmail.com>

Remove extra space in front of the return statement.

Fixes: eb5b5b2ff96e ("sungem_phy: support bcm5461 phy, autoneg.")
Signed-off-by: Jean Sacren <sakiwit@gmail.com>
---
 drivers/net/sungem_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 291fa449993f..4daac5fda073 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -409,7 +409,7 @@ static int genmii_read_link(struct mii_phy *phy)
 	 * though magic-aneg shouldn't prevent this case from occurring
 	 */
 
-	 return 0;
+	return 0;
 }
 
 static int generic_suspend(struct mii_phy* phy)
