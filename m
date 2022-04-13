Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A16D4FFE11
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbiDMSn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbiDMSn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:43:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4B440E71;
        Wed, 13 Apr 2022 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/JByUGqbqjRW0t22OVjXE0r2cFQqamYJUC1OFTwY4yc=; b=FXBzaLDST3Ire/7n6bLCY9fPhO
        N4siP+mbmgstmn/bKN4PwJwGtUqsE63YmvCGhQ0ocrqPyTssotO56f2oUVcQDgDJaPHAv6UtEIajF
        HYo4P16p9qOJDAIlOCOdBP/51wnpeUnB68z5QnxHGROJcyGT/mpPw8zE97eydN9mNIeA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nehvC-00FiB0-VS; Wed, 13 Apr 2022 20:40:54 +0200
Date:   Wed, 13 Apr 2022 20:40:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Message-ID: <YlcZNlrvBXA+6tGk@lunn.ch>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <YlTFRqY3pq84Fw1i@lunn.ch>
 <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
 <YlVz2gqXbgtFZUhA@lunn.ch>
 <20220412133055.vmzz2copvu2qzzin@bang-olufsen.dk>
 <CAJq09z4E-HiA3WD4UtBAYm6mOCehHGedmofCqxRsAwUqND+=uQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z4E-HiA3WD4UtBAYm6mOCehHGedmofCqxRsAwUqND+=uQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It feels strange to force the user to use "realtek,rtl8365mb" or any
> other different string that does not match the chip's real name. I
> would not expect the one writing the DT to know that rtl8367s shares
> the same family with rtl8365mb and rtl8365mb driver does support
> rtl8367s. Before writing the rtl8367s driver, I also didn't know the
> relation between those chips. The common was only to relate rtl8367s
> (or any other chip model) with the vendor driver rtl8367c. As we don't
> have a generic family string, I think it is better to add every model
> variant.

I will just quote the Marvell mv88e6xxx binding:

The compatibility string is used only to find an identification register,
which is at a different MDIO base address in different switch families.
- "marvell,mv88e6085"   : Switch has base address 0x10. Use with models:
                          6085, 6095, 6097, 6123, 6131, 6141, 6161, 6165,
                          6171, 6172, 6175, 6176, 6185, 6240, 6320, 6321,
                          6341, 6350, 6351, 6352
- "marvell,mv88e6190"   : Switch has base address 0x00. Use with models:
                          6190, 6190X, 6191, 6290, 6390, 6390X
- "marvell,mv88e6250"   : Switch has base address 0x08 or 0x18. Use with model:
                          6220, 6250

This has worked well for that driver.

     Andrew
