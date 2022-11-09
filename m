Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036F26232E2
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiKISsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:48:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiKISss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:48:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A62FBB0;
        Wed,  9 Nov 2022 10:48:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DF55B81F93;
        Wed,  9 Nov 2022 18:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D917C433C1;
        Wed,  9 Nov 2022 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019724;
        bh=UNb9le3yhXJJI9GP8gOSqL9juKR/kJNnF4VSt2jRR98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jiKr33F4vHfYxGU3eRjNwauXJpCBP1L7zrgGPNY9vj369PKxyrW59B0+/3HZSktPD
         EyMDay7RmcxNEWQJKSGX32xe+bbdliZgPGaKtrcyqfyWSViYyQlrecWVQLFGuvppLY
         sjfB+tDTO3t5SXfVX/s6clmMVsKuYDIct9j2oi9yVjw5GQonD7UCVZMcT3g3jSI1QG
         BWkzKXcckiEO0ef0vcewjdyrN1o7zvnusPOBtaXBBmAfisluWdB74JJZF++71WuDct
         7+qpHngXA0XgqqTemOmT9HMRRFOtrrd4Kgufn0vqbqiakTumXw6gn012kle7RM890W
         qVLaVNVOIpk1w==
Date:   Wed, 9 Nov 2022 20:48:40 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, edumazet@google.com,
        longli@microsoft.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, shiraz.saleem@intel.com,
        Ajay Sharma <sharmaajay@microsoft.com>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter
 (MANA) RDMA driver
Message-ID: <Y2v2CGEWC70g+Ot+@unreal>
References: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
 <Y2qqq9/N65tfYyP0@unreal>
 <20221108150529.764b5ab8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108150529.764b5ab8@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 03:05:29PM -0800, Jakub Kicinski wrote:
> On Tue, 8 Nov 2022 21:14:51 +0200 Leon Romanovsky wrote:
> > Can you please ACK/comment on eth part of this series? And how should
> > we proceed? Should we take this driver through shared branch or apply
> > directly to RDMA tree?
> 
> LGTM. Is it possible to get patches 1-11 thry a shared branch and then
> you can apply 12 directly to RDMA? That seems optimal to me.

Please pull, I collected everything from ML and created shared branch.

The following changes since commit f0c4d9fc9cc9462659728d168387191387e903cc:

  Linux 6.1-rc4 (2022-11-06 15:07:11 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/ mana-shared-6.2

for you to fetch changes up to 1e6e19c6e1c100be3d6511345842702a24c155b9:

  net: mana: Define data structures for protection domain and memory registration (2022-11-09 20:41:17 +0200)

Thanks
