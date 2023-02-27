Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2F6A4B50
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjB0TlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjB0TlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:41:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB82313F
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76B5360F08
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5ECC433EF;
        Mon, 27 Feb 2023 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677526855;
        bh=KhNYC0uE0764MJrBXDFOzurn/JLMd3zh70r/K4BRKkg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZBZ3Zetd1u2wuOlo6NKL8x+momM3cklFdF//Dta2j3kChHaqihvOveOw0lnLKA6IH
         HVp29zTCpOH3L76fkQsdPs4K2TLp3dbg8rA5XwM/ZiG7b8XtmtPmXioR2QJlSXM1iI
         14YfdwHdNNJW6nOIINVRfGB648O08kjYsE8dPMgt9gXoQHcQp+NUM20RSxuPCEO7lj
         W5i4b8NI99f/YmATlhjXsX1w3wxCAW1VfOJ4lkmABZf4H2v9fTA51z9YN6BIPadla/
         /+c/QIavInsl3qheqPwuUAEqAAWR0sP2nYXMH8l3JtvFDedjh7Yjcbq+5bAI0sR+zi
         wV9LtMjnHzgSQ==
Date:   Mon, 27 Feb 2023 11:40:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ocelot_ext: remove unnecessary phylink.h
 include
Message-ID: <20230227114054.61fe22da@kernel.org>
In-Reply-To: <E1pVbBE-00CiJn-NK@rmk-PC.armlinux.org.uk>
References: <E1pVbBE-00CiJn-NK@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 16:44:20 +0000 Russell King (Oracle) wrote:
> During review of ocelot_ext, it created a private phylink instance
> that wasn't necessary. This was removed for subsequent postings,
> but the include file seems to have been left behind. Remove it.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Applied, thanks!
