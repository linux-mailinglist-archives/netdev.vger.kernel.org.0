Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0BFF132DF1
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgAGSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 13:06:11 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55393 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbgAGSGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 13:06:11 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so490684wmj.5;
        Tue, 07 Jan 2020 10:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TwyqbtixwfDzppKFaI3w4i8nG7c7b8pJMNXC0vFuA/8=;
        b=hak7QrKONk+QHhTwUiKGycoyKENk56hZB0bxZmV2lrgltNbvfPhNC4tW4nfoO/cYK7
         RIYJYjgSjF9JFvo1U7FkNnuOdKL7Msh3IPwaMY4eyAjKcGrsE/d4TvxKIXBmLc/aquJj
         2UotjacloQrE872HHQA65Q5aLRuuEr23wdXztDdnhAKtRrZlXGBqC0sB8QfWwZpT0/gt
         LDVf95slcQa31IcX9SDh8cHSnvM9X8CjlUrs8dDwFMg0iJAlC/whWX0h6g2ZhJutttxX
         9sLbEfpBZtLyy5XMGUyhDCufkUBLQE4kirrJwNn6qnD4hHcQuMOpppKOnDlgrb/9uH6s
         M0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TwyqbtixwfDzppKFaI3w4i8nG7c7b8pJMNXC0vFuA/8=;
        b=bU3wtok7EGHlawC341i0yYaPbCBwP5X6FrcbnkbQp1aaS/b5xdeejCQbY7rVIaratv
         RJ2X9Ip/K89uD89RDTjqqGTn/WVykgHh14gAz7o3B38RMy5yf47McEksyU/ehiYW5955
         0sRMe2yrSNK27DqtWC8DS2fmSSgA7zgn75//8kxzdAgUvK2aDLpjXDa+8QvfSlzh8fCV
         eSJ2hygIDsC5q9n5fmnfj4jYDPbDIzHAhDT1f4CPKpVJvDz6UsJNA12N0cZVGfPEh8dw
         RX1uyXBhrZeYaKdhkV+WtnY+s7kTmlidi3sPoSjQmm/utpxgM+nPoIEXiCt1tC96rt3R
         1kaA==
X-Gm-Message-State: APjAAAWPXBTxNZMXvjiL53zk+Ynovk1XsphBsWCGpyaHqQLLC7tuAEfH
        ajsheDmmM1SuLEkQJQoAjWaiZzv0
X-Google-Smtp-Source: APXvYqxEBb32tYns6M/I4BzfkOxhu71xtZitfjJweSdd+xVfOkC3VOJNBWhZ3FAHzZWRTdjujr8yLg==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr286431wmc.47.1578420369265;
        Tue, 07 Jan 2020 10:06:09 -0800 (PST)
Received: from [192.168.8.147] (118.164.185.81.rev.sfr.net. [81.185.164.118])
        by smtp.gmail.com with ESMTPSA id c68sm477362wme.13.2020.01.07.10.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 10:06:08 -0800 (PST)
Subject: Re: [RPI 3B+ / TSO / lan78xx ]
To:     Stefan Wahren <stefan.wahren@i2se.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        RENARD Pierre-Francois <pfrenard@gmail.com>,
        nsaenzjulienne@suse.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
 <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
 <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
 <f7e1f498-d90b-1685-dc02-4c24273957a7@i2se.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6a8ec9cb-b56d-a788-1460-e9f0d9dd8f5f@gmail.com>
Date:   Tue, 7 Jan 2020 10:06:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f7e1f498-d90b-1685-dc02-4c24273957a7@i2se.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/20 9:30 AM, Stefan Wahren wrote:
> Hi Eric,
> 
> Am 07.01.20 um 18:04 schrieb Eric Dumazet:
>>

>>
>> I doubt TSO and SACK have a serious generic bug like that.
>>
>> Most likely the TSO implementation on the driver/NIC has a bug .
> 
> Yes, the issue isn't reproducible with the Raspberry Pi 3B and the same
> kernel (without +). The main difference between both boards is the
> different ethernet USB chip:
> 
> Raspberry Pi 3B: smsc95xx
> Raspberry Pi 3B+: lan78xx
> 
>>
>> Anyway you do not provide a kernel version, I am not sure what you expect from us.
> 
> It's Linux 5.4.7 (arm64) as in the provided github link. I asked
> Pierre-Francois to report this issue here, so the issue get addressed
> properly. Currently this very old bug not fixed in mainline and the
> Raspberry Pi vendor tree uses a workaround (disable TSO).

This is puzzling.

Bug seems trivial enough :/

