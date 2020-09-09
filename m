Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C387B263838
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgIIVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIIVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:10:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF36C061573;
        Wed,  9 Sep 2020 14:10:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 16so3924652qkf.4;
        Wed, 09 Sep 2020 14:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3mU7ucabB0/5yMnTgF30fG5C3ciyGZ3uXNSyF4+lYCo=;
        b=nBYqef/PCCJcspisGVWhoPmK+zUvcPwwdSpDDaICi2uCxkvvBvaF0eERdVWb7llw/t
         6ABDu8a4zkFogkkBBhHUGAHzXdPU1wtaom2XxGvTS2O5LrQmdaoAUMiU5fhboWO10KFQ
         ntapzgQrgAC/nVLFbocZ+39y2LvSODf3n588c927WyYGKA4YdNgQf5LkGJtfyJFlc7Dk
         KtkQpuH15SLNIhh6sh2AKARxpfkYdZ+Bn/PnlodJSe4ItKkqgZaFRL90Ffl4EfoID95T
         nn+9lGW4SI5XbMxsKxiL0bxXcODczT03n1NtujFbqg0UJMtIacA91CYY59qTRqbKLhbQ
         wPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3mU7ucabB0/5yMnTgF30fG5C3ciyGZ3uXNSyF4+lYCo=;
        b=BRRNsGBy5BeZwV9JNSoERkVKJm97TP/2db/afT0hVs0aQ1LXrTeH9rokepwxzkjf/i
         5UtctcO8CyWpYiRPwJQ1bZ+spKlwBriz/qLyJBvHZQDMrseDBZIYnDyvZSTnN3B+FMEI
         J/d6VPwCS40dXlxiewFjAfuxuLcAc7G7vLEJ/7qiaeDfY2PS2WRHOvdFLvJwB24IoU1c
         yeYMJdgc2Qv4ih6zyMlRvQksj4UXseebflMSYfAkPXMrWoLuHxWNZe/K7zbjbuxwDic7
         KrxypA616aCqhVsm6zvVRRohBnaZ6l7br7NIVruRa4D24QxDrNWlfng0TvShWYYd1ukO
         3Q2A==
X-Gm-Message-State: AOAM530Sh/toSvNX51/sFRZNT4WrxrvLL8zts7ubMZL/6ZcsLEA7rmKb
        vK23jyRRaZxivPsBlfXtmIo9i05wQzxFS0J6J6w=
X-Google-Smtp-Source: ABdhPJzWlKB0+TDhhuM6wk10LfJgy6uMCG8BA1b08aIb6se0IKKI9pXzQc7pDZh2XQdYn1DPmZtSCPrPM7YA3puXk6Y=
X-Received: by 2002:a37:e509:: with SMTP id e9mr4767095qkg.469.1599685850618;
 Wed, 09 Sep 2020 14:10:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com> <HK2PR06MB35077179EE3FDE04A1EB612786260@HK2PR06MB3507.apcprd06.prod.outlook.com>
 <CAGRyCJFuMv5PmLC2iUGOgbBufWUKhmVoYgrK_hXTgqmj1P1Yjw@mail.gmail.com> <87tuw7dsit.fsf@miraculix.mork.no>
In-Reply-To: <87tuw7dsit.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Wed, 9 Sep 2020 23:10:39 +0200
Message-ID: <CAGRyCJEuzhTJ+shfnobW_2z7=Y1TDF1YYP_1=VrXZvVNMS9HNg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>,
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

Hi Bj=C3=B8rn,

Il giorno mer 9 set 2020 alle ore 14:49 Bj=C3=B8rn Mork <bjorn@mork.no> ha =
scritto:
>
> Daniele Palmas <dnlplm@gmail.com> writes:
> > Il giorno mer 9 set 2020 alle ore 13:09 Carl Yin(=E6=AE=B7=E5=BC=A0=E6=
=88=90)
> > <carl.yin@quectel.com> ha scritto:
> >>
> >> Hi Deniele:
> >>
> >>         I have an idea, by now in order to use QMAP,
> >>         must execute shell command 'echo mux_id > /sys/class/net/<ifac=
e>/add_mux' in user space,
> >>         maybe we can expand usage of sys attribute 'add_mux', like nex=
t:
> >>         'echo mux_id mux_size mux_version > /sys/class/net/<iface>/add=
_mux'.
> >>         Users can set correct 'mux_size and mux_version' according to =
the response of 'QMI_WDA_SET_DATA_FORMAT '.
> >>         If 'mux_size and mux_version' miss, qmi_wwan can use default v=
alues.
> >>
> >
> > not sure this is something acceptable, let's wait for Bj=C3=B8rn to com=
ment.
>
> This breaks the "one value per file" rule.  Ref
> https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt
>
> And I really think this userspace ABI is complicated enough already
> without adding yet another variable governed by strict rules.
>
> I'd prefer this to just work, if possible.  I liked the simplicity of
> your patch.  If it is necessary to have a different value when QMAP is
> disabled, then I'd much rather see two fixed values, depending on
> QMI_WWAN_FLAG_MUX.
>

