Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B7C63B4B8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 23:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbiK1WSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 17:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiK1WSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 17:18:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE6D303EB;
        Mon, 28 Nov 2022 14:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C419B81022;
        Mon, 28 Nov 2022 22:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBE2C433C1;
        Mon, 28 Nov 2022 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669673897;
        bh=rwK2Oe6rssPPQUxPyu6rJ5UNk8p9/cJOjAk0fhEeRY0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=siQpm8GfV5cbw2WMIzTLOnoviVJdgMbRir9MTJFn8G8fKhBm1mKsTW18PGxIO5wqe
         xoXu3Bvbxf2QOFeUVVdEGyJAGpd+m6EY2ksaYQh7vnRi6Yt/Uj0B/kERBpM+hAB3O7
         EgbbrcNs9j/HsU0n1KsedZDVuM8lUFSdmviuF7pLRiMsdRS30F0CQBY2A/WHeDhPNb
         E9TIL7WkYBJHhklVYmoA6eHNGnO9pCH1NXsJtXXWaXLA6ozHYlMEu4ybkJgOMybRxl
         FECyCKkvG8uW3gWnvHS6KISp5t8uDatyFyRVdZ15juYjnimYpPQ0IqUlgXht4584mB
         2oqC2aoThDPnQ==
Date:   Mon, 28 Nov 2022 14:18:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuan Can <yuancan@huawei.com>
Cc:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add check for nla_nest_start()
Message-ID: <20221128141816.3df481d0@kernel.org>
In-Reply-To: <20221126100634.106887-1-yuancan@huawei.com>
References: <20221126100634.106887-1-yuancan@huawei.com>
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

On Sat, 26 Nov 2022 10:06:32 +0000 Yuan Can wrote:
>   udp_tunnel: Add checks for nla_nest_start() in
>     __udp_tunnel_nic_dump_write()
>   wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()

Please post these separately (with David's feedback addressed)
they need to go to different trees so making them as series is
counter-productive.
