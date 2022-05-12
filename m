Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ABF5251B3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354955AbiELP5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351802AbiELP5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:57:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C39C9EF7
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 08:57:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A043061EF5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 15:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9217C385B8;
        Thu, 12 May 2022 15:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652371070;
        bh=aSOrleWg/69P64A/9A9X8BOncOn3wySSB8POB/uhTAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YX8wXPvsOEd4tguYfG6aFpV2rQ50Fc92oEALmw6I34t9ZniZwyY2khJ63amelyMa0
         aWJCo/4hj8dZOKG+qdX44La5hnqDh6mRTb0izzx61kAhx/8+1UvP/s0ClCIu4wgDSi
         UTn3TDATROOmFQBAyw0/ANSw3BDJgrJnRMofIlsPoweBjcfoX7C4F4h1q+aqqDOZ9A
         CGk+T1recJ6LvYoBBqYUHseIwoe9ya6NYKY8x5GKuqWFAVhEqnf3vdyPWIzKJIniHx
         HpYkGyeUv0rfGKi4gBKmj1Ztb3hho0BCV4s5REFbvlal6XRD+yt/Cl1fqP0932+2JP
         Iw5rFolNDsWwg==
Date:   Thu, 12 May 2022 08:57:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jiawen Wu" <jiawenwu@trustnetic.com>
Cc:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 00/14] Wangxun 10 Gigabit Ethernet Driver
Message-ID: <20220512085748.2f678d20@kernel.org>
In-Reply-To: <004401d865e4$c3073d10$4915b730$@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
        <20220511175425.67968b76@kernel.org>
        <004401d865e4$c3073d10$4915b730$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 17:43:39 +0800 Jiawen Wu wrote:
> On Thursday, May 12, 2022 8:54 AM, Jakub Kicinski wrote:
> > On Wed, 11 May 2022 11:26:45 +0800 Jiawen Wu wrote:  
> > >  22 files changed, 22839 insertions(+)  
> > 
> > Cut it up more, please. Expecting folks to review 23kLoC in one sitting is
> > unrealistic. Upstream a minimal driver first then start adding features.  
> 
> I learned that the number of patches should not exceed 15 at a time, refer
> to the guidance document.
> May I ask your advice that the limit of one patch and the total lines?

There is no strict limit, but the reality is that we have maybe 
5 people reviewing code upstream and hundreds of developers typing 
and sending changes. So the process needs to be skewed towards making
reviewer's life easier, reviewers are the bottleneck.

So there is no easy way here. Remove as much code as possible to still
have functional driver and cut it up. Looks like you can definitely
drop all patches starting from patch 7 to begin with. But patches 1-6
are still pretty huge.
