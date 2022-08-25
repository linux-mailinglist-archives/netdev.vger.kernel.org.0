Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F8D5A1AEC
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbiHYVSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243595AbiHYVSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:18:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC7BB8F17;
        Thu, 25 Aug 2022 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RAd6uJ1Jd3UcrbvUgO3Ob6W84IU7b0iYpv54mufMdvs=; b=qflfgTGcWoBdJzFGDMeYFaeBhO
        sI7HYqR3qDkcOnpF1pZRzXtAAEUQbmkQKfiDjczRIs6IDjEKFkCBbvEKKLwFly/rk7AGOwxsjlVYe
        ubZusHq1XijrNrbrOHSrZusn4/aCQLoF8X9kmZ9Mg1r5pI+6ISYwZ9TL9wDo266puXII=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oRKFB-00Ebnf-JO; Thu, 25 Aug 2022 23:18:29 +0200
Date:   Thu, 25 Aug 2022 23:18:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v2 2/2] net: asix: ax88772: add ethtool pause
 configuration
Message-ID: <YwfnJYQRJj8dhA+a@lunn.ch>
References: <20220822123943.2409987-1-o.rempel@pengutronix.de>
 <20220822123943.2409987-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822123943.2409987-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 02:39:43PM +0200, Oleksij Rempel wrote:
> Add phylink based ethtool pause configuration
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
