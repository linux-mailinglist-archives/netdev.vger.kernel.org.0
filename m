Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA84DE4CD
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241635AbiCSARp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiCSARp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:17:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50985B6E7F;
        Fri, 18 Mar 2022 17:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3EUAArsXr+rhfXgx3ggs3vJLaIOQendkgvJ/9e1VIaI=; b=mNybOq2gXPqacwTUQ6iKj7D7Fw
        9ATeinKV2VgWA3KubS09gdeVfvdp5VPvswT5slgCfAueCvNjXUoRrL26gqC+Z7CBT5gm4+BA+Zrcj
        MBfINjG4Lsmpvh5EAP8X2DaEOnS9UpEZcABoS+sX2U35r78bXI4bXmYlt48V0AyHbZNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVMlX-00Bdq9-Ma; Sat, 19 Mar 2022 01:16:19 +0100
Date:   Sat, 19 Mar 2022 01:16:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v3 3/3] net: mdio: mscc-miim: add lan966x
 internal phy reset support
Message-ID: <YjUg01ysbonU7L/p@lunn.ch>
References: <20220318201324.1647416-1-michael@walle.cc>
 <20220318201324.1647416-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318201324.1647416-4-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 09:13:24PM +0100, Michael Walle wrote:
> The LAN966x has two internal PHYs which are in reset by default. The
> driver already supported the internal PHYs of the SparX-5. Now add
> support for the LAN966x, too. Add a new compatible to distinguish them.
> 
> The LAN966x has additional control bits in this register, thus convert
> the regmap_write() to regmap_update_bits() to leave the remaining bits
> untouched. This doesn't change anything for the SparX-5 SoC, because
> there, the register consists only of reset bits.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
