Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC703DF3EA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbhHCR0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238172AbhHCR0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 13:26:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694DFC06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 10:26:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id o5so37526849ejy.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 10:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=N1Qe9TsgSzJpSwt+luP/6/md0IyKL4bJHO0YNjhwkx8=;
        b=T2Ft/lNCv4gilYjeIIFiaBE2bdM1yh0hZiMZXToC0s6MzVcqd3jvm+Mt+1vyvEJDhC
         mI9lNxrk0+1H8swdW8gw++EdtAAyw1zabZru37YQpoxlHxbJ9MFithg/wKgCcivetLnZ
         u9i0dsVE5SUYYetTDyfjEoiVpcFVl7ZNMegIE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=N1Qe9TsgSzJpSwt+luP/6/md0IyKL4bJHO0YNjhwkx8=;
        b=rVOXS8y30Jg54CBfGwIdDk0N4Jr/od1PinNGE44yvBXkJXyKNktwT0DeG85tNz7aje
         vKyoAffzraFHvHGqEw1rYqCxPd0waHMoUpHPP9OirLE5SZcfxzmgHNZe6UIdhtbs/yrf
         M7TaD138rVMxiHnhBhp+bNrtJEn9gD7pGV5U9bOfTNRU7+rBHr+QOY5exgy8ey5KxNJd
         CwhQyHcKibB0H+73VK+27xezmHur0WZD45bJYwu7VJpaCNBBbr2eVHnbstf4bA1UYSjl
         7mi5d0NU7EkcYW+AHLKgVFA7MZlQWabK3+agHRDBnqllImc0wnCvhAOdknZmMkBa0Y10
         Buhg==
X-Gm-Message-State: AOAM530FocrEnZUccM6j/i2VCr/lM6A7ojunsYd0liPW3D1uBTxZrNI0
        pjkNLVUFP1WGj04GmWHQ333poQ==
X-Google-Smtp-Source: ABdhPJw1EQxvBL7pr3J6l7rNorckSN+j3Z4vplu26A8XbjySOK8vJukdmsmVti8yMZH/pZKDprgZdw==
X-Received: by 2002:a17:907:2145:: with SMTP id rk5mr15887098ejb.94.1628011584057;
        Tue, 03 Aug 2021 10:26:24 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id i6sm8542059edt.28.2021.08.03.10.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:26:23 -0700 (PDT)
Date:   Tue, 3 Aug 2021 20:26:22 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
Subject: Re: [PATCH net v2 1/2] Check the return value of get_geristers() and
 friends;
Message-ID: <YQl8Pr42Oj4PafFP@carbon>
Mail-Followup-To: Pavel Skripkin <paskripkin@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Petko Manolov <petkan@nucleusys.com>
References: <20210803161853.5904-1-petko.manolov@konsulko.com>
 <20210803161853.5904-2-petko.manolov@konsulko.com>
 <69cedfb2-fc76-0afb-3a48-f24f238d5330@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69cedfb2-fc76-0afb-3a48-f24f238d5330@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-03 19:45:56, Pavel Skripkin wrote:
> On 8/3/21 7:18 PM, Petko Manolov wrote:
> > From: Petko Manolov <petkan@nucleusys.com>
> > 
> > Certain call sites of get_geristers() did not do proper error handling.  This
> > could be a problem as get_geristers() typically return the data via pointer to a
> > buffer.  If an error occured the code is carelessly manipulating the wrong data.
> > 
> > Signed-off-by: Petko Manolov <petkan@nucleusys.com>
> > ---
> >   drivers/net/usb/pegasus.c | 104 ++++++++++++++++++++++++++------------
> >   1 file changed, 72 insertions(+), 32 deletions(-)
> > 
> > diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> > index 9a907182569c..06e3ae6209b0 100644
> > --- a/drivers/net/usb/pegasus.c
> > +++ b/drivers/net/usb/pegasus.c
> > @@ -132,9 +132,15 @@ static int get_registers(pegasus_t *pegasus, __u16 indx, __u16 size, void *data)
> >   static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
> >   			 const void *data)
> >   {
> > -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
> > +	int ret;
> > +
> > +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REGS,
> >   				    PEGASUS_REQT_WRITE, 0, indx, data, size,
> >   				    1000, GFP_NOIO);
> > +	if (ret < 0)
> > +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> > +
> > +	return ret;
> >   }
> >   /*
> > @@ -145,10 +151,15 @@ static int set_registers(pegasus_t *pegasus, __u16 indx, __u16 size,
> >   static int set_register(pegasus_t *pegasus, __u16 indx, __u8 data)
> >   {
> >   	void *buf = &data;
> > +	int ret;
> > -	return usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
> > +	ret = usb_control_msg_send(pegasus->usb, 0, PEGASUS_REQ_SET_REG,
> >   				    PEGASUS_REQT_WRITE, data, indx, buf, 1,
> >   				    1000, GFP_NOIO);
> > +	if (ret < 0)
> > +		netif_dbg(pegasus, drv, pegasus->net, "%s failed with %d\n", __func__, ret);
> > +
> > +	return ret;
> >   }
> >   static int update_eth_regs_async(pegasus_t *pegasus)
> > @@ -188,10 +199,9 @@ static int update_eth_regs_async(pegasus_t *pegasus)
> >   static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
> >   {
> > -	int i;
> > -	__u8 data[4] = { phy, 0, 0, indx };
> > +	int i, ret = -ETIMEDOUT;
> >   	__le16 regdi;
> > -	int ret = -ETIMEDOUT;
> > +	__u8 data[4] = { phy, 0, 0, indx };
> >   	if (cmd & PHY_WRITE) {
> >   		__le16 *t = (__le16 *) & data[1];
> > @@ -211,8 +221,9 @@ static int __mii_op(pegasus_t *p, __u8 phy, __u8 indx, __u16 *regd, __u8 cmd)
> >   		goto fail;
> 		^^^^^^^^^
> 
> I really don't want You to spin this series one more time, but ret
> initialization is missed here again :) Maybe, it's not really important
> here...

I'll respin this as many times as needed. :)

> And Fixes or CC stable is missed too

Done.


cheers,
Petko
