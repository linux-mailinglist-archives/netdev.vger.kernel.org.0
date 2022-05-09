Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99690520329
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbiEIRJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239482AbiEIRJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:09:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96042D572E;
        Mon,  9 May 2022 10:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5615561549;
        Mon,  9 May 2022 17:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5104FC385B1;
        Mon,  9 May 2022 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652115913;
        bh=hPfwttjDKS5VbKLDMyB6qPIDEclzcNRrUVoHj1607Ew=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OTOTLYS0FB6K12s3wLdBAHatQ/gPw/URa7FMCeRwDsRqNkqJ2Vr6MVsOaYgEJfxin
         fEa1aW13gwgFn8IaUIXGzzovKUgZFdFqT/l+nKslxvB7JK6p47YegfSNx1dKGa+yLZ
         xapl3b3irJ7GYIs+5LTT1heyYR8yr9LrCJCI184GvvK4T0tjHzQioZSa7n+JFG3+Ua
         CoM979nY7j+OhgUKDdvlXuEY1LKuo7WY49x3PFowJ4A/CFd8sKxZZsUjbrz2s/kgUZ
         sXjAt40dxcmeq6ysK6ccLxSe+cme/DiTtqK1D5DEEtcxcn7TFRmTK1zH3dCMf66BOD
         jFUUB5TZZhpBg==
Date:   Mon, 9 May 2022 10:05:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Akira Yokosawa <akiyks@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ben Greear <greearb@candelatech.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v3] net/core: Rephrase function description of
 __dev_queue_xmit()
Message-ID: <20220509100512.719f9225@kernel.org>
In-Reply-To: <4dd26a0e-819d-8414-8b71-1783e263209c@gmail.com>
References: <20220507084643.18278-1-bagasdotme@gmail.com>
        <0cf2306a-2218-2cd5-ad54-0d73e25680a7@gmail.com>
        <Yni6nBTq+0LrBvQN@debian.me>
        <4dd26a0e-819d-8414-8b71-1783e263209c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 13:59:48 +0700 Bagas Sanjaya wrote:
> On 5/9/22 13:54, Bagas Sanjaya wrote:
> > I'm in favor of this patch. Thanks.
> 
> Oops, I mean I'm in favor of your patch suggestion.

I think I already said what my preference was. This is a trivial
matter, let me just send a patch myself.
