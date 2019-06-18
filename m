Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB74AC6D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfFRU6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:58:36 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40801 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbfFRU6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:58:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id e8so15969250otl.7;
        Tue, 18 Jun 2019 13:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eWOlIQpBoXx+dBn8lseeqeYMHmFuOji9HYHAzsBj+Yo=;
        b=lTtpIIik85r71kD7QuF+ci8JCVP6HSQJwrWbglXjJOHHWVSCFPBaEzidFE1P1szIvW
         uyN+6I3/3CeGSgDFBJSKpUqJ+bZFNFvPbIvkugH31w9jGgajx5rZp5S8eX2eafs3HYEA
         z7U6sC9z6XhaKTgQ5usQK1k+KMV30FqPrWd0nyr/PzUKElTBMHWSdyA4/po+vihp3lhW
         QIPsR7HmvZG6opDQNl9Y2AKrLZHeJHdKe8x+5iR/vZcdjXA6NKSdcsPeHuKrMnZ1e04i
         M9hcai3YmZYBqE8NU7og9mjkzIv+vTOG6eYHIrGm5HsehFPmEkqhjr57nrOXc0aeskRk
         SpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eWOlIQpBoXx+dBn8lseeqeYMHmFuOji9HYHAzsBj+Yo=;
        b=bmP/hPxqcDWrCOCipNHesGWbE1nusTlrqTutvqRqRrHi6lRgxm4L1cxcy6DAjKTB3n
         eZtV/3hzHiSIHqPB25peN46tJayaRE/Ep+gfmSDQCbM3yD3Pp85PXnMLIO3vwkN0+9NO
         E/d24MxtaEsVLScob86hcb0IcQSQACgXYc2i65MKBgvOgR56DVnjCn0+rNzCq3GI0Izj
         BTghP6sFGOIeC6Gpk8u5pityUrg/drpWXI9hviRFGSvxgNT1XKyuhjnRx+qGPvaVnDas
         bxK3h0gbZCYRGeGQhRjTypN9wdtkI9WvYSMXpjXsKyD1tx5mkduVcHaeK448Y6+lJWye
         NHTw==
X-Gm-Message-State: APjAAAX9UdpgD37f55mtCeDh7iv3kNkaB7WKGJmBUSpa4T8Vvoc4R9GB
        YAcfdixE1mcHjsW8EkWRmLWXiBf0GvGzNgkDU3E=
X-Google-Smtp-Source: APXvYqwkdc6hhspveBKMMLkcBtJO+FzMapbB2HHbr7srIo2djZJcZ+0uZld5b+z55f3sgyxFjDXdwUv6VaCslijIKmw=
X-Received: by 2002:a9d:6405:: with SMTP id h5mr54059515otl.42.1560891514777;
 Tue, 18 Jun 2019 13:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <5d089fb6.1c69fb81.4f92.9134@mx.google.com> <7hr27qdedo.fsf@baylibre.com>
 <CAFBinCCrpQNU_JtL0SwEGbwWZ2Qy-b2m5rdjuE0__nDRORGTiQ@mail.gmail.com> <7d0a9da1-0b42-d4e9-0690-32d58a6d27de@collabora.com>
In-Reply-To: <7d0a9da1-0b42-d4e9-0690-32d58a6d27de@collabora.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 18 Jun 2019 22:58:23 +0200
Message-ID: <CAFBinCA7gMLJ=jPqgRgHcBABBvC7bWVt8VJhLZ5uN=03WL1UWQ@mail.gmail.com>
Subject: Re: next/master boot bisection: next-20190617 on sun8i-h2-plus-orangepi-zero
To:     Guillaume Tucker <guillaume.tucker@collabora.com>
Cc:     Kevin Hilman <khilman@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        tomeu.vizoso@collabora.com, mgalka@collabora.com,
        broonie@kernel.org, matthew.hart@linaro.org,
        enric.balletbo@collabora.com, Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume,

On Tue, Jun 18, 2019 at 10:53 PM Guillaume Tucker
<guillaume.tucker@collabora.com> wrote:
>
> On 18/06/2019 21:42, Martin Blumenstingl wrote:
> > On Tue, Jun 18, 2019 at 6:53 PM Kevin Hilman <khilman@baylibre.com> wrote:
> > [...]
> >> This seems to have broken on several sunxi SoCs, but also a MIPS SoC
> >> (pistachio_marduk):
> >>
> >> https://storage.kernelci.org/next/master/next-20190618/mips/pistachio_defconfig/gcc-8/lab-baylibre-seattle/boot-pistachio_marduk.html
> > today I learned why initializing arrays on the stack is important
> > too bad gcc didn't warn that I was about to shoot myself (or someone
> > else) in the foot :/
> >
> > I just sent a fix: [0]
> >
> > sorry for this issue and thanks to Kernel CI for even pointing out the
> > offending commit (this makes things a lot easier than just yelling
> > that "something is broken")
>
> Glad that helped :)
>
> If you would be so kind as to credit our robot friend in your
> patch, it'll be forever grateful:
>
>   Reported-by: "kernelci.org bot" <bot@kernelci.org>
sure
do you want me to re-send my other patch or should I just reply to it
adding the Reported-by tag and hope that Dave will catch it when
applying the patch?
in either case: I did mention in the patch description that Kernel CI caught it

by the way: I didn't know how to credit the Kernel CI bot.
syzbot / syzkaller makes that bit easy as it's mentioned in the
generated email, see [0] for a (random) example
have you considered adding the Reported-by to the generated email?


Martin


[0] https://lkml.org/lkml/2019/4/19/638
