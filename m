Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADF068EB03
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjBHJUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjBHJUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129B146176;
        Wed,  8 Feb 2023 01:17:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79882B81AB4;
        Wed,  8 Feb 2023 09:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E13C433D2;
        Wed,  8 Feb 2023 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675847864;
        bh=xj4g6KBK6xFMP62Pr942zcU1+4GWM3KNnLX/whlWKq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1ySraTqLjTvB6WS319g2m2CskOjWqM2RDNeZgmv+rWQgCqt1Vv+M4rM/vgUxBGAX
         TWvFitLceG78PPJJUkmVZ+utv84HHnw7l2EezDuy8eVWvDE69NCWGCQateTiqpBoo1
         9KBXH7o4UfXu2Y+fG7cskizM+matRvMum0kWrUeM4D4eR3eWbLl9tIq5x8MekYDNm8
         9dnconDP0Quvf5svTEgfKVUTz6cOAGchDT18J5xjdtYjj/CAs7sa8FHC+ghzsNZeQb
         m5j5LBqBLvBBZse8bVzH2u9457Dw9JMjro8cclohi8tcdEVoIqojhG+gTgduOf4nF2
         FPQG55AwchZyg==
Date:   Wed, 8 Feb 2023 11:17:39 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y+Nos4xQw8dpMYjb@unreal>
References: <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92kaqJtum3ImPo0@nvidia.com>
 <20230203174531.5e3d9446@kernel.org>
 <Y+EVsObwG4MDzeRN@nvidia.com>
 <20230206163841.0c653ced@kernel.org>
 <Y+KsG1zLabXexB2k@nvidia.com>
 <20230207140330.0bbb92c3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207140330.0bbb92c3@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 02:03:30PM -0800, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 15:52:59 -0400 Jason Gunthorpe wrote:
> > On Mon, Feb 06, 2023 at 04:38:41PM -0800, Jakub Kicinski wrote:
> > > On Mon, 6 Feb 2023 10:58:56 -0400 Jason Gunthorpe wrote:  

<...>

> > > The simplest way forward would be to commit to when mlx5 will
> > > support redirects to xfrm tunnel via tc...  
> > 
> > He needs to fix the bugs he created and found first :)
> > 
> > As far as I'm concerned TC will stay on his list until it is done.
> 
> This is what I get for trusting a vendor :/

I'm speechless. I was very clear what is my implementation roadmap.

Are you saying that your want-now-tc-attitude is more important than
working HW (found when integrated with libreswan) and Steffen's request
to implement tunnel mode?

> 
> If you can't make a commitment

You got this commitment from two people already, but unfortunately
you refuse to listen.

Thanks
