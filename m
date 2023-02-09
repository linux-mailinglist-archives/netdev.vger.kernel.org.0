Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD495690F9A
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBIRy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 12:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBIRyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 12:54:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA551E2B2;
        Thu,  9 Feb 2023 09:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE9C861B76;
        Thu,  9 Feb 2023 17:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 171F3C433D2;
        Thu,  9 Feb 2023 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675965263;
        bh=00nM44/MoPM42oJ0uTdNy3wFm7tJkujEAFNU2YBUoIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UheZwYHByqjlrnLQ7okcHNYY0m8BeJXW/D984OazYqHYChijl7F//VAkXzhVNVQiY
         uIqbDPv4qUefMnsfGsL4cxy2cAWhl/hX7MBZA7o7tWyzg7sglPaG065ODfKY/gMXge
         Jao++gUq2oO4DfUC3grPczUR62c4fzrAKv7llaCbYB1QFrONyYqqGEqCVUhJ5QxHcs
         xZ88dT9Fo9vc0STGxLxf+vjOuPnUx8zKQOuizOD91ih3ENsDqBLqYau/MHTFOU9Drb
         vxXXomLiGnQIXF4xnwSyO17pe409Ssm58IRQPKq3xbRv89wJwV9o100wFWiae3Ow8T
         kiOqZ1nAWnPJw==
Date:   Thu, 9 Feb 2023 09:54:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: skbuff: drop the word head from skb cache
Message-ID: <20230209095422.56bcda65@kernel.org>
In-Reply-To: <CANn89iK2r54xfcoUT18MXTQ72mR8vVzoUyHLcBx8-7QibtsVCQ@mail.gmail.com>
References: <20230209060642.115752-1-kuba@kernel.org>
        <CANn89iK2r54xfcoUT18MXTQ72mR8vVzoUyHLcBx8-7QibtsVCQ@mail.gmail.com>
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

On Thu, 9 Feb 2023 10:17:17 +0100 Eric Dumazet wrote:
> Lets not rename 'struct sk_buff' :)
> 
> (Packets are not necessarily tied to a socket)

That made me giggle :)
But I may move the structures to a separate header from the inline
helpers one day to make rebuilds faster..
