Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E33E588282
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 21:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiHBT2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 15:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiHBT2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 15:28:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6BB39BB6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CAEB82067
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 19:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAE5C433D6;
        Tue,  2 Aug 2022 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659468526;
        bh=YjjOEb9RddbezUDdSAqtQKzMcG19hQoERWWUoHk7Xlo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MSEGKDzOZGjNIGARBgqn7Ka9x9dPG7aWQJMxA6RpycLUD6/uuRg6+d2oGHEDaavdO
         Q+rWpxuI2+t0Dtg3IzPz5Jnkig5t2n01Lo/Z2dU+4v99JxLasR1L6jaNN9Bnh+7fhL
         XZzozUUESoF6uJAPIk6GvUm06Mikkxhf/0klUyX6q45tXAgiqehqwbz9d8jQOfy9xV
         Kb3wor+ufF9Ckc39k31ziydqE7CxEurJQ7klZmAgYjlLZEV8qXJ8abPvDNHBpGdXWN
         AIj7uqqmm1NmMECgdowcxjjLA3LgF9MyBuSCaYPqsgoBNZMx0lnfXbmQ8KIPBxKA+f
         c7uRFJ54/P8kA==
Date:   Tue, 2 Aug 2022 12:28:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, xeb@mail.ru, edumazet@google.com,
        roopa@nvidia.com, bigeasy@linutronix.de, iwienand@redhat.com,
        heikki.krogerus@linux.intel.com, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: gro: skb_gro_header helper function
Message-ID: <20220802122844.56ddafd8@kernel.org>
In-Reply-To: <20220802142842.GA2524@debian>
References: <20220802142842.GA2524@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Aug 2022 16:38:02 +0200 Richard Gobert wrote:
> Introduce a simple helper function to replace a common pattern.
> When accessing the GRO header, we fetch the pointer from frag0,
> then test its validity and fetch it from the skb when necessary.
> 
> This leads to the pattern
> skb_gro_header_fast -> skb_gro_header_hard -> skb_gro_header_slow
> recurring many times throughout GRO code.
> 
> This patch replaces these patterns with a single inlined function
> call, improving code readability.
> 
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>

# Form letter - net-next is closed

The merge window for Linux 6.0 has started and therefore 
net-next is closed for new drivers, features, code refactoring 
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
