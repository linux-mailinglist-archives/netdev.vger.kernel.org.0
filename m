Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38822A6B49
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 18:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgKDRBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 12:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731553AbgKDRBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 12:01:45 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43BEC0613D3;
        Wed,  4 Nov 2020 09:01:45 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id w145so17201605oie.9;
        Wed, 04 Nov 2020 09:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uknDCoKDga/da3SSTNKpZLFOARnk/1czGWKL3e4opsA=;
        b=Nj78/yMtn9Bz24YK5JLcHx1MsO1C5RbFb3bcNQfDKNgDb8qTrEZV/wNN0dPZUetf88
         vFGXw69ykOJAhxTTnqCmuYZ25FpK99TUJx6+Jd+NUYonNuNCWpF94lqhi8wdNZd90KsC
         GdI/L5jLYfWnZT1mkCht67LGLy9EgipQNdHtGGotelR4l46xeAYIVSTfxm2DDGJUR4kE
         h7IPifIgaEjd9XpJZydqcQqK1Jdfg6bOs9hLmq/sZ4qv6QzB4s6IROtc4SxZnpuXod5Y
         qYXsWmPEgl1f8XUszV6V2CagdkeeWuF398+stdQYrzwHBLsbwi68b6rA7uS7nazKpMC0
         FQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uknDCoKDga/da3SSTNKpZLFOARnk/1czGWKL3e4opsA=;
        b=piARaNgVzAiYqmT97CEAh8veiorBP+m//KWNhXLpAk7Ew2qPIv6Kyz9Uscma4PkcQt
         cfdJD8kbvOzL+Cif7dE66dj957v3bRrU4QzkUIWx7CkjkOJbQWHeA5i1TGR2My4+VO0j
         lGw9t55ahs4OiMMXsv408+RKSiW6qxyJQ7dKkfRWtAYJX7U6uI7WV2ZcMOf78eycOVze
         43BlDCC3sHWY/AqrrzzRtMPFKS+4HdOXOh3rgUGphPaYMpWau7hi6TBURdqtS/ToQdFY
         x3Sv/lQ//X8Zm1RRlEuA6Og1I30hzgWNC4DjwlTO2cINFd3eE2qiMpVJqIgtxxUwyKCX
         Vpfg==
X-Gm-Message-State: AOAM532KcbByfuOA9qc3gHkmm+xzmTgGdMaMM9as7w00KCCV4UCtM5Q5
        tLoGm0PPWegiAHeYNrvg5ui5p8xUs35AifTFFFE=
X-Google-Smtp-Source: ABdhPJwLrc04OOOAuViqEFuEwlu6OC0l+UZ/XYET1RwC/wCciqygskfFNRfSoMC6pbWqBK7T5crCnYzRaLiHE/q/i6s=
X-Received: by 2002:aca:bbc2:: with SMTP id l185mr1416712oif.172.1604509305040;
 Wed, 04 Nov 2020 09:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com>
In-Reply-To: <20200909091302.20992-1-dnlplm@gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 4 Nov 2020 18:01:34 +0100
Message-ID: <CAKfDRXhDFk7x7b35G5w4XytcL29cw=U8tVpvFJmbsWezVUsTtQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Sep 9, 2020 at 11:14 AM Daniele Palmas <dnlplm@gmail.com> wrote:
>
> Add default rx_urb_size to support QMAP download data aggregation
> without needing additional setup steps in userspace.
>
> The value chosen is the current highest one seen in available modems.
>
> The patch has the side-effect of fixing a babble issue in raw-ip mode
> reported by multiple users.
>
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> Resending with mailing lists added: sorry for the noise.
>
> Hi Bj=C3=B8rn and all,
>
> this patch tries to address the issue reported in the following threads
>
> https://www.spinics.net/lists/netdev/msg635944.html
> https://www.spinics.net/lists/linux-usb/msg198846.html
> https://www.spinics.net/lists/linux-usb/msg198025.html
>
> so I'm adding the people involved, maybe you can give it a try to
> double check if this is good for you.
>
> On my side, I performed tests with different QC chipsets without
> experiencing problems.
>
> Thanks,
> Daniele

First of all, I am very sorry for not providing any feedback earlier.
I applied your patch and have been running it on my devices more or
less since it was submitted. My devices are equipped with different
generations of modems (cat. 4, cat. 6, cat. 12, 5G NSA), and I haven't
noticed any problems and the babble-issue is gone. Over the last
couple of days I also finally had a chance to experiment with QMAP,
using an SDX55-based modem (i..e,32KB datagram support). Increasing
the datagram size to 32KB gives a nice performance boost over for
example 16KB. When measuring using iperf3 (on the same device), the
throughput goes from around 210 Mbit/s and to 230 Mbit/s. The CPU was
more or less saturated during all of my experiments, so the main
performance gain was from the increased aggregated datagram size.

As a side question, and perhaps this should be a separate thread, does
anyone have any suggestion on how to improve QMI performance further?
The device that I used for my iperf3-tests is mt7621-based, and using
for example an Ethernet dongle I am able to reach somere between 400
and 500 Mbit/s over USB. The Ethernet dongle is able to make use of
for example scatter-gather, but I would still expect at least a bit
more using QMI. I tried to replace the alloc()/put() in the
qmimux_rx_fixup() function with clone() and then doing push()/pull(),
but this resulted in a decrease in performance. I have probably
overlooked something, but I think at least my use of the functions was
correct. The packets looked correct when adding some debug output,
error counters did not increase, etc., etc. The mobile network is not
the bottleneck, on my phone I reliably get around 400 Mbit/s.

BR,
Kristian
