Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BA658EF77
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 17:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbiHJPfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 11:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiHJPfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 11:35:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0579B639D;
        Wed, 10 Aug 2022 08:35:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 810665C2C0;
        Wed, 10 Aug 2022 15:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660145712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=phOPmviTrSVc6Big96eHWPdI379M+oLowb8bvheVGbk=;
        b=vSpntsQOQb7xiH283KdJV4ICFJAnKibgpEsUzpyvzMg9yKRTkJOc0RotVWc+2f/8ScxThn
        Wb0ZlORQrZU4hf2Dl9uxGJQiLwvQ14MECuQjYwHtMDM8lr2M3y1KL5ptvlPjCBvdXVsc6N
        C8nS1J/17jgzCASRdtPjWpC/BizWc90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660145712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=phOPmviTrSVc6Big96eHWPdI379M+oLowb8bvheVGbk=;
        b=tIhRSNwZTHtQ7eWJ2iK6vAbvSyWZW937veYhvnORwW6g+nKtDWys0huEb+5vzXm6wIRFZu
        FcoolSUJmbuYdcDg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 279E32C1CD;
        Wed, 10 Aug 2022 15:35:12 +0000 (UTC)
Date:   Wed, 10 Aug 2022 17:35:10 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220810153510.GS17705@kitsune.suse.cz>
References: <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
 <20220809224535.ymzzt6a4v756liwj@pali>
 <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
 <YvMF1JW3RzRbOhlx@lunn.ch>
 <20220810071603.GR17705@kitsune.suse.cz>
 <YvPMJLSuG3CBC//n@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvPMJLSuG3CBC//n@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 05:17:56PM +0200, Andrew Lunn wrote:
> > > I guess you are new to the netdev list :-)
> > > 
> > > This is one of those FAQ sort of things, discussed every
> > > year. Anything like this is always NACKed. I don't see why this time
> > > should be any different.
> > > 
> > > DSA is somewhat special because it is very old. It comes from before
> > > the times of DT. Its DT binding was proposed relatively earl in DT
> > > times, and would be rejected in modern days. But the rules of ABI mean
> > > the label property will be valid forever. But i very much doubt it
> > > will spread to interfaces in general.
> > 
> > And if this is a FAQ maybe you can point to a summary (perhaps in
> > previous mail discusssion) that explains how to provide stable interface
> > names for Ethernet devices on a DT based platform?
> 
> As far so the kernel is concerned, interface names are unstable. They
> have never been truly stable, but they have got more unstable in the
> past decade with multiple busses being probed in parallel, which did
> not happen before so much.
> 
> > On x86 there is a name derived from the device location in the bus
> > topology
> 
> This is nothing to do with x86. That is userspace, e.g. systemd,
> renaming the interfaces. This applies for any architecture for which
> systemd runs on.
> 
> > which may be somewhat stable but it is not clear that it
> > cannot change, and there is an optional BIOS provided table that can
> > asssign meaningful names to the interfaces.
> 
> I doubt the kernel is looking at ACPI tables. It is user space which
> does that.
> 
> The kernel provides udev with a bunch of information about the
> interface, its bus location, MAC address, etc. Userspace can then
> decide what it wants to call it, and what its alternative names are,
> etc.
> 
> Also, this is not just a network interface name problem. Any device
> with a number/letter in it is unstable. I2C bus devices: i2c0,
> i2c1... SPI bus deviceS: spi0, spi1...,

Thees do have numbered aliases in the DT. I don't know if the kernel
uses them for anything.

> Block devices, sda, sdb, sdc,

These too, at least mmc.

Thanks

Michal
