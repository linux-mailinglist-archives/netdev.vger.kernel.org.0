Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359B41D405C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgENVoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgENVoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:44:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00153C061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:44:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id v12so678963wrp.12
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0BU9fvGNvf/IPOYUbtuQn28WdfC/+aZc7ulxwRzESXk=;
        b=A0uAKBeaT3RjBNflH/dm/3hMYD6aS9cdOfNdBRilpmczazkwpcNQEEVK3xxyBRDQzJ
         iK9jSqls1vziG5CEzECKabpHCkzuMXagTCCgns+sUFmQhtIoGyzvPJqmQd0sXnoww0zp
         iS3Flh+Vvgd2ZcSGBDVi4sMVPWNwtDTKPhCEzMs15Xl+M0dfxdtExT1X8ZfHvcV3w4Ee
         xjrID3B+KG8f7rfDQofxmDe5OiyUu1y/eRDpV2k8q9XEHlGXRHkvppyDcXnJsYYA5PQx
         aWnXPUn3VVqjGoDkt7CItCq5x+QXZps6Bkm1ug/ELZq4fGp3PrXqFbxcKHLT+HsNcX4e
         bnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0BU9fvGNvf/IPOYUbtuQn28WdfC/+aZc7ulxwRzESXk=;
        b=R5wiy3mgKNzGj6jZ+ky0q6caHnduBwOwD9vEv9AoWws9ROUwF7CskwoofGmRMYn2T3
         tVGTA6OJ1pGR+hbl82Vd+k+xPfqVIo67Er/f8/vpCJ+K9Z9v+Et6iCBe9jTjbkEaKSuZ
         kGTydtCgB+qPRmPfSgHQIDvBiq0VMQzul2Z1vlkXQqS9ICNQdZJPRP/8JDVHnKaC9sOs
         UJR2POCS4eblv8YLzOoInXTcMfCJBKJW2zbxA4WJpaUuTf7eaPSgqbbNheGfAZOuxnwp
         7TsgAl9CNV7sz0/Wk7EcjxDJegoqGlrT8+R11NsbBVkirsAne+7hev8kS/1cq3J6/e/e
         5nXg==
X-Gm-Message-State: AOAM531kZn1Slm5kpzd5PqIa1GL6ZDQxNBMiqiX9kmcYH5LCBSkb+Wzi
        X9xZlxdVhu7cmxNqTn1E2FXPQ9eJ
X-Google-Smtp-Source: ABdhPJxcx7aQcBYG9FZzgzXcL8e+pd9cqfW+wrN91LyDrQPmVsIyH+ZZoTMdq0M6kaZROHuA0bHNWg==
X-Received: by 2002:a5d:490e:: with SMTP id x14mr450056wrq.375.1589492661485;
        Thu, 14 May 2020 14:44:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:44a3:4c94:7927:e2e6? (p200300EA8F28520044A34C947927E2E6.dip0.t-ipconnect.de. [2003:ea:8f28:5200:44a3:4c94:7927:e2e6])
        by smtp.googlemail.com with ESMTPSA id k13sm501794wmj.40.2020.05.14.14.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 14:44:21 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: r8169: don't include linux/moduleparam.h
Message-ID: <e3dab3ec-6ae9-ceeb-3277-2d84bf2ab93a@gmail.com>
Date:   Thu, 14 May 2020 23:44:07 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

93882c6f210a ("r8169: switch from netif_xxx message functions to
netdev_xxx") removed the last module parameter from the driver,
therefore there's no need any longer to include linux/moduleparam.h.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6c9a50958..97a7e27ff 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
2.26.2

