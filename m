Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7C2105B5F
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKUUw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:52:26 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42450 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:52:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so2329441pfh.9;
        Thu, 21 Nov 2019 12:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9U2qqaFTNnfIBTOta2W1cA2dziggMNyD+HUy1loDO1g=;
        b=nYjw7Uiz0QUJnKMqYM73GeL/nLoBRnqaXqU8DHfnykpLqPidcGO8FwsfzyjH4yCdSE
         DhuY1INHupxSRdcDu/vXKx5H7LV2vJkcNSFtIC57K0S/+VydXpvaglWt7F9sU9wBV+ws
         2uw5xKU3s6yiOZSTLWNcCndWy5AznenRaUcWHY7vhWQr7jsReUAPuwdsSVnQqN9K0sZ3
         HVAXW9Nv1jkxBD5F56IFniIVUHn04YtIiVy45vKf+5zclo1UGVUmHzgh859lRSWq7NHa
         ymBCA1kvoQGbjpc5jljm6E1MG3gwrz4IG2ef9DBScP8HbjqsOl+ABdumZSZnfIRKtw2y
         tr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9U2qqaFTNnfIBTOta2W1cA2dziggMNyD+HUy1loDO1g=;
        b=YwEHUCSiamM5rIz73d93Jt0XJHK1kvTU29xBiDHwV0F8cLTCMNEsrpqI7sGtpdNzTw
         m/Qa/+IKhwsYbO2F/XEOcSli3iYhmlSJ6fXg+7UImGhrT6PSuuF7PHRbytdGBUobRTNb
         OqiCiVHl0LTgyVRQAuw6EZjTlioiUl6WSDyHuBkATRI+vKklBB0J06kq9npO+IYxjA/i
         zBvZpr5+Q9iPMV2AYdBmrxshvmW2+lloPoj92r3WvTua8Rq7NJXlHCjLThuSDziabN4C
         NcrKH6e4aVyQg4Ogp9GGBC0GqltaEHqC5jlRPib4AJKdcjbYtCbxM1Xc2Lpz8MU8N1Hk
         4Kdw==
X-Gm-Message-State: APjAAAXwLZeSlX/lBJHGcMnJRYW9reXs6ZKeNf/WLiJ6DPmtR+bZSh+Y
        IXhRVOm8jyD1Pur+kQtxPJA=
X-Google-Smtp-Source: APXvYqyHrchtONXQoQmVbfSKMYMI1MDo9BkqRo9FOqVJDD6DMfOwkY7I3v4cwHDs/cWvqHFMnPOPTw==
X-Received: by 2002:a63:184c:: with SMTP id 12mr5247366pgy.418.1574369544598;
        Thu, 21 Nov 2019 12:52:24 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a29sm3887100pgd.12.2019.11.21.12.52.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Nov 2019 12:52:23 -0800 (PST)
Subject: Re: next/master bisection: boot on beaglebone-black
To:     "kernelci.org bot" <bot@kernelci.org>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, guillaume.tucker@collabora.com,
        Jouni Hogander <jouni.hogander@unikie.com>, broonie@kernel.org,
        khilman@baylibre.com, mgalka@collabora.com,
        enric.balletbo@collabora.com
Cc:     Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>
References: <5dd6d7d2.1c69fb81.48b6f.33f2@mx.google.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <4e43ed85-139f-d23f-96d1-a50b9fc56780@gmail.com>
Date:   Thu, 21 Nov 2019 12:52:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5dd6d7d2.1c69fb81.48b6f.33f2@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 10:30 AM, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> next/master bisection: boot on beaglebone-black
> 
> Summary:
>   Start:      9942eae47585 Add linux-next specific files for 20191121
>   Details:    https://kernelci.org/boot/id/5dd6696859b514303ecf550d
>   Plain log:  https://storage.kernelci.org//next/master/next-20191121/arm/multi_v7_defconfig/gcc-8/lab-baylibre/boot-am335x-boneblack.txt
>   HTML log:   https://storage.kernelci.org//next/master/next-20191121/arm/multi_v7_defconfig/gcc-8/lab-baylibre/boot-am335x-boneblack.html
>   Result:     b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       next
>   URL:        git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>   Branch:     master
>   Target:     beaglebone-black
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     multi_v7_defconfig
>   Test suite: boot
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit b8eb718348b8fb30b5a7d0a8fce26fb3f4ac741b
> Author: Jouni Hogander <jouni.hogander@unikie.com>
> Date:   Wed Nov 20 09:08:16 2019 +0200
> 
>     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
>     
>     kobject_init_and_add takes reference even when it fails. This has
>     to be given up by the caller in error handling. Otherwise memory
>     allocated by kobject_init_and_add is never freed. Originally found
>     by Syzkaller:
>     
>     BUG: memory leak
>     unreferenced object 0xffff8880679f8b08 (size 8):
>       comm "netdev_register", pid 269, jiffies 4294693094 (age 12.132s)
>       hex dump (first 8 bytes):
>         72 78 2d 30 00 36 20 d4                          rx-0.6 .
>       backtrace:
>         [<000000008c93818e>] __kmalloc_track_caller+0x16e/0x290
>         [<000000001f2e4e49>] kvasprintf+0xb1/0x140
>         [<000000007f313394>] kvasprintf_const+0x56/0x160
>         [<00000000aeca11c8>] kobject_set_name_vargs+0x5b/0x140
>         [<0000000073a0367c>] kobject_init_and_add+0xd8/0x170
>         [<0000000088838e4b>] net_rx_queue_update_kobjects+0x152/0x560
>         [<000000006be5f104>] netdev_register_kobject+0x210/0x380
>         [<00000000e31dab9d>] register_netdevice+0xa1b/0xf00
>         [<00000000f68b2465>] __tun_chr_ioctl+0x20d5/0x3dd0
>         [<000000004c50599f>] tun_chr_ioctl+0x2f/0x40
>         [<00000000bbd4c317>] do_vfs_ioctl+0x1c7/0x1510
>         [<00000000d4c59e8f>] ksys_ioctl+0x99/0xb0
>         [<00000000946aea81>] __x64_sys_ioctl+0x78/0xb0
>         [<0000000038d946e5>] do_syscall_64+0x16f/0x580
>         [<00000000e0aa5d8f>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>         [<00000000285b3d1a>] 0xffffffffffffffff
>     
>     Cc: David Miller <davem@davemloft.net>
>     Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
>     Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>

This should be fixed by Eric's patch here:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=48a322b6f9965b2f1e4ce81af972f0e287b07ed0
-- 
Florian
