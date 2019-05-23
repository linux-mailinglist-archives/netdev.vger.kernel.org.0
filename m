Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D0B2743B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 04:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfEWCFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 22:05:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45311 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727305AbfEWCFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 22:05:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id s11so2302570pfm.12
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 19:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lDCTwqL6KeGiUNlHJVa2ySTy0xupKhw2tMHI0Ab2lbk=;
        b=ZInF+5pDFrHZNSSbkLy3G+hGhhujPTTVuXKG9wUDvFM7BF2gAwUhsuwoqlivP5c4ZD
         sSgx7LPLtbvIAh5J3phblVXuq9Fc29Xi18R6NtJE5qYM0cRN8FQIRmXK3elKXD2ihsqn
         Zlozn0dbKtxnIGCPA6Uhg1aF//rcBZL8Gfht6csvkX2TQ/IsKOlHxwnUxELHPY4p/iPH
         VFd2Ql7DC8yR2+IBmtOgGAG1dcE7//j3oW5RJ4TGPcKRLZXbDcyp9YxLnoRcs1q704E6
         +PVm+9MVdLUaYFfWAhyOJzEpIElzmsdTrT+0SGWEmOMnBMImpDojUzdPybumcVSh6Aft
         FLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lDCTwqL6KeGiUNlHJVa2ySTy0xupKhw2tMHI0Ab2lbk=;
        b=HVzwenIoSw0OAkEJtgskcFqrZm/6IxgY+eKpHPwrhv/lvk9JbGJ7T2tgnQpHiqol5C
         QEzW24Ou1WsUgFgA9O8JSGJr8pG2SnZgwZts5o0w0xNPDMjpU7bS989P+dWOTEm8va9X
         Dhgc39tRq5Ng7o+kDRsoBZH9g0u/DSVrjGHtiGEFIt7zpQImWgPm2Rbk07ObZ9Ee93Tt
         DYtlIOIitOQ27qBZ8cs+oa4Pt8/NyCiTjoviDU4pt3eJgvejGAkndUA/rmUQ6TM9Zx8I
         f21l1jk6DVdUcQQECGgfzBn/ycAN3zbpwKsFCGUoMHxtyHGJWCn4lkFSwW3ZK21hzj4k
         waaw==
X-Gm-Message-State: APjAAAWJjaxgb5b46E11sm0wlGv2Yj6tML757z62v6srOCeNyJZrKqdg
        9xzjId0Q9cUJ5lorIbe+ZlQ=
X-Google-Smtp-Source: APXvYqyyAcRXjX572NPiS3mF0EgK3bnPe9V1VODSDWlFP0ce2c0wNycOERc+ejH6Sl9aCJ3fABB3cw==
X-Received: by 2002:aa7:8b57:: with SMTP id i23mr18256041pfd.54.1558577107298;
        Wed, 22 May 2019 19:05:07 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm1021357pgv.4.2019.05.22.19.05.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 19:05:06 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 3/9] net: phy: Add phy_standalone sysfs entry
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-4-ioana.ciornei@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8e954092-852b-6e69-a10f-8da480ba8749@gmail.com>
Date:   Wed, 22 May 2019 19:05:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523011958.14944-4-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/2019 6:20 PM, Ioana Ciornei wrote:
> Export a phy_standalone device attribute that is meant to give the
> indication that this PHY lacks an attached_dev and its corresponding
> sysfs link.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

I would rather have that attribute be conditionally visible/created upon
a PHY device being associated with a NULL net_device and not have it for
"non-standalone" PHY devices, that would be confusing.

> ---
>  drivers/net/phy/phy_device.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 25cc7c33f8dd..30e0e73d5f86 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -537,10 +537,22 @@ phy_has_fixups_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(phy_has_fixups);
>  
> +static ssize_t phy_standalone_show(struct device *dev,
> +				   struct device_attribute *attr,
> +				   char *buf)
> +{
> +	struct phy_device *phydev = to_phy_device(dev);
> +
> +	return sprintf(buf, "%d\n", !phydev->attached_dev);
> +}
> +
> +static DEVICE_ATTR_RO(phy_standalone);
> +
>  static struct attribute *phy_dev_attrs[] = {
>  	&dev_attr_phy_id.attr,
>  	&dev_attr_phy_interface.attr,
>  	&dev_attr_phy_has_fixups.attr,
> +	&dev_attr_phy_standalone.attr,
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(phy_dev);
> 

-- 
Florian
