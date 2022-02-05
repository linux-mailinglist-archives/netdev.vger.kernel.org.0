Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD374AA637
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379197AbiBED1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:27:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33778 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbiBED1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:27:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EED47B8389B;
        Sat,  5 Feb 2022 03:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B67C340E8;
        Sat,  5 Feb 2022 03:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644031655;
        bh=awW5DWPWiwi2e8pT1xTOVqMTonuYkfRWD87Woqgmgbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kaXLHzQhmHij6d3Cd7dXtecFAjAavuYgOwxDqVtE1D8Tr0yPUyrthqc6Pub1+K3Zh
         aBouYac48jobPQfEwbr8N2WxTXXs32YKmFOBvzyisIMLv1lopHWc6oZdbswWPxkYwn
         BsZlaV/7a6yRhQaPXwO2wUERurPVYqLMoArGHvsxSUG1oGXR3yHWYqM8YQBc1ktmP5
         hWs4cTdguZlffOX1MtjjW4YyxsAeX1QG+7qZpW90sSub1dzedYiCnaoz7cA89Dt/ky
         FAiydWy09C3BRt4etX2WWEEpoXT2iPlKd2K4R0zDSmIpTbkeZT59wTJz3nNUbHF4SP
         bV7AgVRl1W6SA==
Date:   Fri, 4 Feb 2022 19:27:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20220204192734.0c2c5e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204174500.72814-6-prasanna.vengateshan@microchip.com>
References: <20220204174500.72814-1-prasanna.vengateshan@microchip.com>
        <20220204174500.72814-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022 23:14:55 +0530 Prasanna Vengateshan wrote:
> Basic DSA driver support for lan937x and the device will be
> configured through SPI interface.
>=20
> drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
> the new files come under this path. Hence no update needed to the
> MAINTAINERS
>=20
> Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
> added support for port_stp_state_set() & port_fast_age().
>=20
> lan937x_flush_dyn_mac_table() which gets called from
> port_fast_age() of KSZ common layer, hence added support for it.
>=20
> RGMII internal delay values for the mac is retrieved from
> rx-internal-delay-ps & tx-internal-delay-ps as per the feedback from
> v3 patch series.
> https://lore.kernel.org/netdev/20210802121550.gqgbipqdvp5x76ii@skbuf/
>=20
> It supports standard delay 2ns only. If the property is not found, the va=
lue
> will be forced to 0.
>=20
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>


drivers/net/dsa/microchip/lan937x_dev.c:162:6: warning: no previous prototy=
pe for =E2=80=98lan937x_r_mib_pkt=E2=80=99 [-Wmissing-prototypes]
  162 | void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
      |      ^~~~~~~~~~~~~~~~~
