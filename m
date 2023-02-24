Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E606A1528
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjBXDDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjBXDDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:03:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756E2BDF5;
        Thu, 23 Feb 2023 19:03:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D1F5BCE21A0;
        Fri, 24 Feb 2023 03:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AC2C433EF;
        Fri, 24 Feb 2023 03:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677207803;
        bh=NDoK5e2kczfPG8bCKCQ1NNk7OjKyuYuk9kgZog2uktw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y7Kjwp1p/NywpI9es3Lt5W+4s060SqivXzaUJEIT0quhCbnVn3EAKoTYRdmlcKWVD
         Xc3LFCAZqzQxdImbrMZOuNZSI8V78xgCdz53e7WIYboq6zQBGmF40NNSQxribMvG+p
         pjkk67JmodqA+4iPgf5qfq75PUH7spBYIjWJBx9ssyAl4slsh3VaVwHx/b+Mc3U/0H
         yK+XMt1QNLpRfyZO20evudXU8/c+vcSpkUupXKHkZntjB78Zlc8YAfTn5oneyfj00J
         NKZP3dROkKTowMVwKZeE9/OkYbaW4fBiZ3mM0iL8aRKHE35MT+oGPWrCdA7Il3W5Nz
         m86o5fnQ7Qjdg==
Date:   Thu, 23 Feb 2023 19:03:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH net] net: sunhme: Fix region request
Message-ID: <20230223190321.402822a7@kernel.org>
In-Reply-To: <20230222204242.2658247-1-seanga2@gmail.com>
References: <20230222204242.2658247-1-seanga2@gmail.com>
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

On Wed, 22 Feb 2023 15:42:41 -0500 Sean Anderson wrote:
> devm_request_region is for I/O regions. Use devm_request_mem_region
> instead.  This fixes the driver failing to probe since 99df45c9e0a4
> ("sunhme: fix an IS_ERR() vs NULL check in probe"), which checked the
> result.
> 
> Fixes: 914d9b2711dd ("sunhme: switch to devres")
> Signed-off-by: Sean Anderson <seanga2@gmail.com>

Applied, thanks!
