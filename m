Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0533D519164
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 00:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243654AbiECWaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 18:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235020AbiECWaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 18:30:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6A225C59;
        Tue,  3 May 2022 15:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dQbAhLGYkSC9p3//MdXKmbMJRWP0vX5cZWdr61xwGEA=; b=ERVmPGm9UX70qdCIc8SmknZp6v
        vevqhSa9AvYZNoyRPL4S8d1qqQTt5PvluKbYQ2vN1EyI5YxulgNcvwW5iqYXac7soQ5R7aALvxY9Q
        AtnzbzSgA09Pv0ttjlAmwtRJKtHLxcxQNLqsZl55BR3nsIqNxE75qWEpEnIvnHLSr2ao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nm0yM-00173O-Lh; Wed, 04 May 2022 00:26:22 +0200
Date:   Wed, 4 May 2022 00:26:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>
Subject: Re: [PATCH net-next v2 6/7] net: phy: smsc: Cache interrupt mask
Message-ID: <YnGsDtscYkh28PFm@lunn.ch>
References: <cover.1651574194.git.lukas@wunner.de>
 <e4a5d784e47bf919873e520e0c6c5156a1ecdde7.1651574194.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4a5d784e47bf919873e520e0c6c5156a1ecdde7.1651574194.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 03:15:06PM +0200, Lukas Wunner wrote:
> Cache the interrupt mask to avoid re-reading it from the PHY upon every
> interrupt.
> 
> This will simplify a subsequent commit which detects hot-removal in the
> interrupt handler and bails out.
> 
> Analyzing and debugging PHY transactions also becomes simpler if such
> redundant reads are avoided.
> 
> Last not least, interrupt overhead and latency is slightly improved.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
> Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
