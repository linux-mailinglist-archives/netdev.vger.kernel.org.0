Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE54436126
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhJUMPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:15:45 -0400
Received: from sonic304-21.consmr.mail.ne1.yahoo.com ([66.163.191.147]:45631
        "EHLO sonic304-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231346AbhJUMPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1634818408; bh=FiYc4Cu3WdHu1E7ELTL7dv9bG4/CO0s7hijLbVdELKI=; h=Subject:From:In-Reply-To:Date:Cc:References:To:From:Subject:Reply-To; b=Wes3vQMgKbujmJcEGxTPUZSHbbCEIPxptz6/j4XatJDWKJw/pa7Fxnru05YbDqWnESGWFZUwpJGhoPgL/NK4y5v8l/n3NDzw0AmbNCIaw7hOoV6YXxojYe99VeUUTjxf/W0OJ1MY30w3sgdg1od2IimOXZojgNHoDZQQwOAYSRDHiRWQZ0B/zsCgl5OGzI9Ut9KMiFXMSJ0GMdOo9s6BTm+KwzdwSx1H9gIXIO9XhZPaLMkjiNi6tBxn/cNHbxwAGKy8kjfjaazvT0qAxkx0kLLi/5HxGlTxdVb3J1YKnSfCR+jB7ZY//DlwqGpYZrEYiSO17gs0Dx9mcmVIjFkxZw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1634818408; bh=V6IwxZg1nRI1d51SY2v8zaA/SWdrl2W5hXtWq91swNj=; h=X-Sonic-MF:Subject:From:Date:To:From:Subject; b=NEYYyLioC0aXTwbwwySwqYKQdhF7REib9JsbhdFCMUUXUpScyxLFVAaKc+dIsX/rGbGXR3mlNFe/srtpBpPl6ZmlA8on7y563vvMgFzj9XF2nu5CbUmhXfHx59ZINqtCiO0SOrU3Bll7n2uTu5Jp8daKVYDsT3fx4fm2yy+y6CiYfL5P9KEhukVPINjNd9hYxzZbLj0Ha0mLI5sZummwhxjQwCOdUhPS87hdkxhfgJFwLKoKrbzZwMMKJFBUlOAEh3ab3eEWPBbIUnG9DpKVJsq5wvtWd/b4EqSctiVzqqKfw1LPwv54Y/39h3pDQCA4nc7XLdZ11QRnXi7+wpes/g==
X-YMail-OSG: CUd.UqMVM1kBAX61LhbgEPcENReXGV.efLmMASLfKn2BBq3KrQdUlABCmPTsiZv
 lzPNJCShS131AK7NFG4IIbCWpQ2GAWEfj.pG9dCOPLQjfTLgzQbddMU_hteeEiHkS328YvBbFNFi
 9T4s0QTJ4yO19qtkSD809Od3jpGCO3MNRWburjFckKGThWHqVFHBgcB82.sowGPJDlt6k4HKniNT
 QQj7xlhwng08nN2UJoHIdDjYyw9p9Vfa_vgx_FDMC9E9nbCAr12GIG9D6.6eJA5QPEJqf3YTNBgt
 3L6ku.guvGo5OEWH7U0X48f2ajaOEgAN7eCsdgoX5MhcabX16ylYfk3seE7nqo7OMcyYAFBP0rLG
 oOBxasXgCugdb264zeFqIwRQpM9fVVR8NB0uwn04O.ZaiSt54D.EHQsrDtqbN_K4pyR_PLrIFofd
 SmIJTbbCGVmCCLDSAU50CCKHY3nL1IEviup5NRbN0wNMzejdA4ZRyfajq3mhO4PeTvtPc6GNq2nn
 vAP3n.NzHfWqWjPzQQY7tCV3I9PpUNOBUoufFvkwSK3V0m7YbWPZihgPLVKffU4aoIfXITZEkQfb
 MeZczDrrOR.TK2bu85Wx_dkVWVfIHN9Z48YSIUj3WK2AuDIvHhleNqfERav5jAKllh6n3tYdjclM
 ZVy__PW2x7SDrOOMoaZeNCtj0nevEg67oU3X4AkHs_HB9CHijWsQoBU05hC.viDyRoYYWzL6ZU0y
 wcSLLh6iX8stWTGZJttvyJ5vTLGBAlinP.gCm5WfxzsE0vk.lq5m3pGkHUi41ZqkopiyEwBxIoxN
 kBYoAnVw7yWiZ17_Hy0JiMb4fnelcJegQBUY.ceCrg3ewEphUUL909cfv1tbGDFT7hjNUc7fNve1
 hOEnTKWYIz7Hn9RDyDH0CLIgSnbai9mmltRgd2ltgqjx_WVoaI3YpLT13YS3VK8R0RIa39h.wfm5
 WxY4VCccTU2puvH9JeM9f7vTEIacX2EzPT3csKEYebnGVgQ_z.2NnRRl5avLCSdM5GfYhvl8MBSH
 1rI6_MlVSfXSH3WFJJ2tHzPI1wHmn3XelakSbSoAW9gaB_nzNNg6.D5rjFxvpGxkhqpkoGDXirdo
 2FuY3VXokNmfezD4JUQiZkiVQujakVgiXMuCbVJNYUNK2SA8z2P.usy5.iJEZlShS9fF.PEZNsRB
 fvh6ygT4IH605nwJz2JTC83eXxoLGqElVF_Mh1Y7vw04K10EQuOp2glWqu3GEEfXi8xHGECojext
 5Ld2UlBkJPC4D6Cn2o0EQEtA8lN4fML2FXJeYsuS37nNBtJ3.SLAEEfFNFn_C5q2R0S66pdOLy6w
 dbbCpKLk4p8XkDGFrd0pMbJkYIh69lSVbKCLeZs8y.kygPY5wnkpfQH2swB26OgakmMBW4ixKOf0
 YLjN.uoSHiBMLRZk2GUk7rRMqZpVNu2yGI98mG3VFjo3ISVhqrlOQs8Wa.hKjEFj4saaygTjNyG1
 kID1J_EwZjTONJ5rYyspid.d8nd7hnTlPg_xNXNLVDWLhMaLztzHMzkCzaUgGKhQpPPPDxH9agaF
 QzjtCSntd2_oqFTk2y_mz3ghptbfOCG1uQ5emcOqmocnM3b15eTq7XDXNOuRxXe_PYSGR0FAXVt8
 mQs0ETecduSlR72i5eMP2qOswau1xI3EuMcslonh5J6k84gxkM2NJisJBvy.y3alIyWVYYQ9UeoZ
 S.qd5IoUuHbyQkLCEvwmTO04phLIlSs9gB9I0Yn1T8G9R9KHP_DBtyAphGTrrAJKfoYO7.qG1vr7
 kbKmjeExcPPLRxVu18y7qqk4z06UKVUdsCsgQpPPg1Q7sWU3Vj.TGAtZW.jXjager3DP.GvpkWZO
 _SUNZaDiWRFNLAtLRrYdqIw4OBQrw0gA75C6N32PXCvmamPZIqTQLmtZxXEZc4JLdmTS5Gk0eS1H
 TcR.lTrw7yXXtwDZA3ACrlpMWHLVZ_Nc0ZZwJyqNqVJy8UWUt9KVi5p3NhuF4BD2SGpj.RvfvWGf
 ITlEykCAovs._jhkngeqefHSiI2luzU9laoGoXuJ_INxa_hvK5PDcPyW2xm4KTNV1vk7cu0r.Qiy
 DhXa32RGuwSyOtsl1Yj4CHKPnN8b0bbf9IjzEtENKFYHGAcOrO51Z5oyTwFe3FJMeAVKvFXHlkeg
 aEfrc.ByjOhPRgFJt5KMFCSEY4LXNDS0.HNKEGLVKSFHT
X-Sonic-MF: <vschagen@cs.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Thu, 21 Oct 2021 12:13:28 +0000
Received: by kubenode549.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID ac3fe0de01b5e30d28d8d00a375edb08;
          Thu, 21 Oct 2021 12:13:24 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: DSA slaves not inheriting hw_enc_features and xfrmdev_ops?
From:   R W van Schagen <vschagen@cs.com>
In-Reply-To: <YXAGNmH+GsI5e9ly@lunn.ch>
Date:   Thu, 21 Oct 2021 20:13:13 +0800
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A08F0571-5705-4FD6-9C5D-55B4C0734712@cs.com>
References: <CDEC9628-69B6-4A83-81CF-34407070214F.ref@cs.com>
 <CDEC9628-69B6-4A83-81CF-34407070214F@cs.com> <YXAGNmH+GsI5e9ly@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3608.120.23.2.7)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 20 Oct 2021, at 20:06, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> On Wed, Oct 20, 2021 at 09:28:40AM +0800, R W van Schagen wrote:
