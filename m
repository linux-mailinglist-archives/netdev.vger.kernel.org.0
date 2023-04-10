Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F56DC6B1
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjDJMU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjDJMU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5573D6590;
        Mon, 10 Apr 2023 05:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E43E561B6C;
        Mon, 10 Apr 2023 12:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA1CC433EF;
        Mon, 10 Apr 2023 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681129251;
        bh=qAiViZFTjwW5jvmupiD8t0d1vpgVxX0pOPthBKjeqgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VMZZvgq8avInlnsgTtRo5FoOCXzQeNjdBmnVsAkvyGpyfVdM0FjWOjSlIirmj8d3G
         7+9O9FA8RsQUVBxKKC5pTKOw/geUfiSa2q8bmyfGQwxA0fhmeez92HGFrq9uRLpWpv
         7Nng4sa2JJ47hxdP1xR4AU5FLZVJjOrW9foh/MOzs7zRHfMTInsCtp9lHWZmBb2TGS
         e/lA30gO3CPsELJdFX+EkuvS1SG3+woz/d4HM4pwU0tO6ez1SUEY4qt2iuWiHfqQFs
         NhYVH1gEIPtlOzFuN1HDIBiwsUQRIdWjOH3FUXOIwJE3FHLZK1vsPAPWJl0REiTPFD
         UKD9ouPACa6Qg==
Date:   Mon, 10 Apr 2023 14:20:46 +0200
From:   Simon Horman <horms@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, lvs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: Re: [PATCH nf-next 0/4] ipvs: Cleanups for v6.4
Message-ID: <ZDP/Ht1Nb4iRSkI8@kernel.org>
References: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230409-ipvs-cleanup-v1-0-98cdc242feb0@kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 11:42:34AM +0200, Simon Horman wrote:
> Hi Pablo,
> 
> this series aims to clean up IPVS in several ways without
> implementing any functional changes, aside from removing
> some debugging output.
> 
> Patch 1/4: Update width of source for ip_vs_sync_con_options
>            The operation is safe, use an annotation to describe it properly.
> 
> Patch 2/4: Consistently use array_size() in ip_vs_conn_init()
>            It seems better to use helpers consistently.
> 
> Patch 3/4: Remove {Enter,Leave}Function
>            These seem to be well past their use-by date.
> 
> Patch 4/4: Correct spelling in comments
> 	   I can't spell. But codespell helps me these days.
> 
> All changes: compile tested only!

Hi all,

Julian pointed out some minor issues which I will address in a v2.
