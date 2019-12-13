Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 489BE11E9C3
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfLMSIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 13:08:39 -0500
Received: from mail-lf1-f47.google.com ([209.85.167.47]:44871 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbfLMSIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 13:08:39 -0500
Received: by mail-lf1-f47.google.com with SMTP id v201so151857lfa.11
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 10:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=uSDbVP2IpEz1j2zd9DOhJ64hIkO1QDTGNHkpAV7s4wA=;
        b=JOA1t0fmXkezwi0lM7V3mjyl9IIRYp301lsMCqoqK1NKNNGD+67XrmMH5aNQHygtkW
         4XwFR7Rlrg2tlU+Gzi/hOHeSDGqdEssnqG3r4QleZEYHhNUpwbtkruFgwU8iIHytD47X
         8H4bksfUhMe/saKHWrqcMNWn6ZW0NRlnlHKHhaJSfZsdTlh0UXmrdEGoacV2AuwX/Q6y
         WuXw7iyk+P2b4yEvyDm9SjrZnJnB4Qha+QoY9OmzsPWdSigAxQyW65om+TeJbUMANx+I
         ektAwma/wCwsBIa7AMsQupdagF1fPkoV/H6u6TusbpkyS5XEQ1qzx5/RK1LHDRUuJXbd
         CHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=uSDbVP2IpEz1j2zd9DOhJ64hIkO1QDTGNHkpAV7s4wA=;
        b=Lqge60mpS4oac2l8142JArXkTjEdSUjb3AGaQky33YhLqdmimJ+dk6/4aPEVcCV3Zw
         ZC3kFS0WkS4SE2zcUcUjwzIw/wYpKJPWW/sWfE24/8Jr7rVc8Yj0BW6+vi2p0nl5KsSA
         MoJ8bQcijIEYx3iXecILIF/vhRLypYAxUisoCk6wNIXv2ImYMbU2vcWFNPes2YN76VI0
         679UtD7bmOhRugcYchRkN7rZnbEZvSjDNQbOCys5TjUDRU9reb/grECyxLyBUseCqCI6
         k6Yz0k9yH2AV6pZUezWHS2JLLiRkbkhg28RH/KdTC042WCatzKUmp/yuL0iHspywfDjP
         oxiA==
X-Gm-Message-State: APjAAAU5+TeCqod2kXNjQ2RbHospwghZXrB9w3Gyjdkb/kPZS7+pLye8
        dkDciQSIoVolZuk/KHMWld3H2Q==
X-Google-Smtp-Source: APXvYqybP2kMdxoCygUBZo9HEip5boksOVEGKDghXrFReOee9i3fChKT0VRaG+HGg2qxvF1Ysa0ZEw==
X-Received: by 2002:a19:7015:: with SMTP id h21mr9478328lfc.68.1576260517093;
        Fri, 13 Dec 2019 10:08:37 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x12sm5254695ljd.92.2019.12.13.10.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 10:08:36 -0800 (PST)
Date:   Fri, 13 Dec 2019 10:08:28 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191213100828.6767de6e@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
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
        <20191212175418.3b07b7a9@cakuba.netronome.com>
        <AM6PR05MB514261CD6F95F104C0353A4BC5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 03:21:02 +0000, Yuval Avnery wrote:
> > I see, is this a more fine grained capability or all or nothing for SR-IOV control?
> > I'd think that if the SmartNIC's eswitch just encapsulates all the frames into a
> > L4 tunnel it shouldn't care about L2 addresses.  
> 
> People keep saying that, but there are customers who wants this capability :)

Right, but we should have a plan for both, right? Some form of a switch
between L4/no checking/ip link changes are okay vs strict checking/L2/
SmartNIC provisions MAC addrs?

> > > > What happens if the SR-IOV host changes the MAC? Is it used by HW or
> > > > is the MAC provisioned by the control CPU used for things like spoof  
> > > > check?  
> > >
> > > Host shouldn't have privileges to do it.
> > > If it does, then it's under the host ownership (like in non-smartnic mode).  
> > 
> > I see so the MAC is fixed from bare metal host's PoV? And it has to be set  
> 
> Yes
> 
> > through some high level cloud API (for live migration etc)?
> > Do existing software stacks like libvirt handle not being able to set the MAC
> > happily?  
> 
> I am not sure what you mean.
> What we are talking about here is the E-switch manager setting a MAC to another VF.
> When the VF driver loads it will query this MAC from the NIC. This is the way
> It works today with "ip link set _vf_ mac"
> 
> Or in other words we are replacing "ip link set _vf_ mac" and not "ip link set address"
> So that it can work from the SmartNic embedded system.
> There is nothing really new here, ip link will not work from a SmartNic,
> this is why need devlink subdev.

Ack, but are we targeting the bare metal cloud scenario here or
something more limited? In a bare metal cloud AFAIU the customers
can use SR-IOV on the host, but the MACs need to be communicated/
/requested from the cloud management system.

IOW the ip link and the devlink APIs are in different domains of
control. Customer has access to ip link and provider has access to
devlink.

So my question is does libvirt run by the customer handle the fact 
that it can't poke at ip link gracefully, and if live migration is
involved how is the customer supposed to ask the provider to move an
address?
