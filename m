Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F32316EDD
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbhBJSh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbhBJSe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 13:34:58 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43253C061574;
        Wed, 10 Feb 2021 10:34:18 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id e9so1693705plh.3;
        Wed, 10 Feb 2021 10:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dj5e+JdQ9inL9MdyTwQAUMaybZD9FtdxxaVKbEntvms=;
        b=Ub/5H3X0wZ2QMT2YY41+mARnKBQEPOq+YPST8XpKW0Pbcd1aIThNMaFuOFpzOKv7ui
         gCpXUI6xVEOLJOBkQhRdz7WZ/lC7QDMCa6jTx0SnpWBgHRXA46ADflD43HMcXKowHFBi
         mvBx2gVx1OwX4RNyp/s51QSzG8v3ZvX1jK2IZnOuDFjeGBeh/8Nk5e2l8RPW2fdBzM6Q
         /LM1URg4t2WO6LDd9vjfR0S6PcgdNxDfGxTOcOvCtza1XgdI2I174URB291rOU2Akfws
         F1KvpdIe4wGnxH4AZcTk5gA61Kb97mwu2opyLH64S65Cn2Hz5BVd61lByN4e0OtM/+D2
         sidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=dj5e+JdQ9inL9MdyTwQAUMaybZD9FtdxxaVKbEntvms=;
        b=DWGVaiyo1g1o68l/bqllOEmH96esomib3L/c8xQMv1/RrhNSlraxBR9tJqB3Q4AlF8
         bZY92TW1Gz+c6qjq73Og3vr6O9dS5QLS1Hdl4gQq32h44LN100UU43PQXVFwLpLhRNZM
         wa1c2sDPQGjtm9X54ekbvlOjv88a03UOj/UnFBdUrv+wIw8a60YPd7OEq+COYgghRjX7
         BwjnJDlZ8ovhXHafvFyD0D7tXW5Ughz1PIqnFk/Cog670qi8ug9e1akJKNfM0cWpWWYM
         V5bRIWxv1B7uhWDFE938TzUqX9B3oCmR94q3KiJUdv6nqIvR85UQdoKQfV6DyA3eqBQp
         qI7g==
X-Gm-Message-State: AOAM531s8GUMXXHnqunv2CwrcHRI3to/UPJOszcL//sv+woQBg4sLXS0
        i3tWaawKmSgeRKx4URaCItgX8jFlkBk=
X-Google-Smtp-Source: ABdhPJzzfNc3Tgk6r1NRjnnlY4LFIZVY7qJEHNHAxqnO4Rxu2KkTVn41dp8KvzmYQgMfOsYFQ/ngKQ==
X-Received: by 2002:a17:90a:4148:: with SMTP id m8mr228227pjg.184.1612982057749;
        Wed, 10 Feb 2021 10:34:17 -0800 (PST)
Received: from [10.67.49.228] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d124sm2592077pfa.149.2021.02.10.10.34.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 10:34:17 -0800 (PST)
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
To:     Michael Walle <michael@walle.cc>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210209163852.17037-1-michael@walle.cc>
 <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <558e057f-69a4-cb16-ef0f-9e3d005060ea@gmail.com>
Date:   Wed, 10 Feb 2021 10:34:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <41e4f35c87607e69cb87c4ef421d4a77@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/10/21 3:20 AM, Michael Walle wrote:
> 
> Am 2021-02-09 17:38, schrieb Michael Walle:
>> --- a/drivers/net/phy/phy.c
>> +++ b/drivers/net/phy/phy.c
>> @@ -308,7 +308,7 @@ void phy_ethtool_ksettings_get(struct phy_device
>> *phydev,
>>      if (phydev->interface == PHY_INTERFACE_MODE_MOCA)
>>          cmd->base.port = PORT_BNC;
>>      else
>> -        cmd->base.port = PORT_MII;
>> +        cmd->base.port = phydev->port;
>>      cmd->base.transceiver = phy_is_internal(phydev) ?
>>                  XCVR_INTERNAL : XCVR_EXTERNAL;
>>      cmd->base.phy_address = phydev->mdio.addr;
> 
> Russell, the phylink has a similiar place where PORT_MII is set. I don't
> know
> if we'd have to change that, too.
> 
> Also, I wanted to look into the PHY_INTERFACE_MODE_MOCA thing and if we can
> get rid of the special case here and just set phydev->port to PORT_BNC
> in the
> driver. Florian, maybe you have a comment on this?

For GENET, it's simple because we can do this:

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index fcca023f22e5..34cbd008a3af 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -777,6 +777,8 @@ static int bcmgenet_get_link_ksettings(struct
net_device *dev,
                return -ENODEV;

        phy_ethtool_ksettings_get(dev->phydev, cmd);
+       if (dev->phydev->interface == PHY_INTERFACE_MODE_MOCA)
+               cmd->base.port = PORT_BNC;

        return 0;
 }

but for bcm_sf2.c, we would need to add plumbing between the DSA core
and the DSA driver in order to override the cmd structure with the
desired port and that would be most likely the only driver needing that,
should we really bother? There is also potentially a 3rd driver coming
down the road (bgmac) which would need to report MoCA/BNC.

I don't see this scaling very well nor being such a big issue to have
that in the PHYLIB and PHYLINK.
-- 
Florian
