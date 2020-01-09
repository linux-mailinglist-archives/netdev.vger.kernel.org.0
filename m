Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37AB1362A3
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgAIVeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgAIVeg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 16:34:36 -0500
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2E520880;
        Thu,  9 Jan 2020 21:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578605674;
        bh=yn8sZNTzca5AhB7S6VZtExiIG/wWNPNaKx+okU9FHHo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=l1s44wy6UQynSATYWDgO5lND21qsYB27at/WiYGXThb9dukwcZWPlnPwqmyf1t1T3
         E3YqBNzDLgwtmj9PFMKzD2g6ret177fA/5yfx6jk12MyVu5e9bIrdpD7lJJgJxtmRj
         gxj0vOhLoR4+pnt933b303hp2OWtYntBh3Xl3BSU=
Received: by mail-qv1-f51.google.com with SMTP id z3so3661318qvn.0;
        Thu, 09 Jan 2020 13:34:34 -0800 (PST)
X-Gm-Message-State: APjAAAXCPBNpcQA/wFmzt2dNsQpD6vYvlCQXCY4cXM42ffLyNr5o7ydA
        ZtBZ2dalQMl34//Uaha9kWEk1hKknh6roPjCRA==
X-Google-Smtp-Source: APXvYqx43aMDqlaNqB0yVv64A+3XvbHK2prKiNN1FroBxw1xay/yrMm6w+12fNYNnHKqtqhTf/NG9bpdwJoHep0cNuk=
X-Received: by 2002:a0c:f6cd:: with SMTP id d13mr10492240qvo.20.1578605673756;
 Thu, 09 Jan 2020 13:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20191108103526.22254-1-christophe.roullier@st.com>
 <20191108103526.22254-2-christophe.roullier@st.com> <20191108104231.GE4345@gilmour.lan>
 <f934df21-ac57-50ad-3e7b-b3b337daabe1@st.com> <20191115075008.GY4345@gilmour.lan>
 <009e8c0e-6a72-7e14-699e-8a897199ae16@st.com>
In-Reply-To: <009e8c0e-6a72-7e14-699e-8a897199ae16@st.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 9 Jan 2020 15:34:20 -0600
X-Gmail-Original-Message-ID: <CAL_JsqLQoo0RMtdKgYbWP=wUiO6z2QM7tVzGJv_iMekFKQUDiQ@mail.gmail.com>
Message-ID: <CAL_JsqLQoo0RMtdKgYbWP=wUiO6z2QM7tVzGJv_iMekFKQUDiQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: dwmac: increase 'maxItems' for
 'clocks', 'clock-names' properties
To:     Christophe ROULLIER <christophe.roullier@st.com>
Cc:     Maxime Ripard <mripard@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 3:07 AM Christophe ROULLIER
<christophe.roullier@st.com> wrote:
>
> On 15/11/2019 08:50, Maxime Ripard wrote:
> > On Fri, Nov 08, 2019 at 01:02:14PM +0000, Christophe ROULLIER wrote:
> >> On 11/8/19 11:42 AM, Maxime Ripard wrote:
> >>> Hi,
> >>>
> >>> On Fri, Nov 08, 2019 at 11:35:25AM +0100, Christophe Roullier wrote:
> >>>> This change is needed for some soc based on snps,dwmac, which have
> >>>> more than 3 clocks.
> >>>>
> >>>> Signed-off-by: Christophe Roullier <christophe.roullier@st.com>
> >>>> ---
> >>>>    Documentation/devicetree/bindings/net/snps,dwmac.yaml | 8 +++++++-
> >>>>    1 file changed, 7 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >>>> index 4845e29411e4..376a531062c2 100644
> >>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> >>>> @@ -27,6 +27,7 @@ select:
> >>>>              - snps,dwmac-3.710
> >>>>              - snps,dwmac-4.00
> >>>>              - snps,dwmac-4.10a
> >>>> +          - snps,dwmac-4.20a
> >>>>              - snps,dwxgmac
> >>>>              - snps,dwxgmac-2.10
> >>>>
> >>>> @@ -62,6 +63,7 @@ properties:
> >>>>            - snps,dwmac-3.710
> >>>>            - snps,dwmac-4.00
> >>>>            - snps,dwmac-4.10a
> >>>> +        - snps,dwmac-4.20a
> >>>>            - snps,dwxgmac
> >>>>            - snps,dwxgmac-2.10
> >>>>
> >>>> @@ -87,7 +89,8 @@ properties:
> >>>>
> >>>>      clocks:
> >>>>        minItems: 1
> >>>> -    maxItems: 3
> >>>> +    maxItems: 5
> >>>> +    additionalItems: true
> >>> Those additional clocks should be documented
> >>>
> >>> Maxime
> >> Hi Maxime,
> >>
> >> The problem it is specific to our soc, so is it possible to
> >>
> >> propose "optional clock" for 2 extras clocks in snps,dwmac.yaml
> >>
> >> and "official" description in soc yaml file (stm32-dwmac.yaml) ?
> >>
> >>     clocks:
> >>       minItems: 1
> >>       maxItems: 5
> >>       additionalItems: true
> >>       items:
> >>         - description: GMAC main clock
> >>         - description: Peripheral registers interface clock
> >>         - description:
> >>             PTP reference clock. This clock is used for programming the
> >>             Timestamp Addend Register. If not passed then the system
> >>             clock will be used and this is fine on some platforms.
> >>
> >> +      - description: optional clock
> >>
> >> +      - description: optional clock
> > I guess we'd really need to figure out what those clocks are doing,
> > they are probably helpful (and used, under a different name) by
> > others.
> >
> > Hopefully the questions Rob asked will clear that out
>
> Rob, do you have any ideas, suggestions ?

Answer my questions from patch 2:

> What does 'power mode' mean? IIRC, some DW MACs have a clock for WoL
> called LPI or something. Are you sure this is ST specific and not DW
> config or version specific?
