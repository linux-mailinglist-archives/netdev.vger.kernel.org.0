Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051E011DBDD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731815AbfLMByX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:54:23 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33518 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbfLMByX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:54:23 -0500
Received: by mail-pl1-f194.google.com with SMTP id c13so551698pls.0
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 17:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eoiSnk1pHFT7uOPnXRekHlHqWONQYLxlX5qDtDX8dSY=;
        b=JvC9kIOTSQh07g0uueKv8CsEQJLIHIdDAYOwSJVjZ6KWB//ZcIJoLHC/IL1OQlhVX8
         WfmUbi/eqPKlCi0IF3XpMd2txe432VSKfeBRSek5/CSFr4PsmcrNbf/c/27hXJIheXBp
         8AowVD1LlpQk/qISEXN/hoVTFFxrsnsYfKK0iYj4vdJb8A+78tbPy4K8UEIMGECmNLFv
         XURu+S/Chj4NykbboFezGKZCo/YSttUI6kSuA/HFu7uJ06yFoyxB3w1i9Hf6p0bXVyXl
         W3YWYh8tCNqminaGpmJiu/FBqA63YgfRwOlYgPwmFR3fQ2gpGfzvCwNHNSoXkHsFA5zf
         Yxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eoiSnk1pHFT7uOPnXRekHlHqWONQYLxlX5qDtDX8dSY=;
        b=X2KeBGfI/o1WE+hF4RHYxoxQUPK/IYTkGdH6SXbN3d5ATS7lVj4+wZNQwKPXbeIQt+
         EJtlykBL/BNzYNoAB5WKRzylO2fvE5g7BLU46wQHxhhI7Osa8EtfxQXRmfHv/u2SQHfK
         OvvbT7/lqDrMSAr7vFvShc2pwpNZlZGiGC0zCZ7tTa7HRyT6F/1ri1fBYhBNSHCr/10x
         Vgude0toEfOIe06TXiEXKkH0nHWbdBvk6T0Hf6mPDCnOrDXZGjL1up8kO3svZ9b8oYfz
         BwlcRrg/Jp2bgfuyzrfh3KNF97bNkTfuOyd86YtaP0PexiO5J6+pGQvSlUWnb5ODcj7R
         tk/w==
X-Gm-Message-State: APjAAAWNFUz1e9QHasdDNEUBB7Kn2SZJn72QdyIqbd03ct73AQbX+/tR
        ixBuB4r6hhjr7D0kBz5IoPf11HwVzB8=
X-Google-Smtp-Source: APXvYqyY28OE1FdXO6EkG+kFxG1+NEHRTqcjZm0QoYXJ9zNZb4l71RmMfKiOLe4zaXAy1jJilHsWpA==
X-Received: by 2002:a17:902:b195:: with SMTP id s21mr13086226plr.265.1576202062313;
        Thu, 12 Dec 2019 17:54:22 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p4sm9065990pfb.157.2019.12.12.17.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 17:54:22 -0800 (PST)
