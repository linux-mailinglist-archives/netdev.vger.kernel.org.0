Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68878EAF2
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfHOMBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 08:01:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44269 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbfHOMBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 08:01:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so1977983wrf.11
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 05:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jPGzkRBRT8bF8Sp7ucZCpjelq95g2AL6Gc+Rjkr/dlo=;
        b=b/68EKI4yxdytTdhxRL4qRn4mOfmvXFv51AkhZ8iRjSWceCeF9YeM31Z5ZY5nwEMJn
         I99Uy96c8oKl0t03Jk1G/QYacWC0wPSItjudM4JRe6a5HwpVZJnFR5vcQug/2LCjh9kn
         +qPDFxCzY7Oa3AhKAK5zPS5Dl/JwX/e8U9RmlHr1fW0v6WVxAPPCVPExOj03EenhhmzK
         u90Q8Acli3iedAphcib8pOM5f82GuqRaF9IAmNM79BJEhTJrpERDun6dglZonQ9GejBv
         nwHcCjmqrMeE2rB0uTTGZxPeQGCwqwqrRByZtIVEOzZkQKcdL0S6f+vQa/NFN4wa9TMv
         K85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jPGzkRBRT8bF8Sp7ucZCpjelq95g2AL6Gc+Rjkr/dlo=;
        b=rNGzgZxuO/XbKtWmNQrcqcpjZOX2vmeMC1vFsivq0ZfXYP9moNFbT+wy9MuA9y3VGI
         x/j4tl5LW2M6LgEaCMBZYHuGvYXncgXS6anhdRh9YQl+d2w2i3rmXAIeONFm75GgoGmI
         3tqUwJBpT0aS870/0y0LMV0UGxRSfDbhZNle2XoTOOqQPqbIpC6wFaFvI9HEjVFHav/Y
         XNlvHTqXjSw9h3+jf6YWMWNTq0ODLbcKHPH4qQS5Etvc5eHJG0cAQ3Qj0JIMoI8LseFL
         bXmvNQDKxEnO+SGJDNGQ+Sx3vX6ZrRS9EGzyIhRVGm01UkcCNsh4Sazu8Ms0sdEQB+6k
         j2sw==
X-Gm-Message-State: APjAAAVbs2OZ1d79lcfGCFU3wQjlXDcBvYpOCXDfslcuHJ6btzi3aO/U
        jwJ9Nl8Lir3n3KNHFJ7gNZQ=
X-Google-Smtp-Source: APXvYqx7ctAo3AObHXDJYPuv/7yVFMqhMk1SUaJIphINuSueyoZcMD1LiBF2F44ZRKdIbk6i6sX17A==
X-Received: by 2002:adf:f705:: with SMTP id r5mr5026742wrp.342.1565870512394;
        Thu, 15 Aug 2019 05:01:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:b8fa:18d8:f880:513c? (p200300EA8F2F3200B8FA18D8F880513C.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:b8fa:18d8:f880:513c])
        by smtp.googlemail.com with ESMTPSA id q3sm1525479wma.48.2019.08.15.05.01.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 05:01:51 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Kevin Hilman <khilman@baylibre.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: phy: remove genphy_config_init
Message-ID: <95dfdb55-415c-c995-cba3-1902bdd46aec@gmail.com>
Date:   Thu, 15 Aug 2019 14:01:43 +0200
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

Heiner Kallweit (3):
  net: phy: remove calls to genphy_config_init
  net: dsa: remove calls to genphy_config_init
  net: phy: remove genphy_config_init

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
 12 files changed, 14 insertions(+), 86 deletions(-)

-- 
2.22.1

