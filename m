Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6A11B6482
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgDWTeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbgDWTeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:34:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52A2C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:33:58 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e26so7768835wmk.5
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kalnmIkRf3NBE/i7SUoIwr0bcmOdnf8YawUYsWGtkxg=;
        b=BoU+3LHkC+aUi7JdthsBu92aQeBMIq7TyFuCY5l/4TimL31OFGsz2T/xXwSvgiS9Dy
         magCiR0vKS5axxY5F4dAVf7l9mZG0Tseog6u+0UkJLNz1MEIgKElCi0vfqLCp105gGRj
         4QI1UYD2L67JlLKVJIAXDethjv9EUL8+RIR1XuwwjzeNnbqE9ukTD/9DvoB7CubugLMG
         MeIyxtN2FqgMteGjMSYBs+bh4f9AbsXBEsV2klQ0cbz3//5oIv6rSVaAB+gpamvE65I4
         EK0Mi5wrJJLadXWZLROGdVXQxKOq/A52up2oaDk7lUV2cNC8se3Lp6gOkwKJW7k/ZNim
         C/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kalnmIkRf3NBE/i7SUoIwr0bcmOdnf8YawUYsWGtkxg=;
        b=MJDOQ21rLbBDSwikf1TWFcQW+tNmZcv3afmJ4VMogsa2RdxhJ4yv5zfIWNHTWZnmy8
         EplVaPIDXTmSMEzL+skBY9HwVvz8rKyy6vy8N12bUwGtiC9MgtPq7gVg4N/gAsxCAUs0
         QlvMs8ytb18JfGTCNsELi8Xh5HxSyVzYzpVfjf3liF/BO4eTiItrfmxaQpkkwNaZEvgQ
         b92oSoxrt2DyFVcoNoZFx/q0ry1sRDka6NhetszZdILaCqSKEicRyCGlHNOPMSU/GM95
         Hq33qr8GIT+p7gUiHZjRHanpfWL2QSj7KYdHGFAajZZpIX3xaNF2GxZSVBbisOm5OAzk
         TmjA==
X-Gm-Message-State: AGi0PuYUqlVCCdxmJzdkktRZxwlW7Dy2/fgr5ec9XTe6cUZxjiCk3uvS
        GMuHqRjMACOZcKLCLZIL7mz24rAd
X-Google-Smtp-Source: APiQypIII4Q5l7CtJF7fv9HM8P8i+/EPcjGRLpFbZBIV8bycQnDQw6JlsX59q8RnIbn5ZPQYuaWnIw==
X-Received: by 2002:a7b:c306:: with SMTP id k6mr5617412wmj.40.1587670437388;
        Thu, 23 Apr 2020 12:33:57 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c569:21dc:2ec:9a23? (p200300EA8F296000C56921DC02EC9A23.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c569:21dc:2ec:9a23])
        by smtp.googlemail.com with ESMTPSA id 36sm5115538wrc.35.2020.04.23.12.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 12:33:56 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: phy: smaller phylib improvements
Message-ID: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Date:   Thu, 23 Apr 2020 21:33:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Series with smaller improvements for suspend and soft-reset handling.

Heiner Kallweit (3):
  net: phy: make phy_suspend a no-op if PHY is suspended already
  net: phy: remove genphy_no_soft_reset
  net: phy: reset phydev->suspended if soft reset is triggered in
    power-down state

 drivers/net/phy/cortina.c    |  1 -
 drivers/net/phy/marvell10g.c |  2 --
 drivers/net/phy/phy-c45.c    |  1 -
 drivers/net/phy/phy_device.c | 16 ++++++++++++++--
 drivers/net/phy/teranetics.c |  1 -
 include/linux/phy.h          |  4 ----
 6 files changed, 14 insertions(+), 11 deletions(-)

-- 
2.26.2

