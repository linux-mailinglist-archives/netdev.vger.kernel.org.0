Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016FD469159
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 09:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239117AbhLFIWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 03:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhLFIWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 03:22:08 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6BFC0613F8
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 00:18:40 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r25so39282328edq.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 00:18:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FLgL+Rg5NCWWzElR7HWgwgoRaulskX+Kpx0ShYHWA4g=;
        b=HeXOxSvsb3IQDAQJCPVtS/s2ZEBLsE+nYrdqrvLJPxHAYqYTMwtZyRHxEuVlf/RRqu
         7rjQhPHN8mXduSrG5bxgTV5itD/FTevXOLG5wA1s+sJRnDNXbmR4bVqgiSmz/ZTPm2aR
         bjdQ1AFjUNjckpD2SOLtFQZTLCIvQSrberNSgQ7NIX/IpOkwGbXdCL0NxhiRjzPJ9XwV
         A2N1SL5jz0Dln/1O6mVSaBbnNxGebqvh7wVzb1z2eFbG7ID9vBWjXS3HqjlRqpxtSypP
         vHCyHsjCI+nx6DZxejOB9nT3iO1A0lMqoeYET/B2Z1dkXffUCsFVoJloz01NOgFqu9Qk
         iX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FLgL+Rg5NCWWzElR7HWgwgoRaulskX+Kpx0ShYHWA4g=;
        b=MfB23+rf+egbBm1UwHxmypAYH3mnjYXckc6JeJiIE03qCGaoQdEwqX8GfPNumJJf4I
         /9lFsH3LmreMlb5v8jQ+2iMigfkslJDLFnV6MHgHBDFW9B0QMiNa55PL9kg3qhPIIdWx
         SBamZza8teTKU9N024TQLtScZUNlxP3Mucvk/QqQiixQWhpRCiBCaeD/9+ZNYtYAU0RF
         1MsFiNayJtm3HskYtsFG8dviGTYfgVQRsprFIA8SjuqDUCl6yee1xDv3xrXVeR1VcoXg
         gx6N6mSYlsbf23wz2XUF7eB+7DjZuZt3NU7rPMZJ3BwmTneHwJSiXjP60UYrcnbPctHA
         f/OA==
X-Gm-Message-State: AOAM531hXBUvvlRXAw5PM5f7HsUNeMhDGRHArLMoCUp6QGVsBYv4Irzr
        zNUQdmMsybDRXETJuQlxpGzAFQ==
X-Google-Smtp-Source: ABdhPJys1al501SDYxS07ftVK+p4x0A9MhwESfT8VSNJ46D9DGjKs/0Zep+412Ex1NGUBrx7LKzAfA==
X-Received: by 2002:a05:6402:40d3:: with SMTP id z19mr52626437edb.185.1638778718702;
        Mon, 06 Dec 2021 00:18:38 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u16sm7442151edr.43.2021.12.06.00.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 00:18:38 -0800 (PST)
Date:   Mon, 6 Dec 2021 09:18:37 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] net/mlx5: Memory optimizations
Message-ID: <Ya3HXZ04TtkrHud2@nanopsycho>
References: <20211130150705.19863-1-shayd@nvidia.com>
 <20211130113910.25a9e3ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <879d6d7c-f789-69bc-9f2d-bf77d558586a@nvidia.com>
 <20211202093129.2713b64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <36d138a36fb1f86397929d56e6b716e89fc61e2e.camel@nvidia.com>
 <20211202172803.10cd5deb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202172803.10cd5deb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 03, 2021 at 02:28:03AM CET, kuba@kernel.org wrote:
>On Thu, 2 Dec 2021 18:55:37 +0000 Saeed Mahameed wrote:
>> On Thu, 2021-12-02 at 09:31 -0800, Jakub Kicinski wrote:
>> > On Wed, 1 Dec 2021 10:22:17 +0200 Shay Drory wrote:  
>> > > EQ resides in the host memory. It is RO for host driver, RW by
>> > > device.
>> > > When interrupt is generated EQ entry is placed by device and read
>> > > by driver.
>> > > It indicates about what event occurred such as CQE, async and more.  
>> > 
>> > I understand that. My point was the resource which is being consumed
>> > here is _host_ memory. Is there precedent for configuring host memory
>> > consumption via devlink resource?
>> 
>> it's a device resource size nonetheless, devlink resource API makes
>> total sense.
>
>I disagree. Devlink resources were originally written to partition
>finite device resources. You're just sizing a queue here.
>
>> > I'd even question whether this belongs in devlink in the first place.
>> > It is not global device config in any way. If devlink represents the
>> > entire device it's rather strange to have a case where main instance
>> > limits a size of some resource by VFs and other endpoints can still
>> > choose whatever they want.
>> 
>> This resource is per function instance, we have devlink instance per
>> function, e.g. in the VM, there is a VF devlink instance the VM user
>> can use to control own VF resources. in the PF/Hypervisor, the only
>> devlink representation of the VF will be devlink port function (used
>> for other purposes)
>> 
>> for example:
>> 
>> A tenant can fine-tune a resource size tailored to their needs via the
>> VF's own devlink instance.
>
>Yeah, because it's a device resource. Tenant can consume their host
>DRAM in any way they find suitable.
>
>> An admin can only control or restrict a max size of a resource for a
>> given port function ( the devlink instance that represents the VF in
>> the hypervisor). (note: this patchset is not about that)
>> 
>> > > So far no feedback by other vendors.
>> > > The resources are implemented in generic way, if other vendors
>> > > would
>> > > like to implement them.  
>> > 
>> > Well, I was hoping you'd look around, but maybe that's too much to
>> > ask of a vendor.  
>> 
>> We looked, eq is a common object among many other drivers.
>> and DEVLINK_PARAM_GENERIC_ID_MAX_MACS is already a devlink generic
>> param, and i am sure other vendors have limited macs per VF :) .. 
>> so this applies to all vendors even if they don't advertise it.
>
>Yeah, if you're not willing to model the Event Queue as a queue using
>params seems like a better idea than abusing resources.

I think you are right. On second thought, param look like a better fit.

