Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46B41932AC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 22:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 17:30:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38364 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgCYVaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 17:30:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so4191791ljh.5
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 14:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4pFd7zuO/PHCDkDSk2itdBp2DM3AlcjhRq/1mxLMNh0=;
        b=FGo1WaXeEU2eA+9BT9a8L0JamNnb1QfqHpxrlavFI4DDnjm6Cz05gHVPcJ+/ai61lm
         /fbHB0dVDqWxQL9WuA9+Khll00piHAJUjQEB8PRJwZT9mKUHSXgUAq7i7grgL1KdB/6L
         qw8ciE628a+4RSV7Y8XGtGz7T8IroRWbf5oV0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4pFd7zuO/PHCDkDSk2itdBp2DM3AlcjhRq/1mxLMNh0=;
        b=Dn6yVDoGgmPDWMh/kHdAiu4+b+Cop78Hjb4Xiqlc1mCQAX26Xp8jGHDMf/PKDI6+sb
         2vQWg/w0R6haet02cg7xplfvRElOt13S77gNpVN8L+jzuurGNeTKvLh4elcj60rWBoyw
         tHuu44OM+2XRMPHJBWRjsYzwjPoeXDTncPtXiTNMIaj1BQGt83STM9fv1re4EWE9uCHq
         SgDFV0Hu6Sorukl1pL6mAUI3x87R5ykH3wv8mJFbpY6+521FY+YiuGaAulhn7gECOk7o
         5B/LFHIXW1QzMEgskFqdCJ1zlSmkV1PwB4AsGoAQIf3UgzgEzsjRtD/dXNCi9jKlN9nm
         bkNg==
X-Gm-Message-State: ANhLgQ2tw7fOkE/T3xETBN15jl8/YEZa4qxEdAkBOKF8cTu9QSAoTXp9
        +WunLUfdYFGB4fIhEuq+0X8dCzxa7+2Cnc9lD6a56w==
X-Google-Smtp-Source: ADFU+vtpnSYllD1woB28f1jLDrTWqQun54p7cOQcI+14NHiQ2tGn5V3CCPXhrAqQhIURRdGfgKhUNbJZYiREfhh2qWE=
X-Received: by 2002:a2e:9ad2:: with SMTP id p18mr3109506ljj.15.1585171799825;
 Wed, 25 Mar 2020 14:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200325070336.1097-1-mcchou@chromium.org> <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <72699110-843A-4382-8FF1-20C5D4D557A2@holtmann.org>
