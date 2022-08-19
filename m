Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACBC59A19E
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350255AbiHSPsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350200AbiHSPra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F31BCBD
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:47:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C2D36155B
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 15:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B36C433D7;
        Fri, 19 Aug 2022 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660924028;
        bh=PE51bj3sq26TU8Z0DKyNTxcxCghZyUi5bYb+7HvfZwM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y2gEyCFgL80Tl9eUH8JLVu7srez9EYBAeLY58TDfhC/ibrPGa1BGxHWT8oppuSbG+
         xc3cisxmhkKJMRRqp31PskcwvVvsYLXQ0KyDQFaUpgm7J2LIUEsViY04C3F+nFvX65
         nb0X4GHxA6UzrSqmlSSWoHAC/Z4+63F/UaU3RMC0qVandSUr8PSNeAdZcipcnXWojK
         JDomTwGIws++UW8mbviNFKLwOPDtPDYTpSkgZ35RgGCtRMRcvg4VyPfD7RrWvlzegW
         2idJtf0v701JX1rKJW8zqmX0M7ICf7PwSZW6LuwYdXbGrqj8pGNw3128reD2OvjO1o
         xNr5sO37NgL7g==
Date:   Fri, 19 Aug 2022 08:47:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220819084707.7ed64b72@kernel.org>
In-Reply-To: <Yv8lGtYIz4z043aI@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
        <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
        <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
        <20220818193449.35c79b63@kernel.org>
        <Yv8lGtYIz4z043aI@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 08:52:26 +0300 Leon Romanovsky wrote:
> > Let me be very clear - as far as I'm concerned no part of the RDMA
> > stack belongs in netdev. What's there is there, but do not try to use
> > that argument to justify more stuff.
> > 
> > If someone from the community thinks that I should have interest in
> > working on / helping proprietary protocol stacks please let me know,
> > because right now I have none.  
> 
> No one is asking from you to work on proprietary protocols.

That's not what I said. I don't know English grammar enough but you
took the modifying (descriptive? genitive?) noun and treated it as 
the object.

I don't want to be in any way disrespectful to the technology you
invest your time in. Or argue with any beliefs you have about it.

> RoCE is IBTA standard protocol and iWARP is IETF one. They both fully
> documented and backed by multiple vendors (Intel, IBM, Mellanox, Cavium
> ...).
> 
> There is also interoperability lab https://www.iol.unh.edu/ that runs
> various tests. In addition to distro interoperability labs testing.
> 
> I invite you to take a look on Jason's presentation "Challenges of the
> RDMA subsystem", which he gave 3 years ago, about RDMA and challenges
> with netdev.
> https://lpc.events/event/4/contributions/364/

I appreciate the invite, but it's not high enough on my list of interest
to spend time on.
