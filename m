Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331EC90FFB
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfHQK2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 06:28:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40957 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfHQK2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 06:28:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id c3so3884047wrd.7
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 03:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ic4QxDcnEZDhCpYny2vHTdJ+dOVOWXSrwdjwSM39+oE=;
        b=dXETHoTZ3yT1tDkbMOzWnf07w9/anSOn9DCxcm5/e0bW1/D7P7CoqbQVunPZjHNxyL
         pWsz+FvGrHvrczRXk40yAZzFpx4onSHTQVF5o0FrHLCfJLxlk0PTMpzRv0FIfpbxoR3F
         xnBhyXMaLE8fKBm/SEttWKS6uHWs17+B/Ija1Vn7AuqR9VaojRsx01CYvlVQwiWOflLr
         /zRU7NyJnwk/ZuaCGjtzSJOInV2hDoxzI6RcUmr65rsZaCSp4Vqm0b1bs1GCR2lbo0+C
         MhXUCkDN2RgqNbNjuTosc6+fdUiAFmtEqKNIZv/lRUToGwemYn0X2fkrczTY0cPGoPzd
         9MeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ic4QxDcnEZDhCpYny2vHTdJ+dOVOWXSrwdjwSM39+oE=;
        b=XcgiRESOSvSlcpNdzF7cVTEVamV8WL+a4xaHQ11NwUVDlLyYd4m2QTBBaXzrKED4ZX
         DJXRtAaTlpa8NzvAa0X+byXFlxv5k10nrovyHMwHYjwXSX+FBrehLfEXgNtqBgAjU3AM
         nWaEtJeS8r9FQIFTxECrkfJJ8IyhCxRP++M2nkMV8sfEyQ0oqoDc/7N4ky3unOuSx8sX
         iqeqJXJiVdUHot0qxZZ7X0iukISPOBBygTPJL771B+dzT4vfrCuJlmCKoU8uwG1iiq7N
         erC7/kuxZeX+FRJ4APIQbTeAWEPAP+Xk/2DAWrWpPm7ccYomOEweXDKak4JaX9dYGmSP
         hu2A==
X-Gm-Message-State: APjAAAWRF6K8x/+vLyc8mHox4oZV1qWMmd2QTu71BIOmhWXzvmPeqe5n
        vFWxEp6oexrUBFMHVOrYB9I=
X-Google-Smtp-Source: APXvYqxY5+kiPOd6DrP5bS66mWlMUYUrbzpIKhgZdFRKIQA74iNtBh7etxMglSPusTVUbnz3rk0K8g==
X-Received: by 2002:adf:eac3:: with SMTP id o3mr14493248wrn.264.1566037713892;
        Sat, 17 Aug 2019 03:28:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f47:db00:ec01:10b1:c9a3:2488? ([2003:ea:8f47:db00:ec01:10b1:c9a3:2488])
        by smtp.googlemail.com with ESMTPSA id 24sm5380514wmf.10.2019.08.17.03.28.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 03:28:33 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v3 0/3] net: phy: remove genphy_config_init
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Message-ID: <8790db9d-af10-c3b1-bc65-ee21bb99e6d9@gmail.com>
Date:   Sat, 17 Aug 2019 12:28:18 +0200
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
v3:
- pass NULL as config_init function pointer for dp83848

Heiner Kallweit (3):
  net: phy: remove calls to genphy_config_init
  net: dsa: remove calls to genphy_config_init
  net: phy: remove genphy_config_init

 drivers/net/phy/adin.c         |  4 ---
 drivers/net/phy/at803x.c       |  4 ---
 drivers/net/phy/dp83822.c      |  5 ----
 drivers/net/phy/dp83848.c      | 11 ++------
 drivers/net/phy/dp83tc811.c    |  4 ---
 drivers/net/phy/meson-gxl.c    |  2 +-
 drivers/net/phy/microchip.c    |  1 -
 drivers/net/phy/microchip_t1.c |  1 -
 drivers/net/phy/mscc.c         |  4 +--
 drivers/net/phy/phy_device.c   | 51 ----------------------------------
 drivers/net/phy/vitesse.c      |  6 ++--
 include/linux/phy.h            |  1 -
 net/dsa/port.c                 |  5 ----
 13 files changed, 9 insertions(+), 90 deletions(-)

-- 
2.22.1

