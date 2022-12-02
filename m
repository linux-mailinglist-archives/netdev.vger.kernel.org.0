Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1BA640E67
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 20:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbiLBT0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 14:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiLBT0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 14:26:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DCFE1749
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 11:26:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55D376204B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 19:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885BAC433D6;
        Fri,  2 Dec 2022 19:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670009168;
        bh=Dzu1CX0rkh35Gb9waI6RozbqNKZGLUP9Mgk3TgzQ1DQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mZHQgtt3zCdJRk4TNNXxF1mxA/XLLMH5AYQ8xxaQZM+YvcxzOA1z6TDYqtshoMoi8
         XK3l737yMfeA3C4Lu0QHGArliIv93Be1BCJUQ4G1lGNK4tZLiL15gx6KPGYl0NaAEg
         EFXFOPBKVJHlFrwM8t25ohgQabcQOUS9PLp1fa9dxCtP2XqRAQdCi9mrJ41K2/cD+8
         1rYxxqwiILB4GyZAvsjVotJlN2kCTKe0ySfKOvk3ptmdMdDSA8ylYLG3YMLvJxRMi1
         UdhAIyx4CGZ0BMvlSM9XhAyfmmK/tuNbwkecFOsiH1ZhhbyJii6//IGynsRIBWqA5w
         nBwSc9t+UMgjg==
Date:   Fri, 2 Dec 2022 11:26:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <20221202112607.5c55033a@kernel.org>
In-Reply-To: <Y4pEknq2Whbw/Z2S@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
        <20221202094243.GA704954@gauss3.secunet.de>
        <Y4o+X0bOz0hHh9bL@unreal>
        <20221202101000.0ece5e81@kernel.org>
        <Y4pEknq2Whbw/Z2S@unreal>
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

On Fri, 2 Dec 2022 20:31:46 +0200 Leon Romanovsky wrote:
> Not really, it is a matter of trust.

More of a question of whether we can reasonably expect to merge all 
the driver code in a single release cycle. If not then piecemeal
merging is indeed inevitable. But if Steffen is happy with the core
changes whether they are in tree for 6.2 or not should not matter.
An upstream user can't access them anyway, it'd only matter to an
out-of-tree consumer.

That's just my 2 cents, whatever Steffen prefers matters most.

> The driver exists https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
> and it is a lot of code (28 patches for now) which is more natural for us to route through
> traditional path.
> 
> If you are not convinced, I can post all these patches to the ML right now
> and Steffen will send them to you.
