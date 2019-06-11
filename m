Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FC3D242
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391540AbfFKQ2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:28:51 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37713 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfFKQ2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:28:51 -0400
Received: by mail-lf1-f67.google.com with SMTP id d11so1959358lfb.4
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgyPf7xhx0YF0w9Kty/80UkxGW/cNJhmecxkZGC4Svg=;
        b=Wy6GLE/bRjVgzVg3lTBzcxvgONy0/gxFk0wNAyFPNhLKb1zkqgi7IORqDn/A5oMhNs
         P1N7dtfcmcAozuWE5Eb3UlefyJfoLU/vDMgiMI3gdS0x+DBehpksepzE3rG6XpxcTQTL
         dgguk5hn73V7XtY9m418kM424zKdGmSeZiwHBMjROl0RJXauPuHC4yXQZJhkON6lbL4x
         8yP5dVjBuymlWB96zkGHGcjBVzztPUFGpPcNcVrKQyhj8zt9gsA+MYw/a7H4tw2+tBeS
         72NhJJT+iv7ymfMLyx7RYScRS52teqvNNZh+H661tbd0KCYPYAwPMSB88JYKm6t07qyn
         5NRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RgyPf7xhx0YF0w9Kty/80UkxGW/cNJhmecxkZGC4Svg=;
        b=I2VQpxGoYZs6UcxupdWycaOXmzXSaZYFKl4uzchYurTux1vkKKHnkgF+/0wwUt6Idj
         IbxArn96N+3N/ak+J5vRCD1xF6uUIfV7RTsCH6NT1BZJsNFoXN9oLsb9SxruQnJ6u0Dl
         Rdroatqj4grwLtXPc9xXK6Rp6ZtfwX0GS7y+JnfhQaenXytyo2ex6mSUFQ2/Cluiq0at
         zZzynqTb5uzqe5gldmjNEMOgKHX2Q3JcZbD2QYJjsY5nzui9AI+Qpetu8xIUJPKBgCSO
         nWmtVrki4Hg60eJXQj/tRmOQ1thsMAMRD77M6bwRikzCrYjBseYy8o2fVCidA8FV79pR
         hHzA==
X-Gm-Message-State: APjAAAUzG2ES9cX7hbSn66xMNy8mJgcQny8pbuUHPFgykXSixJpgCUAL
        ySpDFZrOn6t1ZgowA8Fvuq3Vpc8QxZAsDaWaEnIGrg==
X-Google-Smtp-Source: APXvYqz+8HsvC2fZeq6JGexwZBxWKw0IGtco6wwqGIYyL/OdqZf9E69/kPyFOQ1Wtpf5LQTIPeOKLiFAWfBQYsb8+YM=
X-Received: by 2002:a19:c383:: with SMTP id t125mr31681402lff.89.1560270528359;
 Tue, 11 Jun 2019 09:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190606094722.23816-1-anders.roxell@linaro.org>
 <d6b79ee0-07c6-ad81-16b0-8cf929cc214d@xs4all.nl> <CADYN=9KY5=FzrkC7MKj9QnG-eM1NVuL00w8Xv4yU2r05rhr7WQ@mail.gmail.com>
 <c2ff2c77-5c14-4bc4-f59c-7012d272ec76@thinci.com> <1560240943.13886.1.camel@pengutronix.de>
 <221c8ef8-7adc-4383-93c9-9031dca590f0@xs4all.nl> <CADYN=9K7GwPGM_Eh5q-OZ9rcEPAjXw4BXy-m3a=QxmGuVruCUw@mail.gmail.com>
 <CAAEAJfC9vja5WwsNc5+MTVHLFg_P3zG=OZt_CuRR5eG-3iWD9Q@mail.gmail.com>
In-Reply-To: <CAAEAJfC9vja5WwsNc5+MTVHLFg_P3zG=OZt_CuRR5eG-3iWD9Q@mail.gmail.com>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 11 Jun 2019 18:28:37 +0200
Message-ID: <CADYN=9L36CadXu2csbQhvey=20NTte-a+a8i08w=pP-+VdTuLA@mail.gmail.com>
Subject: Re: [PATCH 5/8] drivers: media: coda: fix warning same module names
To:     Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matt Redfearn <matt.redfearn@thinci.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>,
        "stefan@agner.ch" <stefan@agner.ch>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jun 2019 at 18:18, Ezequiel Garcia
<ezequiel@vanguardiasur.com.ar> wrote:
>
>
>
> On Tue, Jun 11, 2019, 1:01 PM Anders Roxell <anders.roxell@linaro.org> wrote:
>>
>> On Tue, 11 Jun 2019 at 10:21, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> >
>> > On 6/11/19 10:15 AM, Philipp Zabel wrote:
>> > > Hi,
>> > >
>> > > On Mon, 2019-06-10 at 13:14 +0000, Matt Redfearn wrote:
>> > >>
>> > >> On 10/06/2019 14:03, Anders Roxell wrote:
>> > >>> On Thu, 6 Jun 2019 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> > >>>>
>> > >>>> On 6/6/19 11:47 AM, Anders Roxell wrote:
>> > >>>>> When building with CONFIG_VIDEO_CODA and CONFIG_CODA_FS enabled as
>> > >>>>> loadable modules, we see the following warning:
>> > >>>>>
>> > >>>>> warning: same module names found:
>> > >>>>>    fs/coda/coda.ko
>> > >>>>>    drivers/media/platform/coda/coda.ko
>> > >>>>>
>> > >>>>> Rework so media coda matches the config fragment. Leaving CODA_FS as is
>> > >>>>> since thats a well known module.
>> > >>>>>
>> > >>>>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>> > >>>>> ---
>> > >>>>>   drivers/media/platform/coda/Makefile | 4 ++--
>> > >>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>> > >>>>>
>> > >>>>> diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
>> > >>>>> index 54e9a73a92ab..588e6bf7c190 100644
>> > >>>>> --- a/drivers/media/platform/coda/Makefile
>> > >>>>> +++ b/drivers/media/platform/coda/Makefile
>> > >>>>> @@ -1,6 +1,6 @@
>> > >>>>>   # SPDX-License-Identifier: GPL-2.0-only
>> > >>>>>
>> > >>>>> -coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
>> > >>>>> +video-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
>> > >>>>>
>> > >>>>> -obj-$(CONFIG_VIDEO_CODA) += coda.o
>> > >>>>> +obj-$(CONFIG_VIDEO_CODA) += video-coda.o
>> > >>>>
>> > >>>> How about imx-coda? video-coda suggests it is part of the video subsystem,
>> > >>>> which it isn't.
>> > >>>
>> > >>> I'll resend a v2 shortly with imx-coda instead.
>> > >
>> > > I'd be in favor of calling it "coda-vpu" instead.
>> >
>> > Fine by me!
>> >
>> > >
>> > >> What about other vendor SoCs implementing the Coda IP block which are
>> > >> not an imx? I'd prefer a more generic name - maybe media-coda.
>> > >
>> > > Right, this driver can be used on other SoCs [1].
>> >
>> > Good point.
>>
>> OK, so I'll change it to 'media-coda'.
>>
>>
>>
>
> As suggested by Philipp, coda-vpu seems the most accurate name.

urgh, that correct.

Thanks,
Anders

>
> Thanks,
> Ezequiel
>
>
>
>> Cheers,
>> Anders
>>
>> >
>> > Regards,
>> >
>> >         Hans
>> >
>> > >
>> > > [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg146498.html
>> > >
>> > > regards
>> > > Philipp
>> > >
>> >
