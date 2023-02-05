Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC00B68AF57
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 11:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjBEK0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 05:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBEK0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 05:26:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E673F7EE7;
        Sun,  5 Feb 2023 02:26:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A84F60B95;
        Sun,  5 Feb 2023 10:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514BDC433EF;
        Sun,  5 Feb 2023 10:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675592790;
        bh=e+skIjST0iHGrYwqhT7z93UrAVg8jBJa6Acudexq2cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p/1IFHSP1AiijWgukh14qcnvKglwnk+Rcv4YCdygL8IL9U6J8DefK2T3o9mlZylOZ
         TXG/znTsBHdmuQIPoLOLwv3XiGHxhqWPq4oR2rrwGzgwyewyXywiKTF7xGc6kCr62i
         vjGTI+cVxQqic4Zec8cCLaghG1pvTrvEEbGEbiPLJKdF2VhwFq30JEczw+c2atB8QE
         WEPNSmz6oe/X0ZRoYe+9anq8pVlS4f1g+7t0S6tbdC/tWwnRD5R9jz3N70ruAnPdHP
         2dvQBomSQy8pUrXYgaS3Fm/VCLzaXeSzyNtmmprpwPLfONdF4uRokeH1UUP5w6DQwl
         uXON3IGsgkf6A==
Date:   Sun, 5 Feb 2023 12:26:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9+EUoIyLPgONDEC@unreal>
References: <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
 <Y9v61gb3ADT9rsLn@unreal>
 <Y9v93cy0s9HULnWq@x130>
 <20230202103004.26ab6ae9@kernel.org>
 <Y91pJHDYRXIb3rXe@x130>
 <20230203131456.42c14edc@kernel.org>
 <Y92rHsui8dmZclca@x130>
 <20230203175739.1fef3a24@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230203175739.1fef3a24@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 05:57:39PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Feb 2023 16:47:26 -0800 Saeed Mahameed wrote:
> > On 03 Feb 13:14, Jakub Kicinski wrote:
> > >I believe Paolo is planning to look next week. No idea why the patch
> > >got marked as Accepted 🤷️

<...>

> My memory is that Leon proposed IPsec offload, I said "you're doing
> this for RDMA", he said "no we will also need this for TC redirect",
> I said "if you implement TC redirect that's a legit use of netdev APIs".
> 
> And now RDMA integration is coming, and no TC in sight.
> 
> I think it's reasonable for me to feel mislead.

And I think that it is reasonable to assume that company doesn't need to
stop its execution just because Leon is going through very challenging
time.

Like, I said, first I need to fix HW limitation and it much harder than
it sounds.

https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=xfrm-latest&id=67bff1d4a6e30010b6fd88ddc3ed70e9da75c95a

Thanks
