Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6EC1A400
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 22:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfEJU2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 16:28:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43188 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfEJU2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 16:28:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so9162175wro.10;
        Fri, 10 May 2019 13:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4oo9VpI9u4DIMN55RUb50fL1HXNAqX7lB/VYU3Tw7LE=;
        b=VCovYDX9Wyzos5C0L+I7uw39UNUJzRUKzQBCqQJAMJ83uORcI0Qfne601d/zy5yvJi
         Lvv5uNXffTJUEoLAXaU8OLDNyMOIOwDPUJnOk5SG1vof7Xz9KJOT+jygJoL8KC7PnFdB
         yjtRX/k3jJl83o6DjV5VwztTekgeAU9/s7iEkpUuNQzb/wrVCCWBTkldLsE+e1FR/uoL
         8L+/Y+Pl2QebH2nBirtO+GZMBW77oWZy9jrMnEIIDTfx2b6V7bbYO/4g6dreoaPa1nNQ
         6qW+bjAsjs3ubp7YK+CkOoa/2twou6Qs7YvdkZGmfcSCXgTIovaYxc6haxVWUtPuyUT4
         YhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oo9VpI9u4DIMN55RUb50fL1HXNAqX7lB/VYU3Tw7LE=;
        b=Yt19bEqMRaUSbl7mf2mKihNWfIL6KWoitzeOkD2OELYA4P3ItIJGWZjiLM4Q0vABnn
         vIrJeRfjRQ5waH2nvdPXZXyNXvAPoJm3PhEvx+hr+mj1exQWFy1bA6FjVsORS29XPG1s
         iTls9QmdeYXZ6+SQZbce8rNRxIxfD9+ZjtPDavN/KhwlQcleoHaOfpMzAS0Ufk6+bcbC
         L8zsp7/RiA9ki0D+DTs4T3dQAtc/+gZDPbuL50RBflyBHTcSXI8Unww6GVYKHZJ8juZL
         UvKh1XuJl1DTyU8xlaNLVMvk/vlBnpcNF2gXje67T9z6nhO2Io/yLf61gUGv9TC3zU5Q
         IeFg==
X-Gm-Message-State: APjAAAVJ/pDYg0k04FDAhTKm9s0vdW8Il2wzEv5iMOXobq0PZUpp6ivg
        icp5It5TrfqzKNMbF7qnWVEiBJvLvNo=
X-Google-Smtp-Source: APXvYqwuNzEseRsIWDyW2EXkfd43eSF011BcsKgSqhJXIIeU2zzYr3MHuKXEFr6WTOCTb/CoO5Mpbg==
X-Received: by 2002:adf:f788:: with SMTP id q8mr9183954wrp.181.1557520093304;
        Fri, 10 May 2019 13:28:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:b86d:cacd:ffb5:67a5? (p200300EA8BD45700B86DCACDFFB567A5.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:b86d:cacd:ffb5:67a5])
        by smtp.googlemail.com with ESMTPSA id a15sm9528424wru.88.2019.05.10.13.28.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 13:28:12 -0700 (PDT)
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
To:     Vicente Bergas <vicencb@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
Date:   Fri, 10 May 2019 22:28:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.05.2019 17:05, Vicente Bergas wrote:
> Hello,
> there is a regression on linux v5.1-9573-gb970afcfcabd with a kernel null
> pointer dereference.
> The issue is the commit f81dadbcf7fd067baf184b63c179fc392bdb226e
>  net: phy: realtek: Add rtl8211e rx/tx delays config
> which uncovered a bug in phy-core when attempting to call
>  phydev->drv->read_page
> which can be null.
> The patch to drivers/net/phy/phy-core.c below fixes the kernel null pointer
> dereference. After applying the patch, there is still no network. I have
> also tested the patch to drivers/net/phy/realtek.c, but no success. The
> system hangs forever while initializing eth0.
> 
> Any suggestions?
> 
The page operation callbacks are missing in the RTL8211E driver.
I just submitted a fix adding these callbacks to few Realtek PHY drivers
including RTl8211E. This should fix the issue.
Nevertheless your proposed patch looks good to me, just one small change
would be needed and it should be splitted.

The change to phy-core I would consider a fix and it should be fine to
submit it to net (net-next is closed currently).

Adding the warning to the Realtek driver is fine, but this would be
something for net-next once it's open again.

> Regards,
>  Vicenç.
> 
Heiner

> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -648,11 +648,17 @@
> 
> static int __phy_read_page(struct phy_device *phydev)
> {
> +    if (!phydev->drv->read_page)
> +        return -EOPNOTSUPP;
> +   
>     return phydev->drv->read_page(phydev);
> }
> 
> static int __phy_write_page(struct phy_device *phydev, int page)
> {
> +    if (!phydev->drv->write_page)
> +        return -EOPNOTSUPP;
> +
>     return phydev->drv->write_page(phydev, page);
> }
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -214,8 +214,10 @@
>      * for details).
>      */
>     oldpage = phy_select_page(phydev, 0x7);
> -    if (oldpage < 0)
> -        goto err_restore_page;
> +    if (oldpage < 0) {
> +        dev_warn(&phydev->mdio.dev, "Unable to set rgmii delays\n");

Here phydev_warn() should be used.

> +        return 0;
> +    }
> 
>     ret = phy_write(phydev, RTL821x_EXT_PAGE_SELECT, 0xa4);
>     if (ret)
> 
> 

