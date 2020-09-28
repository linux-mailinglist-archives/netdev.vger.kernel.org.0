Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7593327B2CC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgI1RKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:10:40 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:37585 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbgI1RKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 13:10:39 -0400
Received: from methusalix.internal.home.lespocky.de ([109.250.103.238]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MLA6m-1k4roh3B0k-00IDTN; Mon, 28 Sep 2020 19:10:17 +0200
Received: from falbala.internal.home.lespocky.de ([192.168.243.94])
        by methusalix.internal.home.lespocky.de with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <post@lespocky.de>)
        id 1kMwfC-000203-AN; Mon, 28 Sep 2020 19:10:12 +0200
Date:   Mon, 28 Sep 2020 19:10:05 +0200
From:   Alexander Dahl <post@lespocky.de>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Alexander Dahl <ada@thorsis.com>, linux-leds@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Dahl <post@lespocky.de>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Message-ID: <20200928171003.zuruw4zpxxb4qsno@falbala.internal.home.lespocky.de>
Mail-Followup-To: Marek Behun <marek.behun@nic.cz>,
        Alexander Dahl <ada@thorsis.com>, linux-leds@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>
References: <20200927004025.33c6cfce@nic.cz>
 <20200927025258.38585d5e@nic.cz>
 <2817077.TXCUc2rGbz@ada>
 <20200928175209.06193d95@nic.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n5cbyak4nggrijyp"
Content-Disposition: inline
In-Reply-To: <20200928175209.06193d95@nic.cz>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Scan-Signature: 6a840d8600e1795c6c928f53886675fd
X-Spam-Score: -2.9 (--)
X-Provags-ID: V03:K1:w2Gp4OpBHW/RYlZ2xx2HCk1LgSu39tt4/0sPjNz4wiY3nyfvQt9
 t2Q/dheLWycA/b5/+Pn9HDjDUO5T9C5b5Wg/HsfgfpbR6dw7XRTLBdfjRZKiL1gIRLPBjZ8
 ff2jOnZd42avepQwT0EsKzlKk0srypdcp2+b6dvvn2WyNJvP7I6IQhmlikvOKmIlvPN9Ln/
 5AhcVXLDSmyV96wSdag5A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tPeUOZWhCrQ=:fe0ni99SN1JyXS6jXKKe50
 ZTT6qW4avIptjmJXgHtDRewVNvH199Q5jvUwKioIgyeyykMB+lOp1Yem9kzAtA/ow2dEgmF1y
 LfMU+DekhkqIHxUH/nO2ckVctMpv12/AdfHVje+jfOZJJqbEdOPGXj0tu+gZgqEtCHULz8UPu
 YfQ6YQIITQ1dV5Eawg5YlM69b2IkUruXxp7PyqhTj0vJAsMB0+rW26XhYCGth58qjnukkKlfp
 UJRIZuxPMfNljKxM0aopkHdmKT05t8RiO5jNQjziA6fA+2nARX546EBfimxxXlQHU9DeU94ZU
 IaMITRjSPaEB5MQne+SqjeR7TsMqG3LHS/JXckB96kxW4dqI3ZrKp8HAIcZIFLNu+jY7NOXvy
 XqNASQbLA7eJ0hKXNahH2Wfw5z4HLN2OAcjfKpPP1SNMzVjzQFrwEbTaWPkHZ7v5YU4qebbQd
 +155uth8yCcQjzrKZvDstWzbwaYzV5cj9BVNnCpozm6FS5Y1oAnSAIb4JutyBgg5dJwF0X1Y0
 mJDgy5AqwJqoZ3yHcqrFOiPW6x4F0pD41x0oRqFz+QM24+Dy/SKUQ8XpjIzpKt/+2m6/yWZOh
 Is2eH7XJ770xkzl/KAMv8mt+dT0K50C8XInySg4ab6IasaszDhMfhu/EXYVP7fX5gEKxuI5pR
 cI7DWCsEyPz3RkqH6e8+eBdvYBPgZ8gskACG6PleoMR9jOnQH75M//D3OX9MbspsBi+nQQ2v2
 zTFzq8ojZx4rIyeRBsSd6fLdk2E1JhrHsMwtL1sFiWrNeyVfB2XkDz+gavDLben7tJCTqgJuW
 7HVgcLTgZ/P9h1/EbhuyNrw2nEyvn+7r1Ex+U/XkPey3L4YsxskwwT7hOnQi9Hfn1YrTVMq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--n5cbyak4nggrijyp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hei hei,

