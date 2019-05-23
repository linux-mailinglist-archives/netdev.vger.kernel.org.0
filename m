Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3803E2853A
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731432AbfEWRpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:45:07 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35063 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730899AbfEWRpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:45:07 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so542808wmi.0;
        Thu, 23 May 2019 10:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vuxVMAWDY8cHqFufnZqQDPDTejTS+OO13eju916wpAM=;
        b=vI2eAyq9hKq3yUb8UJwbCHWls1VGJxRoodfP5z/Amr8kMKr36po8hAhqBGAnkouHaF
         afZ8awEuD5giCGcI0q/4bI/KHvjtqhVdfhgcThVvn872EYmcSqrgEcBBOpXtcdJBi5w7
         IxQBguL/jHZK2AFghT+H6ZmwRI3akQrcUcxyIbQzpK1Od66MWiyvWNCslZ0sZ4O5PVcP
         f2LAS6nZbcCk4e5vtd9tcYYli8P8H0d+f/JpoOz6CQHafLaz7Zv+olNGZoAHk3UErGa6
         ko5zawNE1pAVoAiKIZk0/M17jEK6BWm758t13RTckNgmozGqh2P1PEIEZ5jM33dj1g1b
         7wcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vuxVMAWDY8cHqFufnZqQDPDTejTS+OO13eju916wpAM=;
        b=TJq8x1TArYNjYuDoWNj6e3EgaIfJRihLaeKFqsQNbQNstwRypv0q6YD6F5l+IibOmx
         BpeYKVf2MMhNGg60CYj+cWtSi9hiH+c1h5vL2yncafLQKy/UEuSyYdAp8IFWwO/oiPYE
         1Qmp4lC6b5XdUTuMg3lgnPFgUpZODDBTziSUC4kOhhAH6Gf1PqW5dEL6+jfmjYKjWKxB
         X+uW2L4LtYq8FSQZ5XszLDyh5/nDDEBFrGvfdArDdlLlMXoyx7YykKLDEKy6fihdfkIB
         oWxuwohYuwnhfylXvASLaaOu2LFxDibsa2bP9+t3vDuf4VGkPj8N1k3M9KbuUipOyF6+
         cAcw==
X-Gm-Message-State: APjAAAXiRbHVpPZIX2hrZAtAtu28+0+khtAqOxP3ce3rPWp+xfDatAaY
        gHcyMb54MByxUKOJ4i2TuxBsYiCq
X-Google-Smtp-Source: APXvYqxNJqc/gQ7grU9j6U0zREsGXnv+Lf9QVw3rz191xYvNdZT5fQgdkL2G2wKSyuaEs7TrBgJ8LA==
X-Received: by 2002:a1c:1d4:: with SMTP id 203mr13794857wmb.76.1558633503852;
        Thu, 23 May 2019 10:45:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0? (p200300EA8BE97A003CD1E8FED810B3F0.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:3cd1:e8fe:d810:b3f0])
        by smtp.googlemail.com with ESMTPSA id n2sm5676383wro.13.2019.05.23.10.45.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 10:45:03 -0700 (PDT)
Subject: Re: r8169: Link only up after 16 s (A link change request failed with
 some changes committed already. Interface enp3s0 may have been left with an
 inconsistent configuration, please check.)
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a05b0b6c-505c-db61-96ac-813e68a26cc6@molgen.mpg.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <abb2d596-d9fe-5426-8f1d-2ef4a7eb9e1a@gmail.com>
Date:   Thu, 23 May 2019 19:44:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a05b0b6c-505c-db61-96ac-813e68a26cc6@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.05.2019 13:00, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> I optimized the Linux kernel configuration on my ASRock E350M1, and it now
> boots really fast.
> 
> Unfortunately, that seems to cause the network driver to hit some corner
> case, so that the link is supposedly down, although it should be up. The
> cable is plugged in the whole time.
> 
> ```
> [    2.990757] libphy: r8169: probed
> [    2.992661] r8169 0000:03:00.0 eth0: RTL8168e/8111e, bc:5f:f4:c8:d3:98, XID 2c2, IRQ 28
> [    2.992669] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    3.294484] usb 5-2: new low-speed USB device number 2 using ohci-pci
> [    3.458711] usb 5-2: New USB device found, idVendor=1241, idProduct=1122, bcdDevice= 1.00
> [    3.458718] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    3.485065] input: HID 1241:1122 as /devices/pci0000:00/0000:00:12.0/usb5/5-2/5-2:1.0/0003:1241:1122.0001/input/input14
> [    3.485320] hid-generic 0003:1241:1122.0001: input,hidraw0: USB HID v1.00 Mouse [HID 1241:1122] on usb-0000:00:12.0-2/input0
> [    3.967622] random: crng init done
> [    3.967628] random: 7 urandom warning(s) missed due to ratelimiting
> [    4.323449] r8169 0000:03:00.0 enp3s0: renamed from eth0
> [    4.363774] RTL8211DN Gigabit Ethernet r8169-300:00: attached PHY driver [RTL8211DN Gigabit Ethernet] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
> [    4.576887] r8169 0000:03:00.0 enp3s0: Link is Down
> [    4.577167] A link change request failed with some changes committed already. Interface enp3s0 may have been left with an inconsistent configuration, please check.
> [   16.377520] r8169 0000:03:00.0 enp3s0: Link is Up - 100Mbps/Full - flow control rx/tx
> [   16.377553] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready
> ```
> 
> It happens with all Linux kernels I tried. Please find all Linux
> messages attached.
> 
> Could you please tell me, how this can be debugged and solved?
> 
This warning is triggered by errors in do_setlink() in net/core/rtnetlink.c
I'd say:
1. Which kernel config options did you change as part of the optimization?
   (If I understand you correctly the warning didn't pop up before.)
2. Try to find out which call in do_setlink() fails and which errno is returned.

> 
> Kind regards,
> 
> Paul
> 
Heiner
