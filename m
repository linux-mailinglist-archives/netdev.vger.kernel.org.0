Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA59668A74D
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 01:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBDAre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 19:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbjBDArb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 19:47:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7635C991F1;
        Fri,  3 Feb 2023 16:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D769FB82C58;
        Sat,  4 Feb 2023 00:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F6EC433D2;
        Sat,  4 Feb 2023 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675471647;
        bh=B16Hl+PnwMlowI3VjPmfqmUs/yrV8SmLpdhhcZQ8X+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a7LrQb/M9KiVu5Pvr2MoE7yctT/aJFbEguNC0CL1nqE+m5N4Wcbc3IGyZmgVn5aTS
         XhJXQS4b40hSVZ0utdKLYldhIzSMBLj1a5yUaWiCyPwmNjX80Emgl0jC66qIDYDf1K
         m0oGVeGhsH21xJOVnuJzn9BCnjOCvgxqIiTrZhMo9rb0qAJUsV52DRQM8+8pi3dBDE
         UHU/+U7oXb0yznujIB/vQ8jc1q6BlZerOuxYeoPRaXQp6r7PN28mbZGM2bXGVtl6nq
         DouIzMJmF/9MWe4461ICIot0yH+lEHWFhUSU395aSsIN6ssGmVxta+4xDyLBu5P1zc
         yo1Cv91Zw4D6w==
Date:   Fri, 3 Feb 2023 16:47:26 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y92rHsui8dmZclca@x130>
References: <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230203131456.42c14edc@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03 Feb 13:14, Jakub Kicinski wrote:
>I believe Paolo is planning to look next week. No idea why the patch
>got marked as Accepted 🤷️
>
>On Fri, 3 Feb 2023 12:05:56 -0800 Saeed Mahameed wrote:
>> I don't agree, RDMA isn't proprietary, and I wish not to go into this
>> political discussion, as this series isn't the right place for that.
>
>I don't think it's a political discussion. Or at least not in the sense
>of hidden agendas because our agendas aren't hidden. I'm a maintainer
>of an open source networking stack, you're working for a vendor who
>wants to sell their own networking stack.
>

we don't own any networking stack.. yes we do work on multiple opesource
fronts and projects, but how is that related to this patchset ? 
For the sake of this patchset, this purely mlx5 device management, and
yes for RoCE traffic, RoCE is RDMA spec and standard and an open source
mainstream kernel stack.

Now if you have issues of how they manage the RDMA stack, I 100% sure it
has nothing to do with mlx5_core, and such political discussion should be
taken elsewhere.

>Perhaps you'd like to believe, and importantly have your customers
>believe that it's the same networking stack. It is not, the crucial,

I personally don't believe it's the same networking stack.
  
>transport part of your stack is completely closed.
>

RDMA/RoCE is an open standard. also the ConnectX spec for both ethernet
and rdma and driver implementation is completely open..
yes the standard/open defined transport stack is implemented in HW,
hence RDMA..

>I don't think we can expect Linus to take a hard stand on this, but
>do not expect us to lend you our APIs and help you sell your product.
>
>Saying that RDMA/RoCE is not proprietary because there is a "standard"
>is like saying that Windows is an open source operating system because
>it supports POSIX.
>

Apples and oranges, really :) .. 

Sorry but I have to disagree, the difference here is that the spec
is open and the stack is in the mainstream linux, and there are at least
10 active vendors currently contributing to rdma with open source driver
and open source user space, and there is pure software RoCE
implementation for the paranoid who don't trust hw vendors, oh and it uses
netdev APIs, should that be also forbidden ??

What you're really saying here is that no vendor is allowed to do any
offload or acceleration .. not XDP not even tunnel or vlan offload,
and devices should be a mere pipe.. 



