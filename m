Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DCF563444
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiGANVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiGANVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:21:04 -0400
X-Greylist: delayed 206 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Jul 2022 06:21:02 PDT
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEAB5C9F9;
        Fri,  1 Jul 2022 06:21:02 -0700 (PDT)
Received: from equinox by eidolon.nox.tf with local (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1o7GWa-00GsJJ-Lp; Fri, 01 Jul 2022 15:17:33 +0200
Date:   Fri, 1 Jul 2022 15:17:32 +0200
From:   David Lamparter <equinox@diac24.net>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
References: <20220701044234.706229-1-kuba@kernel.org>
 <Yr7NpQz6/esZAiZv@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr7NpQz6/esZAiZv@nanopsycho>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[culled Cc:]

On Fri, Jul 01, 2022 at 12:34:13PM +0200, Jiri Pirko wrote:
> Fri, Jul 01, 2022 at 06:42:34AM CEST, kuba@kernel.org wrote:
> >The last meaningful change to this driver was made by Jon in 2011.
> >As much as we'd like to believe that this is because the code is
> >perfect the chances are nobody is using this hardware.
> 
> Hmm, I can understand what for driver for HW that is no longer
> developed, the driver changes might be very minimal. The fact that the
> code does not change for years does not mean that there are users of
> this NIC which this patch would break :/

As a "reference datapoint", I'm a user that was affected by the removal
of the Mellanox SwitchX-2 driver about a year ago.  But that was a bit
different since the driver was apparently rather incomplete (I don't
know the details, was still messing around to even get things going.)

(FWIW my use case is in giving old hardware a second life, in this case
completely throwing away the PowerPC control board from Mellanox SX6000
series switches and replacing it with a new custom CPU board...  I might
well be the only person interested in that driver.

> Isn't there some obsoletion scheme globally applied to kernel device
> support? I would expect something like that.

I have the same question - didn't see any such policy but didn't look
particularly hard.  But would like to avoid putting time into making
something work just to have the kernel driver yanked shortly after :)


-David
