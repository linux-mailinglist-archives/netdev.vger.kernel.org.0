Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132CA42A48
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439959AbfFLPGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:06:36 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38020 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437202AbfFLPGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 11:06:36 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so16738387qtl.5;
        Wed, 12 Jun 2019 08:06:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1g7s/UPWJzJeB4LrTKmbsG4ivrcvy+TUBuxC551yLEY=;
        b=d66shXrNt0O/ILQOmOrlpZDjdgEODCMdtsY8L/CJMIu4+IkFvmEazMfTJ7Au8U64Rq
         4P+o2ddPKPEQSDUifBXoloUYWwr9qwk5e+JW89rzkgiw+lEvwwhWtrsYLOz6hEnb4Jkr
         ibemJxSrT015Q/RbN1pNo4NjbDkvR0VD/tl66yBVm+sPiGbXZdjlFc1ZURJMoZRLl/Xh
         lH/YUbdq2+jZDlEXh+hk230IGhooh1F/ijF2BQItVkmBkdkGPwhI8FSUPc1/hnsGGdwc
         82XGN5iEKnO84hvhgyMQspDGrGIxCs9KXUSJLKEATjSdqnlYmREfwsKEBeFqegjQI9jq
         W0Og==
X-Gm-Message-State: APjAAAXMtyjaTD2zZw160HMJCu7MGGQCPI9NeL+6/WFh3PhbVAGwttLz
        dc13i4VXfStaElvT1PcbT2xAFgUu0zPQJ/wQ6OQ=
X-Google-Smtp-Source: APXvYqzOMpjxx8OTt1LYucvtT3ec0rHQVDXxOvYnWwFFLgDetKQQiEnhNqtCjwvLI9BT1ZM6g2S2uumX596TBUy4Jug=
X-Received: by 2002:ac8:8dd:: with SMTP id y29mr5832711qth.304.1560351994976;
 Wed, 12 Jun 2019 08:06:34 -0700 (PDT)
MIME-Version: 1.0
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
 <36bca57c999f611353fd9741c55bb2a7@codeaurora.org> <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
 <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com> <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
In-Reply-To: <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 12 Jun 2019 17:06:17 +0200
Message-ID: <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
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

On Wed, Jun 12, 2019 at 4:28 PM Dan Williams <dcbw@redhat.com> wrote:
> On Wed, 2019-06-12 at 10:31 +0200, Arnd Bergmann wrote:
> > On Tue, Jun 11, 2019 at 7:23 PM Dan Williams <dcbw@redhat.com> wrote:
> I was trying to make the point that rmnet doesn't need to care about
> how the QMAP packets get to the device itself; it can be pretty generic
> so that it can be used by IPA/qmi_wwan/rmnet_smd/etc.

rmnet at the moment is completely generic in that regard already,
however it is implemented as a tunnel driver talking to another
device rather than an abstraction layer below that driver.

> > The current rmnet model is different in that by design the upper
> > layer
> > (rmnet) and the lower layer (qmi_wwan, ipa, ...) are kept independent
> > in
> > both directions, i.e. ipa has (almost) no knowledge of rmnet, and
> > just
> > has pointers to the other net_device:
> >
> >        ipa_device
> >            net_device
> >
> >        rmnet_port
> >            net_device
> >
> > I understand that the rmnet model was intended to provide a cleaner
> > abstraction, but it's not how we normally structure subsystems in
> > Linux, and moving to a model more like how wireless_dev works
> > would improve both readability and performance, as you describe
> > it, it would be more like (ignoring for now the need for multiple
> > connections):
> >
> >    ipa_dev
> >         rmnet_dev
> >                wwan_dev
> >                       net_device
>
> Perhaps I'm assuming too much from this diagram but this shows a 1:1
> between wwan_dev and "lower" devices.
>
> What Johannes is proposing (IIRC) is something a bit looser where a
> wwan_dev does not necessarily provide netdev itself, but is instead the
> central point that various channels (control, data, gps, sim card, etc)
> register with. That way the wwan_dev can provide an overall view of the
> WWAN device to userspace, and userspace can talk to the wwan_dev to ask
> the lower drivers (ipa, rmnet, etc) to create new channels (netdev,
> tty, otherwise) when the control channel has told the modem firmware to
> expect one.

Right, as I noted above, I simplified it a bit. We probably want to
have multiple net_device instances for an ipa_dev, so there has
to be a 1:n relationship instead of 1:1 at one of the intermediate
levels, but it's not obvious which level that should be.

In theory we could even have a single net_device instance correspond
to the ipa_dev, but then have multiple IP addresses bound to it,
so each IP address corresponds to a channel/queue/napi_struct,
but the user visible object remains a single device.

I trust that you and Johannes are more qualified than me to make
the call on that point.

       Arnd
