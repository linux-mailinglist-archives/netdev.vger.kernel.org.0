Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B2C4E8351
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbiCZS3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiCZS3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7309224B5C8;
        Sat, 26 Mar 2022 11:27:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 131D260AFA;
        Sat, 26 Mar 2022 18:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0903C340ED;
        Sat, 26 Mar 2022 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648319255;
        bh=6A9geVN7hz7JjWyGpdDgRTCPZVGMU3xykfJX5UwPGRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=faKaYvsqHjsnHgOEciNLdiDiMhorx0X+bUTo59SGODwMlJddNYfplHnsXf0sU549w
         4ANwwCKF51V/9DaY3tom5RG3qfXD0QmS81y/3TXn3mm08ex8+fEjeMjuoXBDMJqLl+
         0AI3DuVVzhmkWCg6OlTolBQjOdL0oAMNlz0VfcIYweNEzhbTuRziQpSHSqJj+bIgYL
         R1s6AHzJAsNzqkQNMB+azLZqK4aVjRoZovlNyCbRaVd+mrLcguckEHmPkxU6NbLTv/
         9ozRB76LLhEhA9uotDvzkuJtxWtMjiBvC8EJVK380hmOMVs4aHnXPQ75rK4aP5xD5n
         j+IsdIUf+nLBw==
Date:   Sat, 26 Mar 2022 19:27:20 +0100
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Benjamin =?UTF-8?B?U3TDvHJ6?= <benni@stuerz.xyz>
Cc:     andrew@lunn.ch, sebastian.hesselbarth@gmail.com,
        gregory.clement@bootlin.com, linux@armlinux.org.uk,
        linux@simtec.co.uk, krzk@kernel.org, alim.akhtar@samsung.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, robert.moore@intel.com,
        rafael.j.wysocki@intel.com, lenb@kernel.org, 3chas3@gmail.com,
        laforge@gnumonks.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        tony.luck@intel.com, james.morse@arm.com, rric@kernel.org,
        linus.walleij@linaro.org, brgl@bgdev.pl,
        mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca,
        pali@kernel.org, dmitry.torokhov@gmail.com, isdn@linux-pingi.de,
        benh@kernel.crashing.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        nico@fluxnic.net, loic.poulain@linaro.org, kvalo@kernel.org,
        pkshih@realtek.com, bhelgaas@google.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 16/22] dvb-usb: Replace comments with C99 initializers
Message-ID: <20220326192720.0fddd6dd@coco.lan>
In-Reply-To: <20220326192454.14115baa@coco.lan>
References: <20220326165909.506926-1-benni@stuerz.xyz>
        <20220326165909.506926-16-benni@stuerz.xyz>
        <20220326192454.14115baa@coco.lan>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 26 Mar 2022 19:24:54 +0100
Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:

> Em Sat, 26 Mar 2022 17:59:03 +0100
> Benjamin St=C3=BCrz <benni@stuerz.xyz> escreveu:
>=20
> > This replaces comments with C99's designated
> > initializers because the kernel supports them now.
> >=20
> > Signed-off-by: Benjamin St=C3=BCrz <benni@stuerz.xyz>
> > ---
> >  drivers/media/usb/dvb-usb/dibusb-mb.c | 62 +++++++++++++--------------
> >  drivers/media/usb/dvb-usb/dibusb-mc.c | 34 +++++++--------
> >  2 files changed, 48 insertions(+), 48 deletions(-)
> >=20
> > diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/=
dvb-usb/dibusb-mb.c
> > index e9dc27f73970..f188e07f518b 100644
> > --- a/drivers/media/usb/dvb-usb/dibusb-mb.c
> > +++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
> > @@ -122,40 +122,40 @@ static int dibusb_probe(struct usb_interface *int=
f,
> > =20
> >  /* do not change the order of the ID table */
> >  static struct usb_device_id dibusb_dib3000mb_table [] =3D {
> > -/* 00 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_CO=
LD) },
> > -/* 01 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WA=
RM) },
> > -/* 02 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_COLD) },
> > -/* 03 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_WARM) },
> > -/* 04 */	{ USB_DEVICE(USB_VID_COMPRO_UNK,	USB_PID_COMPRO_DVBU2000_UNK_=
COLD) },
> > -/* 05 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_COLD) },
> > -/* 06 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_WARM) },
> > -/* 07 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_COLD) },
> > -/* 08 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_WARM) },
> > -/* 09 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_COL=
D) },
> > -/* 10 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_WAR=
M) },
> > -/* 11 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_COLD) =
},
> > -/* 12 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_WARM) =
},
> > -/* 13 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_C=
OLD) },
> > -/* 14 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_W=
ARM) },
> > -/* 15 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_COLD)=
 },
> > -/* 16 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_WARM)=
 },
> > -/* 17 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_COLD) },
> > -/* 18 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_WARM) },
> > -/* 19 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_=
COLD) },
> > -/* 20 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_=
WARM) },
> > -/* 21 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_=
AN2235_COLD) },
> > -/* 22 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_=
AN2235_WARM) },
> > -/* 23 */	{ USB_DEVICE(USB_VID_ADSTECH,		USB_PID_ADSTECH_USB2_COLD) },
> > +[0]  =3D	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_CO=
LD) },
> > +[1]  =3D	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WA=
RM) }, =20
>=20
> While here, please properly indent this table, and respect the 80-columns=
 limit,
> e. g.:
>=20
> static struct usb_device_id dibusb_dib3000mb_table [] =3D {
> 	[0] =3D { USB_DEVICE(USB_VID_WIDEVIEW=20
> 			   USB_PID_AVERMEDIA_DVBT_USB_COLD)=20
> 	},
> 	[1]  =3D	{ USB_DEVICE(USB_VID_WIDEVIEW,
> 			     USB_PID_AVERMEDIA_DVBT_USB_WARM)
> 	},
> 	...

Err.... something went wrong with my space bar and I ended hitting send to
soon... I meant:

static struct usb_device_id dibusb_dib3000mb_table [] =3D {
 	[0] =3D { USB_DEVICE(USB_VID_WIDEVIEW=20
 			   USB_PID_AVERMEDIA_DVBT_USB_COLD)=20
 	},
 	[1] =3D { USB_DEVICE(USB_VID_WIDEVIEW,
 			   USB_PID_AVERMEDIA_DVBT_USB_WARM)
 	},
	...
};

Thanks,
Mauro
