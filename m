Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75254121B0B
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLPUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:44:56 -0500
Received: from mail-lj1-f174.google.com ([209.85.208.174]:44795 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfLPUox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:44:53 -0500
Received: by mail-lj1-f174.google.com with SMTP id u71so525056lje.11
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 12:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kMZ+ohHFSUBj4hQc2aSeFVGq7nRc0OvU5KlbiMjbC1U=;
        b=ujZB/Y7XeISCORKzGRlgrNhWkJVmLtsJIqjQRHx5AAvtPevbVdxhj+7ZnFTqQlxnOT
         ywCcuI6/3ZZSwDNGgUV3Z2OlRQJADA4E80r+jhBsGjIYgzeZvdKFhBIaPnBQkCaayp3k
         cdBSUzILPpVHqmrO/HxXxeEced2weIlvXBsbrxrZ+mYWxfzBIRImf3dmopSqMVznYFL5
         kpHJ3mdSysLwjr2pF8313eQRKgno86xab/nnqYsjc5Y2KOx3l75w9FEUi19g5rf4qh6W
         EoB7BI5C55KXWLbLIDpQPxCraHBonknMg4SBYyPHUYJEw1mSfoz6ek5IpQq7/V4xnnym
         ZEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kMZ+ohHFSUBj4hQc2aSeFVGq7nRc0OvU5KlbiMjbC1U=;
        b=lk2hpvoZzfXP/5ZrtuOac1zCkrVFa8ltoEvyiK/juftpHu2RbcOuLrJ85tRehYaskd
         JErjdLTsZ9zGbpYWUGLn8qSogD4MLPS0b9+k/rYRTYRCxuPpxHlL3NM6xfeoOXfjcRTz
         tgy/UT3uyXhQKVorEzYVh0Z6hEQkx3lB4HiDtEDaRtKhEWl6YOEhSu9PUzAQgpN6oL89
         toDnWKOhEsWrIIMq27aPPwU90x8typUvlV4EVsvrZaQDgdzWz97jVACgAjZaiddPvfbU
         2LbLArE+SKjSQsfdpyqA9EACT3IdGJQOAwRfy4ASDHkQ8dMn8SO1omeAWCp0J9h/wjPP
         q39A==
X-Gm-Message-State: APjAAAUjcEA9VlViOe4jqxPlsn+QUNKn1XdAJLSruIxYobI8D+qZZ+h6
        SNJIHZx8QNvXiZCaTtbxFX/70Q==
X-Google-Smtp-Source: APXvYqzSVpPLVKvizhOUuIbVJ6jUgR2LXPP3M+uhsQfJpeDvhsg9fL0joJ4evsmOLynV5Oo5+2Gp7g==
X-Received: by 2002:a2e:556:: with SMTP id 83mr712749ljf.127.1576529090387;
        Mon, 16 Dec 2019 12:44:50 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k25sm11097754lji.42.2019.12.16.12.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:44:50 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:44:41 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191216124441.634ea8ea@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB51422CE9C249DB03F486CB63C5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
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
        <20191213100828.6767de6e@cakuba.netronome.com>
        <AM6PR05MB51422CE9C249DB03F486CB63C5540@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 20:05:00 +0000, Yuval Avnery wrote:
> > On Fri, 13 Dec 2019 03:21:02 +0000, Yuval Avnery wrote:  
> > > > I see, is this a more fine grained capability or all or nothing for SR-IOV control?  
> > > > I'd think that if the SmartNIC's eswitch just encapsulates all the
> > > > frames into a
> > > > L4 tunnel it shouldn't care about L2 addresses.  
> > >
> > > People keep saying that, but there are customers who wants this
> > > capability :)  
> > 
> > Right, but we should have a plan for both, right? Some form of a switch
> > between L4/no checking/ip link changes are okay vs strict checking/L2/
> > SmartNIC provisions MAC addrs?  
> 
> I am not sure I understand
> The L2 checks will be on NIC, not on the switch.
> Packet decapsulated and forwarded to the NIC, Where the MAC matters..

If there is tunnelling involved where customer's L2 is not visible to
the provider underlay why does the host ip-link not have a permission
to change the MAC address?

The NIC CPU can just learn about the customer MAC change and configure
the overlay forwarding appropriately.

> > > > > > What happens if the SR-IOV host changes the MAC? Is it used by
> > > > > > HW or is the MAC provisioned by the control CPU used for things
> > > > > > like spoof check?  
> > > > >
> > > > > Host shouldn't have privileges to do it.
> > > > > If it does, then it's under the host ownership (like in non-smartnic mode).  
> > > >
> > > > I see so the MAC is fixed from bare metal host's PoV? And it has to
> > > > be set  
> > >
> > > Yes
> > >  
> > > > through some high level cloud API (for live migration etc)?
> > > > Do existing software stacks like libvirt handle not being able to
> > > > set the MAC happily?  
> > >
> > > I am not sure what you mean.
> > > What we are talking about here is the E-switch manager setting a MAC to another VF.  
> > > When the VF driver loads it will query this MAC from the NIC. This is
> > > the way It works today with "ip link set _vf_ mac"
> > >
> > > Or in other words we are replacing "ip link set _vf_ mac" and not "ip link set address"  
> > > So that it can work from the SmartNic embedded system.
> > > There is nothing really new here, ip link will not work from a
> > > SmartNic, this is why need devlink subdev.  
> > 
> > Ack, but are we targeting the bare metal cloud scenario here or something
> > more limited? In a bare metal cloud AFAIU the customers can use SR-IOV on
> > the host, but the MACs need to be communicated/ /requested from the
> > cloud management system.  
> 
> Yes, so the cloud management system communicates with the Control CPU, not the host,
> Not whatever customer decides to run on the hypervisor. The host PF is powerless here (almost like VF).
> 
> > 
> > IOW the ip link and the devlink APIs are in different domains of control.
> > Customer has access to ip link and provider has access to devlink.  
> 
> For host VF - Customer has access to ip link exactly like in non-smartnic mode.
> For host PF - "ip link set vf" will return error. Everything running on the host is not-trusted.
> 
> > 
> > So my question is does libvirt run by the customer handle the fact that it can't
> > poke at ip link gracefully, and if live migration is involved how is the customer
> > supposed to ask the provider to move an address?  
> 
> I don't understand the question because I don't understand why is it different
> from non-smartnic where the host hypervisor is in-charge.
 
The ip-link API will suddenly start returning errors which may not be
expected to the user space. So the question is what the user space is
you're expecting to run/testing with? _Some_ user space should prove
this design out before we merge it.

The alternative design is to "forward" hosts ip-link requests to the
NIC CPU and let software running there talk to the cloud back end.
Rather than going 
  customer -> could API -> NIC, 
go 
  customer -> NIC -> cloud API
That obviously is more complex, but has the big advantage of nothing 
on the host CPU having to change.
