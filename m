Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC2252FD43
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 16:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiEUO0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 10:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiEUO0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 10:26:41 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EEC3AA59
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 07:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=4TQ7pAeXGZOQJQMxJ/uWJEaE7eYx7c3DeMDfRZc6DD0=; b=1t
        +lNfsEA+araGeQm2DPJFTKKzXSm3L/xBpW7g2/BkYUPfGX0Y0TMVQEGSnpYTM9DWVRysmNkcMeeDQ
        0tLmT53nutvHCASmGPWmWt/BubVATFtSe1/XeJBApHSvYMSSibUjPHMbKm12UE/HKFWsx2fJ+yXo8
        S0nhZpWozEz7N2g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nsQ3u-003mGk-FT; Sat, 21 May 2022 16:26:34 +0200
Date:   Sat, 21 May 2022 16:26:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        NXP Linux Team <linux-imx@nxp.com>, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: fec: Do proper error checking for optional clks
Message-ID: <Yoj2mnv2TZDffd3B@lunn.ch>
References: <Yof3/o46wXWXMsKo@lunn.ch>
 <20220521083425.787204-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220521083425.787204-1-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 10:34:25AM +0200, Uwe Kleine-König wrote:
> An error code returned by devm_clk_get() might have other meanings than
> "This clock doesn't exist". So use devm_clk_get_optional() and handle
> all remaining errors as fatal.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
