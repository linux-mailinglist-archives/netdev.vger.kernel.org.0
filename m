Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4D640D48
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 19:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbiLBScI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 13:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbiLBSbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 13:31:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34442EA5D7
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 10:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBA0462387
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 18:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5993C433D6;
        Fri,  2 Dec 2022 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670005911;
        bh=iDSkrXBLtep0PP1Gvf10BKq73MGeY3IYwGfV1m0SgxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bRxC52kbDf1SpnbTCPKwxYW3nsiDJ1f2dSK2KzKSzB71RqpOKWG0+2zsGy8obti50
         yRPxiWVZJKEqcqj1piaFZ2aogdYwaI+/1saIla+95efTX5Q0NwQZvz5NVH0wqFpVH2
         T9Z+xqWDMU+O8eQyVq77z8zb5GwWPwcq3aSBqiLw7GWoJt3dDieHyV3PB8zP87X7kC
         a2tqYgoNGFsI5OPq3nGcEVlRbznooiZEhiWClheOuUUPEGATKrisX3p1lPxUfwBVgT
         FLOE1xcSfm5/sj90VBCg8r1D6JASAV8exrYkNpCgx/0hE2jH6MuME3ToTWaMWzMNW0
         YCMPq9ra49OAQ==
Date:   Fri, 2 Dec 2022 20:31:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH xfrm-next v9 0/8] Extend XFRM core to allow packet
 offload configuration
Message-ID: <Y4pEknq2Whbw/Z2S@unreal>
References: <cover.1669547603.git.leonro@nvidia.com>
 <20221202094243.GA704954@gauss3.secunet.de>
 <Y4o+X0bOz0hHh9bL@unreal>
 <20221202101000.0ece5e81@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202101000.0ece5e81@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 10:10:00AM -0800, Jakub Kicinski wrote:
> On Fri, 2 Dec 2022 20:05:19 +0200 Leon Romanovsky wrote:
> > You won't need to apply and deal with any
> > merge conflicts which can bring our code :).
> 
> FWIW the ipsec tree feeds the netdev tree, there should be no conflicts
> or full release cycle delays. In fact merging the infra in one cycle
> and driver in another seems odd, no?

Not really, it is a matter of trust.

The driver exists https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log/?h=xfrm-next
and it is a lot of code (28 patches for now) which is more natural for us to route through
traditional path.

If you are not convinced, I can post all these patches to the ML right now
and Steffen will send them to you.

Thanks
