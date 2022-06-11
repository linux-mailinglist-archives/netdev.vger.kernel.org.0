Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1E5475EC
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 17:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbiFKPJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 11:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiFKPI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 11:08:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8678D37BDE;
        Sat, 11 Jun 2022 08:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gDUa+esIiiBXTNfV0lnhBpLu0uaY1/e4KgjKosEHKvQ=; b=TV2SEpJbiA3HOGWZ6iMGco+DKI
        pxUEgLkpfRllaLb4WQ/xdJF7qdPOlmj5pn4Z7G4B0PDdKT4hywuVv1Psc3ttEbEHQr/k4kWtlif6m
        jdBqatsWxsFxdKT4+34/oLitdfrJ0/GXJ17A93cxiNoyCbzptEiEXlSJkWoVa41YqB90=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o02jH-006WHx-As; Sat, 11 Jun 2022 17:08:47 +0200
Date:   Sat, 11 Jun 2022 17:08:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: phy: dp83td510: add SQI support
Message-ID: <YqSv/4V1n+W2pxpF@lunn.ch>
References: <20220608123236.792405-1-o.rempel@pengutronix.de>
 <20220608123236.792405-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608123236.792405-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 02:32:34PM +0200, Oleksij Rempel wrote:
> Convert MSE (mean-square error) values to SNR and split it SQI (Signal Quality
> Indicator) ranges. The used ranges are taken from "OPEN ALLIANCE - Advanced
> diagnostic features for 100BASE-T1 automotive Ethernet PHYs"
> specification.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
