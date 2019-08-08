Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3815286940
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390266AbfHHTCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:02:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45209 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733248AbfHHTCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:02:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id q12so5699646wrj.12
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/CfaSs3aRX37lW+/yQckAZp2t935WrWQfkEFPNQQ5oQ=;
        b=qZgFGvInCGt9Ks90n4Aho8r+Yut10mqDiphIOWX/qdggYEtqNtPUPpx1+MIXrg09++
         j6fzOC3RVlVZ4KMphAUazRm067/iIRxVT/QydwsObBwTVdy7Fn3hAP0GmZjhh86yUDra
         by5cdwXAlUvEwawX9zr2cG7dq43e3jbhc52E52Ji+QQLQoBm0goYfh0bDcZ8cF+52AFj
         sLTPF4Rv4uWkfPJGkEMgbAmLIjPK6Ls8/AkWbYUJ7NXVy46tVWQoYUw4FZS9/AkW+402
         LWjN89MJytdqRC52BEFSn1XGbCl8WX7JkKjfjczLnHEJ7xT7wp2Y5KYY0FJNrzat0YSp
         T14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/CfaSs3aRX37lW+/yQckAZp2t935WrWQfkEFPNQQ5oQ=;
        b=iexzZhcjpDfX40qOG1gt5DJ6qAs8eSbnG5KKclnj29ssv6sfQBSI2xvdT87d/WBYrW
         ihVDVL4uu999SspHanWUmYAfgUCxoPdzDeeMe2/WaNHYbM5Q/TW52HTjRyKN1qlQgK0C
         gQrS2xIrj6CELNSHdS9W/APvNbiNduFIMtgNl9oHquVHrzLi4idxHih2U+xysx8wWWWj
         JnNxG5i9xklOkSP/jvxbzqUZoPaos4AJ1IdUwYfb5sWaSjfYYo40rZndymD5zCTAA888
         bqPK6c9NPV6xXbj6JzvrKdGDZRFwqmfbNDRwyJ8ZDSsI0jyIvTxXmMm0QUOfFpvvZ8Lt
         eLJw==
X-Gm-Message-State: APjAAAVpT8dtVJ8AYWi+McJT2E3BFzoRXRyGJ4/yhNThZSZtSdGI263d
        xrLmg9fCoGW3XxgV7uAMrxqJr7LG
X-Google-Smtp-Source: APXvYqxtOKGprm9mO0X2K+QaIh655+7Z5z512dm9Nrv9BrrhwCYp4oG4brRe55i9pg/6l5AsjTFyQg==
X-Received: by 2002:adf:9ece:: with SMTP id b14mr18795106wrf.192.1565290966793;
        Thu, 08 Aug 2019 12:02:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id f192sm5131752wmg.30.2019.08.08.12.02.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:02:46 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/3] net: phy: realtek: add support for integrated
 2.5Gbps PHY in RTL8125
Message-ID: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Date:   Thu, 8 Aug 2019 21:02:40 +0200
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
First two patches add necessary functionality to phylib.

Heiner Kallweit (3):
  net: phy: prepare phylib to deal with PHY's extending Clause 22
  net: phy: add phy_modify_paged_changed
  net: phy: realtek: add support for the 2.5Gbps PHY in RTL8125

 drivers/net/phy/phy-core.c   | 29 ++++++++++++++++++----
 drivers/net/phy/phy_device.c | 35 +++++++++++---------------
 drivers/net/phy/realtek.c    | 48 ++++++++++++++++++++++++++++++++++++
 include/linux/phy.h          | 10 +++++++-
 4 files changed, 96 insertions(+), 26 deletions(-)

-- 
2.22.0

