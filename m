Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6691998E9
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730706AbgCaOsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbgCaOst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 10:48:49 -0400
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98470214DB;
        Tue, 31 Mar 2020 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585666128;
        bh=e/7jTSv5Ln/7N2erMxSAhTPfQO0mGgov7i4pB0Kxz8M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EbrJxT9+qQ4vbmfQodNUZ75MqmrVy3/2NQDxPg4GsBywCzjeqIw2fq6lj3s7435X2
         NIM+7Ydop9wv5/4CkHGw9c7dOJtPBA/zSDJDrPe+DungVFsSYeZaSpNvpWfCUq24L2
         R+q388+xL8Vgv6ukYJr671hgBiLOn4kma+Cvp9Ro=
Received: by mail-qv1-f41.google.com with SMTP id p60so10971550qva.5;
        Tue, 31 Mar 2020 07:48:48 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1vMtCY640U90YBDNmS9RLEHsh5XJbMHUiAIrRTnM79TJ+N1F3y
        F6fi44rWk2ybm3rFmqdCCAJmx/+EFr9IetQppQ==
X-Google-Smtp-Source: ADFU+vsm7QnLg9VC47OO+I8GiU3/k2tefVEY+Sy39Kwt/VBNT1kmLS6ih/sV4b6JI7vayYbVNykmFae5IwQbSwKy9fk=
X-Received: by 2002:ad4:4bc3:: with SMTP id l3mr16286378qvw.79.1585666127545;
 Tue, 31 Mar 2020 07:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200325220542.19189-1-robh@kernel.org> <20200325220542.19189-2-robh@kernel.org>
 <20200327202159.GA12749@ravnborg.org>
In-Reply-To: <20200327202159.GA12749@ravnborg.org>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 31 Mar 2020 08:48:36 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+zFGvJ+3CmKw3OzgEWi-p4Uz9+nmnS5ax0J9ewoz5qZg@mail.gmail.com>
Message-ID: <CAL_Jsq+zFGvJ+3CmKw3OzgEWi-p4Uz9+nmnS5ax0J9ewoz5qZg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: iio/accel: Drop duplicate adi, adxl345/6
 from trivial-devices.yaml
To:     Sam Ravnborg <sam@ravnborg.org>
Cc:     devicetree@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Guillaume La Roque <glaroque@baylibre.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Lee Jones <lee.jones@linaro.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Brian Masney <masneyb@onstation.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 2:22 PM Sam Ravnborg <sam@ravnborg.org> wrote:
>
> Hi Rob.
>
> On Wed, Mar 25, 2020 at 04:05:38PM -0600, Rob Herring wrote:
> > The 'adi,adxl345' definition is a duplicate as there's a full binding in:
> > Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> >
> > The trivial-devices binding doesn't capture that 'adi,adxl346' has a
> > fallback compatible 'adi,adxl345', so let's add it to adi,adxl345.yaml.
> >
> > Cc: Michael Hennerich <michael.hennerich@analog.com>
> > Cc: Jonathan Cameron <jic23@kernel.org>
> > Cc: Hartmut Knaack <knaack.h@gmx.de>
> > Cc: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
> > Cc: linux-iio@vger.kernel.org
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../devicetree/bindings/iio/accel/adi,adxl345.yaml     | 10 +++++++---
> >  Documentation/devicetree/bindings/trivial-devices.yaml |  4 ----
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> > index c602b6fe1c0c..d124eba1ce54 100644
> > --- a/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> > +++ b/Documentation/devicetree/bindings/iio/accel/adi,adxl345.yaml
> > @@ -17,9 +17,13 @@ description: |
> >
> >  properties:
> >    compatible:
> > -    enum:
> > -      - adi,adxl345
> > -      - adi,adxl375
> > +    oneOf:
> > +      - items:
> > +          - const: adi,adxl346
> > +          - const: adi,adxl345
> > +      - enum:
> > +          - adi,adxl345
> > +          - adi,adxl375
>
> I assume it is my schema understanding that is poor.
> But I cannot parse the above.
>
> The mix of items, enum and const confuses me.

compatible can be one of 3 possibilities:
"adi,adxl346", "adi,adxl345"
"adi,adxl345"
"adi,adxl375"

For a single entry, 'items' can be omitted.

> I guess that if I am confused then others may end in the same situation.
> Can we improve readability here or amybe add a comment?

example-schema.yaml explains this to some extent. I'd rather improve that.

Rob
