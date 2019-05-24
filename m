Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABABA29D95
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfEXR4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:56:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42953 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXR4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:56:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so10861018wrb.9;
        Fri, 24 May 2019 10:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WB6mvyC+JVnZd7zMcQh/gqdtDtbu3lgSONOBy+nJ5Ak=;
        b=ScJ3yLS9gwhM1VHwfsM8qrJOYEmre/pEdCzHs2vPomQ72/6ixwj5Q2aZFfpzaaRZ6z
         To30YvZMavQUTENMbi0U+obduB7597rsq0BqSOorKwbA1P1Ehh3eS6+dOIFWOLsQQLoX
         CTd9rNvmr/VpolTQa0MJPfaK9BtdUmfAG82mCIsAGGPylQRJMoQiAmjUPza8VcpHTyPt
         dpztb0UoRizCwoItPa63jgPicsjeu7gzdCmHHrR7w9j0Q+IU0r241YpGvxZNYoKOWJ2k
         5lCgTI0pgW8w8vhz3uVVu2JvxkKBu2L4v33vPUxQ7JuLXd2TLSFb35oASDed9onqSnvW
         j1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WB6mvyC+JVnZd7zMcQh/gqdtDtbu3lgSONOBy+nJ5Ak=;
        b=K+/hhKzn1ynAmtXpIy1+lJsX+GVRvL5xztgM0ExaOOD6o3kasz0E2WnuliYJ9FHV7e
         wCTTy9EpgWBPgxCaJNkSsY6x5oAylu+hcUkj+/bTrywa/vDjAg3/k+7jxnPPrcscWHTh
         HsePERDDKgj+oHh0bEIm/GYnGpDZ8bNF+vOE0IUBmMNjux496tSeXVdzcjs5W+JM4wLy
         FDB7OkKaJ8CMvi7XSXeNwCQVWxzb+GLo6apog2rq9aiv6EApK0kH9J9aA1BWfgsj+N2n
         ttI1JOMMbb66IVkVJP/6Ib+y/n23uDda39OezpDgMXo4w7xgGugOVjAqbq2scCyDUsGp
         PqAQ==
X-Gm-Message-State: APjAAAXf9gw5rnAS/iXn8cyWsx9G0lC2EBHHgzIsQI6QITDSuRvPELZh
        ffhTQ1RRTtv+1iDJ0/LfIxfRWc4v
X-Google-Smtp-Source: APXvYqxVCoHANdCz9gKAloT/0sEvb0FSEfiWh6j5MSH44DlW0n+kCHjbKKV8Z0nFLNGIoG35Tjjzew==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr222841wrs.291.1558720565961;
        Fri, 24 May 2019 10:56:05 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f? (p200300EA8BE97A00E8AA5F65936F3A1F.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:e8aa:5f65:936f:3a1f])
        by smtp.googlemail.com with ESMTPSA id y132sm4417953wmd.35.2019.05.24.10.56.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:56:05 -0700 (PDT)
Subject: Re: r8169: Link only up after 16 s (A link change request failed with
 some changes committed already. Interface enp3s0 may have been left with an
 inconsistent configuration, please check.)
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a05b0b6c-505c-db61-96ac-813e68a26cc6@molgen.mpg.de>
 <abb2d596-d9fe-5426-8f1d-2ef4a7eb9e1a@gmail.com>
 <48ad419a-65f4-40ca-d7a9-01fafee33d83@molgen.mpg.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5d25b4f3-20d3-6c93-2c0a-b95fde9e4c40@gmail.com>
