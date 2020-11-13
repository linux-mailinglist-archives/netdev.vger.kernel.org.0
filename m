Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5F2B1E1A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 16:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgKMPFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 10:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgKMPFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 10:05:24 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE96C0613D1;
        Fri, 13 Nov 2020 07:05:11 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n11so9191288ota.2;
        Fri, 13 Nov 2020 07:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1C47CTLZAr89HP4Ij49KChin9n/8obEs9p/icBbyAZE=;
        b=KG5S5U2kccbW0H4DF1sSGnVRAZL776fQmrZHApKZVnVh1XXn2LG9mG2p0h0FblW+MV
         FGjd9VHdExpUitvFcz507nNywfL7q6Lv+7rgMoyk8d4IIFQDYX5otPdN/JWBqvUX5k8q
         VlO4WAgw2g7ujeNNzP0bZzwuVqS1Lc6EK/yLdMsvGKUfvZndEIgkXKSrAaxBiPKSGyeJ
         l+PKE+3+XTI4sdq/wQYGMNSu1MUGsndWg1BvHzx/MgnshB57zv+nsV/RAfVq4xC+2+F5
         q6z36ZJeN8MaKaUEefiJwy2ceZtz1wtyOh0T1K0cvYC+jkWtEj3jtUaOPn3vBNceNB9f
         CwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1C47CTLZAr89HP4Ij49KChin9n/8obEs9p/icBbyAZE=;
        b=NEFiC5fVwQlvLdnGj+DdAmHoZXaYPnMSEBKHCbEliDBp91VBn7HavYYgYFsvvd4ch4
         UQvgTX2LIo8gXQ5xOWXoUhKom5DbOXjWdHvW+Xwj24It4Kxf59VB1Kt0rWygx4IUqxsZ
         F53elt/JSrCS0YwzHRsRKepui/bsiy0QUrpIrUQZxRviY4vymZIskU2EoFQa0yScuggZ
         vkX497UXCANVv6i8TSiRMAOS1ctZWSperCo8385MNdnVGWG+Xb6Pk36FC6mQcYU2hfcT
         ASj/zkcj+BxxarE10+PbmTqPG84Mt9eeJDTDzh+6u8AJt15st/gqjspnHGpzVKrd+klL
         hiVQ==
X-Gm-Message-State: AOAM533VxUd22bnrxGaEzBH7l3fvivtQkdlja9qDRSuFRPmLUOidmIL/
        +TwJ/0O8SrEH5VzyZ8pfngHae36y3r2DThs8xoI=
X-Google-Smtp-Source: ABdhPJyl4bssDWV93YJHQrFi28t8HVpRM6w/THK3WbZjakE5i/96GEDqtjQK4TPjzsd2aNY0iD1d0w0YwdtlFmt/dMg=
X-Received: by 2002:a9d:6f8f:: with SMTP id h15mr1828218otq.166.1605279910676;
 Fri, 13 Nov 2020 07:05:10 -0800 (PST)
MIME-Version: 1.0
References: <e724ce7621dcb8bd412edb5d30bfb1e8@sslemail.net>
 <CAKfDRXjcOCvfTx0o6Hxdd4ytkNfJuxY97Wk2QnYvUCY8nzT7Sg@mail.gmail.com>
 <HK2PR06MB35071489A05CEBF9C5FADD1C86E60@HK2PR06MB3507.apcprd06.prod.outlook.com>
 <CAKfDRXgGw0s=DAOsR5x7SXtr6twda5U_uOEb_VNZ-0hVEEvuYg@mail.gmail.com>
In-Reply-To: <CAKfDRXgGw0s=DAOsR5x7SXtr6twda5U_uOEb_VNZ-0hVEEvuYg@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 13 Nov 2020 16:04:59 +0100
Message-ID: <CAKfDRXg+ViFVdN=op1s-xuaEQ3aWqtdh6-kdvcuMnx2zdd0QOw@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 13, 2020 at 9:50 AM Kristian Evensen
<kristian.evensen@gmail.com> wrote:
> Yes, you are right in that NAT can have a large effect on performance,
> especially when you start being CPU-limited. However,when using perf
> to profile the kernel during my tests, no function related to
> netfilter/conntrack appeared very high on the list. I would also
> expect the modem to at least reach the performance of the dongle, with
> offloading being switched off. However, there could be some detail I
> missed.

I continued working on this issue today and I believe I have found at
least one reason for my performance problems. My initial attempts at
profiling resulted in quite noisy perf files and this caused me to
look in the wrong places. Today I figured out how to get a cleaner
file, and I noticed that a lot of resources were spent on
pskb_expand_head() + support functions.

My MT7621 devices are used as routers, so before the packets are sent
out on the LAN additional headers have to be added. The current code
in qmimux_rx_fixup() allocates an SKB for each aggregated packet and
copies the data from the URB. The newly allocated SKB has too little
headroom, so when we get to ip_forward() then the check in skb_cow()
fails and the SKB is reallocated. After increasing the amount of data
allocated to also include the required headroom + reserving headroom
amount of bytes, I see a huge performance increase. I go from around
230 Mbit/s and to 280Mbit/s, with significantly less CPU usage. 280
Mbit/s is the same speed as I get from my phone connected to the same
network, so it seems to be the max of the network right now.

I do not know what would be an acceptable way (if any) to get this fix
upstreamed. I currently add an additional "safe" amount of data, but I
am pretty sure ETH_HLEN + 2 is not an acceptable solution :)

Kristian
