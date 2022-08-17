Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225AC597359
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbiHQPyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbiHQPyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:54:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3708C45F;
        Wed, 17 Aug 2022 08:54:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC9EB81E1A;
        Wed, 17 Aug 2022 15:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467AFC433D7;
        Wed, 17 Aug 2022 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660751655;
        bh=+TPtPHk/ZePyFoyYD4f8JLqqgbi4l9lYy2gA0NBPu6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=STJWsRxmu9+76KazBcwal9IKV2AviFQ7zSYeU3OTaKnuBrE729/ZOduJAlmzmkXVP
         oyRDnK6MIz/Gg/K2eBvJujt9j9rplwoKZjM8W7HqaCjbHTvV2QlSYmIsZE8OCZuwVv
         rmxWnhgcM1N0L1n2nQ4rLvnIWYE4BSzfheKNjBuP4Vir0WiDbvJxd9qyywvpHl76Ed
         OC7GjPEuYrVX0m/B7stC+G1wS5n2bSSKsOr0atthJMB92NrYyMhrnWIoufHOVY58jn
         4PhE7AAMRpDK4hYbSq+3qiYKCKh9gWLyOD64YqAnhNM74ixMwnBnGr6DUjFGk4bSH8
         E1iIlGlYtWlrg==
Date:   Wed, 17 Aug 2022 08:54:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220817085414.53eca40f@kernel.org>
In-Reply-To: <20220815175009.2681932-1-f.fainelli@gmail.com>
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 10:50:07 -0700 Florian Fainelli wrote:
> Hi all,
> 
> This patch series has the bcm_sf2 driver utilize PHYLINK to configure
> the CPU port link parameters to unify the configuration and pave the way
> for DSA to utilize PHYLINK for all ports in the future.
> 
> Tested on BCM7445 and BCM7278

Last call for reviews..
