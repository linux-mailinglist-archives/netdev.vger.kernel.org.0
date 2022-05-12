Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18D152578B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 00:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353887AbiELWGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 18:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348898AbiELWGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 18:06:50 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD63966FBB
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 15:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bKCMqeMh0K5gpbcEeXi8as7KHxFxS/ODtUXAR9aDQxE=; b=Mr8Tb+kHKfJQhDFzPVnFPZPoQe
        bMc75tcXyXtJEQWrQVRN2ZhxWLd3pMvT5M8IbqlFtEF+7gn7pLebF+5JQRIG0GAzSMaR2A6Emf3NH
        IebqVqcouDPMcP6TmhrJPiV8GUPrp2NdO/ts0Z+vbKvAeMwBShbyWUFtcGPs7sULt4xI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npGxF-002Vo7-24; Fri, 13 May 2022 00:06:41 +0200
Date:   Fri, 13 May 2022 00:06:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] Wangxun 10 Gigabit Ethernet Driver
Message-ID: <Yn2E8X6f8PJ0c4CB@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511175425.67968b76@kernel.org>
 <004401d865e4$c3073d10$4915b730$@trustnetic.com>
 <20220512085748.2f678d20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512085748.2f678d20@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 08:57:48AM -0700, Jakub Kicinski wrote:
> On Thu, 12 May 2022 17:43:39 +0800 Jiawen Wu wrote:
> > On Thursday, May 12, 2022 8:54 AM, Jakub Kicinski wrote:
> > > On Wed, 11 May 2022 11:26:45 +0800 Jiawen Wu wrote:  
> > > >  22 files changed, 22839 insertions(+)  
> > > 
> > > Cut it up more, please. Expecting folks to review 23kLoC in one sitting is
> > > unrealistic. Upstream a minimal driver first then start adding features.  
> > 
> > I learned that the number of patches should not exceed 15 at a time, refer
> > to the guidance document.
> > May I ask your advice that the limit of one patch and the total lines?
> 
> There is no strict limit, but the reality is that we have maybe 
> 5 people reviewing code upstream and hundreds of developers typing 
> and sending changes. So the process needs to be skewed towards making
> reviewer's life easier, reviewers are the bottleneck.
> 
> So there is no easy way here. Remove as much code as possible to still
> have functional driver and cut it up. Looks like you can definitely
> drop all patches starting from patch 7 to begin with. But patches 1-6
> are still pretty huge.

Hi Jiawen Wu

After a quick look at the patches, i'm guessing you are new to
submitting to mainline. So it might even make sense to just post patch
1. Please make it standalone, so most of the txgbe.rst can be removed,
since the driver with just patch 1 has none of the features discussed
in it. We can give you feedback which should help you learn the
process, and what we expect from mainline code. You can then rework
that patch and the rest of your driver from what you have learned,
making further patches easier and faster to review.

       Andrew

