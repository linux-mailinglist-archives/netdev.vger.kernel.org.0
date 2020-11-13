Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39502B1692
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 08:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgKMHhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 02:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgKMHhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 02:37:38 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5013CC0613D1;
        Thu, 12 Nov 2020 23:37:38 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id t142so1952113oot.7;
        Thu, 12 Nov 2020 23:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFMFLWWTfi10fKhsaLXn7qpaj9MnwqgtX3A+mFzhD+w=;
        b=RSZRcxyj+KaNfwxfyWiVkX19UNGatET0KYdhzOXKMfIRQs28ngk7GFYNnOhGr3vTtR
         rwy8zQrozIA7K+QhV1ovR1QVnxa5Ej337gBDREjqGYa9HazZmXH+C7X5p0oegoQCBYC1
         pkAMMjdpGsQKpLPWzNngZ9I8HvIxQ6wcq1fN7jr9U4OkRWUYGdgCbQ8Phr4RP9Bp6JSC
         KdNoLKBF4P2BrKdDDAsySoneOiYV0bvCNU67FCEHf12yXW77IiRAvoqgEgM8l7ZtT5Wb
         NP8xbkzVh9nzE4Ud8X+Jo/B82S9XB4K4X4qs5rEDvL3IPodHuPWB8l+X8De6RdD/1w6b
         2QCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFMFLWWTfi10fKhsaLXn7qpaj9MnwqgtX3A+mFzhD+w=;
        b=g1zmfnUoAJMQXw7oA2vi1WOnrH9nL9oC2I7gT3WYHCKz+mOxXtJG2/JiIHvXEtrPZx
         X/ZtqX0JAvwtrEwPW5hWfPP8G7MJwYGmcvs+k6YnwEsiWDt+Jse1kfp37Z4CsltRml34
         5wjANy6/HoqfrAR+QiBOXVL2BlpVLnQOM5yA1w8kRxAOcuDCSMGePO87/yL+MK8EF632
         Jb2h1ZflVk+CdhMboH4lmSIYFieEyT/UErBehqa34QJ/W71B+WKkYT4mC4RLl/Yu7BtU
         FFkaSx+cMZ/nlWG1jcf2tWOaxqJ11szHXxkoVGl3PURKOMWvepYVJJNQJKKdd9vFvSKq
         gULA==
X-Gm-Message-State: AOAM5318w4et94UaK1wGU2paZ3egMrujUH3JvmZV8S2twq0Cuft5rW8J
        DR5QyTMddLcvFlI0wfybztgW1UVGYpRzbAGfMZM=
X-Google-Smtp-Source: ABdhPJwQRgYLydClI0XmvjyFKGtZWXxm7pmgEvDFYgA8KLN+9joGOM5GL+pl5oO78IptiFsJX4TYa2wFpUd+P3Ts0XY=
X-Received: by 2002:a4a:dcd6:: with SMTP id h22mr608646oou.6.1605253057666;
 Thu, 12 Nov 2020 23:37:37 -0800 (PST)
MIME-Version: 1.0
References: <20200909091302.20992-1-dnlplm@gmail.com> <CAKfDRXhDFk7x7b35G5w4XytcL29cw=U8tVpvFJmbsWezVUsTtQ@mail.gmail.com>
 <CAGRyCJHqQpOgkbh=DvEL=7LJr0z65L6Oq9-sK7DJBtxu0_=_Ww@mail.gmail.com>
In-Reply-To: <CAGRyCJHqQpOgkbh=DvEL=7LJr0z65L6Oq9-sK7DJBtxu0_=_Ww@mail.gmail.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 13 Nov 2020 08:37:26 +0100
Message-ID: <CAKfDRXjcOCvfTx0o6Hxdd4ytkNfJuxY97Wk2QnYvUCY8nzT7Sg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        Carl Yin <carl.yin@quectel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniele,

On Thu, Nov 12, 2020 at 7:29 PM Daniele Palmas <dnlplm@gmail.com> wrote:
> thanks for testing. Still thinking it could be better to differentiate
> between raw-ip and qmap, but not yet able to find the time to perform
> some tests on my own.

I agree that separating between qmap and non-qmap would be nice.
However, with my modules I have not noticed any issues when using 32KB
as the URB size. Still, the results show that there is no gain in
increasing the aggregation size from 16 to 32KB. Capturing traffic
from the modem reveals that the hardware still only generates 16KB
URBs (even in high-speed networks). I also see that for example the
r8152 driver uses a static URB size of 16384.

> Is the dongle driver based on usbnet? Besides the aggregated datagram
> size, did you also try different datagram max numbers?

The dongle driver is not based on usbnet, it is r8152. I tried to
increase the maximum datagrams from 32 to 64 (as well as some other
values), but it had no effect on the perfrormance.

> The only advice I can give you is to check if other drivers are
> performing better, e.g. did you try the MBIM composition? not sure it
> will make much difference, since it's based on usbnet, but could be
> worth trying.

I tried to use MBIM, but the performance was the same as with QMI. I
will take a look at r8152 and experiment with implementing some of the
differences in usbnet/qmi_wwan. I see for example that r8152 uses
NAPI, which while not a perfect fit for USB could be worth a try.
Based on some discussions I found on the mailing list from 2011,
implementing NAPI in usbnet could be worthwhile.

Thanks for the reply!

BR,
Kristian
