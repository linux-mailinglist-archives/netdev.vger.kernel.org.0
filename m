Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE06E7CFC
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbjDSOjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDSOjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:39:37 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDF735A3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=lqhgkAi2HZk50QHaKlDZ9g9mufk+AaYLxsNDVFBM7DE=; b=yE
        9/0jUpx0xU6sTi2KXc5UaFassTBNIiT8k92vqRXrJXd8zFjrOANVmbJs4KUe3L5MojlGEhEX9DJii
        UP6v7YPKJkD3B8wOhgOG2ov+C3ki+3CISpElKgbSP5voSxvv02t374Dp/j8PDBMhWz+KHwF7Osehq
        19uhERCMOd3M0ns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pp8xl-00Ahoq-6s; Wed, 19 Apr 2023 16:39:13 +0200
Date:   Wed, 19 Apr 2023 16:39:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <03bd17cf-1763-4913-8249-eda6fbc31440@lunn.ch>
References: <ZD/Nl+4JAmW2VTzh@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZD/Nl+4JAmW2VTzh@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 01:16:39PM +0200, Ramón Nordin Rodriguez wrote:
> This patch adds support for the Microchip LAN867x 10BASE-T1S family
> (LAN8670/1/2). The driver supports P2MP with PLCA.

It is normal to list here what has changed since the last
version. That gives reviewers an idea what comments have been address,
and if any have been missed.

> Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
