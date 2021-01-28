Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6730804A
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhA1VKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:10:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1VKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:10:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 04E7D64D9E;
        Thu, 28 Jan 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611868210;
        bh=ooiSAea0QPOd1AfSxSbsAPnrr7JSugPcfNr5usJZyVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2GWINlarbUp4rMq2iwRGr7Xd8se8WQvtbwS7nEsNUtEF0vmzOAQj42RQ8n80dAcR
         b+ETjCeHgU/y6XSOsDCTsMaaMjG8laBExlVkxxP1/MyIciLo/D9ll00YXk+uFaFewB
         +lSdLk++SzUvm+WInU4ddAU6GTM3geMuLr8rDcKpd9Hpqb2AwnFl6Ej16dOf95UtbV
         mWuVQRJ8dXDrF6rBWdyE1bGRDIZkHOnr2VW/JIXAE7sN3O8vzNnXHu+4GmWCOfL91x
         CVCioiupKdxg5ibWsLzOT0STENNtkzkOQt37EHvGyMrphbdILGgmJgCA86YgW4YvjB
         qFa6qRxOrW8tQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E684B6530E;
        Thu, 28 Jan 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: cdc_ether: added support for Thales Cinterion PLSx3
 modem family.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161186820993.20635.15989337693774271219.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 21:10:09 +0000
References: <20210126044245.8455-1-gciofono@gmail.com>
In-Reply-To: <20210126044245.8455-1-gciofono@gmail.com>
To:     Giacinto Cifelli <gciofono@gmail.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 26 Jan 2021 05:42:45 +0100 you wrote:
> lsusb -v for this device:
> 
> Bus 003 Device 007: ID 1e2d:0069
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 ?
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x1e2d
>   idProduct          0x0069
>   bcdDevice            0.00
>   iManufacturer           4 Cinterion Wireless Modules
>   iProduct                3 PLSx3
>   iSerial                 5 fa3c1419
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          352
>     bNumInterfaces         10
>     bConfigurationValue     1
>     iConfiguration          2 Cinterion Configuration
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
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         8
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       0
>       bFunctionProtocol       0
>       iFunction               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        8
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      6 Ethernet Networking
>       bInterfaceProtocol      0
>       iInterface              0
>       CDC Header:
>         bcdCDC               1.10
>       CDC Ethernet:
>         iMacAddress                      1 00A0C6C14190
>         bmEthernetStatistics    0x00000000
>         wMaxSegmentSize              16384
>         wNumberMCFilters            0x0001
>         bNumberPowerFilters              0
>       CDC Union:
>         bMasterInterface        8
>         bSlaveInterface         9
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
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        9
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        9
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 Unused
>       bInterfaceProtocol      0
>       iInterface              0
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
> [...]

Here is the summary with links:
  - net: usb: cdc_ether: added support for Thales Cinterion PLSx3 modem family.
    https://git.kernel.org/netdev/net/c/dad3a72f5eec

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


