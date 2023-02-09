Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5341A68FEBA
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 05:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjBIE2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 23:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBIE2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 23:28:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD43126BA;
        Wed,  8 Feb 2023 20:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CCB861889;
        Thu,  9 Feb 2023 04:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEBC4339B;
        Thu,  9 Feb 2023 04:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675916835;
        bh=IQCmLWBitA8EqJlOcurDX4UWPvWs7KBmMZD6qitKS1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oHXym3yw0Il8xiNX12jFl+Fl1RmJD3RYCFvWaPRwZ8WakgT++2kuZsKkWWDsBKRww
         34U9MapuTHy0zCbd7/gche1IrC457V6IjjcAnSAdaK5SDHC7U4Nq6Rtzkbn/vi4RAn
         0FZa58ga10O+rEm3+61271HbqVeQvJqgWxEU/gtVcNHJi8AyXAQs1xXnuY/suFC7Wq
         0cwDDeLG/wpRx/krWHflmA0UxChaVGILPJyktzd+85PrY9r5+UcIhjoi5GHB/Z2qQj
         tIOzL0uF4qRdYvHQF3IOICzX0nd988+VK8QRG4oRtoWAp6JDNrDAYmHAGP7RQ6nyTu
         s0zjYepy+VdAg==
Date:   Wed, 8 Feb 2023 20:27:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next netdev notifier deadlock 2023-02-07
Message-ID: <20230208202714.5b3ecc3e@kernel.org>
In-Reply-To: <Y+RseKpYCBnXzImH@x130>
References: <20230208005626.72930-1-saeed@kernel.org>
        <20230208191250.45b23b6f@kernel.org>
        <20230208191605.719b19db@kernel.org>
        <Y+RseKpYCBnXzImH@x130>
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

On Wed, 8 Feb 2023 19:46:00 -0800 Saeed Mahameed wrote:
> On 08 Feb 19:16, Jakub Kicinski wrote:
> >Ooh, maybe I'm not supposed to pull?
> >Jiri's changes have Change-Ids on them:  
> 
> Fixed now, same tag, if you wanna go ahead and pull.
> Please let me know if you prefer V2..

One more, on:
 
 94b3ec5464f6323e1cd6be72b84c2d98c942ea13

FETCH_HEAD  8946287ba8513c1c
