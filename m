Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799D364C1DC
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbiLNB3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLNB3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:29:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6252322BFD;
        Tue, 13 Dec 2022 17:29:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64BA617AC;
        Wed, 14 Dec 2022 01:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31C1C433D2;
        Wed, 14 Dec 2022 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670981381;
        bh=CLryo1YCdKv65ckOCD5QKETbB4hOo61txF2CTDjOm/o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ShTMGjg5+CttSyM24yatIeX8V7jrQvaFlqeCDdKdd9IdGpSFRiF9qQVnKMrGdXufv
         7fyogvAclABAq0F5z1HZvOo4mOfF4LXQpH5iQ41133VLbCz9IcFtOib6Q97XRWJ3R8
         Ytx8BKkSGfz6nYXnuxOZNbZ72rbiF4JwwcNeLy58dN9uskg7e9Xdh8Za4f4FVZZwJF
         rMhmmwpgSkcusFUz+lYBg5VpUPwnsgGjSYiOsVf7Tjo/njBcTBoSFUUaiMhFyBFqzb
         PYk0G+ACccC9K13fBYpjlJwUHm0NvctxBrGVOyaMbYPZeDuOdqMBxlPRYbaPvgLzrM
         Hr78ONw1ArGZw==
Date:   Tue, 13 Dec 2022 17:29:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v2 net-next 0/3] mv88e6xxx: Add MAB offload support
Message-ID: <20221213172939.3503a64f@kernel.org>
In-Reply-To: <20221213174650.670767-1-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
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

On Tue, 13 Dec 2022 18:46:47 +0100 Hans J. Schultz wrote:
> This patchset adds MAB [1] offload support in mv88e6xxx.
> 
> Patch #1: Correct default return value for mv88e6xxx_port_bridge_flags.
> 
> Patch #2: Change chip lock handling in ATU interrupt handler.
> 
> Patch #3: The MAB implementation for mv88e6xxx.

# Form letter - net-next is closed

We have already submitted the networking pull request to Linus
for v6.2 and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.2-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
