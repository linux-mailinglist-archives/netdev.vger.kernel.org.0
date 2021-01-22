Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85BE2FF9D0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbhAVBKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:10:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbhAVBKj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:10:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9C7C20799;
        Fri, 22 Jan 2021 01:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611277798;
        bh=OUiXDScSbgPJFPkrGTP9D/DyAZv3BTnXVdfiVjRnH94=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a18XuGDnA37KYIB1AH8lAJN/6gQJ26HALHcCFqFQleJnFW5D7jDeLS0mvb/TsBKD1
         8zqjgqkv1+MTtYD/K61cKPgnoMLyKYDQk1/jy4NWSshRLOrna4E8e68wJ1raxOKX5g
         uOTP9ZBE9nWVJ67s6G4AKPCZfegQG285BFkjhWWPi2a4ZVK6KLEgkT/+xPcumoG3W1
         49rbEJPzV/vShSVptgxjtgSdJDzGLuVeBStMIjG2E/fuaQWOvdSQNljstyoh5KSvfX
         xSv+qWtq3Bk3b27OzAPQA1GbW4kvuzaEeHXH+/SVrDUg+4dpVRyaKMIM1nQ0RBpkn/
         2kMXfZQ3aaClA==
Date:   Thu, 21 Jan 2021 17:09:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Giacinto Cifelli <gciofono@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: qmi_wwan: added support for Thales
 Cinterion PLSx3 modem family
Message-ID: <20210121170957.49ed2513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210120045650.10855-1-gciofono@gmail.com>
References: <20210120045650.10855-1-gciofono@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn, I think this was posted before you pointed out the missing CCs
and Giacinto didn't repost.

Looks good?

On Wed, 20 Jan 2021 05:56:50 +0100 Giacinto Cifelli wrote:
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
> 
> Notes:
>     changelog:
>         v2: removed unneeded line: {QMI_FIXED_INTF(0x1e2d, 0x006f, 8)}
> 
>  drivers/net/usb/qmi_wwan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index af19513a9f75..cc4819282820 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1302,6 +1302,7 @@ static const struct usb_device_id products[] = {
>  	{QMI_FIXED_INTF(0x0b3c, 0xc00a, 6)},	/* Olivetti Olicard 160 */
>  	{QMI_FIXED_INTF(0x0b3c, 0xc00b, 4)},	/* Olivetti Olicard 500 */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0060, 4)},	/* Cinterion PLxx */
> +	{QMI_QUIRK_SET_DTR(0x1e2d, 0x006f, 8)}, /* Cinterion PLS83/PLS63 */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0053, 4)},	/* Cinterion PHxx,PXxx */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0063, 10)},	/* Cinterion ALASxx (1 RmNet) */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0082, 4)},	/* Cinterion PHxx,PXxx (2 RmNet) */

