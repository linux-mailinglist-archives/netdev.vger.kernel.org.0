Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B160692C28
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBKAiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKAiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:38:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4F63C39;
        Fri, 10 Feb 2023 16:38:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0332E61EF4;
        Sat, 11 Feb 2023 00:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7D5C433D2;
        Sat, 11 Feb 2023 00:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676075898;
        bh=z/4g8+HjTBmvfBMV9jnrgYLYNCiRwvypyW6GWl+aDjY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VSb98J8313MJV5b07+gaScT6mOeHQokSe39sUL/rS4qCVsfej0niWqYyv3oIwGIgl
         Hq7ubsxuDEoGwo2dt54HPQi3emw5D/TwQXHJ4gQJ19nhyzcsYhVswtZiDWdLSgZ5u+
         maSMz41yy1ZYGWVVKmObUgqrjFHbYzoN1I6kqKIC88CXffPWMLa9BKfbTcYXf/a7xc
         Gr8X+Qw2ULwu5CgZkVEWV/Deb90U6nEM9qv19FayfpoKXU2mlRhCso3oVhsg6AQvMA
         byGIYGb4fP6rk51ux8k7woIpg3SFpPZSyp2DNmWK/XdcfrdvdRU+c+tx/ZK8dfQI10
         DzNEqVxVWYucg==
Date:   Fri, 10 Feb 2023 16:38:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, <andrew@lunn.ch>,
        <nm@ti.com>, <ssantosh@kernel.org>, <srk@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 0/2] Introduce ICSSG based ethernet Driver
Message-ID: <20230210163816.423a0ee9@kernel.org>
In-Reply-To: <20230210114957.2667963-1-danishanwar@ti.com>
References: <20230210114957.2667963-1-danishanwar@ti.com>
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

On Fri, 10 Feb 2023 17:19:55 +0530 MD Danish Anwar wrote:
> This series depends on two patch series that are not yet merged, one in
> the remoteproc tree and another in the soc tree. the first one is titled
> Introduce PRU remoteproc consumer API and the second one is titled
> Introduce PRU platform consumer API.
> Both of these are required for this driver.
> 
> To explain this dependency and to get reviews, I had earlier posted all
> three of these as an RFC[1], this can be seen for understanding the
> dependencies.

And please continue to post them as RFC :( If there are dependencies
which the networking tree doesn't have we can't possibly merge these :(
