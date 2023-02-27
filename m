Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9306A4CF6
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjB0VQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 16:16:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjB0VQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 16:16:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4D727D46;
        Mon, 27 Feb 2023 13:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DD4ECE1194;
        Mon, 27 Feb 2023 21:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA3AC4339B;
        Mon, 27 Feb 2023 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677532606;
        bh=Y+45uLb2rwEYSyb2wyROLBing0xKnFJZiGEP/d0URG4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fReZ4EimOfDk+i+HeK0FfZsQgFLOzEuWqAeZYpwmUCMgShCrJjR7Cx0iWrv3l57SE
         ItI5Hh5XjtI0l9mLK+XUIl1QZQ1M09E327fPfNORFZ2fBp9KTxcrxo+LzWysBDum+9
         97Z603CNzf43didCTpT4QQYJSN4dWfm4CZYK3nrvQQxnhVH4D4lqT7GrSh3wB+NwWg
         xIue7Il93tpmp9d8FzE9zvyttAI8jT2M2Y1V/b1xIOmFzbYuj0QammvIf/8KswZ1Ii
         1h03EZdDZatlcC07Gg3xF4a43dZKlJhDtz5neDHqj+r1ZXvxau2fcSfU6LSDa5Qj5Z
         /h7RadljcbUcw==
Date:   Mon, 27 Feb 2023 13:16:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net v1 1/1] net: phy: c45: fix network interface
 initialization failures on xtensa, arm:cubieboard
Message-ID: <20230227131645.58fadb5c@kernel.org>
In-Reply-To: <20230225071644.2754893-1-o.rempel@pengutronix.de>
References: <20230225071644.2754893-1-o.rempel@pengutronix.de>
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

On Sat, 25 Feb 2023 08:16:44 +0100 Oleksij Rempel wrote:
> Without proper initialization, "changed" returned random numbers and caused
> interface initialization failures.
> 
> Fixes: 022c3f87f88e ("net: phy: add genphy_c45_ethtool_get/set_eee() support")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thanks!
