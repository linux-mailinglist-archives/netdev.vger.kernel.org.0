Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7748F29A28
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391617AbfEXOiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:38:00 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:36891 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 10:38:00 -0400
Received: by mail-oi1-f195.google.com with SMTP id f4so7189443oib.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 07:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CFrjmDnqzNNFxq7deh1hPBcok1l+5oaCp9KNgtEyRok=;
        b=mQl7Pw6eyhvnZn05JHEzHbMMXoJ0FHmZoBzUrcgCM3Px36sEc+lJlKSzZwBZ5JkIa5
         syeKoqbqZnyaf342f7g66BFV2wdqdnIxGi/XDJi+5KWdkjUUrUTz5ZSbS2vJHq5isagj
         XXvm1bANIPMHBgYMN6j6Si7a9XO4bXYHhKSIfGg+wJy7zsmiupQKAdEQiAgBxnlZRCnh
         +60cjc8pOqO4JYlBE8vxzIDRk9NyzNGKBgLLmpr7G71D8YwUF4uFZX5SZsBzMBM4Jk/d
         tmQP779CkC/sVEsqGEJsax57drsScfi+Da9zmUGuvFyE+oNyBlCVKxbuVnfxZs8EUP9L
         KkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CFrjmDnqzNNFxq7deh1hPBcok1l+5oaCp9KNgtEyRok=;
        b=Z0v3whbr8NmTgrVAPTA2hwnfrZuVsovOcTpsSChHt+cMp2ohY+Q1hI92MrO1DLalXV
         X1UKN3FypNlxvhcco0y+1dCM7hUUhl9C93D6f6I1iILaMzSbAXTBATMJ2xl9Cxrs/eAX
         XMIKmpmghCE5aM9pOWE8KQq51nCVFRGue0/whYNPcUri5aSSpUlvOzDfiFeTL2ZQKQBi
         WeJAGrZItf9AoixjDp3GxoLO3eafH7qrlAVT6bZwX3eNRewHN4rUz21OFMkHCSW473tz
         QWs9fbHh3sXGMIFDQtSbjAmV5PvwCRYlFBecdXLUL2+LwuTJY9CMTMXQLD52/ocdI7DJ
         Ipcw==
X-Gm-Message-State: APjAAAUD9iTh+W1JHaEtFpmULwTcoXrwm+OzbVTSmMKXrkUJzsrYucVf
        EF/VglUaHqumYrol/sQiCrk=
X-Google-Smtp-Source: APXvYqw4pzOuVacpDFaIawHi1BOQR208nQMWdivnC+7xkAOYIYIiDo/0aOQ144mOFOqrZYqXGCFFrw==
X-Received: by 2002:aca:ccd0:: with SMTP id c199mr1541oig.63.1558708679366;
        Fri, 24 May 2019 07:37:59 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id f4sm1176222oih.39.2019.05.24.07.37.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 07:37:58 -0700 (PDT)
Subject: Re: [PATCH] net:phy:dp83867: set up rgmii tx delay
To:     Max Uvarov <muvarov@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net
References: <20190524103523.8459-1-muvarov@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <748ce02b-985d-54ad-8cfe-736f38622e25@gmail.com>
Date:   Fri, 24 May 2019 07:37:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524103523.8459-1-muvarov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2019 3:35 AM, Max Uvarov wrote:
> PHY_INTERFACE_MODE_RGMII_RXID is less then TXID
> so code to set tx delay is never called.
> 
> Signed-off-by: Max Uvarov <muvarov@gmail.com>

Could you provide an appropriate Fixes: tag for this as well as fix the
subject to be:

net: phy: dp83867: Set up RGMII TX delay

(sorry for being uber nitpicking on this)

> ---
>  drivers/net/phy/dp83867.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 2984fd5ae495..5fed837665ea 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -251,10 +251,8 @@ static int dp83867_config_init(struct phy_device *phydev)
>  		ret = phy_write(phydev, MII_DP83867_PHYCTRL, val);
>  		if (ret)
>  			return ret;
> -	}
>  

Is this hunk ^ intentional?

> -	if ((phydev->interface >= PHY_INTERFACE_MODE_RGMII_ID) &&
> -	    (phydev->interface <= PHY_INTERFACE_MODE_RGMII_RXID)) {
> +		/* Set up RGMII delays */
>  		val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIICTL);
>  
>  		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> 

-- 
Florian
