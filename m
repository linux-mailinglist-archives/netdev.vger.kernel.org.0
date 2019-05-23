Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3E128592
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbfEWSGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:06:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41912 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387459AbfEWSGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:06:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id u16so3395013wrn.8;
        Thu, 23 May 2019 11:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Kmj1SfRwUw9u9puwf4cpgVRacLw8HccKeSb6z3yZrWA=;
        b=fpFi2bU4KezKy9w+iThls3IxbCD6Mte2c+I79JHI/ElfTMKj3/3LRh648w+SpvBnyY
         9zcRq5B9tWPIhkXwy96KPsveApq/X1AbKCoBhjnbySa7BzIUZYAGzXC8Ym1UOe8BUydz
         SGLzUtauv/Idi0QD88S+jMy+VinRjky38aOWPw0a+qnDLt2w60RJYHSayQk6TNYXKUIV
         Fo0MIaRDe51JjNNGIg1RQ4bCcJ7Ajjm+xI0pQnnaQfNz0j4XiWinutoZNCikUGH7dxYA
         y8AaSdthKzqJuC1Q4ymFOq3+vplekJ3GgCpV5rIZ9YQ7is7dUUNQcbFMf0Vh8UJ+fuQj
         5rmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Kmj1SfRwUw9u9puwf4cpgVRacLw8HccKeSb6z3yZrWA=;
        b=AUG6mCl3gfBZh599WhTnfOZnANXRXjL3b3uylhlY9Ga+4pdVlq1MYwMHTRD9nEtQcT
         gIzsTX1nsa+m8qcajvrZBVeH0UEO/KCQ8aTBJAVea35dYxFumwQk7g1QNjpG208twTs1
         IB3iunwgNzlhy9fYcJqIQ1gZbDd1CR+iCBQQmhoU1FeL0BMEkpbnaJ6jTrZlAxswSolC
         2nTxsiQ4koTAYnRr0nnY8XrdjNBipTuEn3UOXkz2bdjgYiWwNfjDix/7NDJ2MIQt0U6G
         lFFUK8EBIH+yu3IlzRSKNf4ZprJ5JzKRLg9wyvqhcNMC6+1T6F+m6JC5iNg/TSZVTswl
         wkHg==
X-Gm-Message-State: APjAAAXQ8cjHPM1FI3gE1ttmFWyTSQvSXoK5jN4IXiBfyQjpY4QIIqWE
        amwLcN7nFDqEhbfh0q+FlI5Ix3Oh
X-Google-Smtp-Source: APXvYqyAN4LtfivBu324JAIFzsV9rNdYkmUQmvr7cU+zLh1m7y0XYm5wA5lO3KlKdXT9bze/AeU2WA==
X-Received: by 2002:a5d:4907:: with SMTP id x7mr47122036wrq.199.1558634776314;
        Thu, 23 May 2019 11:06:16 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0? (p200300EA8BE97A003CD1E8FED810B3F0.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0])
        by smtp.googlemail.com with ESMTPSA id w185sm189225wma.39.2019.05.23.11.06.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:06:15 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next v2 0/3] net: phy: add interface mode
 PHY_INTERFACE_MODE_USXGMII
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <9d284f4d-93ee-fb27-e386-80825f92adc8@gmail.com>
Date:   Thu, 23 May 2019 20:06:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for interface mode USXGMII.

On Freescale boards LS1043A and LS1046A a warning may pop up now
because mode xgmii should be changed to usxgmii (as the used
Aquantia PHY doesn't support XGMII).

Heiner Kallweit (3):
  net: phy: add interface mode PHY_INTERFACE_MODE_USXGMII
  dt-bindings: net: document new usxgmii phy mode
  net: phy: aquantia: add USXGMII support and warn if XGMII mode is set

 Documentation/devicetree/bindings/net/ethernet.txt | 1 +
 drivers/net/phy/aquantia_main.c                    | 8 ++++++++
 include/linux/phy.h                                | 3 +++
 3 files changed, 12 insertions(+)

-- 
2.21.0

