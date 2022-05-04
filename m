Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D2351996F
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 10:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346114AbiEDITX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 04:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346106AbiEDITV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 04:19:21 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [176.9.242.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A9C1FCD6;
        Wed,  4 May 2022 01:15:45 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 94FA0101951B0;
        Wed,  4 May 2022 10:15:43 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 67F464D2E9; Wed,  4 May 2022 10:15:43 +0200 (CEST)
Date:   Wed, 4 May 2022 10:15:43 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Ferry Toth <fntoth@gmail.com>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 0/7] Polling be gone on LAN95xx
Message-ID: <20220504081543.GA21083@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
 <a9fcc952-a55f-1eae-c584-d58644bae00d@gmail.com>
 <20220503082612.GA21515@wunner.de>
 <2a436486-a54d-a9b3-d839-232a38653af3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a436486-a54d-a9b3-d839-232a38653af3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 03, 2022 at 04:26:58PM +0200, Ferry Toth wrote:
> On 03-05-2022 10:26, Lukas Wunner wrote:
> > On Mon, May 02, 2022 at 10:33:06PM +0200, Ferry Toth wrote:
> > > I have "DMA-API: debugging enabled by kernel config"
> > > and this (I guess) shows me before and after the patches:
> > > 
> > > ------------[ cut here ]------------
> > > DMA-API: xhci-hcd xhci-hcd.1.auto: cacheline tracking EEXIST, overlapping
> > > mappings aren't supported
> > 
> > That is under investigation here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=215740
> > 
> > It's apparently a long-standing bug in the USB core which was exposed
> > by a new WARN() check introduced in 5.14.
> 
> I'm not sure this is correct. The issue happens for me only when connecting
> the SMSC9414.
> 
> Other usb devices I have (memory sticks, wifi, bluetooth) do not trigger
> this.

Hm, I've taken the liberty to add that information to the bugzilla.

Thanks,

Lukas
