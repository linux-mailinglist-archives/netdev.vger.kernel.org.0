Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB5D304CB0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 23:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbhAZWxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 17:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbhAZEst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:48:49 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BE5C06178C;
        Mon, 25 Jan 2021 20:46:20 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id j138so8084533vsd.8;
        Mon, 25 Jan 2021 20:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=IP5M4PN/Nn91tAnkvr99hv7pCevUNHFRjS0aESbP1hM=;
        b=sJDHODnxIsF4ZEOrGtN76gJWjOS+YzZEg5vodXb8PmTgEIMI39CTtB0nfvCc58Jk/T
         fHHgLj+S8/IbJY4bABaeOfRgO2RSJUpCxlEiveJZHBrnV9TFza9pZXkiViHWxUPuGhtA
         WSA7aL9weHevu/BXTmi6QAnisBKGafX6pPQj7do2RBU2+s2SJ5WD+1VC06ymV4KG2+/b
         EwoBwf/OFk/l2cnM1RbER7e0E6lIq89UuWYnTnbctd20Z7JaM2ccZHnfjhpBIOvlUx1k
         yEVPXdo+YFH6+Ak3RvBIRstjVKUU1acSS+bxFhdWyiSVnW61yXnybrJhnQVze6t/oICW
         PnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=IP5M4PN/Nn91tAnkvr99hv7pCevUNHFRjS0aESbP1hM=;
        b=O9CokB4694sPT/P+4Fd+4dVByqujin3yCYox5ibs287bSRZdQi94sCkuNI76CpYjFN
         6EnydMDxWqnOTOLbnNLsHpGtwiFygm7tw4lxJQ17fksaiTtN+7n2HzVUKyAhNWBh2drJ
         HYlnY/8ePnIjCo1NQdJ09jzcdVYnSqFo9O1lq7ftJiNLggHQcSxzn0PuN3O2m8lGRggD
         hdgsuP4GXUUg/o5rpUIIHt2xxlLUeySgWLjxAouZjJ31MYjJsTlQ/KmoVgv6u/s/OkrM
         dkcpnkbWJOKEw1aXyEmziyDFcXjwS2E/3SRCIHW0mO/KcebAke8OD6DS6UYVRrmIm4jc
         C37g==
X-Gm-Message-State: AOAM532cUQ/QqPczxPJKk5+TX84P7P6Gsy6YfTuxEUZrDqKwB0iwQMlF
        WIrBFVRsrlnEt1llvKxCOo4GNYZmfgQepIaGIs/3xWrD
X-Google-Smtp-Source: ABdhPJwX3LgNBi2vYzJ5dL11y26QQqXOTALIn3e9C3h7YKyWB86d/iyh5PfHPQz2pzmbiIep+fvDsFCo3zTanGniwFM=
X-Received: by 2002:a05:6102:3017:: with SMTP id s23mr351158vsa.37.1611636379510;
 Mon, 25 Jan 2021 20:46:19 -0800 (PST)
MIME-Version: 1.0
References: <20210126044155.8348-1-gciofono@gmail.com>
In-Reply-To: <20210126044155.8348-1-gciofono@gmail.com>
From:   Giacinto Cifelli <gciofono@gmail.com>
Date:   Tue, 26 Jan 2021 05:46:08 +0100
Message-ID: <CAKSBH7H3Oqp3xLOcxwgRk8MXoOqM8fqFV=Uk5wtSKjruwDeMnA@mail.gmail.com>
Subject: Re: [PATCH] net: usb: qmi_wwan: added support for Thales Cinterion
 PLSx3 modem family
To:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear all,

please ignore this.  I have sent the wrong patch.  This one, in v2, I
am told that has been applied already.
Apologies again.

Kind Regards,
Giacinto


