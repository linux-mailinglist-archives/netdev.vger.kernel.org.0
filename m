Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A508061174A
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiJ1QP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiJ1QPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:15:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F301F9D9;
        Fri, 28 Oct 2022 09:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFCE1B82AE9;
        Fri, 28 Oct 2022 16:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D10BC433C1;
        Fri, 28 Oct 2022 16:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666973636;
        bh=cyyqcm/JaENKJGOXUYiC10jl9feIzA5u6Tf4EihPGRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bh9Vf4fgcCN0sc4enG4CeLLDpvVtzdBMoPzRaX88fslY7Cb9zdiuQGvN/aNg6yKDt
         Fy7vKbEKL5MkoEk0Scgb+G4STfvEzeSyGjFIrSUpEgKtRKT7SO9XaT6deJblApfYns
         R6CTotTWNwINPfbGnDepXMAlWkPF/4km774qQ5PmW9ow3GvQDSLJGRl80PGZs3FVJA
         1GEQwTjMAYD//IBIlIVXesDHt9qxBHMdVHNjggxJE0t3Yoxz/z06EgtgqnllONy0m1
         UvfW21nxONB8UvgcjxXmpmMZmBa4t/G71/zrl82FIrOkB6ZVlIywsZgL48TrVnvUmR
         1dWlZeSUrIILA==
Date:   Fri, 28 Oct 2022 09:13:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/2] netlink: introduce NLA_POLICY_MAX_BE
Message-ID: <20221028091354.6acf9c60@kernel.org>
In-Reply-To: <20221028101613.GC1915@breakpoint.cc>
References: <20220905100937.11459-1-fw@strlen.de>
        <20220905100937.11459-2-fw@strlen.de>
        <20221027133109.590bd74f@kernel.org>
        <2f528f1a320c55fdc7f3be55095c1f0eacee1032.camel@sipsolutions.net>
        <20221027233500.GA1915@breakpoint.cc>
        <20221027193931.2adce94d@kernel.org>
        <20221028101613.GC1915@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 12:16:13 +0200 Florian Westphal wrote:
> > The NLA_BE* idea seems appealing, but if the implementation gets
> > tedious either way works for me.  
> 
> Doesn't look too bad.  I plan to do a formal submission once I'm back
> home.

Neat, FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
