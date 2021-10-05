Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675D0422DE7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhJEQ1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhJEQ1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7C8561372;
        Tue,  5 Oct 2021 16:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633451162;
        bh=76HflE+65WoKlwr0Ikh2P5HBiytxbXZcsuFK1z4oWho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9beRN4aEDcFDJPwm3aM+RkgjsjIdhHtZZ4otX6FdoYTDkmcQzb07sC2svC5dqjCN
         nGNH0hwgjfke0lga0z7bvNuwI1x5Wicqr9Ih5GeSEHkLy7RL5V/QmN00rQZHJt6v0l
         EKhBOkDrBV7+yxylXn8EgNcFq8wDP4B4U9+nabwZ0Im585XXo/+s+ivkhMp+6074Ic
         QUZJ/xL4v3Jot1keRdpMVPAvaN0Vcz/0h7s/wQaNprvVPOfkwlR/6+VWW8ehXJjd3y
         e5BGoSPQStn7ULOXtIs478W5ooeASQf8WdMmn4f84rdmplVwLIyw0rdw269z7RsUyz
         H4FqbUla+WypQ==
Date:   Tue, 5 Oct 2021 09:26:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phylink: use mdiobus_modify_changed()
 helper
Message-ID: <20211005092601.7029f2d0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <E1mXmSA-0015rK-Pj@rmk-PC.armlinux.org.uk>
References: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
        <E1mXmSA-0015rK-Pj@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 05 Oct 2021 16:34:02 +0100 Russell King (Oracle) wrote:
> Use the mdiobus_modify_changed() helper in the C22 PCS advertisement
> helper.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 28 ++++------------------------
>  1 file changed, 4 insertions(+), 24 deletions(-)
>=20
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index b32774fd65f8..d76362028752 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c

drivers/net/phy/phylink.c: In function =E2=80=98phylink_mii_c22_pcs_set_adv=
ertisement=E2=80=99:
drivers/net/phy/phylink.c:2599:11: warning: unused variable =E2=80=98ret=E2=
=80=99 [-Wunused-variable]
 2599 |  int val, ret;
      |           ^~~
drivers/net/phy/phylink.c:2599:6: warning: unused variable =E2=80=98val=E2=
=80=99 [-Wunused-variable]
 2599 |  int val, ret;
      |      ^~~
