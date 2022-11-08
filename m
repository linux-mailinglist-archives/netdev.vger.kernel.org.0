Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF362127D
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiKHNhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiKHNhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:37:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9013012AA3
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hkqgs8tXew55CcjbQ4pxmXbRvq+I6kAtErrhQFXPGLY=; b=s4movJtUINmBfkOzQStWjaqtJz
        MXw2ijw9xbKN4p5u8A7YAoEh7JklQ1kmmDsujFR1S8wiy+fs2glkJa1j42WM5dUGFdm1CzN/hNH58
        5cbfnZH2M6r/1HuNtXwflXLNDwvCyq8PBcC7SoEMCjKj5pRda8jtDS4FZgprQGcyPg5Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osOmZ-001p3X-US; Tue, 08 Nov 2022 14:36:51 +0100
Date:   Tue, 8 Nov 2022 14:36:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lukasz Majewski <lukma@denx.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 3/9] net: dsa: mv88e6xxx: implement get_phy_address
Message-ID: <Y2pbc90XD5IvZZC0@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-4-lukma@denx.de>
 <20221108091220.zpxsduscpvgr3zna@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108091220.zpxsduscpvgr3zna@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would it be possible to do like armada-3720-turris-mox.dts does, and put
> the phy-handle in the device tree, avoiding the need for so many PHY
> address translation quirks?
> 
> If you're going to have U-Boot support for this switch as well, the
> phy-handle mechanism is the only thing that U-Boot supports, so device
> trees written in this way will work for both (and can be passed by
> U-Boot to Linux):

This is how i expect any board using the MV88E6141 and MV88E6341 work.
It has the same issue that it is not a 1:1 mapping.

Portability with U-boot is an interesting argument. Maybe there are
patches to u-boot to add the same sort of quirks?

	Andrew