Date:   Thu, 12 Dec 2019 17:54:18 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191212175418.3b07b7a9@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <AM6PR05MB5142F0F18EA6B6F16C5888CEC5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 20:44:31 +0000, Yuval Avnery wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Thursday, December 12, 2019 10:25 AM
> > To: Yuval Avnery <yuvalav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Andy Gospodarek
> > <andy@greyhouse.net>
> > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > 
> > On Thu, 12 Dec 2019 05:11:12 +0000, Yuval Avnery wrote:  
> > > > > > Okay, please post v2 together with the tests. We don't accept
> > > > > > netdevsim features without tests any more.  
> > > > >
> > > > > I think the only test I can currently write is the enable SR-IOV
> > > > > max_vfs enforcement. Because subdev is not in yet.
> > > > > Will that be good enough?  
> > > >
> > > > It'd be good to test some netdev API rather than just the
> > > > enforcement itself which is entirely in netdevsim, I think.
> > > >
> > > > So max_vfs enforcement plus checking that ip link lists the correct
> > > > number of entries (and perhaps the entries are in reset state after
> > > > enable) would do IMO.  
> > >
> > > Ok, but this is possible regardless of my patch (to enable vfs).  
> > 
> > I was being lenient :) Your patch is only really needed when the devlink API
> > lands, since devlink will display all max VFs not enabled.
> >   
> > > > My knee jerk reaction is that we should populate the values to those
> > > > set via devlink upon SR-IOV enable, but then if user overwrites
> > > > those values that's their problem.
> > > >
> > > > Sort of mirror how VF MAC addrs work, just a level deeper. The VF
> > > > defaults to the MAC addr provided by the PF after reset, but it can
> > > > change it to something else (things may stop working because spoof
> > > > check etc. will drop all its frames, but nothing stops the VF in
> > > > legacy HW from writing its MAC addr register).
> > > >
> > > > IOW the devlink addr is the default/provisioned addr, not
> > > > necessarily the addr the PF has set _now_.
> > > >
> > > > Other options I guess are (a) reject the changes of the address from
> > > > the PF once devlink has set a value; (b) provide some
> > > > device->control CPU notifier which can ack/reject a request from the PF  
> > to change devlink's value..?  
> > > >
> > > > You guys posted the devlink patches a while ago, what was your
> > > > implementation doing?  
> > >
> > > devlink simply calls the driver with set or get.
> > > It is up to the vendor driver/HW if to make this address persistent or not.
> > > The address is not saved in the devlink layer.  
> > 
> > It'd be preferable for the behaviour of the kernel API to not be vendor
> > specific. That defeats the purpose of having an operating system as a HW
> > abstraction layer. SR-IOV devices of today are so FW heavy we can make
> > them behave whatever way we choose makes most sense.
> >   
> > > The MAC address in mlx5 is stored in the HW and persistent (until PF
> > > reset) , whether it is set by devlink or ip link.  
> > 
> > Okay, let's see if I understand. The devlink and ip link interfaces basically do
> > the same thing but one reaches from control CPU and the other one from
> > the SR-IOV host? And on SR-IOV host reset the addresses go back to 00:00..
> > i.e. any?  
> 
> No,
> This will work only in non-SmartNic mode, when e-switch manager is on the host,
> MAC will be accessible through devlink and legacy tools..
> For smartnic, only devlink from the embedded OS will work. Ip link from the host will not work.

I see, is this a more fine grained capability or all or nothing for
SR-IOV control? I'd think that if the SmartNIC's eswitch just
encapsulates all the frames into a L4 tunnel it shouldn't care about L2
addresses.

> > What happens if the SR-IOV host changes the MAC? Is it used by HW or is the
> > MAC provisioned by the control CPU used for things like spoof check?  
> 
> Host shouldn't have privileges to do it.
> If it does, then it's under the host ownership (like in non-smartnic mode).

I see so the MAC is fixed from bare metal host's PoV? And it has to be
set through some high level cloud API (for live migration etc)? 
Do existing software stacks like libvirt handle not being able to set
the MAC happily?

> > Does the control CPU get a notification for SR-IOV host reset? In that case
> > the control CPU driver could restore the MAC addr.  
> 
> Yes, but this is irrelevant here, the MAC is already stored in HW/FW.
> The MAC will reset only when the E-switch manager (on the control CPU) reset.
> 
> > > So from what I understand, we have the freedom to choose how netdevsim  
> > > behave in this case, which means non-persistent is ok.  
> > 
> > To be clear - by persistent I meant that it survives the SR-IOV host's resets,
> > not necessarily written to NVRAM of any sort.  
> 
> Yes, this is my view as well.
> For non-smartnic it will survive VF disable/enable.
> MAC is not stored on NVRAM, it will disappear once the driver on the control CPU resets.
> 
> > I'd like to see netdevsim to also serve as sort of a reference model for device
> > behaviour. Vendors who are not first to implement a feature always
> > complain that there is no documentation on how things should work.  
> 
> Yes, this is a good idea.
> But it seems we are always held back by legacy tools with no well-defined behavior.
