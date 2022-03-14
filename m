Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7A4D8E62
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245138AbiCNUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245155AbiCNUm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:42:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481B433E97;
        Mon, 14 Mar 2022 13:41:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2ED5612FE;
        Mon, 14 Mar 2022 20:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020CCC340E9;
        Mon, 14 Mar 2022 20:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647290508;
        bh=Q5UNElCKVDoWPSERLB+Lk/Z1wAvO6d4km8pZXOgZUmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZB4KnbTkKmaR1zk4Nf9BkLPY/kVU6SsOdNuYkzxmOMbExwCYpsHkrYETrB1HCgLCt
         6q0N3MIlhZANwUjQMdXgfJrhTQlve323ON3is8cCqjDdLCMELvUH/R5mgHSd95m1Rh
         s/uAN6afFQuqjL9BOShyl+A3DZPQqeGinBiyzdac2TyKse+VJDHmWXAjwmpzkvo2PM
         98ifDHKaK4xC4ufHTgeGijkCr4QpjNzp3cVzN6Z9POX7mtpMI+4odBcqGF8ov1ds+m
         NvynoChcq+eBierxvJzMpDCgQXrOkIYjoPvAx/yUHTaU+icgF+W6h+EdYmnmP6sQzV
         yvgZTkige8FuA==
Date:   Mon, 14 Mar 2022 13:41:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220314134146.20fef5b9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6d37b8c3415b88ff6da1b88f0c6dfb649824311c.camel@sipsolutions.net>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87sfrkwg1q.fsf@tynnyri.adurom.net>
        <20220314113738.640ea10b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6d37b8c3415b88ff6da1b88f0c6dfb649824311c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 21:17:30 +0100 Johannes Berg wrote:
> On Mon, 2022-03-14 at 11:37 -0700, Jakub Kicinski wrote:
> > Yeah.. patchwork build thing can't resolve conflicts. I wish there was
> > a way to attach a resolution to the PR so that the bot can use it :S
> 
> That'd be on thing - but OTOH ... maybe you/we could somehow attach the
> bot that processes things on the netdev patchwork also to the wireless
> one? It's on the same patchwork instance already, so ...

Depends on what you mean. The bot currently understands the netdev +
bpf pw instance so it determines the target tree between those four.

We'd need to teach it how to handle more trees, which would be a great
improvement, but requires coding.

> But I do't know who runs it, how it runs, who's paying for it, etc.

Yeah... As much as I'd love to give you root on the VM having it under
the corporate account is the only way I can get it paid for :(
