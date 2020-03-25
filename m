Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E219333F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCYWCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:02:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44523 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgCYWCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:02:43 -0400
Received: by mail-lf1-f67.google.com with SMTP id j188so3133290lfj.11
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kMrdIcSekVyYpSUHbdn6aie/98pCO+vQsLQWmECU324=;
        b=dHdysE/SayM8kJkixhAFnl2T8s+GCoCy/QiD8wY91rB93D75s7yeO3ECQ/Q9l0EYlU
         UrA7ZXq61ksQ23EPDGiaXzoY3BcPTUuCZPI1jpU3rt/D1frfyvfylGMHY4nza8LF9CC1
         lhZjfgQkw5ctJ4wnBEhMYfyax+49IHetbc0UA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kMrdIcSekVyYpSUHbdn6aie/98pCO+vQsLQWmECU324=;
        b=W7ANZIEXJghvXCosBxFVSzOyjy+xHhmQW308J/Cfi04r5NKRCs6y0rRWuqrz6idzWf
         KleBedOkObOS4CYPji0CMpx8yAI7nzq5Y+NDbRmWTYbuGaY/2btn/bmsqbfr+KfwTYLb
         7XpTfLcU3riCaiJ3IWExAaPZL791+g7nUr/LSEJpul4YKHd0mTmbtnnStcV72CFtwR2W
         l3yiqOPpsywt361d74VnTBIK8nnWyl6Ez9pXTuNV1O8laO35YuSW5g70C8os2l5QwYnx
         VOM1QhR5kI5hYDT9xWAU41S/CvbkU5tVmauNnhae46Y/TIDUkhxISiPGoW0J+79p8v6k
         Y6iQ==
X-Gm-Message-State: ANhLgQ1Lls+vcSd4qwgs/JZCt1ah4g0LQC+g95o8sdXgUt7kwnDBDtrR
        PCWQVnLbhXmL+3Gbk3GlH7JLRHp/eNAxsIl+2ncITw==
X-Google-Smtp-Source: ADFU+vsg1qBWTCMyzYGdubeKJoXICpju2ZdEGKqP6lEFbMFIxAckyAFCowoTtdWPZKlEjRQLBIIrKmGxlGZ2d5NALH4=
X-Received: by 2002:a19:4f0c:: with SMTP id d12mr3632373lfb.117.1585173760630;
 Wed, 25 Mar 2020 15:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200325070336.1097-1-mcchou@chromium.org> <20200325000332.v2.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
 <72699110-843A-4382-8FF1-20C5D4D557A2@holtmann.org> <CABmPvSFL_bkrZQJkAzUMck_bAY5aBZkL=5HGV_Syv2QRYfRLfw@mail.gmail.com>
 <B2A2CFFE-8FC1-462B-9C7F-1CD584B6EB24@holtmann.org>
In-Reply-To: <B2A2CFFE-8FC1-462B-9C7F-1CD584B6EB24@holtmann.org>
From:   Miao-chen Chou <mcchou@chromium.org>
Date:   Wed, 25 Mar 2020 15:02:29 -0700
Message-ID: <CABmPvSFwb1zu33fUog9hVK6y2R=PmKeGyOwkP3+=ZzE_qkX9yQ@mail.gmail.com>
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

