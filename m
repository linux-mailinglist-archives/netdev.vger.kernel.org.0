Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27BA51194E
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 16:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiD0OSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 10:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237393AbiD0OSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 10:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD95A5468C
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 07:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 340F861D9E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 14:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8A1C385A7;
        Wed, 27 Apr 2022 14:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651068889;
        bh=CRndAupM5/Vg0BD1j2wv4BWeO1eE1Cxrt/zsi6Q0kcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rMEM+qkX7GJ5YfOrbQcXemeU3fQW9QV8wbGoDZaw3+Cp9ORhHYzUxEoR7f16dwvmx
         +uZiAOSyqSSnPpT2f+jmXagzayjTpHJijw2yZohgGstD4QUgaPIKrItN64dY/tXjPl
         cRwlg7feYFUSUyU2AOLOlKYpHz05XVlqr1P/+jBUESx/SMglbh1OJl0HYhpgq9NBjq
         JEnuwzETRB/fTqV8/JuV5DpUoFFaoNy0E0pbnxkMW5jnbdkYWP+Mpf71us7RHBbOCt
         P6VO0HWZcxLhf1TM7/Jv4BI4RqiHdzObTAhsNHsb85naou5S2JRCyJf75Rl48lzDJb
         JifiCBL1QSH+Q==
Date:   Wed, 27 Apr 2022 07:14:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220427071447.69ec3e6f@kernel.org>
In-Reply-To: <YmjyRgYYRU/ZaF9X@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
        <20220425090021.32e9a98f@kernel.org>
        <Ymb5DQonnrnIBG3c@shredder>
        <20220425125218.7caa473f@kernel.org>
        <YmeXyzumj1oTSX+x@nanopsycho>
        <20220426054130.7d997821@kernel.org>
        <Ymf66h5dMNOLun8k@nanopsycho>
        <20220426075133.53562a2e@kernel.org>
        <YmjyRgYYRU/ZaF9X@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Apr 2022 09:35:34 +0200 Jiri Pirko wrote:
> >> The relationship-by-name sounds a bit fragile to me. The names of
> >> components are up to the individual drivers.  
> >
> >I asked you how the automation will operate. You must answer questions
> >if you want to have a discussion. Automation is the relevant part.  
> 
> Automation, not sure. It would probably just see type of gearbox and
> flash it. Not sure I understand the question, perhaps you could explain?
> Plus, the possibility is to auto-flash the GB from driver directly.
> 
> 
> >You're not designing an interface for SDK users but for end users.  
> 
> Sure, that is the aim of this API. Human end user. That is why I wanted
> the user to see the relationships between devlink dev, line cards and
> the gearboxes on them. If you want to limit the visibility, sure, just
> tell me how.

Okay, we have completely different views on what the goals should be.
Perhaps that explains the differences in the design.

Of the three API levels (SDK, automation, human) I think automation
is the only one that's interesting to us in Linux. SDK interfaces are
necessarily too low level as they expose too much of internal details
to standardize. Humans are good with dealing with uncertainty and
diverse so there's no a good benchmark.

The benchmark for automation is - can a machine use this API across
different vendors to reliably achieve its goals. For FW info/flashing
the goal is keeping the FW versions up to date. This is documented:

https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management

What would the pseudo code look like with "line cards" in the picture?
Apply RFC1925 truth 12.

> >> There is no new command for that, only one nested attribute which
> >> carries the device list added to the existing command. They are no new
> >> objects, they are just few nested values.  
> >
> >DEVLINK_CMD_LINECARD_INFO_GET  
> 
> Okay, that is not only to expose devices. That is also to expose info
> about linecards, like HW revision, INI version etc. Where else to put
> it? I can perhaps embed it into devlink dev info, but I thought separate
> command would be more suitable. object cmd, object info cmd. It is
> more clear I believe.

> >> If so, how does the user know if/when to flash it?
> >> If not, where would you list it if devices nest is not the correct place?  
> >
> >Let me mock up what I had in mind for you since it did not come thru 
> >in the explanation:
> >
> >$ devlink dev info show pci/0000:01:00.0
> >    versions:
> >        fixed:
> >          hw.revision 0
> >          lc2.hw.revision a
> >          lc8.hw.revision b
> >        running:
> >          ini.version 4
> >          lc2.gearbox 1.1.3
> >          lc8.gearbox 1.2.3  
> 
> Would be rather:
> 
>           lc2.gearbox0 1.1.3
>           lc2.gearbox1 1.2.4

I thought you said your gearboxes all the the same FW? 
Theoretically, yes. Theoretically, I can also have nested "line cards".

>           lc8.gearbox0 1.2.3
> 
> Okay, I see. So instead of having clear api with relationships and
> clear human+machine readability we have squahed indexes into strings.
> I fail to see the benefit, other than no-api-extension :/ On contrary.

Show me the real life use for all the "clear api with relationships"
and I'll shut up.

I would not take falling back to physical (HW) hierarchy for the API
design as a point of pride. Seems lazy if I'm completely honest.
Someone else's HW may have a different hierarchy, and you're just
forcing the automation engineer iterate over irrelevant structures
("devices").

My hunch is that automation will not want to deal with line cards
separately, and flash the entire devices in one go to a tested and
verified bundle blob provided by the vendor. If they do want to poke 
at line cards - the information is still there in what I described.

> >$ devlink lc show pci/0000:01:00.0 lc 8
> >pci/0000:01:00.0:
> >  lc 8 state active type 16x100G
> >    supported_types:
> >      16x100G
> >    versions: 
> >      lc8.hw.revision (a) 
> >      lc8.gearbox (1.2.3)
> >
> >Where the data in the brackets is optionally fetched thru the existing
> >"dev info" API, but rendered together by the user space.  
> 
> Quite odd. I find it questionable to say at least to mix multiple
> command netlink outputs into one output.

Really? So we're going to be designing kernel APIs so that each message
contains complete information and can't contain references now?

> The processing of it would be a small nightmare considering the way
> how the netlink message processing works in iproute2 :/
