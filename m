Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D037D482D21
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 00:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiABXWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 18:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiABXWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 18:22:08 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69C1C061761
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 15:22:07 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w20so57764781wra.9
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 15:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MacweqI6v8X4KTBsSw+nOUjE7F6SVOZ8dI3NpFgpKFk=;
        b=e89DUXUwq07OgqOCKKN5jleoxvX0zyS7yfnU5gCwcQhkeqd3N0feVI/tE0KHNJucqQ
         ydP7DiSJH79ogVZPvYfkrehT8PPUi/z94NiUChD5CicnF52hwOZ7jfBzBqq2MqBhJKZf
         zFLUrdAJRYQtR/+kUUCeqJTO+Cad9ZIkMamCbzV5PPg69Ue0Im7T9d4hu6VIlwRtKaUu
         8G/LPhGjc5/2+dKYfCB9y30eYvvEJq4AtsSb6bpHPjhDv4LpQdDU8Iw5IwzYv1HtmOys
         Jit53nNe1II+yCNbQoVnPDh4X1hPjIdSc8Jd8rwBAw+EYmrr72n8Ox4IQay5im0w5/TQ
         nIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MacweqI6v8X4KTBsSw+nOUjE7F6SVOZ8dI3NpFgpKFk=;
        b=6u7XaFraa9Ewmh6qJBJc/vTlGMXDjtXp8fPDcblhwVNnT2UuKQvGVVrMsBB1tu5pzG
         joTteREWgOphtyeQXUUBJqBk9N65fCztbdhdOODlSZ2kvCeTeLEpAFdafWjky9wuoLQ7
         h4wCTPZ4IaKPXs2V00yUIdJv32vy4IHrvls8fNKIyn5V2hhR2jeMKS/JqtQ6CWRcX528
         RpbdmnX242VdRxWMuPgEnJwVEVReOdr5+A+Ysxwbec8qPsZv7S82Ajk/n+K3q2kz9m02
         HssSx9FNRs5Hpp5tOp+k4rkXmy7vV7NEnTfxWLNsBSGS3jiP1y1HrSD7fm4hKqOH3Dtq
         YPug==
X-Gm-Message-State: AOAM532wXRAa/8kSkFR7tokK7q9cYec1lt9sElLBhZ5XGKaBRvef4du6
        g4tcN/0B+pMawcVovyLhB4A=
X-Google-Smtp-Source: ABdhPJx/4Zof9TF44AFOnLUyUezYqtnG4UjF8QqPU6RJ3/ByQISz0KbWFlQGAXfn7iCCz2AcYmgIrw==
X-Received: by 2002:adf:9d84:: with SMTP id p4mr36993719wre.188.1641165726365;
        Sun, 02 Jan 2022 15:22:06 -0800 (PST)
Received: from [192.168.189.213] (ppp-88-217-87-205.dynamic.mnet-online.de. [88.217.87.205])
        by smtp.googlemail.com with ESMTPSA id o10sm24144290wmq.31.2022.01.02.15.22.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jan 2022 15:22:06 -0800 (PST)
Message-ID: <d16086d7-9998-57e2-8c77-fb34b7631886@googlemail.com>
Date:   Mon, 3 Jan 2022 00:21:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Ryan Lahfa <ryan@lahfa.xyz>
Cc:     netdev@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>
References: <20211224203018.z2n7sylht47ownga@Thors>
 <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Andreas Seiderer <x64multicore@googlemail.com>
In-Reply-To: <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Dec 2021 03:21 Jakub Kicinski wrote:
> On Fri, 24 Dec 2021 21:30:18 +0100 Ryan Lahfa wrote:
>> Hi all,
>>
>> I recently bought an USB-C 2.5Gbps external network card, which shows in
>> `lsusb` as:
>>
>>> Bus 002 Device 003: ID 0bda:8156 Realtek Semiconductor Corp. USB 10/100/1G/2.5G LAN
>> By default, on my distribution (NixOS "21.11pre319254.b5182c214fa")'s
>> latest kernel (`pkgs.linuxPackages_latest`) which shows in `uname -nar`
>> as:
>>
>>> Linux $machine 5.15.10 #1-NixOS SMP Fri Dec 17 09:30:17 UTC 2021 x86_64 GNU/Linux
>> The network card is loaded with `cdc_ncm` driver and is unable to detect
>> any carrier even when one is actually plugged in, I tried multiple
>> things, I confirmed independently that the carrier is working.
>>
>> Through further investigations and with the help of a user on
>> Libera.Chat #networking channel, we blacklisted `cdc_ncm`, but nothing
>> get loaded in turn.
>>
>> Then, I forced the usage of r8152 for the device 0bda:8156 using `echo
>> 0bda 8156 > /sys/bus/usb/drivers/r8152/new_id`, and... miracle.
>> Everything just worked.
>>
>> I am uncertain whether this falls in kernel's responsibility or not, it
>> seems indeed that my device is listed for r8152: https://github.com/torvalds/linux/blob/master/drivers/net/usb/r8152.c#L9790 introduced by this commit https://github.com/torvalds/linux/commit/195aae321c829dd1945900d75561e6aa79cce208 if I understand well, which is tagged for 5.15.
>>
>> I am curious to see how difficult would that be to write a patch for
>> this and fix it, meanwhile, here is my modest contribution with this bug
>> report, hopefully, this is the right place for them.
> Can you please share the output of lsusb -d '0bda:8156' -vv ?
>
> Adding Hayes to the CC list.
>