On Wed, Mar 25, 2020 at 2:37 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Miao-chen,
>
> >>> This adds a bit mask of driver_info for Microsoft vendor extension an=
d
> >>> indicates the support for Intel 9460/9560 and 9160/9260. See
> >>> https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> >>> microsoft-defined-bluetooth-hci-commands-and-events for more informat=
ion
> >>> about the extension. This was verified with Intel ThunderPeak BT cont=
roller
> >>> where msft_vnd_ext_opcode is 0xFC1E.
> >>>
> >>> Signed-off-by: Miao-chen Chou <mcchou@chromium.org>
> >>> ---
> >>>
> >>> Changes in v2:
> >>> - Define struct msft_vnd_ext and add a field of this type to struct
> >>> hci_dev to facilitate the support of Microsoft vendor extension.
> >>>
> >>> drivers/bluetooth/btusb.c        | 14 ++++++++++++--
> >>> include/net/bluetooth/hci_core.h |  6 ++++++
> >>> 2 files changed, 18 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> >>> index 3bdec42c9612..4c49f394f174 100644
> >>> --- a/drivers/bluetooth/btusb.c
> >>> +++ b/drivers/bluetooth/btusb.c
> >>> @@ -58,6 +58,7 @@ static struct usb_driver btusb_driver;
> >>> #define BTUSB_CW6622          0x100000
> >>> #define BTUSB_MEDIATEK                0x200000
> >>> #define BTUSB_WIDEBAND_SPEECH 0x400000
> >>> +#define BTUSB_MSFT_VND_EXT   0x800000
> >>>
> >>> static const struct usb_device_id btusb_table[] =3D {
> >>>      /* Generic Bluetooth USB device */
> >>> @@ -335,7 +336,8 @@ static const struct usb_device_id blacklist_table=
[] =3D {
> >>>
> >>>      /* Intel Bluetooth devices */
> >>>      { USB_DEVICE(0x8087, 0x0025), .driver_info =3D BTUSB_INTEL_NEW |
> >>> -                                                  BTUSB_WIDEBAND_SPE=
ECH },
> >>> +                                                  BTUSB_WIDEBAND_SPE=
ECH |
> >>> +                                                  BTUSB_MSFT_VND_EXT=
 },
> >>>      { USB_DEVICE(0x8087, 0x0026), .driver_info =3D BTUSB_INTEL_NEW |
> >>>                                                   BTUSB_WIDEBAND_SPEE=
CH },
> >>>      { USB_DEVICE(0x8087, 0x0029), .driver_info =3D BTUSB_INTEL_NEW |
> >>> @@ -348,7 +350,8 @@ static const struct usb_device_id blacklist_table=
[] =3D {
> >>>      { USB_DEVICE(0x8087, 0x0aa7), .driver_info =3D BTUSB_INTEL |
> >>>                                                   BTUSB_WIDEBAND_SPEE=
CH },
> >>>      { USB_DEVICE(0x8087, 0x0aaa), .driver_info =3D BTUSB_INTEL_NEW |
> >>> -                                                  BTUSB_WIDEBAND_SPE=
ECH },
> >>> +                                                  BTUSB_WIDEBAND_SPE=
ECH |
> >>> +                                                  BTUSB_MSFT_VND_EXT=
 },
> >>>
> >>>      /* Other Intel Bluetooth devices */
> >>>      { USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
> >>> @@ -3734,6 +3737,8 @@ static int btusb_probe(struct usb_interface *in=
tf,
> >>>      hdev->send   =3D btusb_send_frame;
> >>>      hdev->notify =3D btusb_notify;
> >>>
> >>> +     hdev->msft_ext.opcode =3D HCI_OP_NOP;
> >>> +
> >>
> >> do this in the hci_alloc_dev procedure for every driver. This doesn=E2=
=80=99t belong in the driver.
> > Thanks for the note, I will address this.
> >>
> >>> #ifdef CONFIG_PM
> >>>      err =3D btusb_config_oob_wake(hdev);
> >>>      if (err)
> >>> @@ -3800,6 +3805,11 @@ static int btusb_probe(struct usb_interface *i=
ntf,
> >>>              set_bit(HCI_QUIRK_STRICT_DUPLICATE_FILTER, &hdev->quirks=
);
> >>>              set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks)=
;
> >>>              set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> >>> +
> >>> +             if (id->driver_info & BTUSB_MSFT_VND_EXT &&
> >>> +                     (id->idProduct =3D=3D 0x0025 || id->idProduct =
=3D=3D 0x0aaa)) {
> >>
> >> Please scrap this extra check. You already selected out the PID with t=
he blacklist_table. In addition, I do not want to add a PID in two places i=
n the driver.
> > If we scrap the check around idProduct, how do we tell two controllers
> > apart if they use different opcode for Microsoft vendor extension?
>
> for Intel controllers this is highly unlikely. If we really decide to cha=
nge the opcode in newer firmware versions, we then deal with it at that poi=
nt.
>
> However for Intel controllers I have the feeling that we better do it aft=
er the Read the Intel version information and then do it based on hardware =
revision and firmware version.
I would agree with you given that the FW loaded for the same HW can
differ, and different FW version may have different configuration in
terms of the use of extensions. But it's not clear to me how we can
tell whether an extension is supported based on a version number. Is
there any implication on the support of an extension given a FW
version (e.g. any FW version greater than 10 would support MSFT
extension)?
>
> >> An alternative is to not use BTUSB_MSFT_VND_EXT and let the Intel code=
 set it based on the hardware / firmware revision it finds. We might need t=
o discuss which is the better approach for the Intel hardware since not all=
 PIDs are unique.
> > We are expecting to indicate the vendor extension for non-Intel
> > controllers as well, and having BTUSB_MSFT_VND_EXT seems to be more
> > generic. What do you think?
>
> We don=E2=80=99t have to have one specific way of doing it. As I said, if=
 we ever have Zephyr based controller with MSFT extension, we have a vendor=
 command to determine the support and the opcode. So that will not require =
any extra quirks or alike.
>
> Anyhow, maybe we introduce BTUSB_MSFT_VND_EXT_FC1E that just says set the=
 opcode to FC1E. For all other opcodes we will introduce similar constants.=
 At most I assume we end up with 5-6 constants.
>
> >>
> >>> +                     hdev->msft_ext.opcode =3D 0xFC1E;
> >>> +             }
> >>>      }
Regards,
Miao
