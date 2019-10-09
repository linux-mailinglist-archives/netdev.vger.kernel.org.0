Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBF1D11B3
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731168AbfJIOtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 10:49:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42078 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728019AbfJIOtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 10:49:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id f16so2441762qkl.9;
        Wed, 09 Oct 2019 07:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=teP+v5+FmL8g/wWAr/zXVAASv0PDM3ORznw1y//XCT8=;
        b=LUh3U1RZuletqxsN1/v62aLao850xzu4kDZzFJX9Bd5g6og2N3HDIDL1zqfIwYbrzo
         c0NYF/FJh9RCI/Kny4+6bsMSOxPgDqJqlLCZWB7z5Or5wrOGVo7/opWo9g84voGt1oQf
         SJ/sbmTiIxpEh7TDBQL+HrshIZxYLhQwZgX3c6Q8ogIplNdVC5DfI6TnN2u5mEGfgvSw
         QnxhIEofnr76/j82zofavnysrUpPMP/uvn7pvdC6CksQTByercDenI68wCJZ/+hr628f
         rEUCS6PYnz8/iRMrvWD03Z9+3aR7WpAf3gEr5WopKqbEdrVKUj3yAlrODGft7mS3QSqp
         GGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=teP+v5+FmL8g/wWAr/zXVAASv0PDM3ORznw1y//XCT8=;
        b=ozDjGGljhE3RchPSMhdiCj/V11C5ZIEQuwtFrV9ZBsnUUh2BDRgIWi+ayghLW4XE3J
         OOo9VdC5N+CVmmqgXoDYhoOmYtWCj/TWK3YVDHE0zImHlqD2JW2o1F/UxPS6DqFhRjQD
         nEz6+SSstEvJBp8og1RgiUA7Cjjn8Owys8AJm4gR3DZC0Oe3Qn0t6To64Dfpsp6vSPWg
         7RLz94hmhndGCfM7BCkiNqHKCb8OAHAe9j8WF2IeUVJj1X/Tk41u/KKrgks9u2smmjzl
         1YwBEt3ZUzACBngczl8UhFGCST5q/lKk5C82sy9CKxhv1i/bDJmF3LtAQKyZIeEPvEuu
         uk7A==
X-Gm-Message-State: APjAAAWrvNlGYX7ryteU0kCb2/QYuXBKDJYi/sE3WdXete5amjcvargs
        saQum4RDw3fViEf83MLDXlj2V5MgaMfluHHI7bGICDujdps=
X-Google-Smtp-Source: APXvYqwYi+lDvaMvV4dD4YlweLdZ2LA4nKyQVW9AUzcdihl5mbZ+0xFZcjAxIMcD1PVzWmazt3mDv7reoUfd/a9jBv4=
X-Received: by 2002:a37:a8d5:: with SMTP id r204mr3781791qke.377.1570632585010;
 Wed, 09 Oct 2019 07:49:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191009090718.12879-1-dnlplm@gmail.com> <8736g2xlxn.fsf@miraculix.mork.no>
In-Reply-To: <8736g2xlxn.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 9 Oct 2019 16:49:34 +0200
Message-ID: <CAGRyCJEYGpucM5NS5tymDP_6wwBSXG1V_4TLCAoTGxtNnD3Y=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add Telit 0x1050 composition
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno mer 9 ott 2019 alle ore 12:17 Bj=C3=B8rn Mork <bjorn@mork.no> ha =
scritto:
>
> Daniele Palmas <dnlplm@gmail.com> writes:
>
> > This patch adds support for Telit FN980 0x1050 composition
> >
> > 0x1050: tty, adb, rmnet, tty, tty, tty, tty
>
> Great!  I must admit I have been a bit curious about this since you
> submitted the option patch.  And I'm still curious about what to expect
> from X55 modems in general.  There was a lot of discussion about future
> modems using PCIe instead of USB etc.  I'd appreciate any info you have
> on relative performance, quirks, firmware workarounds etc.  If you are
> allowed to share any of it..
>