On Tue, Jan 26, 2021 at 5:42 AM Giacinto Cifelli <gciofono@gmail.com> wrote:
>
> Bus 003 Device 009: ID 1e2d:006f
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x1e2d
>   idProduct          0x006f
>   bcdDevice            0.00
>   iManufacturer           3 Cinterion Wireless Modules
>   iProduct                2 PLSx3
>   iSerial                 4 fa3c1419
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          303
>     bNumInterfaces          9
>     bConfigurationValue     1
>     iConfiguration          1 Cinterion Configuration
>     bmAttributes         0xe0
>       Self Powered
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         0
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       2 Abstract (modem)
>       bFunctionProtocol       1 AT-commands (v.25ter)
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      2 Abstract (modem)
>       bInterfaceProtocol      1 AT-commands (v.25ter)
>       iInterface              0
>       CDC Header:
>         bcdCDC               1.10
>       CDC ACM:
>         bmCapabilities       0x02
>           line coding and serial state
>       CDC Call Management:
>         bmCapabilities       0x03
>           call management
>           use DataInterface
>         bDataInterface          1
>       CDC Union:
>         bMasterInterface        0
>         bSlaveInterface         1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         2
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       2 Abstract (modem)
>       bFunctionProtocol       1 AT-commands (v.25ter)
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      2 Abstract (modem)
>       bInterfaceProtocol      1 AT-commands (v.25ter)
>       iInterface              0
>       CDC Header:
>         bcdCDC               1.10
>       CDC ACM:
>         bmCapabilities       0x02
>           line coding and serial state
>       CDC Call Management:
>         bmCapabilities       0x03
>           call management
>           use DataInterface
>         bDataInterface          3
>       CDC Union:
>         bMasterInterface        2
>         bSlaveInterface         3
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         4
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       2 Abstract (modem)
>       bFunctionProtocol       1 AT-commands (v.25ter)
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        4
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      2 Abstract (modem)
>       bInterfaceProtocol      1 AT-commands (v.25ter)
>       iInterface              0
>       CDC Header:
>         bcdCDC               1.10
>       CDC ACM:
>         bmCapabilities       0x02
>           line coding and serial state
>       CDC Call Management:
>         bmCapabilities       0x03
>           call management
>           use DataInterface
>         bDataInterface          5
>       CDC Union:
>         bMasterInterface        4
>         bSlaveInterface         5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        5
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x86  EP 6 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         6
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       2 Abstract (modem)
>       bFunctionProtocol       1 AT-commands (v.25ter)
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        6
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      2 Abstract (modem)
>       bInterfaceProtocol      1 AT-commands (v.25ter)
>       iInterface              0
>       CDC Header:
>         bcdCDC               1.10
>       CDC ACM:
>         bmCapabilities       0x02
>           line coding and serial state
>       CDC Call Management:
>         bmCapabilities       0x03
>           call management
>           use DataInterface
>         bDataInterface          7
>       CDC Union:
>         bMasterInterface        6
>         bSlaveInterface         7
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x87  EP 7 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        7
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x88  EP 8 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        8
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x89  EP 9 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x8a  EP 10 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x05  EP 5 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
>
> Signed-off-by: Giacinto Cifelli <gciofono@gmail.com>
> ---
>  drivers/net/usb/qmi_wwan.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index af19513a9f75..262d19439b34 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1302,6 +1302,8 @@ static const struct usb_device_id products[] = {
>         {QMI_FIXED_INTF(0x0b3c, 0xc00a, 6)},    /* Olivetti Olicard 160 */
>         {QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},    /* Olivetti Olicard 500 */
>         {QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},    /* Cinterion PLxx */
> +       {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)},    /* Cinterion PLS83/PLS63 */
> +       {QMI_QUIRK_SET_DTR(0x1e2d, 0x006f, 8)},
>         {QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},    /* Cinterion PHxx,PXxx */
>         {QMI_FIXED_INTF(0x1e2d, 0x0063, 10)},   /* Cinterion ALASxx (1 RmNet) */
>         {QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},    /* Cinterion PHxx,PXxx (2 RmNet) */
> --
> 2.17.1
>
