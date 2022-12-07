Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B064523A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLGCtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLGCt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:49:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726DB2A72F;
        Tue,  6 Dec 2022 18:49:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E2261631;
        Wed,  7 Dec 2022 02:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2985AC433C1;
        Wed,  7 Dec 2022 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670381368;
        bh=Sx1LhHHFx82wCpEnxyWBYABEYLoKkwEfy+CQMZv7esI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NL3gHTUIpYupqgyfub36m8COulaLWwVndCT/Jtso1Erf4whQft9jeHOxOSc1z5WtH
         9sROST+CO8heD4HHzTCSr39UvHULTdwFsKNdGa/0Zi3nsoJXmmfts6R738/l8FvmSt
         ptt+tzbghoAlHt7+ymqmL1VXQXv/AYLCG222tPuMxgox0p/MDZjbvZqgGj5++UUbQy
         AWJILRSV8htn/OZBRbVNdhjfTdqoSnLRi6bSBuXFnqfnjKSV/pf2ZGyKwKOlTWpIvb
         cuIQEMq4b0T7AiMw+vLiQ2InDjU2ES6sTAIwAhVM5UoJdMk6vb/hGhhoJZvpIERK1s
         C5RJIz6ubvlvA==
Date:   Tue, 6 Dec 2022 18:49:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "David S . Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 09/13] net: loopback: use
 NET_NAME_PREDICTABLE for name_assign_type
Message-ID: <20221206184927.7c43d247@kernel.org>
In-Reply-To: <Y4/4Yts6nwDCqC1q@sashalap>
References: <20221206094916.987259-1-sashal@kernel.org>
        <20221206094916.987259-9-sashal@kernel.org>
        <20221206114956.4c5a3605@kernel.org>
        <Y4/4Yts6nwDCqC1q@sashalap>
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

On Tue, 6 Dec 2022 21:20:18 -0500 Sasha Levin wrote:
> >Yeah... we should have applied it to -next, I think backporting it is
> >a good idea but I wish it had more time in the -next tree since it's
> >a "uAPI alignment" :(
> >
> >Oh, well, very unlikely it will break anything, tho, so let's do it.  
> 
> Want me to push it back a week to the next batch? It'll give it two
> weeks instead of the usual week.

Oh, perfect, I didn't know we can hold for a week. Yes, please!
