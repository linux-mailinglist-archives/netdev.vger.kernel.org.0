Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B281F5F5FB1
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 05:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJFDh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 23:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJFDhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 23:37:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE27E7EFEA;
        Wed,  5 Oct 2022 20:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4961E617CF;
        Thu,  6 Oct 2022 03:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60856C433C1;
        Thu,  6 Oct 2022 03:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665027473;
        bh=/yVxJmqvRz+D//XMVfFvLOXigKlk3aoMfTspUWMS1y8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=huPAC8vozvwosN2varfukhAsd/Ue/ERobJImb4xBNa0hFuBbNwao3q6xROusJcC3G
         gqs4D4FLISin36D9zbfVwD8VVGrF8ZIvWcDzQzkAzHsE3NpAYXMlSSvgzDy19BVZim
         KtTQryYN6BbFYWzpYtMnMrF6HXVs0Oge8sPGm2TaOXyIQByPl7StFI9DFsmSFGgSAq
         HGeLrFx6s1GJZZpLJc83e120hXJ+J+GZH4Zw6Ill3TgM3+9E9JzlY/U2pG7gL2pde4
         GbxAbxWEm4TeoNIcAV74d3k99vC7luBE3fyKUAI5PW8xlHPmau0bfO8IyI+CRcpVob
         z+JfrCPASkVNQ==
Date:   Wed, 5 Oct 2022 20:37:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v1 1/1] mac_pton: Don't access memory over expected
 length
Message-ID: <20221005203752.1d6f1883@kernel.org>
In-Reply-To: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
References: <20221005164301.14381-1-andriy.shevchenko@linux.intel.com>
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

On Wed,  5 Oct 2022 19:43:01 +0300 Andy Shevchenko wrote:
> The strlen() may go too far when estimating the length of
> the given string. In some cases it may go over the boundary
> and crash the system which is the case according to the commit
> 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> 
> Rectify this by switching to strnlen() for the expected
> maximum length of the string.

# Form letter - net-next is closed

We have already sent the networking pull request for 6.1
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.1-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
