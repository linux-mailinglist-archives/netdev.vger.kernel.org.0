Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0121FD682
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgFQU4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQU4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:44 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEC4C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:44 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so3844916wrc.7
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7epNvZJMbG2ofu+cuewkLi+otfIKq13XkaDiuiTtJho=;
        b=ZMqF0+zGMrJQrrIRId4B1/LfWieRsQ0G8lXCfoJv0de3qZtiMDvqMTqdb5uW2QKYw8
         xmMj+bQG6GNXvBxN2PC5xdDZsJlZinuree0eKuAVqvCqyJjvodyuIlMF95+oI2kzyppc
         faQAVRierwk23RQgQFXc6VgeN7kMarcWnUawnhIGsE3PdxAm5At9bx7jLuWiNh2bFw3j
         3azLm8KF7ykL/DruPQgVQZZnwnZUe2zAuIFrFlmGIu0ipjIn61FzAD4gvwdh+VPguouH
         ncjNzxN93fzrrsAfk7fErSgn4aDBbYugKR6RQwxr10sdHWNYwGvel1JIkFWQ73c3XZO4
         gl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7epNvZJMbG2ofu+cuewkLi+otfIKq13XkaDiuiTtJho=;
        b=Ox5BtTQftN2mZ/UEcm+Uk04wypAcQBVz5BSRT9Pr07D0NeVrs66Z198jDjdhQgyd93
         PGjNXUT1BNpzS7lYRk3QFYLfMlLk6AderwFsG7vLvO8b6YWLZIGk9fv1A/kikY8SoGC4
         4ivT0rE/gKoJ63294AVL8Hoo5yiHgY//g5L2RCFORQkYn9uIpHxIJQ9J8EivNB450A6G
         meFEWrwD3Kafc4kbgkfai59R3O3MLeS5pLQnZb9pd7OzXcox3BneLWN2bpYM+VRM2rjv
         ftflTdW2ZGZjJuNAssdjeh/1z7TZJ/n6GXzPM2H3ScYgQb2Pxp9ePzNwsuFqb+M1z/S4
         dYIQ==
X-Gm-Message-State: AOAM5326uk3WfVz12Rvcf75k8ECZe9AFxbRAt3BvdRnAahJ6BYijKaGW
        4NLqEMp6hZ6BICURJohlKnr3JGDL
X-Google-Smtp-Source: ABdhPJzGmUpo3hYxuzy+56b5Kl6pndfQGFQuppHbPiYQWK6BBf5p+MlSv24hlY0yg7BGUBUNBtyOlA==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr1025372wrx.133.1592427403114;
        Wed, 17 Jun 2020 13:56:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id p7sm866303wro.26.2020.06.17.13.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:42 -0700 (PDT)
Subject: [PATCH net-next 1/8] r8169: add info for DASH being enabled
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <e1385f3c-49d2-35f5-15d4-783cccf80ed5@gmail.com>
Date:   Wed, 17 Jun 2020 22:51:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of problems it facilitates the bug analysis if we know whether
DASH is active. Therefore emit a message in probe if this is the case.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dad84ecf5..7bb26fb07 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5432,8 +5432,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			    jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
 			    "ok" : "ko");
 
-	if (r8168_check_dash(tp))
+	if (r8168_check_dash(tp)) {
+		netdev_info(dev, "DASH enabled\n");
 		rtl8168_driver_start(tp);
+	}
 
 	if (pci_dev_run_wake(pdev))
 		pm_runtime_put_sync(&pdev->dev);
-- 
2.27.0


