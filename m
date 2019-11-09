Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF18F618A
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfKIU7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:59:03 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53361 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfKIU7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:59:02 -0500
Received: by mail-wm1-f66.google.com with SMTP id u18so1892597wmc.3
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=R6Vriph3UuRblH4/Q1JLhpkNTa6ersKSNSHBnasID4c=;
        b=RRWEg+MYT3O4MWn40TbAni95fWPhIu01kbFKQMwLKqX2z0/j4ELcgJ3CNbYjci969Z
         F8OfLZ7i+B74K87h28i0vz54S/MRiLISZnQvbH9qH3IHx+jd1VBMS4psz5M+dM0F1c/H
         6DK97LH0ns+wRm/YJD/wbSXQKvAZkKVkPvec+wz9/KEiOabrGjhecNAHOc+nCmWbO3hK
         OG/R/z1Ouex5Yo7YbMqIjA1QW8Eqei63lBuKwbWLRFpgW2zcoBHtsjBZ9zmiFb3YW4rR
         qNvgW0KC0J5B0LzsJRRI7aVcQuDCV5QeIN+VJfCQ4P1k2XA4PrHuANjrwVM2QAgGe89U
         ssTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=R6Vriph3UuRblH4/Q1JLhpkNTa6ersKSNSHBnasID4c=;
        b=EkcMC/sxKOAWD6UoX57x1mlastXXINTdBeCfpVRl7Uhgg1j6BaAeuYJu6UWSTcGDTe
         ZbuA9ZwpMFVFxUYe9tZz6wtIfwdUte7fAorygNR4THTZKIUlRoJ5ZLcOr0BbS882QzyR
         gsiZCk3dXNM9e0vS4EGP/WBY5gr/b4xUAIqr4KONyByXXr+jmm1GeA1+kk0AxzX0OpML
         rB1XQAAYo4kCsvrEVgxkj7nIGqqvWpQDAQ82AZQgAOy9E1vGYYEuYs1hNHHoT2/tbhmz
         vso0ZzT7OlbDsq9uF0oHO7uH7Khqtx53GhiWxnDB8Lxji6dGcS1Uy6PpFA1fAHwNMzq0
         jnIg==
X-Gm-Message-State: APjAAAXkH8Cv2+CknANq0MOTPndU4tV+aiCVh017ki/dlFbXcUK3Veak
        RnqByU69MU9kLIoxyLL0vQB2JqeZ
X-Google-Smtp-Source: APXvYqyfp2d5ptVHup5SeJKNlSzVHqzkodw2OjgZZxFQDVvLsbTs6kNWfhcDba8z05o0EadLJAtNOQ==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr14320475wma.140.1573333140609;
        Sat, 09 Nov 2019 12:59:00 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4d:a200:7127:c2c7:8451:a38b? (p200300EA8F4DA2007127C2C78451A38B.dip0.t-ipconnect.de. [2003:ea:8f4d:a200:7127:c2c7:8451:a38b])
        by smtp.googlemail.com with ESMTPSA id m13sm10177627wmc.41.2019.11.09.12.58.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 12:59:00 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/5] r8169: improve PHY configuration
Message-ID: <11f690c9-ed72-f84b-a7c3-9e18235d6a9a@gmail.com>
Date:   Sat, 9 Nov 2019 21:58:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds helpers to improve and simplify the PHY
configuration on various network chip versions.

Heiner Kallweit (5):
  r8169: add helper r8168g_phy_param
  r8169: add helper r8168d_phy_param
  r8169: switch to phylib functions in more places
  r8169: add helper r8168d_modify_extpage
  r8169: remove rtl8168c_4_hw_phy_config

 drivers/net/ethernet/realtek/r8169_main.c | 725 +++++++---------------
 1 file changed, 229 insertions(+), 496 deletions(-)

-- 
2.24.0

