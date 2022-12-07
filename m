Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1286464F5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiLGXWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiLGXWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8F72AC41;
        Wed,  7 Dec 2022 15:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85E4561CE1;
        Wed,  7 Dec 2022 23:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964F9C433C1;
        Wed,  7 Dec 2022 23:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670455318;
        bh=dVKNuSs23/RLcOZiUdgdY2RGcdWZI8KuPFx1NSO6Lg4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=niOao95J921qZ+6Nvip0Uv3W/z/wALnJXAO129lsAWEgxw6Polxdli306eglq8SYp
         qL6LG2B7ws4h2a08ROAHnFnZMHm6FrlKM6LRxffHEOLZ328nJsXyo93LFpDTZdTZKp
         wOxgeEmmxugjdDJPu10tFE6i9L7/tFB23hJTEacxvnHcybODlW8EY/U0tuotOOGUjC
         bdHNkEmFvVZyiFgel2N1lfGEEOhtPoz4jHMguosdcvPaeoT86sQkIpQCCKN8SPwywC
         ho+VzMjeREGZYfAsPlUEvBSqAkNleooZiFlyomhGmPwThqimVRoifiMzEDGPq/cD+G
         hwhqbZOGdHysA==
Date:   Wed, 7 Dec 2022 15:21:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <netdev.dump@gmail.com>
Cc:     "'Jiri Pirko'" <jiri@resnulli.us>,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        "'Vadim Fedorenko'" <vfedorenko@novek.ru>,
        "'Jonathan Lemon'" <jonathan.lemon@gmail.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20221207152157.6185b52b@kernel.org>
In-Reply-To: <10bb01d90a45$77189060$6549b120$@gmail.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 15:09:03 +0100 netdev.dump@gmail.com wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, December 7, 2022 3:48 AM
> > Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
> > 
> > On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:  
>  [...]  
> capable
>  [...]  
> require
>  [...]  

Please fix line wrapping in your email client. 
And add a name to your account configuration :/

> > > Yep, you have the knowledge of sharing inside the driver, so you should
> > > do it there. For multiple instances, use in-driver notifier for example.  
> > 
> > No, complexity in the drivers is not a good idea. The core should cover
> > the complexity and let the drivers be simple.  
> 
> But how does Driver A know where to connect its pin to? It makes sense to
> share 

I think we discussed using serial numbers.

> pins between the DPLLs exposed by a single driver, but not really outside of
> it.
> And that can be done simply by putting the pin ptr from the DPLLA into the
> pin
> list of DPLLB.

Are you saying within the driver it's somehow easier? The driver state
is mostly per bus device, so I don't see how.

> If we want the kitchen-and-sink solution, we need to think about corner
> cases.
> Which pin should the API give to the userspace app - original, or
> muxed/parent?

IDK if I parse but I think both. If selected pin is not directly
attached the core should configure muxes.

> How would a teardown look like - if Driver A registered DPLLA with Pin1 and
> Driver B added the muxed pin then how should Driver A properly
> release its pins? Should it just send a message to driver B and trust that
> it
> will receive it in time before we tear everything apart?

Trivial.

> There are many problems with that approach, and the submitted patch is not
> explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
> free 
> counterpart + no flows.

SMOC.

> If we want to get shared pins, we need a good example of how this mechanism
> can be used.

Agreed.

> > > There are currently 3 drivers for dpll I know of. This in ptp_ocp and
> > > mlx5 there is no concept of sharing pins. You you are talking about a
> > > single driver.
> > >
> > > What I'm trying to say is, looking at the code, the pin sharing,
> > > references and locking makes things uncomfortably complex. You are so
> > > far the only driver to need this, do it internally. If in the future
> > > other driver appears, this code would be eventually pushed into dpll
> > > core. No impact on UAPI from what I see. Please keep things as simple as
> > > possible.  
> > 
> > But the pin is shared for one driver. Who cares if it's not shared in
> > another. The user space must be able to reason about the constraints.
> > 
> > You are suggesting drivers to magically flip state in core objects
> > because of some hidden dependencies?!
> 
> If we want to go outside the device, we'd need some universal language
> to describe external connections - such as the devicetree. I don't see how
> we can reliably implement inter-driver dependency otherwise.

There's plenty examples in the tree. If we can't use serial number
directly we can compare the driver pointer + whatever you'd compare
in the driver internal solution.

> I think this would be better served in the userspace with a board-specific
> config file. Especially since the pins can be externally connected anyway.

Opinions vary, progress is not being made.
