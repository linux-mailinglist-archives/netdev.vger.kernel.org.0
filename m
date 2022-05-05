Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7408E51BF41
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358243AbiEEMdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiEEMdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:33:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575914E3B1;
        Thu,  5 May 2022 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tu0GYIgzFnGdNrFJk4cGqBy448paO4C9DBmXUxuFC4M=; b=mnVeiXCT0hPDIsj4ns8MaGaimT
        bYiHgf+x3yY72yPp69OpkpXqNYwdU2xn5eBvKJtphyqjtNUzQAhCmJrLyoulhNgAfip2XnljVNkM+
        23rpq7G1zZFM6edHYqnaQaexNbDoEm8ww1KyCRMbOPP1llL57r80W4eg1X9spTV6pMec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmabb-001Lt6-K9; Thu, 05 May 2022 14:29:15 +0200
Date:   Thu, 5 May 2022 14:29:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/7] net: phy: introduce
 genphy_c45_pma_base1_setup_master_slave()
Message-ID: <YnPDGxqbawnLDfAd@lunn.ch>
References: <20220505063318.296280-1-o.rempel@pengutronix.de>
 <20220505063318.296280-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505063318.296280-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * genphy_c45_pma_base1_setup_master_slave - configures forced master/slave
> + * role of BaseT1 devices.
> + * @phydev: target phy_device struct
> + */
> +int genphy_c45_pma_base1_setup_master_slave(struct phy_device *phydev)

The naming convection is baset1

Please add my

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

when you respin.

    Andrew