>> Hi all,
>>=20
>> When I register a master device (eth0) with ESP hardware offload:
>>=20
>> 	netdev->xfrmdev_ops =3D &mtk_xfrmdev_ops;
>> 	netdev->features |=3D NETIF_F_HW_ESP;
>> 	netdev->hw_enc_features |=3D NETIF_F_HW_ESP;
>>=20
>> Only the =E2=80=9Cfeatures=E2=80=9D are inherited by the DSA slaves. =
When those
>> get registered without the xfrmdev_ops the HW_ESP feature is
>> dropped again.
>>=20
>> Is this a =E2=80=9Cbug=E2=80=9D and should I make a patch to fix this =
or is this actually
>> a design feature?
>=20
> Design feature.
>=20
> The problem is, for most MAC devices, the additional DSA
> header/trailer messes up all acceleration. The HW does not understand
> the header/trailer, don't know they have to skip it, have trouble
> finding the IP header, etc. So in general, we turn off all
> acceleration features.
>=20
> If you pair a Marvell MAC with a Marvell Switch, there is a good
> chance it understands the Marvell DSA header and some forms of
> acceleration work. Same goes for a Broadcom MAC with a Broadcom
> switch. But pair a Freescale MAC with a Marvell Switch and even basic
> IP checksumming does not work, the FEC HW cannot find the IP header.
>=20
>> As a work-around I am using a notifier call and add those features =
but
>> I don=E2=80=99t think this is the proper way to do this in a =
production driver.
>=20
> It is not a simple problem to solve in a generic way. You end up with
> an M by S matrices for HW features which work, where M is the MAC and
> S is the switch.
>=20
> So for you board, with your specific pairing of MAC and Switch, which
> i assume is a mediatek MAC connected to a mediatek switch, using a
> notifier call is not too unreasonable.
>=20
> We could also consider DT properties, indicating which features work
> for this board. That should be a reasonably generic solution, which
> you can implement in the DSA core.
>=20
> 	    Andrew

Thanks for the explanation. For now I will proceed using notifier =
callbacks.

One more strange thing I am noticing: Even if I set NETIF_F_GSO_ESP
I am still not getting any GSO packets (skb_is_gso is always false) so =
my
transmit speeds are like 2/3 of the receive speeds. Hardware Decryption =
vs
Encryption is not 100% the same, but it is close.

I am getting the esp_gro_receive callbacks, but not the esp_gso_segment,
BUT: for some reason my packets still get TCP GSO.

Richard=
