Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744EF6EE4EA
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbjDYPmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbjDYPl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB02B454;
        Tue, 25 Apr 2023 08:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6629F61791;
        Tue, 25 Apr 2023 15:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA9FC433EF;
        Tue, 25 Apr 2023 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682437317;
        bh=IKWz+GGutBkjD9113YcFUYBetBw1I+xVwhSFb82zAaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c56Y2Of2BOHGd5rbWKhEZHIYh55nGV7IfYErs8y80IyjgEXZ41dBeIDWlEeSaZabX
         lSMT63MvkWGBEHXgpG3ih5+JGDuQVs6uqnaLyoQR0vtW42QNeCExyS9y1CHyf5/NvZ
         H4ODybnRaxAo1+CzbaR3Ru334oed10qtBjFhU9G7NMPfJ/Ynngqc2K558EDg+An5gS
         18DWwCPoLuDh1YxdqoPYIef7rEcNISOcgE0QusgKO3FznCymG8syq9fQjrBuec1VcZ
         A8xyeFw6LeL6+MXKZBEtUdG01Yaxd469Ntei62fW3oKGl8qqrC0/ReTlCd1pxSy8bB
         Y6T0OEHLWr9DQ==
Date:   Tue, 25 Apr 2023 08:41:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevsim: fib: Make use of rhashtable_iter
Message-ID: <20230425084156.03682288@kernel.org>
In-Reply-To: <20230425144556.98799-1-cai.huoqing@linux.dev>
References: <20230425144556.98799-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 22:45:55 +0800 Cai Huoqing wrote:
> Iterating 'fib_rt_ht' by rhashtable_walk_next and rhashtable_iter directly
> instead of using list_for_each, because each entry of fib_rt_ht can be
> found by rhashtable API. And remove fib_rt_list.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.
-- 
pw-bot: defer
