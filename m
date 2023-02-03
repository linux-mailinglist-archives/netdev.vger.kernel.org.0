Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7312468A466
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjBCVPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbjBCVPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:15:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7D34311;
        Fri,  3 Feb 2023 13:14:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0BA361FE8;
        Fri,  3 Feb 2023 21:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7A4C4339B;
        Fri,  3 Feb 2023 21:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675458898;
        bh=D/rS6iekYJXom+vVqDqsKfWt7Mbj4ohBFwmZDcelTXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=apyr3dnswTg0TKwNz5ijAcrzjAsJ+TBXmLtadkmgLJypHKVMKRKEyGJpquuEtPhlH
         C/64WsMegmJwPHfWXY3RpVoywL2FRYIcfUR0xSwU9Cts7LyaB1VARnbk+ivwk+wO/F
         V6hUoH9BZKM/rspQqKSGlmFGRIRPytGsrJjIZSqBs3THCMfhWhRiBIg2GXAxHd7HiC
         0k9pdk4BGj2Sh64xbajUS4Pukk19e4iq/56OUTAjSrg3ImXd9MjJmViS/WZR83TWqk
         XBkXDHmIuNVXJN9LGvlT7Z4G4245c8TWgMmXdyT4rm34aJdKOLGehB7TW09rSjGyZW
         rU9DhSUYS/c1Q==
Date:   Fri, 3 Feb 2023 13:14:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230203131456.42c14edc@kernel.org>
In-Reply-To: <Y91pJHDYRXIb3rXe@x130>
References: <20230126230815.224239-1-saeed@kernel.org>
        <Y9tqQ0RgUtDhiVsH@unreal>
        <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
        <20230202092507.57698495@kernel.org>
        <Y9v2ZW3mahPBXbvg@nvidia.com>
        <20230202095453.68f850bc@kernel.org>
        <Y9v61gb3ADT9rsLn@unreal>
        <Y9v93cy0s9HULnWq@x130>
        <20230202103004.26ab6ae9@kernel.org>
        <Y91pJHDYRXIb3rXe@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I believe Paolo is planning to look next week. No idea why the patch
got marked as Accepted =F0=9F=A4=B7=EF=B8=8F

On Fri, 3 Feb 2023 12:05:56 -0800 Saeed Mahameed wrote:
> I don't agree, RDMA isn't proprietary, and I wish not to go into this
> political discussion, as this series isn't the right place for that.

I don't think it's a political discussion. Or at least not in the sense=20
of hidden agendas because our agendas aren't hidden. I'm a maintainer
of an open source networking stack, you're working for a vendor who
wants to sell their own networking stack.

Perhaps you'd like to believe, and importantly have your customers
believe that it's the same networking stack. It is not, the crucial,
transport part of your stack is completely closed.

I don't think we can expect Linus to take a hard stand on this, but
do not expect us to lend you our APIs and help you sell your product.

Saying that RDMA/RoCE is not proprietary because there is a "standard"
is like saying that Windows is an open source operating system because
it supports POSIX.

My objectives for netdev are:
 - give users vendor independence
 - give developers the ability to innovate

I have not seen an RDMA implementation which could deliver on either.
Merging this code is contrary to my objectives for the project.

> To summarize, mlx5_core is doing RoCE traffic processing and directs it to
> mlx5_ib driver (a standard rdma stack), in this series we add RoCE ipsec
> traffic processing as we do for all other RoCE traffic.

I already said it. If you wanted to configure IPsec for RoCE you should
have added an API in the RDMA subsystem.
