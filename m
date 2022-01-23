Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85651497483
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 19:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239838AbiAWSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 13:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbiAWSkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 13:40:43 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E1BC061744;
        Sun, 23 Jan 2022 10:40:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id bg19-20020a05600c3c9300b0034565e837b6so10686219wmb.1;
        Sun, 23 Jan 2022 10:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q/0EoSGGxiZheENQx8vu+lEDidbqKZoQ7scM3xHmiOA=;
        b=O+Kf5RiyxUVhGdsbQVZkzdwZxWyWQcgnYMidtGRdVSKwvn9hsvnL26XNnfUOEx0t6P
         vLngeNLWKbOgtvxDbU9J0UpLObOekcz1gGjK4ROw1uXnyaienlOHg2DFyK5OUjNKgLZC
         bo/mPjBkwfYqVFXiW9lHLj65C55ugenwZ6TcjgQgb0EKFlPh29aSXJsv+f2QVZ9q7Gxf
         EGMCxxqCdw01ov7xwhV2nSQUCMrDbLf218+7eNcpPPtz4ngZfAK+gL8DVnMcM1RArTu8
         lAz8Om1roMz9czYHZQ7iRPRjrsBYAXS+jZq0sVlplhR7VKUw5PxMJwgu1exr04tjHmI7
         Wh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q/0EoSGGxiZheENQx8vu+lEDidbqKZoQ7scM3xHmiOA=;
        b=FADSu6GiYBWPpTr9T8taL8q6/u6ragO5HmbOMG9P8ANWESQxsGOIpGOabKDFehYYoJ
         uv4tPJfw5cTfm495FuT0IouwQf1ENe4ope6ZgrqVrEa4y+HGqibpNuBvtqu1Pb2bZ1VI
         RaQLyy6MNdz2hfHOydABA9OJzV9KfhePegvYuz7mYd3oPPqinlXl2wzsK+4sSsHYB/VD
         9b5UnSHP8Is47RM3lTy6hDaObLgJVXSQTYPe6X83NkU7WXWCk9IEsjRUUQyk5rzlFYhU
         862x+PXh/fJnOeHtBPa57sgP4Okdym7f1OJpzTuyPTzSNUfrS6l9VubsF4ufFxDhw/Xj
         BRLQ==
X-Gm-Message-State: AOAM531zM4CQvBJIcFtz3ijllUNfHr0+htIYkoMeOAigqzU8RmLbtAgS
        9OdfNlqSZTYlkTUEG4uf/gw=
X-Google-Smtp-Source: ABdhPJwwrWFNQAMgjIlpLcOihRvDCG3iOlaR6bE951uOm6yRBbo5Oyhd8NWqdd0Ip6SYmqGCCaZo5Q==
X-Received: by 2002:a7b:cf31:: with SMTP id m17mr8741032wmg.183.1642963236844;
        Sun, 23 Jan 2022 10:40:36 -0800 (PST)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id n15sm9938604wrf.37.2022.01.23.10.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 10:40:36 -0800 (PST)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: asix: remove redundant assignment to variable reg
Date:   Sun, 23 Jan 2022 18:40:35 +0000
Message-Id: <20220123184035.112785-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable reg is being masked however the variable is never read
after this. The assignment is redundant and can be removed.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/net/usb/asix_devices.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 4514d35ef4c4..9b72334aabb6 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -858,7 +858,6 @@ static int marvell_phy_init(struct usbnet *dev)
 		reg = asix_mdio_read(dev->net, dev->mii.phy_id,
 			MII_MARVELL_LED_CTRL);
 		netdev_dbg(dev->net, "MII_MARVELL_LED_CTRL (2) = 0x%04x\n", reg);
-		reg &= 0xfc0f;
 	}
 
 	return 0;
-- 
2.33.1

