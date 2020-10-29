Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359CA29F6E9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 22:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgJ2Vcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 17:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgJ2Vcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 17:32:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68B2E20731;
        Thu, 29 Oct 2020 21:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604007162;
        bh=WS+kIkb76uaa1V08Qat7IYkwuOhVT70qo2uRh7YHCwY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n6Lc2Junwf0Fd9rub11eHYF3TbEa/8vzgjC1v/XgFuylU1YsfLet6/Yede0Nbbi6n
         WX0SIK3xTW65hmWd4RXczSzHmiKRNzvZZGk0IvSYXlClyWhpn3UHbdqu44Ksy9QV+8
         X9e1oF6xIb1BhGhd6EMPAH0mDzkb/tuf7wjtZkuU=
Date:   Thu, 29 Oct 2020 14:32:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willy Liu <willy.liu@realtek.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: realtek: Add phy ids for
 RTL8226-CG/RTL8226B-CG
Message-ID: <20201029143240.5b21e1ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
References: <1603973277-1634-1-git-send-email-willy.liu@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 20:07:57 +0800 Willy Liu wrote:
> Realtek single-port 2.5Gbps Ethernet PHY ids as below:
> RTL8226-CG: 0x001cc800(ES)/0x001cc838(MP)
> RTL8226B-CG/RTL8221B-CG: 0x001cc840(ES)/0x001cc848(MP)
> ES: engineer sample
> MP: mass production
>=20
> Since above PHYs are already in mass production stage,
> mass production id should be added.
>=20
> Signed-off-by: Willy Liu <willy.liu@realtek.com>

drivers/net/phy/realtek.c: In function =E2=80=98rtl8226_match_phy_device=E2=
=80=99:
drivers/net/phy/realtek.c:540:47: warning: suggest parentheses around =E2=
=80=98&&=E2=80=99 within =E2=80=98||=E2=80=99 [-Wparentheses]
  540 |         (phydev->phy_id =3D=3D RTL_8226_MP_PHYID) &&
      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
  541 |         rtlgen_supports_2_5gbps(phydev);
      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     =20
