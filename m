Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACE3651882
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiLTBtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiLTBsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:48:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D3BC;
        Mon, 19 Dec 2022 17:46:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E2B7B80BA5;
        Tue, 20 Dec 2022 01:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760A8C433D2;
        Tue, 20 Dec 2022 01:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671500764;
        bh=zwP+BJJcw/m+OSD7rwNCXS4QdnamcYcjhOSJBdSJX/I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jT60VrfPUldPuiK2FWSpQXyBPiFUGaFFuw4hq1PPYZDcB8XOaivnKLV+O2WfFdUio
         9OZVWy6YKuXys/pSj0NE9/XvP6OznCwAkixfeR2Xq08B2pBmDSECG0uT2xXJNiUsk6
         zrnF9uh10bZIYAr1zKGxrRp7A7w8NWAVIEDnZ/TwF+Qx1H59toNmKV8RSVHjjIBN5V
         eEIZ7c3jKah1qJJW6KgJWpnSpFzTtJLQCAPaLcwErsq3gmFH4jI1rmwr29fUQrQ2up
         QY7NUKMvyOF8gp0bFUCr92oFnSq4gSoyL/CRzMiPjJiYemY++s6FY0WEetF43aqBTL
         CjolFXV52wNrA==
Date:   Mon, 19 Dec 2022 17:46:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/2] net: marvell: prestera: add ipv6 routes
 offloading
Message-ID: <20221219174603.39b4183c@kernel.org>
In-Reply-To: <Y5+RDIIGWGeKGUAo@yorlov.ow.s>
References: <Y5+RDIIGWGeKGUAo@yorlov.ow.s>
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

On Mon, 19 Dec 2022 00:15:40 +0200 Yevhen Orlov wrote:
> Add support for IPv6 nexthop/blackhole/connected routes for Marvell Prestera driver.
> Handle AF_INET6 neigbours, fib entries.
> 
> Add features:
>  - IPv6:
>    - Support "offload", "offload_failed", "trap" flags
>    - Support blackhole, nexthop, local/connected/unreachable/etc (trap)
>      e.g.: "ip addr add 2001:1::1/64 dev sw1p2"
>      e.g.: "ip route add 2002:2::/64 via 2001:2::2"
>      e.g.: "ip route add blachole 2003:2::/64 dev lo"

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after Jan 2nd.

RFC patches sent for review only are obviously welcome at any time.