Date:   Fri, 24 May 2019 19:55:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <48ad419a-65f4-40ca-d7a9-01fafee33d83@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2019 17:14, Paul Menzel wrote:
> Dear Heiner,
> 
> 
> Thank you for the quick reply.
> 
> On 05/23/19 19:44, Heiner Kallweit wrote:
>> On 23.05.2019 13:00, Paul Menzel wrote:
> 
>>> I optimized the Linux kernel configuration on my ASRock E350M1, and it now
>>> boots really fast.
>>>
>>> Unfortunately, that seems to cause the network driver to hit some corner
>>> case, so that the link is supposedly down, although it should be up. The
>>> cable is plugged in the whole time.
>>>
>>> ```
>>> [    2.990757] libphy: r8169: probed
>>> [    2.992661] r8169 0000:03:00.0 eth0: RTL8168e/8111e, bc:5f:f4:c8:d3:98, XID 2c2, IRQ 28
>>> [    2.992669] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>>> [    3.294484] usb 5-2: new low-speed USB device number 2 using ohci-pci
>>> [    3.458711] usb 5-2: New USB device found, idVendor=1241, idProduct=1122, bcdDevice= 1.00
>>> [    3.458718] usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    3.485065] input: HID 1241:1122 as /devices/pci0000:00/0000:00:12.0/usb5/5-2/5-2:1.0/0003:1241:1122.0001/input/input14
>>> [    3.485320] hid-generic 0003:1241:1122.0001: input,hidraw0: USB HID v1.00 Mouse [HID 1241:1122] on usb-0000:00:12.0-2/input0
>>> [    3.967622] random: crng init done
>>> [    3.967628] random: 7 urandom warning(s) missed due to ratelimiting
>>> [    4.323449] r8169 0000:03:00.0 enp3s0: renamed from eth0
>>> [    4.363774] RTL8211DN Gigabit Ethernet r8169-300:00: attached PHY driver [RTL8211DN Gigabit Ethernet] (mii_bus:phy_addr=r8169-300:00, irq=IGNORE)
>>> [    4.576887] r8169 0000:03:00.0 enp3s0: Link is Down
>>> [    4.577167] A link change request failed with some changes committed already. Interface enp3s0 may have been left with an inconsistent configuration, please check.
>>> [   16.377520] r8169 0000:03:00.0 enp3s0: Link is Up - 100Mbps/Full - flow control rx/tx
>>> [   16.377553] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link becomes ready
>>> ```
>>>
>>> It happens with all Linux kernels I tried. Please find all Linux
>>> messages attached.
>>>
>>> Could you please tell me, how this can be debugged and solved?
>>>
>> This warning is triggered by errors in do_setlink() in net/core/rtnetlink.c
>> I'd say:
>> 1. Which kernel config options did you change as part of the optimization?
>>    (If I understand you correctly the warning didn't pop up before.)
> 
> Sorry for being unclear. The same problem happens with Debian
> Sid/unstable’s default Linux kernel 4.19.0-5 (4.19.37) [1]. With the fast
> boot (six seconds from pressing power button to Weston) I just noticed, that
> the network was not set up when wanting to use it.
> 
>> 2. Try to find out which call in do_setlink() fails and which errno
>> is returned.
> 
> Yeah, that’s where I need help. ;-)
> 
> I applied the simple change below to `net/core/rtnetlink.c`.
> 
>                 if (err < 0)
> -                       net_warn_ratelimited("A link change request failed with some changes committed already. Interface %s may have been left with an inconsistent configuration, please check.\n",
> -                                            dev->name);
> +                       net_warn_ratelimited("A link change request failed with some changes committed already (err = %i). Interface %s may have been left with an inconsistent configuration, please check.\n",
> +                                            dev->name, err);
> 
> I get different results each time.
> 
> -304123904
> -332128256
> 
> Any idea, how that can happen?
> 
Instead of %i you should use %d, and the order of arguments needs to be reversed.
But this won't help you to find out which call in do_setlink() failed.
There are several occurrences of code like this:

err = fct();
if (err < 0)
	goto errout;

Best change each such occurrence to the following to find out which call failed.

err = fct();
if (err < 0) {
	pr_err("do_setlink: <fct>: err %d\n", err)
	goto errout;
}

> Is there a better way to debug `do_setlink()` in `rtnetlink.c` than
> printf debugging?
> 
Not really
> 
> Kind regards,
> 
> Paul
> 

