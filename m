Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD8F618F5D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiKDEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiKDEDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:03:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DD81F633;
        Thu,  3 Nov 2022 21:03:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97136B82B6C;
        Fri,  4 Nov 2022 04:03:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EDAC4314D;
        Fri,  4 Nov 2022 04:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667534627;
        bh=drDwwi5O3Hyqk7T839dPMr8Nig2wKgr2yAHO5wQWRI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iKyCDH7bNbxsVE7tPzkoPhcIh9CYpM3+qq39ftOw+YQTATCniCcdsZ4m28Or9bSph
         p23Ya6x9kBsEtSiHCkIfQbwg8Le4joZ0Cj4A3w19L+ZuOe5gzDjN4NOh8ApPOPjxP+
         tOL9RfASZ69uNkqT/B3pywTd7BEYFVjk8zt9+/Odjc3X9Pl5qoYYmIOr0eAgQhPmjn
         5RzxLooe796F5fofbolI706S5+iS4349BuGNEr1h4QlZNZvYmHrXDr/npIHcJnkFF4
         3BQV1scS4brFSaxLg9L+kAEyUOdhGypxTl/nxa1+41HiAfxS2h1XGkmWzNGQ6OZOCv
         g3NDbS5wzbfnw==
Date:   Thu, 3 Nov 2022 21:03:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH net-next v1.2] net: phy: fix yt8521 duplicated argument
 to & or |
Message-ID: <20221103210345.2cc14a0d@kernel.org>
In-Reply-To: <20221103061413.1866-1-Frank.Sae@motor-comm.com>
References: <20221103061413.1866-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Nov 2022 14:14:13 +0800 Frank wrote:
> cocci warnings: (new ones prefixed by >>)
> >> drivers/net/phy/motorcomm.c:1122:8-35: duplicated argument to & or |  
>   drivers/net/phy/motorcomm.c:1126:8-35: duplicated argument to & or |
>   drivers/net/phy/motorcomm.c:1130:8-34: duplicated argument to & or |
>   drivers/net/phy/motorcomm.c:1134:8-34: duplicated argument to & or |
> 
>  The second YT8521_RC1R_GE_TX_DELAY_xx should be YT8521_RC1R_FE_TX_DELAY_xx.
> 
>  Fixes: 70479a40954c ("net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

Please use your full legal name in the tag.

Please address the comments from the previous version, and read this:

https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

Please use natural numbers for versioning - v1, v2, v3