Hi,

I recently faced a similar problem and it could be caused by some energy 
saving function of TLP. Please see the solution at: 
https://forum.manjaro.org/t/no-carrier-network-link-problem-with-usb-2-5-gbit-lan-adapter-realtek-rtl8156b-on-x86-64/97195

I hope this is helpful for you.


Best regards,

Andreas Seiderer


PS: I post you the output of lsusb of my LAN adapter (MAC address 
changed) if you still need it:

Bus 002 Device 002: ID 0bda:8156 Realtek Semiconductor Corp. USB 
10/100/1G/2.5G LAN
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               3.20
   bDeviceClass            0
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0         9
   idVendor           0x0bda Realtek Semiconductor Corp.
   idProduct          0x8156
   bcdDevice           31.00
   iManufacturer           1 Realtek
   iProduct                2 USB 10/100/1G/2.5G LAN
   iSerial                 6 001000001
   bNumConfigurations      3
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0039
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              256mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           3
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol      0
       iInterface              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0002  1x 2 bytes
         bInterval              11
         bMaxBurst               0
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0068
     bNumInterfaces          2
     bConfigurationValue     2
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              256mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         2 Communications
       bInterfaceSubClass     13
       bInterfaceProtocol      0
       iInterface              5 CDC Communications Control
       CDC Header:
         bcdCDC               1.10
       CDC Union:
         bMasterInterface        0
         bSlaveInterface         1
       CDC Ethernet:
         iMacAddress                      3 00E04CXXXXXX
         bmEthernetStatistics    0x0031501f
         wMaxSegmentSize               1518
         wNumberMCFilters            0x8000
         bNumberPowerFilters              0
       CDC NCM:
         bcdNcmVersion        1.00
         bmNetworkCapabilities 0x2b
           8-byte ntb input size
           max datagram size
           net address
           packet filter
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval              11
         bMaxBurst               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0
       bInterfaceProtocol      1
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0
       bInterfaceProtocol      1
       iInterface              4 Ethernet Data
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength       0x0062
     bNumInterfaces          2
     bConfigurationValue     3
     iConfiguration          0
     bmAttributes         0xa0
       (Bus Powered)
       Remote Wakeup
     MaxPower              256mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         2 Communications
       bInterfaceSubClass      6 Ethernet Networking
       bInterfaceProtocol      0
       iInterface              5 CDC Communications Control
       CDC Header:
         bcdCDC               1.10
       CDC Union:
         bMasterInterface        0
         bSlaveInterface         1
       CDC Ethernet:
         iMacAddress                      3 00E04CXXXXXX
         bmEthernetStatistics    0x0031501f
         wMaxSegmentSize               1518
         wNumberMCFilters            0x8000
         bNumberPowerFilters              0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0010  1x 16 bytes
         bInterval              11
         bMaxBurst               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           0
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       1
       bNumEndpoints           2
       bInterfaceClass        10 CDC Data
       bInterfaceSubClass      0
       bInterfaceProtocol      0
       iInterface              4 Ethernet Data
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0400  1x 1024 bytes
         bInterval               0
         bMaxBurst               3
Binary Object Store Descriptor:
   bLength                 5
   bDescriptorType        15
   wTotalLength       0x0016
   bNumDeviceCaps          2
   USB 2.0 Extension Device Capability:
     bLength                 7
     bDescriptorType        16
     bDevCapabilityType      2
     bmAttributes   0x00000002
       HIRD Link Power Management (LPM) Supported
   SuperSpeed USB Device Capability:
     bLength                10
     bDescriptorType        16
     bDevCapabilityType      3
     bmAttributes         0x02
       Latency Tolerance Messages (LTM) Supported
     wSpeedsSupported   0x000e
       Device can operate at Full Speed (12Mbps)
       Device can operate at High Speed (480Mbps)
       Device can operate at SuperSpeed (5Gbps)
     bFunctionalitySupport   2
       Lowest fully-functional device speed is High Speed (480Mbps)
     bU1DevExitLat          10 micro seconds
     bU2DevExitLat        2047 micro seconds
can't get debug descriptor: Resource temporarily unavailable
Device Status:     0x0000
   (Bus Powered)


