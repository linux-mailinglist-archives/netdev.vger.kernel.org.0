Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAEEA198899
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgCaAAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:00:47 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34430 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgCaAAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:00:47 -0400
Received: by mail-lf1-f68.google.com with SMTP id e7so15785937lfq.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 17:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GhTora22O/xRri2wav17l2dK9RxeL1NLGG+m07hxnBU=;
        b=AuEpdqJaTlWMT5ovqDAxZ0mtk0Tx9FwsjiCkWtRs+sf1k1V5ektgE4HuZ3clEnJ9cw
         28tmNb5R+Z9DN+25mkRmkZC7rT0evaKJix82ef9Pif1hH7PgdBbExReUW6Th5fANsVk/
         vxl72Mk+QWUOoOXRpsmF/9a+nGS+i07kZdDys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GhTora22O/xRri2wav17l2dK9RxeL1NLGG+m07hxnBU=;
        b=tOOMKTWne8OxIxXQrGOvaJaDY3N1JCtTNgk0vwdjRRB910IfR6sGjjgio9eFx7Jy59
         UBgDpndpsTaSAFwqzRoQJUc0ILnx9az1LtVE1HxKiOb0ieETv5Av9TODYxbBQk4ELD9P
         l+9PCFYyzNP6Nyo4Wa1WS/j7QDv2uUKW19gruxcFI5d1XUuro9TjJUTvBiYOa/OmoRXa
         EJ/5Xy4cwH2Hg3KHBHcVfv1JHIkt3ipbg04DlC13D7i9e3TdWIux+R9BoT5hfHJoAKNv
         l4ocR8LKq49Yba9OhE9wjVwbMZBb7IOfor1jbNPvGQPmqrUAxR7vDeyFFrP5URiMhTkU
         PcYg==
X-Gm-Message-State: AGi0PuYFDTfTaMEERF2FTojH2uKFK+4voEzvql1RoUvquMqRePJa7fzG
        W6MuFLJstieAGVtNghLZUEl/SxxNmHT/GxfzN3tbhg==
X-Google-Smtp-Source: APiQypJufoxcibfjDOqnStaQybUmnyI2TWBJoKFqz3cpvebIREGAV+EAXQpeVvU4vf5AuoMMqlV1gCcLS1TZBMarq1M=
X-Received: by 2002:a19:c752:: with SMTP id x79mr9351805lff.144.1585612843568;
 Mon, 30 Mar 2020 17:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200328074632.21907-1-mcchou@chromium.org> <20200328004507.v4.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <9CC14296-9A0E-4257-A388-B2F7C155CCE5@holtmann.org>
In-Reply-To: <9CC14296-9A0E-4257-A388-B2F7C155CCE5@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Mon, 30 Mar 2020 17:00:32 -0700
Message-ID: <CABmPvSF=pcffe18iAKgbU8bwFvVDp-NKeAFGw8auKoVd1XAuTQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Bluetooth Kernel Mailing List <linux-bluetooth@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
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

Hi Marcel,

On Mon, Mar 30, 2020 at 3:06 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Miao-chen,
>
> > This adds a bit mask of driver_info for Microsoft vendor extension and
> > indicates the support for Intel 9460/9560 and 9160/9260. See
> > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > microsoft-defined-bluetooth-hci-commands-and-events for more informatio=
n
> > about the extension. This also add a kernel config, BT_MSFTEXT, and a
> > source file to facilitate Microsoft vendor extension functions.
> > This was verified with Intel ThunderPeak BT controller
> > where msft_vnd_ext_opcode is 0xFC1E.
> >
> > Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> >
> > Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> > ---
> >
> > Changes in v4:
> > - Introduce CONFIG_BT_MSFTEXT as a starting point of providing a
> > framework to use Microsoft extension
> > - Create include/net/bluetooth/msft.h and net/bluetooth/msft.c to
> > facilitate functions of Microsoft extension.
> >
> > Changes in v3:
> > - Create net/bluetooth/msft.c with struct msft_vnd_ext defined internal=
ly
> > and change the hdev->msft_ext field to void*.
> > - Define and expose msft_vnd_ext_set_opcode() for btusb use.
> > - Init hdev->msft_ext in hci_alloc_dev() and deinit it in hci_free_dev(=
).
> >
> > Changes in v2:
> > - Define struct msft_vnd_ext and add a field of this type to struct
> > hci_dev to facilitate the support of Microsoft vendor extension.
> >
> > drivers/bluetooth/btusb.c        | 11 +++++++++--
> > include/net/bluetooth/hci_core.h |  4 ++++
>
> so I don=E2=80=99t like the intermixing of core features and drivers unle=
ss it is needed. In this case it is not needed since we can first introduce=
 the core support and then enable the driver to use it.
