Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567D06429D0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiLENqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiLENqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:46:23 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C23E27;
        Mon,  5 Dec 2022 05:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EX9VBUx0OohPDDPJ+qawLeUxqjcIhO+3jf4xmC07RkM=; b=NqFpUeG8QqMQZdn7FZykc0eiLg
        dTlSFaITfBaD5O3dL+AHrc5gKussnJWTrt/eHdhq/xaofDZMD+P+3Qa9g38Jixvc0bHhgtSx3J3yD
        BmfQItnN/7tyeai7ffbeB3DleewTg0uEsHU86y5nA2LgESMhsLlbTj5sJNF90FHW282Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2BnT-004PR3-8q; Mon, 05 Dec 2022 14:46:15 +0100
Date:   Mon, 5 Dec 2022 14:46:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v1 1/1] net: asix: add support for the Linux
 Automation GmbH USB 10Base-T1L
Message-ID: <Y432JzWOzV89I59J@lunn.ch>
References: <20221205132102.2941732-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205132102.2941732-1-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 02:21:02PM +0100, Oleksij Rempel wrote:
> Add ASIX based USB 10Base-T1L adapter support:
> https://linux-automation.com/en/products/usb-t1l.html

Interesting.

I don't know the ASIX driver. Is Linux driving the PHY? So you get the
correct link mode for a T1L PHY?

	Andrew
