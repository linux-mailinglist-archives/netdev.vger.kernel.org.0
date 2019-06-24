Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93CF518DE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfFXQlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:41:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37530 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFXQlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:41:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so10238206qkl.4;
        Mon, 24 Jun 2019 09:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UdA6Y6qkEPNcox/R4AD5p5PdgoW5IX8dJGvSgmjWmkg=;
        b=JhxxntTYearder/a/p+OquDHNuX8jeZ9N2/zYjAaTHici1QdHNF3fXDeq+Qdy/ZELO
         L28sxhlC4z73NiXjlOsmiGjIcgJxbK/4MBgu38/p6eIT5eTdF9nzIA6jlWhEF3TifzWE
         LK70Fmoxgz0yWkXHzS4INQEof6R+A2BE9JX8Y2uvjVqkexfMaMendyllHIMS7k6eYaPp
         QEp1Qa1KoKtTbyeCKaGp5HLl1TP2iS+haRKQkqIsq453Arb2D/ifMTObojJlN5VzUNSi
         GJQzL2MnimDz+k/Wkv9t6LoyanZlY3neCtq5cmbLIOUFpPUiiIXyQK0hxYBDw/0YTI43
         XuQw==
X-Gm-Message-State: APjAAAWs0IPTFOKO2up/cHi5MamuliTC1GqqtjYWAFnZBg3hOJKTuiKm
        F2r/jeRQD2cVK3ykHHr8HKL3ZQgvbjepAP95O54=
X-Google-Smtp-Source: APXvYqx9IXxZ67+F4onDygsWo++RwTBrZyAF3TvR7CC3NoZfdYBTRnVe65OvdwgLfjKt586ottXwhlgpI1RplTtFttg=
X-Received: by 2002:a05:620a:12db:: with SMTP id e27mr111628534qkl.352.1561394477622;
 Mon, 24 Jun 2019 09:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
 <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
 <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
 <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
 <d533b708-c97a-710d-1138-3ae79107f209@linaro.org> <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
 <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
In-Reply-To: <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 24 Jun 2019 18:40:57 +0200
Message-ID: <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 6:21 PM Alex Elder <elder@linaro.org> wrote:
> On 6/18/19 2:03 PM, Johannes Berg wrote:
>
> > Really there are two possible ways (and they intersect to some extent).
> >
> > One is the whole multi-function device, where a single WWAN device is
> > composed of channels offered by actually different drivers, e.g. for a
> > typical USB device you might have something like cdc_ether and the
> > usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
> > similarly, e.g. by using the underlying USB device "struct device"
> > pointer to tie it together.
>
> I *think* this model makes the most sense.  But at this point
> it would take very little to convince me otherwise...  (And then
> I saw Arnd's message advocating the other one, unfortunately...)
>
> > The other is something like IPA or the Intel modem driver, where the
> > device is actually a single (e.g. PCIe) device and just has a single
> > driver, but that single driver offers different channels.
>
> What I don't like about this is that it's more monolithic.  It
> seems better to have the low-level IPA or Intel modem driver (or
> any other driver that can support communication between the AP
> and WWAN device) present communication paths that other function-
> specific drivers can attach to and use.

I did not understand Johannes description as two competing models
for the same code, but rather two kinds of existing hardware that
a new driver system would have to deal with.

I was trying to simplify it to just having the second model, by adding
a hack to support the first, but my view was rather unpopular so
far, so if everyone agrees on one way to do it, don't worry about me ;-)

> > Now, it's not clear to me where IPA actually falls, because so far we've
> > been talking about the IPA driver only as providing *netdevs*, not any
> > control channels, so I'm not actually sure where the control channel is.
>
> There is user space code that handles all of this, and as far as I
> can tell, parts of it will always remain proprietary.

Two replies on this:

- to answer Johannes question, my understanding is that the interface
  between kernel and firmware/hardware for IPA has a single 'struct
  device' that is used for both the data and the control channels,
  rather than having a data channel and an independent control device,
  so this falls into the same category as the Intel one (please correct
  me on that)

- The user space being proprietary is exactly what we need to avoid
  with the wwan subsystem. We need to be able to use the same
  method for setting up Intel, Qualcomm, Samsung, Unisoc or
  Hisilicon modems or anything else that hooks into the subsystem,
  and support that in network manager as well as the Android
  equivalent.
  If Qualcomm wants to provide their own proprietary user space
  solution, we can't stop them, but then that should also work on
  all the others unless they intentionally break it. ;-)

> > and simply require that the channel is attached to the wwan device with
> > the representation-specific call (wwan_attach_netdev, wwan_attach_tty,
> > ...).
>
> Or maybe have the WWAN device present interfaces with attributes,
> and have drivers that are appropriate for each interface attach
> to only the ones they recognize they support.

I think you both mean the same thing here, a structure with callback
pointers that may or may not be filled by the driver depending on its
capabilities.

What we should try to avoid though is a way to add driver private
interfaces that risk having multiple drivers create similar functionality
in incompatible ways.

        Arnd