I will make btusb changes as a different commit in v5.
>
> > net/bluetooth/Kconfig            |  9 ++++++++-
> > net/bluetooth/Makefile           |  1 +
> > net/bluetooth/msft.c             | 16 ++++++++++++++++
> > net/bluetooth/msft.h             | 19 +++++++++++++++++++
> > 6 files changed, 57 insertions(+), 3 deletions(-)
> > create mode 100644 net/bluetooth/msft.c
> > create mode 100644 net/bluetooth/msft.h
> >
> > diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> > index 3bdec42c9612..0fe47708d3c8 100644
> > --- a/drivers/bluetooth/btusb.c
> > +++ b/drivers/bluetooth/btusb.c
> > @@ -21,6 +21,7 @@
> > #include <net/bluetooth/bluetooth.h>
> > #include <net/bluetooth/hci_core.h>
> >
> > +#include "../../net/bluetooth/msft.h"
>
> This was my bad. I didn=E2=80=99t realized that drivers need to the set t=
he opcode and not the core. I updated the patches to fix this.
I will move it to include/net/bluetooth/.
>
> > #include "btintel.h"
> > #include "btbcm.h"
> > #include "btrtl.h"
> > @@ -58,6 +59,7 @@ static struct usb_driver btusb_driver;
> > #define BTUSB_CW6622          0x100000
> > #define BTUSB_MEDIATEK                0x200000
> > #define BTUSB_WIDEBAND_SPEECH 0x400000
> > +#define BTUSB_MSFT_VND_EXT   0x800000
> >
> > static const struct usb_device_id btusb_table[] =3D {
> >       /* Generic Bluetooth USB device */
> > @@ -335,7 +337,8 @@ static const struct usb_device_id blacklist_table[]=
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
> > @@ -348,7 +351,8 @@ static const struct usb_device_id blacklist_table[]=
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
>
> Lets start with ThunderPeak 0x0025 for now. We are looking into enabling =
this in a more generic fashion, but for now lets just enable one card.
Ack.
>
> >
> >       /* Other Intel Bluetooth devices */
> >       { USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
> > @@ -3800,6 +3804,9 @@ static int btusb_probe(struct usb_interface *intf=
,
> >               set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks)=
;
> >               set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> >               set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> > +
> > +             if (id->driver_info & BTUSB_MSFT_VND_EXT)
> > +                     msft_set_opcode(hdev, 0xFC1E);
> >       }
> >
> >       if (id->driver_info & BTUSB_MARVELL)
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index d4e28773d378..239cae2d9998 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -484,6 +484,10 @@ struct hci_dev {
> >       struct led_trigger      *power_led;
> > #endif
> >
> > +#if IS_ENABLED(CONFIG_BT_MSFTEXT)
> > +     __u16                   msft_opcode;
> > +#endif
> > +
> >       int (*open)(struct hci_dev *hdev);
> >       int (*close)(struct hci_dev *hdev);
> >       int (*flush)(struct hci_dev *hdev);
> > diff --git a/net/bluetooth/Kconfig b/net/bluetooth/Kconfig
> > index 165148c7c4ce..5929ccb02b39 100644
> > --- a/net/bluetooth/Kconfig
> > +++ b/net/bluetooth/Kconfig
> > @@ -30,7 +30,7 @@ menuconfig BT
> >               L2CAP (Logical Link Control and Adaptation Protocol)
> >               SMP (Security Manager Protocol) on LE (Low Energy) links
> >            HCI Device drivers (Interface to the hardware)
> > -          RFCOMM Module (RFCOMM Protocol)
> > +          RFCOMM Module (RFCOMM Protocol)
>
> Unrelated changes don=E2=80=99t belong here.
This was probably done by my editor, I will recover it.
>
> >            BNEP Module (Bluetooth Network Encapsulation Protocol)
> >            CMTP Module (CAPI Message Transport Protocol)
> >            HIDP Module (Human Interface Device Protocol)
> > @@ -93,6 +93,13 @@ config BT_LEDS
> >         This option selects a few LED triggers for different
> >         Bluetooth events.
> >
> > +config BT_MSFTEXT
> > +     bool "Enable Microsoft extensions"
> > +     depends on BT
> > +     help
> > +       This options enables support for the Microsoft defined HCI
> > +       vendor extensions.
> > +
> > config BT_SELFTEST
> >       bool "Bluetooth self testing support"
> >       depends on BT && DEBUG_KERNEL
> > diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
> > index fda41c0b4781..41dd541a44a5 100644
> > --- a/net/bluetooth/Makefile
> > +++ b/net/bluetooth/Makefile
> > @@ -19,5 +19,6 @@ bluetooth-y :=3D af_bluetooth.o hci_core.o hci_conn.o=
 hci_event.o mgmt.o \
> > bluetooth-$(CONFIG_BT_BREDR) +=3D sco.o
> > bluetooth-$(CONFIG_BT_HS) +=3D a2mp.o amp.o
> > bluetooth-$(CONFIG_BT_LEDS) +=3D leds.o
> > +bluetooth-$(CONFIG_BT_MSFTEXT) +=3D msft.o
> > bluetooth-$(CONFIG_BT_DEBUGFS) +=3D hci_debugfs.o
> > bluetooth-$(CONFIG_BT_SELFTEST) +=3D selftest.o
> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > new file mode 100644
> > index 000000000000..7609932c48ca
> > --- /dev/null
> > +++ b/net/bluetooth/msft.c
> > @@ -0,0 +1,16 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/* Copyright (C) 2020 Google Corporation */
> > +
> > +#include <net/bluetooth/bluetooth.h>
> > +#include <net/bluetooth/hci_core.h>
> > +
> > +#include "msft.h"
> > +
> > +void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)
> > +{
> > +     hdev->msft_opcode =3D opcode;
> > +
> > +     bt_dev_info(hdev, "Enabling MSFT extensions with opcode 0x%2.2x",
> > +                 hdev->msft_opcode);
> > +}
> > +EXPORT_SYMBOL(msft_set_opcode);
> > diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> > new file mode 100644
> > index 000000000000..7218ea759dde
> > --- /dev/null
> > +++ b/net/bluetooth/msft.h
> > @@ -0,0 +1,19 @@
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > +/* Copyright (C) 2020 Google Corporation */
> > +
> > +#ifndef __MSFT_H
> > +#define __MSFT_H
> > +
> > +#include <net/bluetooth/hci_core.h>
> > +
> > +#if IS_ENABLED(CONFIG_BT_MSFTEXT)
> > +
> > +void msft_set_opcode(struct hci_dev *hdev, __u16 opcode);
> > +
> > +#else
> > +
> > +static inline void msft_set_opcode(struct hci_dev *hdev, __u16 opcode)=
 {}
> > +
> > +#endif
> > +
> > +#endif /* __MSFT_H*/
Thanks,
Miao
