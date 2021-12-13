Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757D64734FC
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 20:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbhLMTaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 14:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhLMTaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 14:30:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FE4C061574;
        Mon, 13 Dec 2021 11:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6282E611E0;
        Mon, 13 Dec 2021 19:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A17C34600;
        Mon, 13 Dec 2021 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639423850;
        bh=YCIulPuC7rz/g+20RoE3fcDBtrYWE3Qufvo06cYhoUs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NzSBW4b4YioKli+ClrzJcc6U6jeGIiTCn5lSYpzRYJY/UC4hLUxHzuZiz8P6mx6Sx
         gNrLTOJ9/UjQH0PYjuCkcwdGCqw1lkYu3EaL0KayS+7fsmsODlpG82MgC56cmK2Mql
         kM2SNWYBQaLhXnFzljumqfj9BYYhELC//tEgFz32JZLdh/slGPz/HHyjfPbgoA2HPc
         HUV/ohrsPGPyXS1o4RXN6PFqlqLvaXBUyg0DQuATmEj1vLSOnhrvc0rWQQLkmdRER9
         SMBeXrMqirdXDf2LPsEcHSC+qSoyLU9UfxoAndKYECV4Ox7gQfza/ZhCev7gHVHUWH
         zJiITef16s25g==
Received: by mail-ed1-f46.google.com with SMTP id w1so55484998edc.6;
        Mon, 13 Dec 2021 11:30:50 -0800 (PST)
X-Gm-Message-State: AOAM532ETaKAMfLREdyUnqXpXeXabpEN9xybcLI5q9Jd7iiOlCDFJm61
        7jRQjn3SJeACsermt6dD4K3vdGtDx+sch5IUFw==
X-Google-Smtp-Source: ABdhPJy++oHUM39e5Ms27cPmoi1TEiua3mJxb9d2Rx+2TgB+kXwcivxSMb5bFNJbaNDO7q7u0b1xHbIR//4B6RpjTC8=
X-Received: by 2002:a17:906:3b18:: with SMTP id g24mr357822ejf.27.1639423849162;
 Mon, 13 Dec 2021 11:30:49 -0800 (PST)
MIME-Version: 1.0
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
 <1638864419-17501-2-git-send-email-wellslutw@gmail.com> <YbPHxVf1vXZj9GOC@robh.at.kernel.org>
 <CAFnkrsmXu9ceSQ7rzOAFy_kP6JMa7GvY7HCbT=_wfskH6wXuSw@mail.gmail.com>
In-Reply-To: <CAFnkrsmXu9ceSQ7rzOAFy_kP6JMa7GvY7HCbT=_wfskH6wXuSw@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 13 Dec 2021 13:30:36 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+5nM2L=p13CSq8FRZX0sMykbXdyBatDR7McUXkv5NXzA@mail.gmail.com>
Message-ID: <CAL_Jsq+5nM2L=p13CSq8FRZX0sMykbXdyBatDR7McUXkv5NXzA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
To:     =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Wells Lu <wells.lu@sunplus.com>,
        Vincent Shih <vincent.shih@sunplus.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 1:35 PM =E5=91=82=E8=8A=B3=E9=A8=B0 <wellslutw@gmai=
l.com> wrote:
>
> Hi Rob,
>
> Thank you very much for your review.
> Please see my replies below:
>
> > Add bindings documentation for Sunplus SP7021.
> >
> [...]
> > > +
> > > +  interrupts:
> > > +    description: |
> > > +      Contains number and type of interrupt. Number should be 66.
> >
> > Drop. That's every 'interrupts' and the exact number is outside the
> > scope of the binding.
>
> Yes, I'll drop the descriptions next patch.
> interrupts property will be:
>
>   interrupts:
>     maxItems: 1
>
>
> [...]
> > > +
> > > +  mdio:
> >
> > Just need:
> >
> >        $ref: mdio.yaml#
> >        unevaluatedProperties: false
> >
> > and drop the rest.
>
> Yes, I'll modify mdio node next patch.
> mdio node will be:
>
>   mdio:
>     $ref: mdio.yaml#
>     unevaluatedProperties: false
>
>
> > > +    type: object
> > > +    description: external MDIO Bus
> > > +
> > > +    properties:
> > > +      "#address-cells":
> > > +        const: 1
> > > +
> > > +      "#size-cells":
> > > +        const: 0
> > > +
> > > +    patternProperties:
> > > +      "^ethernet-phy@[0-9a-f]+$":
> > > +        type: object
> > > +        description: external PHY node
> > > +
> > > +        properties:
> > > +          reg:
> > > +            minimum: 0
> > > +            maximum: 30
>
> Can I limit value of 'reg' to no more than 30?

Isn't that the limit for any MDIO bus? I guess normally 31 is also
valid? I'm not really sure it is worth adding just for that 1 possible
value. Within the range of valid addresses, we can't ever validate
that a DT has the correct address.

Rob
