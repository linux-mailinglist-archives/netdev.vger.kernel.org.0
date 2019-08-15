Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465188F7A5
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfHOXgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:36:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34959 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHOXgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:36:53 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1666786plb.2;
        Thu, 15 Aug 2019 16:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ItxQVkyoKBqZ2cSuaxThUtQAf/xYN33RqQLhEkNeQuY=;
        b=NsKOuhlCcEMFLPbPa1xA0fEzGl25E5j6kt0vw+E5fHt3CU/YkUd568TupE86WZCw+8
         aR1D3rvtuVoQBRkj3vuzL3S/dhkAU1I5w8sonJkztne+frhBeU63cgqdJK3KQX7AGZt1
         vfEMbUTlbkdpcwppKErNeDWUR6VH6of50/Y9qvVirchabBh4P3lxP9Hms5utLFjyzP5N
         9F4knCOtHEJN9cKXIu2LBdCPNjDnrUH9V54fjRqAJCcJRsSkF8f3OpbaSC9pQZZCY41A
         t9Hz+lgefZ3xfINyNora6DshMH156wAfRK4L2E2LR+UymfBc1oGcjoulMex8fnA3koVF
         K7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ItxQVkyoKBqZ2cSuaxThUtQAf/xYN33RqQLhEkNeQuY=;
        b=dtpB7EbaBTzpOMpAe/Sl3K4gXbRLeeOrganrp9sUuc5gOF/nEPQs6PzzBqY9TtZr8M
         d7jIYIEDaE8ZTR0TMsa85tYdEvJkfo4N5I/ntWyHEao9f10MWljsQXeU69aJGw3fv/HI
         3yRLdMX+hxf2no2mMQl/IHLgksZoaf8mYbB4LfKf839c+oGW/qINJMnA29mi7mMlKiKt
         pBdkd9mlcqMnNNZqwSrbtqwsn1XuNvXmNlZFhWTfznk0wP8xjv4xk2gfAPPAg/6tXg0q
         8fwneyZmQNTeyTAQ+zHshGtD7imSB4XCQZnZJ2wQpTr78JeKIQOfKk/t1jEXiRTsxwZX
         NDYg==
X-Gm-Message-State: APjAAAWefPT77gluS41xEDrlcfeDjhJMKQCgw5FiWd84TvISX8tLVNqT
        uGn7LggI6PNrcXXRBNC9doA=
X-Google-Smtp-Source: APXvYqzJeh/sfsZ3Kx0kl+5LYPHmANwVXNyBTfmDpHkwFJa1MfK7qGH+J5n5dNjFFBSyfkPP6YjxPQ==
X-Received: by 2002:a17:902:2be6:: with SMTP id l93mr6651121plb.0.1565912212360;
        Thu, 15 Aug 2019 16:36:52 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x25sm4323825pfa.90.2019.08.15.16.36.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 16:36:51 -0700 (PDT)
Subject: Re: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
References: <20190811234016.3674056-1-taoren@fb.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <d45d609b-60ea-760d-31f4-51afa379c55a@gmail.com>
Date:   Thu, 15 Aug 2019 16:36:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190811234016.3674056-1-taoren@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/19 4:40 PM, Tao Ren wrote:
> The BCM54616S PHY cannot work properly in RGMII->1000Base-X mode, mainly
> because genphy functions are designed for copper links, and 1000Base-X
> (clause 37) auto negotiation needs to be handled differently.
> 
> This patch enables 1000Base-X support for BCM54616S by customizing 3
> driver callbacks, and it's verified to be working on Facebook CMM BMC
> platform (RGMII->1000Base-KX):
> 
>   - probe: probe callback detects PHY's operation mode based on
>     INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
>     Control register.
> 
>   - config_aneg: calls genphy_c37_config_aneg when the PHY is running in
>     1000Base-X mode; otherwise, genphy_config_aneg will be called.
> 
>   - read_status: calls genphy_c37_read_status when the PHY is running in
>     1000Base-X mode; otherwise, genphy_read_status will be called.
> 
> Note: BCM54616S PHY can also be configured in RGMII->100Base-FX mode, and
> 100Base-FX support is not available as of now.
> 
> Signed-off-by: Tao Ren <taoren@fb.com>

> -		reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
> -		bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
> -				     reg | BCM5482_SHD_MODE_1000BX);
> +		reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> +		bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> +				     reg | BCM54XX_SHD_MODE_1000BX);

This could have been a separate patch, but this looks reasonable to me
and this is correct with the datasheet, thanks Tao.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
