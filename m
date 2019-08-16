Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC05490978
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfHPUaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:30:25 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:53178 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727545AbfHPUaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:30:24 -0400
Received: by mail-wm1-f45.google.com with SMTP id o4so4984701wmh.2
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 13:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=T9zrjLIygzStwRFu7jZ+vDx/MRzKjAVtrqummeEGsVY=;
        b=CG1NKHbp5/TMq+MEe9V6fFd+i4eP5avzHiad9kljw6XMeF3d8/VAClvo+Y2ZTu71H9
         suIHM2YHtcw/KAWHWSanFwsTCxiz5H4+J8AqIdnFC85WcZ+YJsyGapGWmzoFnBZNC1uN
         On1Zt+yKTNtJzmFqKDgkLE0igqbSYS9wnXe+aTeUWs59ULwY6tW6V7axXYFbSKlHz/n9
         Se+6uXqoOGx+qk9Aye6yjNF6mSL7Slik7VnxfuD7qLZN4GmLche7wp7LZhX4Po81Ruqb
         BC2QAV+/qGjSrWyD6/pL5T6FgqpLrszMTPXwnnYSVkOVnNhLmGWm406ROphWAq4PRMfe
         kzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=T9zrjLIygzStwRFu7jZ+vDx/MRzKjAVtrqummeEGsVY=;
        b=ix8X5C1c0ZwAS4EzXC13rjMQqItGXL9us2hot3Y84ULkv2RKbi6J291GazVrdDB829
         ppe/QnQy8lhcd0/ouvi+jSimW8a5uP6BIoRhXFGEPbX029+R3/x6cO8aXv1lrvjlbJvr
         wHxEjym+JUUR5xy5wZXg8mNl24OByUBOusHDb5xpVoNKsIeXOl1jkmMs948Up1XmmYrf
         LHMfQKbw0v4cZLIKe0ulgxF/KQNJmfL+gmiZ6NJSo87MYLaEuBhWWl/OdfUH9QmCGe1K
         hRBtJfNL9M16F7/11HSPP2Azri3Y9ZhZOxAx2XBPnC56RhpfNA/1Nb7ruEz35k9vsRuY
         2z7g==
X-Gm-Message-State: APjAAAXZ8MwircDjTMdjzAG8A1NDPqganZGRt5R90qYeR/pNxnPjASHG
        QkqpCgdz22NoXSwru3u9izg=
X-Google-Smtp-Source: APXvYqx7oJ4Z5dwI7ZN3OzyuiffQGw6u7ZJ1GJYeeJpiiBIq2be/gWh57gDXhou7nCypWyx9NiPNJg==
X-Received: by 2002:a1c:39c5:: with SMTP id g188mr8684502wma.167.1565987422640;
        Fri, 16 Aug 2019 13:30:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id g12sm6579332wrv.9.2019.08.16.13.30.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 13:30:22 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] net: phy: remove genphy_config_init
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Message-ID: <62de47ba-0624-28c0-56a1-e2fc39a36061@gmail.com>
Date:   Fri, 16 Aug 2019 22:30:15 +0200
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

Supported PHY features are either auto-detected or explicitly set.
In both cases calling genphy_config_init isn't needed. All that
genphy_config_init does is removing features that are set as
supported but can't be auto-detected. Basically it duplicates the
code in genphy_read_abilities. Therefore remove genphy_config_init.

v2:
- remove call also from new adin driver

Heiner Kallweit (3):
  net: phy: remove calls to genphy_config_init
  net: dsa: remove calls to genphy_config_init
  net: phy: remove genphy_config_init

 drivers/net/phy/adin.c         |  4 ---
 drivers/net/phy/at803x.c       |  4 ---
 drivers/net/phy/dp83822.c      |  5 ----
 drivers/net/phy/dp83848.c      | 16 +++++------
 drivers/net/phy/dp83tc811.c    |  4 ---
 drivers/net/phy/meson-gxl.c    |  2 +-
 drivers/net/phy/microchip.c    |  1 -
 drivers/net/phy/microchip_t1.c |  1 -
 drivers/net/phy/mscc.c         |  4 +--
 drivers/net/phy/phy_device.c   | 51 ----------------------------------
 drivers/net/phy/vitesse.c      |  6 ++--
 include/linux/phy.h            |  1 -
 net/dsa/port.c                 |  5 ----
 13 files changed, 14 insertions(+), 90 deletions(-)

-- 
2.22.1