Maybe to have a more cautious approach we can use 2048 for normal mode
(suggested by Qualcomm for the babble issue) and 16384 when using
QMAP, as done by the Windows driver, adding a comment that higher
values (that should be only related to 5G chipsets) are currently not
supported.

I do not currently have the equipment to test with 5G, but using 16384
could not even be a problem since I doubt that the bottleneck for the
real throughput is the bus.

Moreover, we can face it once we are capable of performing throughput
tests and have indications on the behavior according to the different
sizes of the rx urb.

Sounds reasonable?

>
> >>         If fixed set as 32KB, but MDM9x07 chips only support 4KB, or u=
ses do not enable QMAP,
> >>         Maybe cannot reach max throughput for no enough rx urbs.
> >>
> >
> > I did not test for performance, but you could be right since for
> > example, if I'm not wrong, rx_qlen for an high-speed device would be 2
> > with the changed rx_urb_size.
>
> That's correct.  But I believe 2 URBs might be enough.  Still, would be
> nice if some of you with a fast enough modem could test this.  At least
> if throughput issues are going to be an argument for a more complicated
> ABI.
>

With 16384 we'll have 5 URBs with an high-speed modem and QMAP
enabled. That would usually be a configuration for low-cat modems,
while high-cat use super-speed or super-speed-plus, for which I
already tested that value reaching 1.1Gbit/s.

I can try to perform some additional tests with rx_urb_size=3D16384,
QMAP and low-cat, but it will require more time.

> > So, we'll probably need to modify also usbnet_update_max_qlen, but not
> > sure about the direction (maybe fallback to a default value to
> > guarantee a minimum number if rx_qlen is < than a threshold?). And
> > this is also a change affecting all the drivers using usbnet, so it
> > requires additional care.
>
> I'm not sure we want to do that. We haven't done it for other
> aggregating usbnet protocols.  There is a reason we have the hard limit.
>

Ok, understood.

Thanks,
Daniele

>
>
>
> Bj=C3=B8rn
>
> >> > -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> >> > =E5=8F=91=E4=BB=B6=E4=BA=BA: Daniele Palmas [mailto:dnlplm@gmail.com=
]
> >> > =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Wednesday, September 09, 2020 =
5:13 PM
> >> > =E6=94=B6=E4=BB=B6=E4=BA=BA: Bj=C3=B8rn Mork <bjorn@mork.no>
> >> > =E6=8A=84=E9=80=81: Kristian Evensen <kristian.evensen@gmail.com>; P=
aul Gildea
> >> > <paul.gildea@gmail.com>; Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=90) <carl=
.yin@quectel.com>; David S .
> >> > Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> >> > netdev@vger.kernel.org; linux-usb@vger.kernel.org; Daniele Palmas
> >> > <dnlplm@gmail.com>
> >> > =E4=B8=BB=E9=A2=98: [PATCH net-next 1/1] net: usb: qmi_wwan: add def=
ault rx_urb_size
> >> >
> >> > Add default rx_urb_size to support QMAP download data aggregation wi=
thout
> >> > needing additional setup steps in userspace.
> >> >
> >> > The value chosen is the current highest one seen in available modems=
.
> >> >
> >> > The patch has the side-effect of fixing a babble issue in raw-ip mod=
e reported by
> >> > multiple users.
> >> >
> >> > Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> >> > ---
> >> > Resending with mailing lists added: sorry for the noise.
> >> >
> >> > Hi Bj=C3=B8rn and all,
> >> >
> >> > this patch tries to address the issue reported in the following thre=
ads
> >> >
> >> > https://www.spinics.net/lists/netdev/msg635944.html
> >> > https://www.spinics.net/lists/linux-usb/msg198846.html
> >> > https://www.spinics.net/lists/linux-usb/msg198025.html
> >> >
> >> > so I'm adding the people involved, maybe you can give it a try to do=
uble check if
> >> > this is good for you.
> >> >
> >> > On my side, I performed tests with different QC chipsets without exp=
eriencing
> >> > problems.
> >> >
> >> > Thanks,
> >> > Daniele
> >> > ---
> >> >  drivers/net/usb/qmi_wwan.c | 4 ++++
> >> >  1 file changed, 4 insertions(+)
> >> >
> >> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c=
 index
> >> > 07c42c0719f5..92d568f982b6 100644
> >> > --- a/drivers/net/usb/qmi_wwan.c
> >> > +++ b/drivers/net/usb/qmi_wwan.c
> >> > @@ -815,6 +815,10 @@ static int qmi_wwan_bind(struct usbnet *dev, st=
ruct
> >> > usb_interface *intf)
> >> >       }
> >> >       dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
> >> >       dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
> >> > +
> >> > +     /* Set rx_urb_size to allow QMAP rx data aggregation */
> >> > +     dev->rx_urb_size =3D 32768;
> >> > +
> >> >  err:
> >> >       return status;
> >> >  }
> >> > --
> >> > 2.17.1
> >>
