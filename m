Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E8F3985ED
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhFBKJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhFBKJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 06:09:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96109C061574;
        Wed,  2 Jun 2021 03:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gyoWzTPbOTpOo0u/SQ46gq2VK5nThaC5qMrTlDuzVYM=; b=G2ePi1hFYFjSpsKzXFAm9u5Gv
        cCCTeqPLjmcBfowYrIzyI0Uttom0tUxtKHtufKYPl36wD1MSi1GwxQ/NRl2s6f/v4q9F5vpkZNI1N
        7W5GUqdH6sU5NaWiotKFyW8yX7Punwx/7rZv2jIH9uHrs8AO6MVmdOy+zjEVspwytBhW88uYJ561c
        24QNN9T3dhGNJs3lpFu4avImC0fiPU3zTTHXsQolB8BVpD14ToO4ezpy8rORUC50s4qK1T8XFkRRC
        cSHYaA9Auf+tTAoAyK7YWFDkUTbztktlib9HcsCD0sWPiwCpXXB1RneKBXiNrrzyH6WqlhqzDpiKW
        J8mrU2yrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44604)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1loNmz-0000w3-VD; Wed, 02 Jun 2021 11:07:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1loNmv-00010O-TG; Wed, 02 Jun 2021 11:07:49 +0100
Date:   Wed, 2 Jun 2021 11:07:49 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     Joe Perches <joe@perches.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "opendmb@gmail.com" <opendmb@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH net-next] net: mdio:
 Fix a typo
Message-ID: <20210602100749.GC30436@shell.armlinux.org.uk>
References: <20210602063914.89177-1-zhengyongjun3@huawei.com>
 <76fd35fe623867c3be3f93b51d5d3461a2eabed9.camel@perches.com>
 <264010307fb24b0193cfd451152bd71d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <264010307fb24b0193cfd451152bd71d@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 07:43:19AM +0000, zhengyongjun wrote:
> Russell King told me to do so...  Did I understand it wrong?  
> But from your opinion, I think "Hz" is more appropriate :)

Sadly, you understood wrong. I requested to change from hz to Hz.

> ```
> Russell King <linux@armlinux.org.uk>
> 
> On Tue, Jun 01, 2021 at 10:18:59PM +0800, Zheng Yongjun wrote:
> > informations  ==> information
> > typicaly  ==> typically
> > derrive  ==> derive
> > eventhough  ==> even though
> 
> If you're doing this, then please also change "hz" to "Hz". The unit of frequency is the latter, not the former. Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> ```
> 
> -----邮件原件-----
> 发件人: Joe Perches [mailto:joe@perches.com] 
> 发送时间: 2021年6月2日 15:25
> 收件人: zhengyongjun <zhengyongjun3@huawei.com>; andrew@lunn.ch; hkallweit1@gmail.com; davem@davemloft.net; kuba@kernel.org; bcm-kernel-feedback-list@broadcom.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> 抄送: opendmb@gmail.com; f.fainelli@gmail.com; linux@armlinux.org.uk
> 主题: Re: [PATCH net-next] net: mdio: Fix a typo
> 
> On Wed, 2021-06-02 at 14:39 +0800, Zheng Yongjun wrote:
> > Hz  ==> hz
> []
> > diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
> []
> > @@ -203,7 +203,7 @@ static void unimac_mdio_clk_set(struct unimac_mdio_priv *priv)
> >  		return;
> >  	}
> > 
> > -	/* The MDIO clock is the reference clock (typically 250MHz) divided by
> > +	/* The MDIO clock is the reference clock (typically 250Mhz) divided by
> 
> No thanks.
> 
> MHz is typical, Mhz is not.
> 
> $ git grep -w -i -o -h mhz | sort |uniq -c | sort -rn
>    5042 MHz
>     571 MHZ
>     398 Mhz
>     353 mhz
>      10 mHz
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
