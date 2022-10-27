Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D4B60F98D
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiJ0Npw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiJ0Npq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:45:46 -0400
Received: from tarta.nabijaczleweli.xyz (unknown [139.28.40.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99A7C2D1C6;
        Thu, 27 Oct 2022 06:45:43 -0700 (PDT)
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
        by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id A3BEC4474;
        Thu, 27 Oct 2022 15:45:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
        s=202205; t=1666878341;
        bh=dQDx9GQjjlRYVn7DDiUSbgC4UFIlpnAm/sOjUWUvd6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E8lVSGbKd3NCm3ZCMyZWP/fLOsTs/tyAkWjxMnXehNWBfAZMJqPZJXFHG2MDvwnl+
         sKB2YKY7yPO8p8OsqbBP+Jrabi87k/H+E27R5L7HbNFYxBF4n7MfI1BzPrBx9LcIMn
         QSQGULQS4F5m5xuUhP8fZFfAzPPShf54MuHi865vYy76CyPrutVhwLb78HWWBmKyb1
         S/mwY/ekrTsXi2xZMTSe9thVOKW8tq1QwDRKdE8+zKby7KLlBwgwZhOPU7XeYAq+tv
         o9A9W3h3RB145keotZIwGHzqMS8i10fBS0jRzMKpfzMIrPWtr9jTtxurAE5/nxbuxM
         F8lTl1N54EL836RCnJ/LfjLzlASVPO2eUlxp7ZI9Z1lSThRnaXr3NNY8ldUze5nIP5
         Psq4/fFO3wNYkSc4m3zaMTgbmW16D3Ss4+mKJHp1eyv64Y0aH45tu8okC6RHFsSxUe
         tLGW0loHb3Y0nOFmSr1TgWEQ2VIZ55gU3UJt7jfYe7UHPIvwmakGfOTR1A1QBxoAtn
         J+hJ5SN+DLEoiMOgEAGgd9gENcvlL7yraXRWcNEN3nKoLpXjw8cAM19MSD8EmPOeCT
         qVpuoVlFaKe3s3WwoLu7hYvy5YoaNoCHVu3OEjXVdzekX2d9PUHFB80+GNJZhVL926
         DiHuh0YxFA/5jZwFWg49G6c8=
Date:   Thu, 27 Oct 2022 15:45:40 +0200
From:   =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub =?utf-8?B?S2ljacWEc2tp?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Huang Pei <huangpei@loongson.cn>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 12/15] drivers: net: slip: remove SLIP_MAGIC
Message-ID: <20221027134540.rwzotwafrv6psb4t@tarta.nabijaczleweli.xyz>
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <f5f9036f2a488886fe5a424d8143e8f2f3fdcf3f.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <31c8f481-aeec-daf8-92d7-016824f88760@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t7qokkbezy6yv635"
Content-Disposition: inline
In-Reply-To: <31c8f481-aeec-daf8-92d7-016824f88760@hartkopp.net>
User-Agent: NeoMutt/20220429
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t7qokkbezy6yv635
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 27, 2022 at 03:11:56PM +0200, Oliver Hartkopp wrote:
> I'm not sure why I'm in 'To' here as I'm definitely not the official
> maintainer of slip.
>=20
> But it looks like there is no real maintainer anyway but maybe Jiri ;-)

According to get_maintainer.pl,
(which I just shoved into Cc: indiscriminately,
 lacking any knowledge to the contrary),
you get picked up for slip.{c,h} as commit_signer:2/4=3D50% and 1/2, resp.

As does Jiri, so on that front we're good at least.

Best,

--t7qokkbezy6yv635
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmNai4QACgkQvP0LAY0m
WPHd9Q/+K2dZIj1YG+R33sxAl+Mt8dIpRZzF1vcgYh9GK++i6rKtgQp2hdi669wz
1SK+ElvyCoiBVciPDZ9C8VrMRqWbyuFSJmdLPE0Pn5UXeaRDY/MKK0NjqO2uIMEt
m/Gussa+VhpbX/vKYAHpcPKt9lcqjDXi+Rgyom5NijjKL/0Bak6vaJmy3TFCTBOE
qIWorspbyKHnUqHGHNOnwTTKVQw6rfP7LtDw9yw43oEhkBy9iLShYncZeZs+LG5N
82+1WaHvXAA9ZPxaYL7HlaZ0HfB7yLswbn4i2zLVAXMibGaQsvZDywkZsjVFSHG6
RGJpJ9ynFDe9WHR4Leig7mOa46K0zJOmLQ73/GsC/4Xm/balihDJbghDRcxsfT1T
Jznna74M5EekaOYNyQHOeD6NNFPOAb4NP3AxCzzWkMeTDRNJB7J08BNCoX97AHzo
gIxQEB4pChAwPm/IdLuNZ4PRjrCVyXk3hPAMdhHlECaMdyfkpURsJx1I9ChuFCom
kuyiNla/YH0tEkNHiUWyfdQNU1EQjsADYlImpYwm6xm+Pf54IUus4CDWVT7/A9PH
o4N5UAV/50/S1ZvZfZJuBED24BlS5dHaaBFXVJcOteAqWFFEH/zoZaVxNsfOmcFn
1egDuVCG/TDj9v2xOfebu4sFNlu2wQOYidJdcFOBEDPku8jYWPM=
=oi5M
-----END PGP SIGNATURE-----

--t7qokkbezy6yv635--
