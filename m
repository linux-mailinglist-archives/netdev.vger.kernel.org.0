Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB23EC832
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 10:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhHOIz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 04:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbhHOIz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 04:55:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6D3C0613CF
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 01:54:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id bt14so10480942ejb.3
        for <netdev@vger.kernel.org>; Sun, 15 Aug 2021 01:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=W6ZMorVzkKpkv9QWuIbPmieQrmTuzqC3n4aLplOaHQc=;
        b=N1bTt8l3NISMpLN4mSHo036NFAp3Ani7WSQ86MDOBlovXUfR/E4VvDmynnvSx7Xrs+
         JT7NsqjB57U0siAUqc4+zs7qH3LMe9nYmVFQ+9ge+2ApdC+eWU7JvxPNZR19EqFD20gS
         yVDLNHXbDv5YqE+HKCD25lgcw4KDaQH2yaiws=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=W6ZMorVzkKpkv9QWuIbPmieQrmTuzqC3n4aLplOaHQc=;
        b=fGKpuXXxxzZA+bu5kcJNYUOY3xWDUMLIpxyX02dT5obTUT1HZl/+TtpDDbA2vah90C
         rWXYF2lHZqdSUSYQAvHiaV6e+ut3YwVQWuECOn9yROtv2CgVPFMIVQwyGMVMQTzIs9T9
         ckf8S9mUfBsbdGb4H9lCfpwtoQYhMN00af6P/c75IJ9Lajoun4udX8XdP3Q4I2rynXrR
         DLNs4mGk+imjdVQAf4uQfZZ93/UxBeXRhDceZinsWPKetTCkLvLfhmnWeB0PkfBPM8Ok
         cWk5b/oxAmCAOa7gV1xW9DTRCokc8+yf7Wjb5rwQ1F5B3sradugbzb7c/egJaY+V/4x4
         jc+Q==
X-Gm-Message-State: AOAM533rMTqco+JeCZp8SSco5TKb8aRIKqsP63UFExspKR0rfFfljun0
        MIiqIcgI8P5QoOVALub6bStePQ==
X-Google-Smtp-Source: ABdhPJwE87RFxxVjteM+wj1f2BuIvddB2aeIPNnFUi2TwlW02yJmBDQr+gVMF0Q1agqQh1y4ClrJ4A==
X-Received: by 2002:a17:907:3d91:: with SMTP id he17mr10800808ejc.355.1629017696710;
        Sun, 15 Aug 2021 01:54:56 -0700 (PDT)
Received: from carbon (78-83-68-78.spectrumnet.bg. [78.83.68.78])
        by smtp.gmail.com with ESMTPSA id cz17sm3199002edb.36.2021.08.15.01.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 01:54:56 -0700 (PDT)
Date:   Sun, 15 Aug 2021 11:54:55 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: ignore the return value from
 set_registers();
Message-ID: <YRjWXzYrQsGZiISc@carbon>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        paskripkin@gmail.com, stable@vger.kernel.org, davem@davemloft.net
References: <20210812082351.37966-1-petko.manolov@konsulko.com>
 <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813162439.1779bf63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-13 16:24:39, Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 11:23:51 +0300 Petko Manolov wrote:
> > The return value need to be either ignored or acted upon, otherwise 'deadstore'
> > clang check would yell at us.  I think it's better to just ignore what this
> > particular call of set_registers() returns.  The adapter defaults are sane and
> > it would be operational even if the register write fail.
> > 
> > Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> > ---
> >  drivers/net/usb/pegasus.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> > index 652e9fcf0b77..49cfc720d78f 100644
> > --- a/drivers/net/usb/pegasus.c
> > +++ b/drivers/net/usb/pegasus.c
> > @@ -433,7 +433,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
> >  	data[2] = loopback ? 0x09 : 0x01;
> >  
> >  	memcpy(pegasus->eth_regs, data, sizeof(data));
> > -	ret = set_registers(pegasus, EthCtrl0, 3, data);
> > +	set_registers(pegasus, EthCtrl0, 3, data);
> >  
> >  	if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
> >  	    usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
> 
> This one is not added by the recent changes as I initially thought, 
> the driver has always checked this return value. The recent changes 
> did this:
> 
>         ret = set_registers(pegasus, EthCtrl0, 3, data);
>  
>         if (usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS ||
>             usb_dev_id[pegasus->dev_index].vendor == VENDOR_LINKSYS2 ||
>             usb_dev_id[pegasus->dev_index].vendor == VENDOR_DLINK) {
>                 u16 auxmode;
> -               read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +               ret = read_mii_word(pegasus, 0, 0x1b, &auxmode);
> +               if (ret < 0)
> +                       goto fail;
>                 auxmode |= 4;
>                 write_mii_word(pegasus, 0, 0x1b, &auxmode);
>         }
>  
> +       return 0;
> +fail:
> +       netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
>         return ret;
> }
> 
> now the return value of set_registeres() is ignored. 
> 
> Seems like  a better fix would be to bring back the error checking, 
> why not?

Mostly because for this particular adapter checking the read failure makes much
more sense than write failure.

Checking the return value of set_register(s) is often usless because device's
default register values are sane enough to get a working ethernet adapter even
without much prodding.  There are exceptions, though, one of them being
set_ethernet_addr().

You could read the discussing in the netdev ML, but the essence of it is that
set_ethernet_addr() should not give up if set_register(s) fail.  Instead, the
driver should assign a valid, even if random, MAC address.

It is much the same situation with enable_net_traffic() - it should continue
regardless.  There are two options to resolve this: a) remove the error check
altogether; b) do the check and print a debug message.  I prefer a), but i am
also not strongly opposed to b).  Comments?

> Please remember to add a fixes tag.

Will do.


cheers,
Petko
