Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D30658037D
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 19:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiGYRXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 13:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiGYRXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 13:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA82214D18;
        Mon, 25 Jul 2022 10:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 465B0B81023;
        Mon, 25 Jul 2022 17:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D523DC341C6;
        Mon, 25 Jul 2022 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658769802;
        bh=fchiwXgbBdTjI1tnnwCi+jTVEwh6cgK0qLJkFVlCACE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UqKK0uJQDwEvh2Vi54J+93uJuKGLM7IAOnAOwLCMCuksblRTIRvEgXkjLeUwqPW4N
         5AlvtwsxU8J+i6CNRj/GwiuTygIy05ACwDSzeTQ+zvHZZeFsgMNuaEmyOq9f2QGPgo
         jzadUidSTOzLEpy1Nhq2yX1MX85TEzM+PBpLT4HGtOXqtYBeAfqJkxRmMvfjDsm9aI
         K/31R1brUtwHQtk8FOCFFXUBR+qLE9ofcMp7SDDnxR0K3xBtPT9c3I7y/tmztyWRFy
         F7zgU4j4dUOu+92AJ19L5FXRwcSmVR2o1dhXqEDJi9+Ppq0vOBeD2FIAOdLMZ4hn+j
         Y3FxR5pnKkL0w==
Date:   Mon, 25 Jul 2022 19:23:14 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     William Zhang <william.zhang@broadcom.com>
Cc:     Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        joel.peshkin@broadcom.com, f.fainelli@gmail.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, rafal@milecki.pl,
        krzysztof.kozlowski@linaro.org, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" 
        <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" 
        <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" 
        <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on
 ARCH_BCMBCA
Message-ID: <Yt7RgsTA/1TmMcbU@shikoro>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        William Zhang <william.zhang@broadcom.com>,
        Linux ARM List <linux-arm-kernel@lists.infradead.org>,
        joel.peshkin@broadcom.com, f.fainelli@gmail.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, rafal@milecki.pl,
        krzysztof.kozlowski@linaro.org, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        "open list:I2C SUBSYSTEM HOST DRIVERS" <linux-i2c@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MEMORY TECHNOLOGY DEVICES (MTD)" <linux-mtd@lists.infradead.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:PCI NATIVE HOST BRIDGE AND ENDPOINT DRIVERS" <linux-pci@vger.kernel.org>,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>,
        "open list:PIN CONTROL SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:BROADCOM BMIPS MIPS ARCHITECTURE" <linux-mips@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        "open list:WATCHDOG DEVICE DRIVERS" <linux-watchdog@vger.kernel.org>
References: <20220725055402.6013-1-william.zhang@broadcom.com>
 <20220725055402.6013-7-william.zhang@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cDMN9LvOKh7YHFAv"
Content-Disposition: inline
In-Reply-To: <20220725055402.6013-7-william.zhang@broadcom.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cDMN9LvOKh7YHFAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 24, 2022 at 10:53:59PM -0700, William Zhang wrote:
> With Broadcom Broadband arch ARCH_BCMBCA supported in the kernel, this
> patch series migrate the ARCH_BCM4908 symbol to ARCH_BCMBCA. Hence
> replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.
>=20
> Signed-off-by: William Zhang <william.zhang@broadcom.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net> (for watchdog)
> Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)
>=20

Acked-by: Wolfram Sang <wsa@kernel.org> (for i2c)


--cDMN9LvOKh7YHFAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmLe0X0ACgkQFA3kzBSg
KbYqKBAAh7tkSiVNXcYCzGYcFhSLUkuioAtbrLXR6vkeUJ6qMvd2WkG15238Ti4s
KlFKMBOWT2L+reNiojNZlZ2QMc/U1f/itwXDlViRuwpHBsITqGK+vGE1DH8eiCFP
A5cPFVTh/jXJwGPQmXVzmZ8+opgeBbDg/KJI4PlX0I7KtNhdeArtlCf1EXBZiiOi
QePGA9J4JahuNyjo33zq5Xv1OtyaPFe6hFRtCKR4tsGIHtrJlRtDy/x0Av2hj4fz
m5tju8M/szl7hFyO15x9gg98xif+hTcgOS1H01D29vK74y7iZ61ExKGZ4/4eHz23
3DWL6bANwKiE0CHnJzS9TLPTBrZdv3FHjCATrzJPaVs1VloRBuF86Bo7RFl6Zoi8
fX0j3twBJ8ZqMPEVE4Cw4zHZ2gbAMcQwupF5TTwkPoFrObQJ0Zgx9HrRhTK8HxlO
SiHSdGUJ8LaQq/oZL1OrPJOYVOknOJCWtqfoksGRee+zAjK3muZSEqaJxOjiTawv
xYXDrpbKTEpL+WiEAIvXB4ViWm4YFU7SyDLhizLDRxYQsX2SM1i+phxe/aF98VOb
6CyTctT+bwk/4XZRk3AXLAQq5/haStsr0mf//sUaiJxbdutgWlnnztwHvtZX4hdJ
6h2BPcjqESC3cUfMFPT44QPaa+XZ0YlkTZWyRUP4b+bJNgn2TII=
=c2vg
-----END PGP SIGNATURE-----

--cDMN9LvOKh7YHFAv--
