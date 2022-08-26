Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296F15A286E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 15:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344321AbiHZNVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 09:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344211AbiHZNVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 09:21:43 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C6924080;
        Fri, 26 Aug 2022 06:21:41 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 51311100D941D;
        Fri, 26 Aug 2022 15:21:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 2644054B14; Fri, 26 Aug 2022 15:21:37 +0200 (CEST)
Date:   Fri, 26 Aug 2022 15:21:37 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable-commits@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Mark Brown <broonie@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        Phil Elwell <phil@raspberrypi.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: Patch "usbnet: smsc95xx: Forward PHY interrupts to PHY driver to
 avoid polling" has been added to the 5.15-stable tree
Message-ID: <20220826132137.GA24932@wunner.de>
References: <20220815061223.2484037-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815061223.2484037-1-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Sasha, Dear Greg,

On Mon, Aug 15, 2022 at 02:12:23AM -0400, Sasha Levin wrote:
> This is a note to let you know that I've just added the patch titled
> 
>     usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling
> 
> to the 5.15-stable tree which can be found at:

Please consider reverting upstream commit

  1ce8b37241ed291af56f7a49bbdbf20c08728e88
  usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polling")

in 5.15-stable and 5.18-stable.

I have received two independent reports (from Mark Brown and Phil Elwell)
that the commit breaks link detection on LAN95xx USB Ethernet adapters
in those trees.

The commit works fine in v5.19, but the backports to 5.15 and 5.18 are
apparently missing prerequisites.  Until we've figured out what those are,
the commit should be reverted.

Thank you!

Lukas
