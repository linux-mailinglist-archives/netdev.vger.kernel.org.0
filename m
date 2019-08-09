Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA33882C9
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407568AbfHISmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:42:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33738 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfHISmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:42:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id p77so6739114wme.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=E644zhJWPrNpxvaXDaPGW33O/+KRjyn/ovxtjOAMzRw=;
        b=sQZ4jBPe3mDHdu/pYc727uF0FEyLUw+L9npiCxa05ut6475E0Sl1PAf7wYIDyC3Zjo
         X1dQyMzpWC+Hw2kmisefepe9kaW9u1SxhOgOPzDK5iqjbgF8M1qyIqNzcwRDeP3ZEfC9
         mrwGBk7bhY/t8irfAnu+CcjUBaikAndhRRcCrUKnh/qU9YdLl/O1VEb0jtHMxkHdwy2H
         PW+asuY7uvpcaoqUUKRRW707P16/0an35zcZGGakTdxKJaG1Xw7Tv7mJpg9C/18uDhBF
         FoRXSdu3GZ5k9Ey/Wx80ReFSOOtldlx1sWuFq0cBmW3tnarEiL5xrsbJTY4jZCCm0/sh
         /ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=E644zhJWPrNpxvaXDaPGW33O/+KRjyn/ovxtjOAMzRw=;
        b=lQ/K5HGW7Dq+X3iCQWFsChwIdS7m5jPnRrGgbR3zmTsA7C0NgTpY4qnvRTYHwsnYu+
         c4sCQgihnlSf5h7BnoUVXRAL/dC4QtRfOeVgdi53lqSzwacE5ExIh0tUW8WmQWhUoQOZ
         xV4fyDRsRhAC4vfro+mOAT0Ap0sDmweU6bL3bBQTYm/qN1ao97v54TlUo37X2V7Gd0ZS
         nsoBb+zBlqrF2JJUidG3+qR95WzvvucSTEc5Ux9zdV9bkTymezkfFSX+Yo3C5i1xJq29
         dsACTx4geMmyGM7Lk1ZGYxBDN7BvMI/QqmtrtgwQB9GvEvOAwanuguTQVRjOOTjyQMup
         8S8Q==
X-Gm-Message-State: APjAAAXEctcagttFxFcSUKi6gB0n1D77fmcSXhQLiPYndj93oNqqsTP0
        tmOB7dGmzPfXkkPHZ8Gw9d1WgmsM
X-Google-Smtp-Source: APXvYqy3nvj04lmELIZM6gYfQpiZ6J9DrHeo8Pdor85fjxDuHmoNzuaciAJ1EnGxP/VRLfC7928ywA==
X-Received: by 2002:a1c:f509:: with SMTP id t9mr12826125wmh.6.1565376124550;
        Fri, 09 Aug 2019 11:42:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id t140sm9606581wmt.0.2019.08.09.11.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:42:03 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/4] net: phy: realtek: add support for integrated
 2.5Gbps PHY in RTL8125
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Date:   Fri, 9 Aug 2019 20:41:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the integrated 2.5Gbps PHY in RTL8125.
First three patches add necessary functionality to phylib.

Changes in v2:
- added patch 1
- changed patch 4 to use a fake PHY ID that is injected by the
  network driver. This allows to use a dedicated PHY driver.

Heiner Kallweit (4):
  net: phy: simplify genphy_config_advert by using the
    linkmode_adv_to_xxx_t functions
  net: phy: prepare phylib to deal with PHY's extending Clause 22
  net: phy: add phy_modify_paged_changed
  net: phy: realtek: add support for the 2.5Gbps PHY in RTL8125

 drivers/net/phy/phy-core.c   | 29 ++++++++++++++---
 drivers/net/phy/phy_device.c | 49 +++++++++++-----------------
 drivers/net/phy/realtek.c    | 62 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 10 +++++-
 4 files changed, 113 insertions(+), 37 deletions(-)

-- 
2.22.0

