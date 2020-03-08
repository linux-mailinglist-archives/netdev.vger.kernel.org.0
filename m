Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D40E317D5C2
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 20:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgCHTH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 15:07:58 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33242 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgCHTH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 15:07:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id d22so5559532qtn.0;
        Sun, 08 Mar 2020 12:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=q9gIS4U5Axb2UV/TlkmoKYkwkraygD1wbePWfXVPOcw=;
        b=TXKCEnlyU80n3IUULzxYxQ2QaUidkrNMG/2yUohwmHP1jwU6PTB0LHc5q4Zl3UHH9z
         QX7NilsZjqIK0N/bUVHtKQG/GmA20luiyPSe0MWh9cfPjS0702OICJQCHhKPe0aHL88C
         IzJDs6BqN/SiyMYk5F+3JdV+GZ2DiWtcgmKQErxNJ/27daMjFZ9BtJbM6hs0ug5UgGxV
         9qcCRsIzI4k2umhRSrZOIjMSzQpy8w2ukAZBxqYb+1H0X+7qNODMxTVR4ah2TjETANVr
         WOKvssAWJVwWvRzNsRmX3+IswTN4jqW+Tp1vTUnED9Gavt8stfaSz1TRgFXf4uCtDVMH
         Ip5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=q9gIS4U5Axb2UV/TlkmoKYkwkraygD1wbePWfXVPOcw=;
        b=Sw0cA4cIJaH9wk11r5nlOu/qUC5nOA5W15KaMPxpvnflKWJYoDAoRRnf2p3sab0U2J
         3V+OxOnfS/KKffwpJd1GRu+RlsRfeRUGmy5FUgVfqixvOuPUJWhvZak4IcenfJtnGq2i
         kpAQooHW1M9wmrRyoysYYhat0P4XBWibhhhWz2vCBklOuu/sLY9P5Xb747tTLa7oBcIL
         4cXHuc8Pdvrp/qO2wTKQJAn+nkZVa85T4W/nekyacuiY4b3TF7Ej4RmmIsFCpqk9TZKV
         AWDfxLZbO2e+UdNcWuUBcxmXO4Bq0+Wi5yt51Sgo5y7mFrMeDGShsbJ1VBlNW4jZ6m10
         KT1w==
X-Gm-Message-State: ANhLgQ16OS8pRY2NeI5TmectKonLny+cWwZ45S6M8Lk036B7F45WdxVK
        cEdV9m73kS9AupGR1GAx2EpiNJ5cQQRshAq20UM=
X-Google-Smtp-Source: ADFU+vsOimvYnlJjSAb5ewq/pe6fyi+A4Mpsw3y4Aue/tx3nJ9/UVmpbzyx/MsAJ8RLOIQMsslyv/pKarL3MxmoRH1I=
X-Received: by 2002:ac8:4d1c:: with SMTP id w28mr12051926qtv.48.1583694476930;
 Sun, 08 Mar 2020 12:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <CA+4pmEueEiz0Act8X6t4y3+4LOaOh_-ZfzScH0CbOKT99x91NA@mail.gmail.com>
 <87wo7una02.fsf@miraculix.mork.no>
In-Reply-To: <87wo7una02.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Sun, 8 Mar 2020 20:07:46 +0100
Message-ID: <CAGRyCJE-VYRthco5=rZ_PX0hkzhXmQ45yGJe_Gm1UvYJBKYQvQ@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: Fix for packets being rejected in the
 ring buffer used by the xHCI controller.
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Paul Gildea <paul.gildea@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn and Paul,

Il giorno dom 8 mar 2020 alle ore 16:28 Bj=C3=B8rn Mork <bjorn@mork.no> ha =
scritto:
>
> Paul Gildea <paul.gildea@gmail.com> writes:
>
> > When MTU of modem is set to less than 1500 and a packet larger than MTU
> > arrives in Linux from a modem, it is discarded with -EOVERFLOW error
> > (Babble error). This is seen on USB3.0 and USB2.0 busses. This is
> > essentially because the MRU (Max Receive Size) is not a separate entity=
 to
> > the MTU (Max Transmit Size) and the received packets can be larger than
> > those transmitted. Following the babble error there were an endless sup=
ply
> > of zero-length URBs which are rejected with -EPROTO (increasing the rx
> > input error counter each time). This is only seen on USB3.0. These cont=
inue
> > to come ad infinitum until the modem is shutdown, rendering the modem
> > unusable. There is a bug in the core USB handling code in Linux that
> > doesn't deal well with network MTUs smaller than 1500 bytes. By default=
 the
> > dev->hard_mtu (the "real" MTU) is in lockstep with dev->rx_urb_size
> > (essentially an MRU), and it's the latter that is causing trouble. This=
 has
> > nothing to do with the modems; the issue can be reproduced by getting a
> > USB-Ethernet dongle, setting the MTU to 1430, and pinging with size gre=
ater
> > than 1406.
> >
> > Signed-off-by: Paul Gildea <Paul.Gildea@gmail.com>
> > ---
> > drivers/net/usb/qmi_wwan.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> > index 5754bb6..545c772 100644
> > --- a/drivers/net/usb/qmi_wwan.c
> > +++ b/drivers/net/usb/qmi_wwan.c
> > @@ -815,6 +815,13 @@ static int qmi_wwan_bind(struct usbnet *dev, struc=
t
> > usb_interface *intf)
> >     }
> >     dev->net->netdev_ops =3D &qmi_wwan_netdev_ops;
> >     dev->net->sysfs_groups[0] =3D &qmi_wwan_sysfs_attr_group;
> > +    /* LTE Networks don't always respect their own MTU on receive side=
;
> > +    * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets fro=
m
> > +    * far-end network. Make receive buffer large enough to accommodate
> > +    * them, and add four bytes so MTU does not equal MRU on network
> > +    * with 1500 MTU otherwise usbnet_change_mtu() will change both.
> > +    */
> > +   dev->rx_urb_size =3D ETH_DATA_LEN + 4;

Isn't this going to break the change MTU workaround for dl data
aggregation when using qmap?

Regards,
Daniele

> >  err:
> >     return status;
> >  }
> > --
> > 1.9.1
>
>
> This is fine as a first step towards saner buffer handling in qmi_wwan.
> If real world devices use asymmetric MTUs, then we should just deal with
> that.
>
> So I was going to add my ack.  But the patch does not apply:
>
>
>  bjorn@miraculix:/usr/local/src/git/linux$ git am /tmp/l
>  Applying: net: usb: qmi_wwan: Fix for packets being rejected in the ring=
 buffer used by the xHCI controller.
>  error: corrupt patch at line 10
>
> and checkpatch says why:
>
>  bjorn@miraculix:/usr/local/src/git/linux$ scripts/checkpatch.pl /tmp/l
>  ERROR: patch seems to be corrupt (line wrapped?)
>  #34: FILE: drivers/net/usb/qmi_wwan.c:814:
>  usb_interface *intf)
>
>
> Could you fix up and resend? You might have to use a different email
> client.  See
> https://www.kernel.org/doc/html/latest/process/email-clients.html#email-c=
lients
>
>
> Bj=C3=B8rn