I was having issues with my hw sample related to the data connection
setup with rmnet: now I verified that is working properly with basic
tests, so I sent the patch.

I've reports of peak UDP DL throughput in loopback in the range of
6Gbps (not in Linux), more than 6 times the value I had with qmi_wwan
and LM960 (1.1Gbps), where the modem limit was reached.

For the sample I have it's probably a bit early to perform throughput
tests, but it is something that I hope to do in the next weeks.

The PCIe 3 EP 2-lanes mode is declared faster, but it won't be easy to
test it on official kernel releases, since drivers are missing.

The idea is to start with the patchset available at
https://lore.kernel.org/lkml/001601d52148$bd852840$388f78c0$@codeaurora.org=
/T/,
since it is the only public codebase I could find, but I don't expect
to have something working soon...

> Acked-by: Bj=C3=B8rn Mork" <bjorn@mork.no>
>
> > please find below usb-devices output
> >
> > T:  Bus=3D03 Lev=3D01 Prnt=3D01 Port=3D06 Cnt=3D02 Dev#=3D 10 Spd=3D480=
 MxCh=3D 0
>
> 480 Mbps is a bit slow for this device, isn't it? :-)
>
> I assume you've tested with higher bus speeds?  Not that it matters for
> this patch.  Just curious again.
>

Agree, wrong cable just used for getting the usb-devices output :-) A
better one:

T:  Bus=3D04 Lev=3D01 Prnt=3D01 Port=3D05 Cnt=3D01 Dev#=3D  4 Spd=3D5000 Mx=
Ch=3D 0
D:  Ver=3D 3.20 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 9 #Cfgs=3D  1
P:  Vendor=3D1bc7 ProdID=3D1050 Rev=3D04.14
S:  Manufacturer=3DTelit Wireless Solutions
S:  Product=3DFN980m

Thanks,
Daniele

> > D:  Ver=3D 2.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D64 #Cfgs=3D  =
1
> > P:  Vendor=3D1bc7 ProdID=3D1050 Rev=3D04.14
> > S:  Manufacturer=3DTelit Wireless Solutions
> > S:  Product=3DFN980m
> > S:  SerialNumber=3D270b8241
> > C:  #Ifs=3D 7 Cfg#=3D 1 Atr=3D80 MxPwr=3D500mA
> > I:  If#=3D 0 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3Dff Prot=3D30 Driv=
er=3Doption
> > I:  If#=3D 1 Alt=3D 0 #EPs=3D 2 Cls=3Dff(vend.) Sub=3D42 Prot=3D01 Driv=
er=3Dusbfs
> > I:  If#=3D 2 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3Dff Prot=3Dff Driv=
er=3Dqmi_wwan
> > I:  If#=3D 3 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driv=
er=3Doption
> > I:  If#=3D 4 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driv=
er=3Doption
> > I:  If#=3D 5 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driv=
er=3Doption
> > I:  If#=3D 6 Alt=3D 0 #EPs=3D 3 Cls=3Dff(vend.) Sub=3D00 Prot=3D00 Driv=
er=3Doption
> >
> > Thanks,
> > Daniele
> > ---
> >  drivers/net/usb/qmi_wwan.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 3d77cd402ba9..596428ec71df 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -1327,6 +1327,7 @@ static const struct usb_device_id products[] =3D =
{
> >       {QMI_FIXED_INTF(0x2357, 0x0201, 4)},    /* TP-LINK HSUPA Modem MA=
180 */
> >       {QMI_FIXED_INTF(0x2357, 0x9000, 4)},    /* TP-LINK MA260 */
> >       {QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)}, /* Telit LE922A */
> > +     {QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)}, /* Telit FN980 */
> >       {QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},    /* Telit ME910 */
> >       {QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},    /* Telit ME910 dual modem=
 */
> >       {QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},    /* Telit LE920 */
>
>
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
