Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90DB60EFE2
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiJ0GIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiJ0GIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:08:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1D315D093
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 23:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B92AB824BC
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A223C433D6;
        Thu, 27 Oct 2022 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666850877;
        bh=YqpoAEtfrwCw3s2NQ5PSmg+6xD7nMlHwM2nLErXK58o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nSIiWmA2P3Hh81Hioy4EFRFyqf5/dt9C25G0DoN/RLVfVYw2EYOp21IvYJk9/68oI
         2ifLOTvSoxJ1yrmaq0M7azVUt7KEmqPmiUFU+Bho3ECk52dd/4hfLB1EES/5U3cxG+
         REFJalt/9DeXO3ZdrNC3vj0Y1QO/ehMv0ZzAAbks0GXgal1QwzmLoH6DQdIFLzNTYP
         1UQCYxLOZXO0Az/qNLAGXtyTbG/cQGHS4hjRVEpWIJLHnka0wxoh/ema44sB9W+BY7
         GOtI4WdAOQOVCPD4l8r8O55SVmUyOLx06PeRIs6DZmxIF3At9Hzq6Ob8Hr0DCia9LF
         qpjmMi6EN/zXA==
Date:   Thu, 27 Oct 2022 09:07:52 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v1 0/6] Various cleanups for mlx5
Message-ID: <Y1ogOKDAXRdys2nr@unreal>
References: <cover.1666630548.git.leonro@nvidia.com>
 <20221025110011.rurzxqqig4bdhhq5@sx1>
 <Y1fHq9HVOhgeNhlB@unreal>
 <20221026142731.nrmhssgn5dhi7jot@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026142731.nrmhssgn5dhi7jot@sx1>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 03:27:31PM +0100, Saeed Mahameed wrote:
> On 25 Oct 14:25, Leon Romanovsky wrote:
> > On Tue, Oct 25, 2022 at 12:00:11PM +0100, Saeed Mahameed wrote:
> > > On 24 Oct 19:59, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > Changelog:
> > > > v1:
> > > > Patch #1:
> > > > * Removed extra blank line
> > > > * Removed ipsec initialization for uplink
> > > 
> > > This will break functionality, ipsec should only be enabled on nic and
> > > uplink but not on other vport representors.
> > 
> > I didn't hear any complain from verification. The devlink patch is in
> > my tree for months already.
> > 
> 
> the regression is clear in the code. Ask Raed he added the functionality
> for uplink.

Just to wrap this discussion. Last half a year or so, all IPsec bugs found internally
are assigned on me.

Thanks
