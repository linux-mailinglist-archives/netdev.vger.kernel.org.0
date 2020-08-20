Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625A324AD4F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 05:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgHTD27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 23:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgHTD26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 23:28:58 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE42C061384
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 20:28:57 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a65so373667otc.8
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 20:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fF+dRt58CyDJkqe2eFqFPurhOlRy+MhyKYgh/jsdn+Q=;
        b=sba2bQKZNNe3zs7DYGbWWnjDeDgJKgdgFl32qpVY2IcZo+5it6qr30pLargiHNS1VF
         9N2ljSuI1xb3X3jUO3hdYU4FwW/zbxBKCLHKGFFsylv7KVY9AwKKe/OCHH7ah7bgWAFP
         0V/R+fYE35vhDbNT1QyHmR93yxMFHFfQuxa+rksura1/kna69BSVHKM97tFjQwmJg6Xu
         1e73cN9AHHnV7VLtkVZmiIYzq2UYw7luIiq9vXs3LcbNgGTzGCdWCnbhSJyxl00LgsnJ
         hcclkwsEGFVhEzVEODFZJQ+fBkc8rglEjeeUhLVeARy2aLUwp5EkeZXVFgo5EOUBJLA9
         mH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fF+dRt58CyDJkqe2eFqFPurhOlRy+MhyKYgh/jsdn+Q=;
        b=MfN6JzuMzYHVFxtdXQggeSzy9W26xEGGFXAlhE4yJBB13VNHi/8wyU3ntjViZRPiCN
         2D6lbCrrwvpflVAWgsJx2+aRSU40mmaStREkS5FFKs2gjKTseHglRcEHMXVH4ZZjgZxI
         8jBZVXryiws1fIrVoC+dd1T7Y3epir4hWuItsrDL4BBUrOD7VUVDJGtDXEEp14nLhk4v
         AbkObknXCO4W4aK3iJHmeG1vstpdz3ijBVbkvih5aFYhn0629yYNz4Apps9SjIhpOKKo
         C83bTblXGP01Z3vwG8RqVXKJY8kVyH2J2MS15xE1cSUuNIkAlsx32B+0qm3V1BbA4bcs
         CGcQ==
X-Gm-Message-State: AOAM530fNaP6TICsAdiR3MqWK2XdGQLzQUuPum9WThUWeoB0c9mOw6AH
        7h/AsiFqX4x7mWlQbEVJjIyEFahYZD+lA3t5HgmRvg==
X-Google-Smtp-Source: ABdhPJxZ7nw2s4Dxik9WLGdcKtJi9XiOGz8t6RoivsF5sQizqu4GALCfVQirCeiffIuh9kOf+5CS/1tORO2ndusgNc4=
X-Received: by 2002:a05:6830:237b:: with SMTP id r27mr722568oth.352.1597894136679;
 Wed, 19 Aug 2020 20:28:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <CALAqxLU3bt6fT4nGHZFSnzyQq4xJo2On=c_Oa9ONED9-jhaFgw@mail.gmail.com> <CALAqxLW98nVc-=8Q6nx-wRP1z8pzkw1_zNc9M7V3GhnJQqM9rg@mail.gmail.com>
In-Reply-To: <CALAqxLW98nVc-=8Q6nx-wRP1z8pzkw1_zNc9M7V3GhnJQqM9rg@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Wed, 19 Aug 2020 20:28:44 -0700
Message-ID: <CALAqxLULQvW3UikCHpEzSDnpeYnBy8wDSsWZNbSrmivQTW3_Sg@mail.gmail.com>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxarm@huawei.com, mauro.chehab@huawei.com,
        Manivannan Sadhasivam <mani@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Liwei Cai <cailiwei@hisilicon.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        driverdevel <devel@driverdev.osuosl.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Rob Clark <robdclark@chromium.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Liuyao An <anliuyao@huawei.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Wei Xu <xuwei5@hisilicon.com>,
        Rongrong Zou <zourongrong@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>,
        Network Development <netdev@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Chen Feng <puck.chen@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 7:01 PM John Stultz <john.stultz@linaro.org> wrote:
>
> On Wed, Aug 19, 2020 at 2:36 PM John Stultz <john.stultz@linaro.org> wrote:
> >
> > On Wed, Aug 19, 2020 at 4:46 AM Mauro Carvalho Chehab
> > <mchehab+huawei@kernel.org> wrote:
> > > So, IMO, the best is to keep it on staging for a while, until those
> > > remaining bugs gets solved.
> > >
> > > I added this series, together with the regulator driver and
> > > a few other patches (including a hack to fix a Kernel 5.8
> > > regression at WiFi ) at:
> > >
> > >         https://gitlab.freedesktop.org/mchehab_kernel/hikey-970/-/commits/master
> >
> > Sorry, one more small request: Could you create a branch that only has
> > the DRM driver changes in it?
> >
> > The reason I ask, is that since the HiKey960 isn't affected by the
> > majority of the problems you listed as motivation for going through
> > staging. So if we can validate that your tree works fine on HiKey960,
> > the series can be cleaned up and submitted properly upstream to enable
> > that SoC, and the outstanding 970 issues can be worked out afterwards
> > against mainline.
>
> Just as a heads up, I tried testing your tree with my HiKey960, and
> after fixing the compat string inconsistency, the drivers seem to load
> properly. However the drm_hwcomposer seems to have some trouble with
> the driver:
> 01-01 00:12:41.456   345   345 E hwc-drm-display-compositor: Commit
> test failed for display 0, FIXME
> 01-01 00:12:41.456   345   345 E hwc-drm-two: Failed to apply the
> frame composition ret=-22
> 01-01 00:12:41.456   351   351 E HWComposer:
> presentAndGetReleaseFences: present failed for display 0: BadParameter
> (4)
>
> I'll dig in a bit further as to why, but wanted to give you a heads up.

Ok, I've mostly gotten it sorted out:
  - You're missing a few color formats.
  - And I re-discovered a crash that was already fixed in my tree.

I'll send those patches in a few here.

That said even with the patches I've got on top of your series, I
still see a few issues:
1) I'm seeing red-blue swap with your driver.  I need to dig a bit to
see what the difference is, I know gralloc has a config option for
this, and maybe the version of the driver I'm carrying has it wrong?
2) Performance is noticeably worse. Whereas with my tree, I see close
to 60fps (that clk issue we mentioned earlier is why it's not exactly
60) in most tests, but with yours it mostly hovers around 30some fps,
occasionally speeding up to 40 and then back down.

Obviously with some work I suspect we'll be able to sort these out,
but I also do feel that the set you're starting with for upstreaming
is pretty old. The driver I'm carrying was heavily refactored around
5.0 to share code with the existing kirin driver, in the hopes of
making usptreaming easier, and it seems a shame to throw that out and
focus your efforts on the older tree.

But to be fair, I've not had time to upstream the driver myself, and
it's obviously your choice on how you spend your time.  I am really
excited to see your efforts here, regardless of which driver you end
up pushing.

thanks
-john