In-Reply-To: <72699110-843A-4382-8FF1-20C5D4D557A2@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Wed, 25 Mar 2020 14:29:48 -0700
Message-ID: <CABmPvSFL_bkrZQJkAzUMck_bAY5aBZkL=5HGV_Syv2QRYfRLfw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 1:10 AM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Miao-chen,
>
> > This adds a bit mask of driver_info for Microsoft vendor extension and
> > indicates the support for Intel 9460/9560 and 9160/9260. See
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > microsoft-defined-bluetooth-hci-commands-and-events for more informatio=
n
> > about the extension. This was verified with Intel ThunderPeak BT contro=
ller
> > where msft_vnd_ext_opcode is 0xFC1E.
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > ---
> >
> > Changes in v2:
> > - Define struct msft_vnd_ext and add a field of this type to struct
> > hci_dev to facilitate the support of Microsoft vendor extension.
> >
> > drivers/bluetooth/btusb.c        | 14 ++++++++++++--
> > include/net/bluetooth/hci_core.h |  6 ++++++
> > 2 files changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> > index 3bdec42c9612..4c49f394f174 100644
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
> > #define BTUSB_CW6622          0x100000
> > #define BTUSB_MEDIATEK                0x200000
> > #define BTUSB_WIDEBAND_SPEECH 0x400000
> > +#define BTUSB_MSFT_VND_EXT   0x800000
> >
> > static const struct usb_device_id btusb_table[] =3D {
> >       /* Generic Bluetooth USB device */
> > @@ -335,7 +336,8 @@ static const struct usb_device_id blacklist_table[]=
 =3D {
> >
> >       /* Intel Bluetooth devices */
> >       { USB_DEVICE(0x8087, 0x0025), .driver_info =3D BTUSB_INTEL_NEW |
> > -                                                  BTUSB_WIDEBAND_SPEEC=
H },
> > +                                                  BTUSB_WIDEBAND_SPEEC=
H |
> > +                                                  BTUSB_MSFT_VND_EXT }=
,
> >       { USB_DEVICE(0x8087, 0x0026), .driver_info =3D BTUSB_INTEL_NEW |
> >                                                    BTUSB_WIDEBAND_SPEEC=
H },
> >       { USB_DEVICE(0x8087, 0x0029), .driver_info =3D BTUSB_INTEL_NEW |
> > @@ -348,7 +350,8 @@ static const struct usb_device_id blacklist_table[]=
 =3D {
> >       { USB_DEVICE(0x8087, 0x0aa7), .driver_info =3D BTUSB_INTEL |
> >                                                    BTUSB_WIDEBAND_SPEEC=
H },
> >       { USB_DEVICE(0x8087, 0x0aaa), .driver_info =3D BTUSB_INTEL_NEW |
> > -                                                  BTUSB_WIDEBAND_SPEEC=
H },
> > +                                                  BTUSB_WIDEBAND_SPEEC=
H |
> > +                                                  BTUSB_MSFT_VND_EXT }=
,
> >
> >       /* Other Intel Bluetooth devices */
> >       { USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
> > @@ -3734,6 +3737,8 @@ static int btusb_probe(struct usb_interface *intf=
,
> >       hdev->send   =3D btusb_send_frame;
> >       hdev->notify =3D btusb_notify;
> >
> > +     hdev->msft_ext.opcode =3D HCI_OP_NOP;
> > +
>
> do this in the hci_alloc_dev procedure for every driver. This doesn=E2=80=
=99t belong in the driver.
Thanks for the note, I will address this.
>
> > #ifdef CONFIG_PM
> >       err =3D btusb_config_oob_wake(hdev);
> >       if (err)
> > @@ -3800,6 +3805,11 @@ static int btusb_probe(struct usb_interface *int=
f,
> >               set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks)=
;
> >               set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> >               set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> > +
> > +             if (id->driver_info & BTUSB_MSFT_VND_EXT &&
> > +                     (id->idProduct =3D=3D 0x0025 || id->idProduct =3D=
=3D 0x0aaa)) {
>
> Please scrap this extra check. You already selected out the PID with the =
blacklist_table. In addition, I do not want to add a PID in two places in t=
he driver.
If we scrap the check around idProduct, how do we tell two controllers
apart if they use different opcode for Microsoft vendor extension?
>
> An alternative is to not use BTUSB_MSFT_VND_EXT and let the Intel code se=
t it based on the hardware / firmware revision it finds. We might need to d=
iscuss which is the better approach for the Intel hardware since not all PI=
Ds are unique.
We are expecting to indicate the vendor extension for non-Intel
controllers as well, and having BTUSB_MSFT_VND_EXT seems to be more
generic. What do you think?
>
> > +                     hdev->msft_ext.opcode =3D 0xFC1E;
> > +             }
> >       }
> >
> >       if (id->driver_info & BTUSB_MARVELL)
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index d4e28773d378..0ec3d9b41d81 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/BTUSB_MSFT_VND_EXTBTUSB_MSFT_VND_EXTBTUSB_MSFT_VND_EX=
Tbluetooth/hci_core.h
> > @@ -244,6 +244,10 @@ struct amp_assoc {
> >
> > #define HCI_MAX_PAGES 3
> >
> > +struct msft_vnd_ext {
> > +     __u16   opcode;
> > +};
> > +
> > struct hci_dev {
> >       struct list_head list;
> >       struct mutex    lock;
> > @@ -343,6 +347,8 @@ struct hci_dev {
> >
> >       struct amp_assoc        loc_assoc;
> >
> > +     struct msft_vnd_ext     msft_ext;
> > +
> >       __u8            flow_ctl_mode;
> >
> >       unsigned int    auto_accept_delay;
>
Regards,
Miao
