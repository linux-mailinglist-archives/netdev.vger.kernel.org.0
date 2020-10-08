Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D462E287A66
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgJHQ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:32804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJHQ4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:56:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D007221D7D;
        Thu,  8 Oct 2020 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602176179;
        bh=snir49HEVlLtrbU6+iY7znGYLS9qwcoLGqtqoklxLlk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jfVcWqYGlOaI9hBVlivzveRkbmEiHWkk5N9X1L/4A+VJOm0nz/eoAVMxBziuw8bB8
         PVlA0+4WQkyBw3oVzsRd/uql6ow7eb1Lj4M5jcmVmgsK3GUbyH3gxdDTE6xe5JLdRh
         JsrimB2jkFFWmsXTMLgimqolqwJzZtt/UYWKy/4A=
Date:   Thu, 8 Oct 2020 09:56:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: usb: qmi_wwan: add Cellient MPL200 card
Message-ID: <20201008095616.35a21c00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87d01ti1jb.fsf@miraculix.mork.no>
References: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
        <f5858ed121df35460ef17591152d606a78aa65db.1602140720.git.wilken.gottwalt@mailbox.org>
        <87d01ti1jb.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 08 Oct 2020 10:07:20 +0200 Bj=C3=B8rn Mork wrote:
> Wilken Gottwalt <wilken.gottwalt@mailbox.org> writes:
> > Add usb ids of the Cellient MPL200 card.
> >
> > Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> > ---
> >  drivers/net/usb/qmi_wwan.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 07c42c0719f5..5ca1356b8656 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -1375,6 +1375,7 @@ static const struct usb_device_id products[] =3D {
> >  	{QMI_QUIRK_SET_DTR(0x2cb7, 0x0104, 4)},	/* Fibocom NL678 series */
> >  	{QMI_FIXED_INTF(0x0489, 0xe0b4, 0)},	/* Foxconn T77W968 LTE */
> >  	{QMI_FIXED_INTF(0x0489, 0xe0b5, 0)},	/* Foxconn T77W968 LTE with eSIM=
 support*/
> > +	{QMI_FIXED_INTF(0x2692, 0x9025, 4)},    /* Cellient MPL200 (rebranded=
 Qualcomm 05c6:9025) */
> > =20
> >  	/* 4. Gobi 1000 devices */
> >  	{QMI_GOBI1K_DEVICE(0x05c6, 0x9212)},	/* Acer Gobi Modem Device */ =20
>=20
> Thanks.  Looks nice now.
>=20
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

I'm guessing that I'm supposed to take this patch into the networking
tree, correct?

Is this net or net-next candidate? Bj=C3=B8rn?
