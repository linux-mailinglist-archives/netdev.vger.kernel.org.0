Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E5B2B178A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgKMIuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbgKMIuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:50:52 -0500
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A377C0613D1;
        Fri, 13 Nov 2020 00:50:52 -0800 (PST)
Received: by mail-oo1-xc44.google.com with SMTP id t10so1990857oon.4;
        Fri, 13 Nov 2020 00:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yLIPrLxEESoQYSVCqKJil5xIQrm9huKKzNhFv7s1VYE=;
        b=fpAHRUEAYcDhB3P21m64bD7DB4+ABkcmYKjT1S4V1eYbPeChP8K6s8Cchwn8KdlLPy
         hBkrkgGk8yPuKSrbs62sIGi20J/61RKk7/87y7YH7yNYgpY3sdPGurfajb6PhDp3rfxw
         YB4kXyO8pUK6nLVJE8HvIR5fZ1mZGzlVbUxjIgbnMcnFjimKbCz+bWUjhljGhT8DOO8V
         cmGyRa/vIPdKTnfMVbpSoJ6FarhcObci2RbTsrnIuunooBlzMin0HrgG0PtUzKub3FNv
         V0agJ02vWicA58zF4jEX/6p0fQfUWcGM9kt4h9fC8kYBcQcL0eTgvD2xVv2q6eGQ7r3+
         SFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yLIPrLxEESoQYSVCqKJil5xIQrm9huKKzNhFv7s1VYE=;
        b=X0MdLydKMv6lNPIDUiE99LZteihrihfA6XR+XVOCgIeFYUG4MuJpmcBAuME5eEzTam
         GpTAQwhdZHhT8PA6jNmMXlJgWwghmasuupxlDw/16j1ibm0cKE1UMFS6Kd25IzmptMK3
         fJOMYINld5jzCO8DI/DN4QXw4M8FL6ATD/NhTPPyhE5AZLMCSjAG/ZxfNeYsvrGQWPSo
         fdBJjLPqmSPKlJkdCI20hljf7w4z+/LiADefK4r6T2L7Pbo6aLDLWH5MNRVQ3n69Y5gB
         8BBw+Muo8ojTMvSF3P88njLjDvsRHN4LcQaxHXOlLWmqA6i0ACbU/3zbsNKHDKNKpUhO
         txEw==
X-Gm-Message-State: AOAM533PdqL1ChUrHUgg/opYo1TJoOudKtBqLmCN4CfNzNTmGuAIeUrM
        vejC/PHsvXQQMfVMsGGx+BN/3w31DRh8/U5LZo4=
X-Google-Smtp-Source: ABdhPJxNogNry+2c2AjsJZYItuCloXIpKEUuOdBaR3R0r8D9bWPSvfMM3kXYesKHXPzmHF6B5yVqAbtscYwxvwcOoeI=
X-Received: by 2002:a4a:e24b:: with SMTP id c11mr787680oot.74.1605257451338;
 Fri, 13 Nov 2020 00:50:51 -0800 (PST)
MIME-Version: 1.0
References: <e724ce7621dcb8bd412edb5d30bfb1e8@sslemail.net>
 <CAKfDRXjcOCvfTx0o6Hxdd4ytkNfJuxY97Wk2QnYvUCY8nzT7Sg@mail.gmail.com> <HK2PR06MB35071489A05CEBF9C5FADD1C86E60@HK2PR06MB3507.apcprd06.prod.outlook.com>
In-Reply-To: <HK2PR06MB35071489A05CEBF9C5FADD1C86E60@HK2PR06MB3507.apcprd06.prod.outlook.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 13 Nov 2020 09:50:40 +0100
Message-ID: <CAKfDRXgGw0s=DAOsR5x7SXtr6twda5U_uOEb_VNZ-0hVEEvuYg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     =?UTF-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Carl,

Thanks a lot for your reply.

On Fri, Nov 13, 2020 at 9:37 AM Carl Yin(=E6=AE=B7=E5=BC=A0=E6=88=90) <carl=
.yin@quectel.com> wrote:
>         For openwrt device, the ' Performance bottleneck ' usually is NAT=
, not usbnet.
>         As I remember: MT7621 have dual core, and support Hardware accele=
ration of 'NAT'.

Yes, you are right in that NAT can have a large effect on performance,
especially when you start being CPU-limited. However,when using perf
to profile the kernel during my tests, no function related to
netfilter/conntrack appeared very high on the list. I would also
expect the modem to at least reach the performance of the dongle, with
offloading being switched off. However, there could be some detail I
missed.

>         It seems r8152 is a pure Ethernet card, does it can use the ' Har=
dware acceleration '

I will do some experiments with hardware NAT, thanks for reminding me
of this feature. However, my experience with it is not very good, so I
would ideally like to find a solution that does not rely on this
feature.

>         And do you use 'mpstat -P ALL 2' to monitor each core's loading?
>         Generally USB interrupt occurs at cpu0, and the 'NAT' is also on =
cpu0.
>         You can try to use "echo 2 > /sys/class/net/wwan0/ /queues/rx-0/r=
ps_cpus " to move NAT to cpu1.

I use htop to monitor the load on each core. rx_cpus is set to "e" to
balance traffic better across all cores, locking rx to one core gave a
much worse result (something like 170 Mbit/s).

>         X55 max support 31KB, there are benefit from 16KB -> 31KB.
>         Maybe your X55's FW version is old, only generates 16KB data.
>         And URB size is 32KB, but X55 only output 16KB, so maybe there ar=
e not enough number of URBs?

I had the same theory and asked my FAE if a more recent firmware is
available for my device (some of my tests were done with Quectel
RM500Q). I do not know what is the trigger for the device to generate
32KB URBs is? The fastest network I have access to gives a speed of
700-800 Mbit/s, but I do not know if that is enough?

Kristian
