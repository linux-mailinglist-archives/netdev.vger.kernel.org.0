Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA1526F74
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfEVT4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:56:24 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:38632 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731634AbfEVT4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:56:21 -0400
Received: by mail-wr1-f43.google.com with SMTP id d18so3654771wrs.5;
        Wed, 22 May 2019 12:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TXzPq9ByGbIEa7un2WIzM+92nsCFrJqr2Aqe90VKILo=;
        b=AqxRCmlgWHvArBECjQiVJRP357/rnXIZFzYJDtyAwhx7Ho4QkydaJgm6yk97nwG47t
         bVZsNdR1R8oPcdFZIlNJM4YXo9uBmIE4s72LlxXBpx6q3sCffnXPp+c+XqleQAE/azsu
         CFFX6js9dQ23jMnoF3bYBnPykWBQ6mESzdgJIDSqMzwIesXOb2v22kIBr/7xOovwkKSN
         bOjdfAX3knaPx+TfefQQ9Q9VaOOxoqMjLmTW8TJ0ppOAr8oYkk41MTxMt0tJzPQ/XQ9Z
         U+WZd9MfdW4f29XwRJe6RCl9bpYjI6SWFYkTS4FtpQ4lF1ViOEhTRt4iKXXTiGzy1fg5
         kn8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TXzPq9ByGbIEa7un2WIzM+92nsCFrJqr2Aqe90VKILo=;
        b=EJTu64A75TGQ7vKj9+ca+Xi6q96XyM/qqeoCSQttL8NaNOaDnPZeB+2dAaeuVlk1lr
         cQf7WZGqqAP0BGSTh62cIieXDmpNqRWLVOekp7z1VsPs866mEF3r/r1rGQTInX+BWZ1r
         +ugfJ+IG4vEQorOqGoQ0ZySgrVjklg3ESduNpA3A38kkp3VBJIgq6mBa8BRD1bpe9Xk7
         Sx7YX9RrWxifnRgPyiXKj3FRGzATn7v0fanBaQvsL+r2WyZ+V4416csnv6xLcw0VCJ5Q
         dV6eQrBBYq5ZMPQMe2wliXzpcHl1EmePqV6vdeoRSAJ0UTr6aYibR6LEyCBou2ff2Umr
         9vPg==
X-Gm-Message-State: APjAAAUDUXWOHr5kIW13lhM2dBcA4hfI3ive4PFKcjhpL5P3ox65BqHE
        nFzirhGlxg1F+aqDPy/grQLj9Y53
X-Google-Smtp-Source: APXvYqzQxBhqoXXqVF4VRrFGNN/1HQc8l/EO2jZXf2HK6L3MxHaF9vVX+8cdnVIIOWYmLEQ02K1GXg==
X-Received: by 2002:adf:e90e:: with SMTP id f14mr18836096wrm.166.1558554979553;
        Wed, 22 May 2019 12:56:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:3029:8954:1431:dc1e? (p200300EA8BD45700302989541431DC1E.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:3029:8954:1431:dc1e])
        by smtp.googlemail.com with ESMTPSA id a128sm6606735wma.23.2019.05.22.12.56.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:56:18 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
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
Subject: [PATCH net-next 0/2] net: phy: add interface mode
 PHY_INTERFACE_MODE_USXGMII
Message-ID: <110a1e45-56a7-a646-7b63-f39fe3083c28@gmail.com>
Date:   Wed, 22 May 2019 21:56:14 +0200
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

Add mode USXGMII and change places where so far (incorrectly) XGMII
was used instead.

Heiner Kallweit (2):
  net: phy: add interface mode PHY_INTERFACE_MODE_USXGMII
  net: phy: aquantia: add USXGMII support

 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts | 2 +-
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts | 2 +-
 drivers/net/phy/aquantia_main.c                   | 6 +++++-
 include/linux/phy.h                               | 3 +++
 4 files changed, 10 insertions(+), 3 deletions(-)

-- 
2.21.0

