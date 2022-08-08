Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580F958CFE2
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbiHHVp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiHHVp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:45:26 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6228F5F55;
        Mon,  8 Aug 2022 14:45:25 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DBD49345DB;
        Mon,  8 Aug 2022 21:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659995123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN7ifBF3lT4yinqLuCuSySW0xM2vuY23IO9TR81zg0s=;
        b=C1QqPvqgdkuktIvJHIPThIyVf9jBTYqPCnVu3dzwCFCyyCGySfprsX+7TOSm7cFDuRu8PO
        zivSwh2q3pt4QdcKVi6m+JYKIG1P2Q0MJcUaA+wPJetl35FpFDk8ZfgwzC8RXJqip5r89D
        yw1wzkfuV5CWLuFZDgk8M+hoM0W8hWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659995123;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DN7ifBF3lT4yinqLuCuSySW0xM2vuY23IO9TR81zg0s=;
        b=UER6q+yd3dId7WoIDOmOD1pMlduTlU7pRYXNrWldkBEsNAdpWGDuuEpPe6SideKWd87YnR
        I8jrvb7b+HNA6LAQ==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id B14C72C143;
        Mon,  8 Aug 2022 21:45:23 +0000 (UTC)
Date:   Mon, 8 Aug 2022 23:45:22 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220808214522.GQ17705@kitsune.suse.cz>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220808143835.41b38971@hermes.local>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> On Mon, 8 Aug 2022 23:09:45 +0200
> Michal Suchánek <msuchanek@suse.de> wrote:
> 
> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> > > Hi Tim,
> > > 
> > > On 8/8/22 3:18 PM, Tim Harvey wrote:  
> > > > Greetings,
> > > > 
> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
> > > > aliases in Linux such as:
> > > >         aliases {
> > > >                 ethernet0 = &eqos;
> > > >                 ethernet1 = &fec;
> > > >                 ethernet2 = &lan1;
> > > >                 ethernet3 = &lan2;
> > > >                 ethernet4 = &lan3;
> > > >                 ethernet5 = &lan4;
> > > >                 ethernet6 = &lan5;
> > > >         };
> > > > 
> > > > I know U-Boot boards that use device-tree will use these aliases to
> > > > name the devices in U-Boot such that the device with alias 'ethernet0'
> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> > > > appears that the naming of network devices that are embedded (ie SoC)
> > > > vs enumerated (ie pci/usb) are always based on device registration
> > > > order which for static drivers depends on Makefile linking order and
> > > > has nothing to do with device-tree.
> > > > 
> > > > Is there currently any way to control network device naming in Linux
> > > > other than udev?  
> > > 
> > > You can also use systemd-networkd et al. (but that is the same kind of mechanism)
> > >   
> > > > Does Linux use the ethernet<n> aliases for anything at all?  
> > > 
> > > No :l  
> > 
> > Maybe it's a great opportunity for porting biosdevname to DT based
> > platforms ;-)
> 
> Sorry, biosdevname was wrong way to do things.
> Did you look at the internals, it was dumpster diving as root into BIOS.

When it's BIOS what defines the names then you have to read them from
the BIOS. Recently it was updated to use some sysfs file or whatver.
It's not like you would use any of that code with DT, anyway.

> Systemd-networkd does things in much more supportable manner using existing
> sysfs API's.

Which is a dumpster of systemd code, no thanks.

I want my device naming independent of the init system, especially if
it's systemd.

Thanks

Michal
