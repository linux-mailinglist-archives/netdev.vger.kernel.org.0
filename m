Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FCB68EE50
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjBHLym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHLyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:54:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C781F4614B;
        Wed,  8 Feb 2023 03:54:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60B1461645;
        Wed,  8 Feb 2023 11:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300DFC433EF;
        Wed,  8 Feb 2023 11:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675857279;
        bh=3m4tPCbfDpqvwcU5jQ6xFjRz0if1wl6eQOR/rQmM8sM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UEakdcWXtwCMfKEBP2vGyqnugNorT7qBkh8MVl7tQHl+Mt3jU9hVNhoP6G3C926f/
         GXA11i47bWT0ZtOAffM9uHGk9vnf01oXbk1PIvNKeKNuqaFxHsO+hUPg3LpST3QFgB
         ER/ZaZVoat92T7NSE4sZqUsdsccnj3dCzLRgVyQw=
Date:   Wed, 8 Feb 2023 12:54:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Qi Zheng <zhengqi.arch@bytedance.com>,
        patchwork-bot+netdevbpf@kernel.org, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] some minor fixes of error checking about
 debugfs_rename()
Message-ID: <Y+ONeIN0p25fwjEu@kroah.com>
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
 <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
 <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
 <20230207103124.052b5ce1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207103124.052b5ce1@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 10:31:24AM -0800, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 18:30:40 +0800 Qi Zheng wrote:
> > > Here is the summary with links:
> > >    - [1/3] debugfs: update comment of debugfs_rename()
> > >      (no matching commit)
> > >    - [2/3] bonding: fix error checking in bond_debug_reregister()
> > >      https://git.kernel.org/netdev/net/c/cbe83191d40d
> > >    - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
> > >      (no matching commit)  
> > 
> > Does "no matching commit" means that these two patches have not been
> > applied? And I did not see them in the linux-next branch.
> 
> Correct, we took the networking patch to the networking tree.
> You'd be better off not grouping patches from different subsystems
> if there are no dependencies. Maintainers may get confused about
> who's supposed to apply them, err on the side of caution and 
> not apply anything.
> 
> > If so, hi Greg, Can you help to review and apply these two patches
> > ([1/3] and [3/3])?

If someone sends me patch 1, I can and will review it then.  Otherwise,
digging it out of a random patch series is pretty impossible with my
patch load, sorry.

thanks,

greg k-h