On Mon, Sep 28, 2020 at 05:52:09PM +0200, Marek Behun wrote:
> On Mon, 28 Sep 2020 15:04:10 +0200
> Alexander Dahl <ada@thorsis.com> wrote:
>=20
> > Hei Marek,
> >=20
> > Am Sonntag, 27. September 2020, 02:52:58 CEST schrieb Marek Behun:
> > > On Sun, 27 Sep 2020 00:40:25 +0200
> > >=20
> > > Marek Behun <marek.behun@nic.cz> wrote: =20
> > > > What I am wondering is how should we select a name for the device p=
art
> > > > of the LED for network devices, when network namespaces are enabled.
> > > >=20
> > > > a) We could just use the interface name (eth0:yellow:activity). The
> > > >=20
> > > >    problem is what should happen when the interface is renamed, or
> > > >    moved to another network namespace.
> > > >    Pavel doesn't want to complicate the LED subsystem with LED devi=
ce
> > > >    renaming, nor, I think, with namespace mechanism. I, for my part=
, am
> > > >    not opposed to LED renaming, but do not know what should happen =
when
> > > >    the interface is moved to another namespace.
> > > >=20
> > > > b) We could use the device name, as in struct device *. But these n=
ames
> > > >=20
> > > >    are often too long and may contain characters that we do not wan=
t in
> > > >    LED name (':', or '/', for example).
> > > >=20
> > > > c) We could create a new naming mechanism, something like
> > > >=20
> > > >    device_pretty_name(dev), which some classes may implement someho=
w.
> > > >=20
> > > > What are your ideas about this problem?
> > > >=20
> > > > Marek =20
> > >=20
> > > BTW option b) and c) can be usable if we create a new utility, ledtoo=
l,
> > > to report infromation about LEDs and configure LEDs.
> > >=20
> > > In that case it does not matter if the LED is named
> > >   ethernet-adapter0:red:activity
> > > or
> > >   ethernet-phy0:red:activity
> > > because this new ledtool utility could just look deeper into sysfs to
> > > find out that the LED corresponds to eth0, whatever it name is. =20
> >=20
> > I like the idea to have such a tool.  What do you have in mind?  Sounds=
 for me=20
> > like it would be somehow similar to libgpiod with gpio* for GPIO device=
s or=20
> > like libevdev for input devices or like mtd-utils =E2=80=A6
> >=20
> As Pavel said, we have ethtool, maybe we could have ledtool.

Yes.  IIRC ethtool uses libmnl for communicating with the kernel
through the netlink interface.

> > Especially a userspace library could be helpful to avoid reinventing th=
e wheel=20
> > on userspace developer side?
>=20
> If such a need arises, than yes. For most embedded systems though I
> think ledtool would be enough, since mostly LEDs can be controlled from
> shell scripts.

I saw proprietary embedded C++ applications building on top of
proprietary C libraries interacting with the sysfs leds interface =E2=80=A6
O:-)

> > Does anyone else know prior work for linux leds sysfs interface from=20
> > userspace?
>=20
> I am not aware of that, everyone just uses sysfs now.

Sorry, that was maybe misleading.  What I wanted to know was if there
already is some free library/tool using that sysfs interface?  I
suppose not, otherwise "ledtool" would not be needed?  IIRC there are
generic libs for abstracting sysfs access, but I did not like them.
;-)

Long story short, I would be interested in helping on a ledtool /
libledtool in C in my spare time.  (No time to learn Rust at the
moment though.)

Greets
Alex

--=20
/"\ ASCII RIBBON | =C2=BBWith the first link, the chain is forged. The first
\ / CAMPAIGN     | speech censured, the first thought forbidden, the
 X  AGAINST      | first freedom denied, chains us all irrevocably.=C2=AB
/ \ HTML MAIL    | (Jean-Luc Picard, quoting Judge Aaron Satie)

--n5cbyak4nggrijyp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEwo7muQJjlc+Prwj6NK3NAHIhXMYFAl9yGOcACgkQNK3NAHIh
XMZtghAAxPF6PtBZosVRI0tXrhYDirLw9yXiWWLew0VdKA+rZwCO0iDMmjVB4jfU
P9b8QGk6Brci2FxDRgKyFtcCl33n0S+H71Kw++Wxh2Ru2LY7IyJzOZuXZHexRMS9
0FV7XKeIA4fcqMROMZJzrY818qoDHYj2C/vVrJ+JpprpAUGShw9BX9lbjTbMBmna
JsSmQmf66cEKLdj3+GNMF3xoZ38krEX83uR1Q6vsw2vVql91/cR41I+tSU/R4eDU
2IVF40fmRpWPwLic1TEAzcDMHziUFCfeu3fSokbVSXaxxEWrs0h5Ja+2nCUtlpgM
U5JupBGw4Hqc2fjCQGrDGXjcQ5XGXIZo7jiXc6Ssd8b2xkkX7MgiNo5NM6e5SCF2
rZ12es0N43hpQltJ6LpFch5V3I5iCIc/tIk5Nn16AG6X+gW0NiiHujpjmv2ejpiQ
o7q4xxyM0CBzSlZNgph+FsgwOoA6VdWbn6x/xtDrm3x+sEkKkWWza44G4GXZQ4wc
YQBgFpwdstlUenklYXO0Xu4UZSKMu48bpdMwbckFxgpIy3x/j99RNkEf+umu69+8
NNtW1QfAf/AbZi0iIYeqdJNbGNqfdIYz2iORPEGuFdgVKhIRFbcBfAGf5XJprVHV
pc/B72ACP4bXrErWJj0tXY1tv/xlt3Md88v0whuchBLwjZSWc/8=
=U/7n
-----END PGP SIGNATURE-----

--n5cbyak4nggrijyp--
