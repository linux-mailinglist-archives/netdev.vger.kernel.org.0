Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE54E83EC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 20:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiCZTxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 15:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiCZTxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 15:53:52 -0400
X-Greylist: delayed 443 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Mar 2022 12:52:16 PDT
Received: from relay.hostedemail.com (relay.hostedemail.com [64.99.140.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3162D1F8;
        Sat, 26 Mar 2022 12:52:16 -0700 (PDT)
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay11.hostedemail.com (Postfix) with ESMTP id D198880C9A;
        Sat, 26 Mar 2022 19:52:14 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf03.hostedemail.com (Postfix) with ESMTPA id AC5446000E;
        Sat, 26 Mar 2022 19:51:45 +0000 (UTC)
Message-ID: <63a5e3143e904d1391490f27cc106be894b52ca2.camel@perches.com>
Subject: Re: [PATCH 16/22] dvb-usb: Replace comments with C99 initializers
From:   Joe Perches <joe@perches.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Benjamin =?ISO-8859-1?Q?St=FCrz?= <benni@stuerz.xyz>
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
Date:   Sat, 26 Mar 2022 12:51:44 -0700
In-Reply-To: <20220326192720.0fddd6dd@coco.lan>
References: <20220326165909.506926-1-benni@stuerz.xyz>
         <20220326165909.506926-16-benni@stuerz.xyz>
         <20220326192454.14115baa@coco.lan> <20220326192720.0fddd6dd@coco.lan>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: AC5446000E
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: r3baboadgyrzf5ohpo734it1c55f35b4
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+HneiPuDhf7afikiha+wr4gJKHMUaJQO0=
X-HE-Tag: 1648324305-593106
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-03-26 at 19:27 +0100, Mauro Carvalho Chehab wrote:
> Em Sat, 26 Mar 2022 19:24:54 +0100
> Mauro Carvalho Chehab <mchehab@kernel.org> escreveu:
> 
> > Em Sat, 26 Mar 2022 17:59:03 +0100
> > Benjamin Stürz <benni@stuerz.xyz> escreveu:
> > 
> > > This replaces comments with C99's designated
> > > initializers because the kernel supports them now.
> > > 
> > > Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
> > > ---
> > >  drivers/media/usb/dvb-usb/dibusb-mb.c | 62 +++++++++++++--------------
> > >  drivers/media/usb/dvb-usb/dibusb-mc.c | 34 +++++++--------
> > >  2 files changed, 48 insertions(+), 48 deletions(-)
> > > 
> > > diff --git a/drivers/media/usb/dvb-usb/dibusb-mb.c b/drivers/media/usb/dvb-usb/dibusb-mb.c
> > > index e9dc27f73970..f188e07f518b 100644
> > > --- a/drivers/media/usb/dvb-usb/dibusb-mb.c
> > > +++ b/drivers/media/usb/dvb-usb/dibusb-mb.c
> > > @@ -122,40 +122,40 @@ static int dibusb_probe(struct usb_interface *intf,
> > >  
> > >  /* do not change the order of the ID table */
> > >  static struct usb_device_id dibusb_dib3000mb_table [] = {
> > > -/* 00 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
> > > -/* 01 */	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },
> > > -/* 02 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_COLD) },
> > > -/* 03 */	{ USB_DEVICE(USB_VID_COMPRO,		USB_PID_COMPRO_DVBU2000_WARM) },
> > > -/* 04 */	{ USB_DEVICE(USB_VID_COMPRO_UNK,	USB_PID_COMPRO_DVBU2000_UNK_COLD) },
> > > -/* 05 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_COLD) },
> > > -/* 06 */	{ USB_DEVICE(USB_VID_DIBCOM,		USB_PID_DIBCOM_MOD3000_WARM) },
> > > -/* 07 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_COLD) },
> > > -/* 08 */	{ USB_DEVICE(USB_VID_EMPIA,		USB_PID_KWORLD_VSTREAM_WARM) },
> > > -/* 09 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_COLD) },
> > > -/* 10 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_GRANDTEC_DVBT_USB_WARM) },
> > > -/* 11 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_COLD) },
> > > -/* 12 */	{ USB_DEVICE(USB_VID_GRANDTEC,		USB_PID_DIBCOM_MOD3000_WARM) },
> > > -/* 13 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_COLD) },
> > > -/* 14 */	{ USB_DEVICE(USB_VID_HYPER_PALTEK,	USB_PID_UNK_HYPER_PALTEK_WARM) },
> > > -/* 15 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_COLD) },
> > > -/* 16 */	{ USB_DEVICE(USB_VID_VISIONPLUS,	USB_PID_TWINHAN_VP7041_WARM) },
> > > -/* 17 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_COLD) },
> > > -/* 18 */	{ USB_DEVICE(USB_VID_TWINHAN,		USB_PID_TWINHAN_VP7041_WARM) },
> > > -/* 19 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_COLD) },
> > > -/* 20 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_WARM) },
> > > -/* 21 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_AN2235_COLD) },
> > > -/* 22 */	{ USB_DEVICE(USB_VID_ULTIMA_ELECTRONIC,	USB_PID_ULTIMA_TVBOX_AN2235_WARM) },
> > > -/* 23 */	{ USB_DEVICE(USB_VID_ADSTECH,		USB_PID_ADSTECH_USB2_COLD) },
> > > +[0]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_COLD) },
> > > +[1]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,		USB_PID_AVERMEDIA_DVBT_USB_WARM) },  
> > 
> > While here, please properly indent this table, and respect the 80-columns limit,
> > e. g.:
> > 
> > static struct usb_device_id dibusb_dib3000mb_table [] = {
> > 	[0] = { USB_DEVICE(USB_VID_WIDEVIEW 
> > 			   USB_PID_AVERMEDIA_DVBT_USB_COLD) 
> > 	},
> > 	[1]  =	{ USB_DEVICE(USB_VID_WIDEVIEW,
> > 			     USB_PID_AVERMEDIA_DVBT_USB_WARM)
> > 	},
> > 	...
> 
> Err.... something went wrong with my space bar and I ended hitting send to
> soon... I meant:
> 
> static struct usb_device_id dibusb_dib3000mb_table [] = {
>  	[0] = { USB_DEVICE(USB_VID_WIDEVIEW 
>  			   USB_PID_AVERMEDIA_DVBT_USB_COLD) 
>  	},
>  	[1] = { USB_DEVICE(USB_VID_WIDEVIEW,
>  			   USB_PID_AVERMEDIA_DVBT_USB_WARM)
>  	},
> 	...
> };

maybe static const too

and

maybe

#define DIB_DEVICE(vid, pid)	\
	{ USB_DEVICE(USB_VID_ ## vid, USB_PID_ ## pid) }

so maybe

static const struct usb_device_id dibusb_dib3000mb_table[] = {
	[0] = DIB_DEVICE(WIDEVIEW, AVERMEDIA_DVBT_USB_COLD),
	[1] = DIB_DEVICE(WIDEVIEW, AVERMEDIA_DVBT_USB_WARM),
	...
};

though I _really_ doubt the value of the specific indexing.

I think this isn't really worth changing at all.


