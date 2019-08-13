Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96188C247
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfHMUpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:45:05 -0400
Received: from mail.nic.cz ([217.31.204.67]:49050 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726007AbfHMUpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 16:45:05 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 74FD8140C54;
        Tue, 13 Aug 2019 22:45:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565729103; bh=xlg+VDxUwopGuCsrQrjcS7+TKSmPoCBEYspk4L9l9bs=;
        h=Date:From:To;
        b=r1AfBDs+sVnWnAcvqA6NctP7v+W/kOxtF2zrd1xa/UVreazG/c9Ar2XlUGUDFoI12
         bZKS8c1Xd4Ef6PFOB4LXhS6l0IiwnvbDpCNDyuwYIiT2ZioSv+yJ+ZSvdWZkHepcVN
         cjw63MmpCKcNCz/lcPYYRegXQ6WAX+T3CF33JYPc=
Date:   Tue, 13 Aug 2019 22:45:02 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: check for mode change in
 port_setup_mac
Message-ID: <20190813224502.5a083d77@nic.cz>
In-Reply-To: <20190813203234.GO15047@lunn.ch>
References: <20190813171243.27898-1-marek.behun@nic.cz>
        <20190813203234.GO15047@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 22:32:34 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Tue, Aug 13, 2019 at 07:12:43PM +0200, Marek Beh=C3=BAn wrote:
> > @@ -598,12 +599,49 @@ int mv88e6352_port_link_state(struct mv88e6xxx_ch=
ip *chip, int port,
> >  			      struct phylink_link_state *state)
> >  {
> >  	int err;
> > -	u16 reg;
> > +	u16 reg, mac;
> > =20
> >  	err =3D mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
> >  	if (err)
> >  		return err;
>=20
> Hi Marek
>=20
> It seems a bit off putting this block of code here, after reading
> MV88E6XXX_PORT_STS but before using the value. You don't need STS to
> determine the interface mode.
>=20
> If you keep the code together, you can then reuse reg, rather than add
> mac.
>=20
> Apart from that, this looks O.K.
>=20
>       Andrew

Hi Andrew,
you are right, I shall rewrite this.
Thank you.
Marek
