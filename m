Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1598262E45
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 14:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgIIMAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 08:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727856AbgIIL6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 07:58:12 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E56CC0617A4;
        Wed,  9 Sep 2020 04:58:12 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so1290165qvb.13;
        Wed, 09 Sep 2020 04:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=S7pK42JR8PhzlEF2s3CckSD6djfyBOFE5c0JqG2pCls=;
        b=dx57dff1QA07ETKN9BI0XxhIYsz0c3omPzQmJhHYvB2PDQQJpwdiLXRdKwwl1ED00h
         7ygmPVdvTE6lUpqEeqQ/HfvY1hDcj5OuH/WDNqKFEQR1Cz3EFem5BR3bCpgAda88zvjP
         RGJ7vUppfKpuLGYOXuZmmeMedzrJ6NdVkUvNcyjLslHse3pt4eW80TtiGRvK5kyYGflt
         PAs6P1yMbrRYYKuNqYhxGX9rKwaVZTMC/yADhHIKEp0kxjhVnf1GrEUIAIceqlXeMADs
         o4UVWmCVO/Y1vhzURizrnTbIlmRkZ7BeFwJbaSFQDr9jvs1FIXYn4ypsHM+JrRDcnq27
         jcIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=S7pK42JR8PhzlEF2s3CckSD6djfyBOFE5c0JqG2pCls=;
        b=TKCxAjtnk2vJR0JwMyjo9KIG8iOmtlZW3WYS0JY4po8/8B3aOLayicreZXc7mnYyTT
         tRsfhCaJ/tfpWLHygI4WOiJgUlkH0iCbiy3i/7+HprZDe4JAc2aZ20+s90tIxnXj9QHd
         keuPuEETGUg37/wVSbhnZePYjxRSvXLT6cgTlWOTpNBpFG2LMAHNJ8BnGi+pSYOiHOdF
         gZyPaZM0mL/78F0A4oe/Lod2MsOF3ifyQuQsB1nChoLXmliPUPi4+MxEjrDGQEZ/d8v7
         cWmmdkM7Phbp3M36TeFe7V6099woMJbCJmrvSk/2TlOlZuOydp+dvro5Rhq0jdxgW/oh
         Nfzg==
X-Gm-Message-State: AOAM5303DFYhAEe39nuvWVcwjyQSuOOt1Cv6ARIm+wLlo6JWZBz0cHzS
        FqhixKF+2tBQTTsr3aMmpOQuF+xfwgW5Xf2bNmwvNwDe/7XVSA==
X-Google-Smtp-Source: ABdhPJzgihLNxZLqAj7YH/xgvSRBOyhb4C/njPRBvOh2FOgfr4sQyQKonBtopoJd3oso1dxppdIUTSD0lKUugQLEzYs=
X-Received: by 2002:ad4:534c:: with SMTP id v12mr3546153qvs.27.1599652691437;
 Wed, 09 Sep 2020 04:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com> <HK2PR06MB35077179EE3FDE04A1EB612786260@HK2PR06MB3507.apcprd06.prod.outlook.com>
In-Reply-To: <HK2PR06MB35077179EE3FDE04A1EB612786260@HK2PR06MB3507.apcprd06.prod.outlook.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 9 Sep 2020 13:57:58 +0200
Message-ID: <CAGRyCJFuMv5PmLC2iUGOgbBufWUKhmVoYgrK_hXTgqmj1P1Yjw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Paul Gildea <paul.gildea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Carl,

Il giorno mer 9 set 2020 alle ore 13:09 Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=
=90)
<carl.yin@quectel.com> ha scritto:
>
> Hi Deniele:
>
>         I have an idea, by now in order to use QMAP,
>         must execute shell command 'echo mux_id > /sys/class/net/<iface>/=
add_mux' in user space,
>         maybe we can expand usage of sys attribute 'add_mux', like next:
>         'echo mux_id mux_size mux_version > /sys/class/net/<iface>/add_mu=
x'.
>         Users can set correct 'mux_size and mux_version' according to the=
 response of 'QMI_WDA_SET_DATA_FORMAT '.
>         If 'mux_size and mux_version' miss, qmi_wwan can use default valu=
es.
>

not sure this is something acceptable, let's wait for Bj=C3=B8rn to comment=
.

>         If fixed set as 32KB, but MDM9x07 chips only support 4KB, or uses=
 do not enable QMAP,
>         Maybe cannot reach max throughput for no enough rx urbs.
>

I did not test for performance, but you could be right since for
example, if I'm not wrong, rx_qlen for an high-speed device would be 2
with the changed rx_urb_size.

So, we'll probably need to modify also usbnet_update_max_qlen, but not
sure about the direction (maybe fallback to a default value to
guarantee a minimum number if rx_qlen is < than a threshold?). And
this is also a change affecting all the drivers using usbnet, so it
requires additional care.

Let's wait for the maintainers' advice also on this.

Regards,
Daniele

>
> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Daniele Palmas [mailto:dnlplm@gmail.com]
> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Wednesday, September 09, 2020 5:1=
3 PM
> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Bj=C3=B8rn Mork <bjorn@mork.no>
> > =E6=8A=84=E9=80=81: Kristian Evensen <kristian.evensen@gmail.com>; Paul=
 Gildea
> > <paul.gildea@gmail.com>; Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=90) <carl.yi=
n@quectel.com>; David S .
> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> > netdev@vger.kernel.org; linux-usb@vger.kernel.org; Daniele Palmas
> > <dnlplm@gmail.com>
> > =E4=B8=BB=E9=A2=98: [PATCH net-next 1/1] net: usb: qmi_wwan: add defaul=
t rx_urb_size
> >
> > Add default rx_urb_size to support QMAP download data aggregation witho=
ut
> > needing additional setup steps in userspace.
> >
> > The value chosen is the current highest one seen in available modems.
> >
> > The patch has the side-effect of fixing a babble issue in raw-ip mode r=
eported by
> > multiple users.
> >
> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> > ---
> > Resending with mailing lists added: sorry for the noise.
> >
> > Hi Bj=C3=B8rn and all,
> >
> > this patch tries to address the issue reported in the following threads
> >
> > https://www.spinics.net/lists/netdev/msg635944.html
> > https://www.spinics.net/lists/linux-usb/msg198846.html
> > https://www.spinics.net/lists/linux-usb/msg198025.html
> >
> > so I'm adding the people involved, maybe you can give it a try to doubl=
e check if
> > this is good for you.
> >
> > On my side, I performed tests with different QC chipsets without experi=
encing
> > problems.
> >
> > Thanks,
> > Daniele
> > ---
> >  drivers/net/usb/qmi_wwan.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c in=
dex
> > 07c42c0719f5..92d568f982b6 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, struc=
t
> > usb_interface *intf)
> >       }
> >       dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
> >       dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
> > +
> > +     /* Set rx_urb_size to allow QMAP rx data aggregation */
> > +     dev->rx_urb_size =3D 32768;
> > +
> >  err:
> >       return status;
> >  }
> > --
> > 2.17.1
>
