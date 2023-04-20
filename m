Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613766E86C0
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 02:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjDTAq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 20:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTAq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 20:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F9835B1;
        Wed, 19 Apr 2023 17:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1564B643A8;
        Thu, 20 Apr 2023 00:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDDFC433EF;
        Thu, 20 Apr 2023 00:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681951586;
        bh=c85dxX5VbhX+MDjLca20jOeyW7o9meMS6s/blcJymPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iY9Yrj0ntKaIHAGUiOIgblBZJm5XOSexme9uDdH43nUc/8KST6FcraX6QN1IS32Dd
         4sAqFDjDyXR3MgjSOzrJl+bF9PdeI1kNxyFn/t7F3sd/VwdvjI5oBWynUVSCnOWsnS
         IG1u5KM3cpeA15tZhq1q/m0BsFXUmw7SUCoojluLlTKe+crAAxzzB+VJ2rLH+p7SES
         TqAg6w9E1YPNGUQRq1GQbTkabD9EKJ+RGye9nHGeQdh/aQ3OyniWLB4lSwjB3gUIue
         hd44G1luyLvo4TaJF1T/6NzJs4aeFHkzIx6PPyIZ4plt86uVtQXyhHOWw4VnC0taso
         KX/0h+tr4e7lg==
Date:   Wed, 19 Apr 2023 17:46:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Paul Moore <paul@paul-moore.com>,
        Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Shay Drory <shayd@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
Message-ID: <20230419174625.280a6ed9@kernel.org>
In-Reply-To: <ZECKn2WwX22wrsMt@x130>
References: <ZDhwUYpMFvCRf1EC@x130>
        <20230413152150.4b54d6f4@kernel.org>
        <ZDiDbQL5ksMwaMeB@x130>
        <20230413155139.22d3b2f4@kernel.org>
        <ZDjCdpWcchQGNBs1@x130>
        <20230413202631.7e3bd713@kernel.org>
        <ZDnRkVNYlHk4QVqy@x130>
        <20230414173445.0800b7cf@kernel.org>
        <ZDoqw8x7+UHOTCyM@x130>
        <20230417083825.6e034c75@kernel.org>
        <ZECKn2WwX22wrsMt@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 17:43:11 -0700 Saeed Mahameed wrote:
> So I checked with Arch and we agreed that the only devices that need to
> expose this management PF are Bluefield chips, which have dedicated device
> IDs, and newer than the affected FW, so we can fix this by making the check
> more strict by testing device IDs as well.
> 
> I will provide a patch by tomorrow, will let Paul test it first.

What's "by tomorrow"? Today COB or some time tomorrow? 
Paolo is sending the PR tomorrow, fix needs to be on the list *now*.
