Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E766870C2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBAV7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBAV7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:59:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0D8721D2;
        Wed,  1 Feb 2023 13:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=W9SUVgiDKQB3AC/th2+dgOo9sEGOeO1QB0KsbOvXuNU=; b=f6ZmReIRFRtjB1AnNOXtDIwaeK
        c7qOV9R32cxAtqpIpiIz0DHkdSm96IK5+6ev1OHxY8pAMQnP7ev5pj1WVjXjYE1NWRd3Zhc/jPnXP
        bINdWbwQ+1gv5G2/ditLHAIk94XamrBX0V8I6wE8kwAzf3ztDq7kM7IcC5ozCIRLkt3o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNL7t-003q5U-1L; Wed, 01 Feb 2023 22:58:45 +0100
Date:   Wed, 1 Feb 2023 22:58:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Wei Fang <wei.fang@nxp.com>, Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: fec: restore handling of PHY reset line as
 optional
Message-ID: <Y9rglfKpISuXfOgC@lunn.ch>
References: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201215320.528319-1-dmitry.torokhov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 01:53:19PM -0800, Dmitry Torokhov wrote:
> Conversion of the driver to gpiod API done in 468ba54bd616 ("fec:
> convert to gpio descriptor") incorrectly made reset line mandatory and
> resulted in aborting driver probe in cases where reset line was not
> specified (note: this way of specifying PHY reset line is actually
> deprecated).
> 
> Switch to using devm_gpiod_get_optional() and skip manipulating reset
> line if it can not be located.
> 
> Fixes: 468ba54bd616 ("fec: convert to gpio descriptor")
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
