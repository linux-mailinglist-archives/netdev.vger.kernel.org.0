Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221B2C24CB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732950AbgKXLjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727909AbgKXLjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:39:52 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE1CC0613D6;
        Tue, 24 Nov 2020 03:39:51 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id o11so21556080ioo.11;
        Tue, 24 Nov 2020 03:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o+pLgnufOu586P5N25km8tKyPfvWEh+E0AYw7VCffmc=;
        b=fAlU84St8aTSVSdLa7K2XwZARe2D+EuLN2meQQBV4nfKO4qX+KWuvYvessuPsLRGVQ
         GN29tZ50ReEtksCCcofpdnqRZzJv/7V6CWQCr9tx1nzRTGfVYZX2WdbpytUw8bzZ9Zas
         5qq9lxwbQngbd77gwvPkPlQTtdajvoxaClGI1hdEXRI6U6mBi4yKYSxCoUV2cX1yWDrC
         zdhnL1searhMs4HOOYWZgCkoFiJK0TZFLYl9AiFzZRuK20zGfTy4HOLCw3ex1A+eI+I4
         8U+lgToKbExpLb/YDcmy/Oxsuf5rfumWsV4aSFdbH6o/ZHz+HT3LYhXUnS/nL/pkrkr2
         mtVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o+pLgnufOu586P5N25km8tKyPfvWEh+E0AYw7VCffmc=;
        b=UGOz40LTly7X3qUVLYRs10b3Q18MLD83+IeZeV8I4BpB0zvvY2gqCs5Ur+dloqdKn5
         YuFPeP+fWxOsfzz71uKaI5LpNdvstUo795kqtTUAk6ONGAn3diwhuxPAGM6D6OO8Gzo/
         mNefqHjP68Nvlo0KsD8fD3TbxIobvlg2grpAs/IWM9XmNpyIdWZJV3l0LJDP4367MT36
         UFxTDDwyTJglGlx9zc0IQ5nQV4gs4ATbMzqlg40YsJuPWWv0qctdnTC3HudUVZDxydrx
         3/OlC4WPoz+AnGb+0tS73U41Ta9+J6qI+z4+Cq/ZisPBRoaMACyDpRfTSYlD20rSisu1
         P2fQ==
X-Gm-Message-State: AOAM533GrtM1XOTDGHpkB5CZA0KdiLWiCUYF1JCpKs0UG2PUXth9+NSm
        s7p4f9DiZ7EgXQgu1vsnzSInTb5SBaS4On2Yd0Y=
X-Google-Smtp-Source: ABdhPJyAuwpxepiQkMqr6HXHH/PjSQ2oJsHlN/rNT/dhgM+V8+l1AuOD348LrUQ2R1isVaXMJMSeQXxPhPCU2I6n07g=
X-Received: by 2002:a6b:fc16:: with SMTP id r22mr653203ioh.55.1606217991225;
 Tue, 24 Nov 2020 03:39:51 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5> <20201123080123.GA5656@kozik-lap>
In-Reply-To: <20201123080123.GA5656@kozik-lap>
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
Date:   Tue, 24 Nov 2020 20:39:40 +0900
Message-ID: <CACwDmQBh77pqivk=bBv3SJ14HLucY42jZyEaKAX+n=yS3TSqFw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
To:     "krzk@kernel.org" <krzk@kernel.org>
Cc:     Bongsu Jeon <bongsu.jeon@samsung.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 5:02 PM krzk@kernel.org <krzk@kernel.org> wrote:
>
> On Mon, Nov 23, 2020 at 04:55:26PM +0900, Bongsu Jeon wrote:
> > Since S3FWRN82 NFC Chip, The UART interface can be used.
> > S3FWRN82 supports I2C and UART interface.
> >
> > Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> > ---
> >  .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 28 +++++++++++++++++--
> >  1 file changed, 26 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> > index cb0b8a560282..37b3e5ae5681 100644
> > --- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> > +++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> > @@ -13,6 +13,7 @@ maintainers:
> >  properties:
> >    compatible:
> >      const: samsung,s3fwrn5-i2c
> > +    const: samsung,s3fwrn82-uart
>
> This does not work, you need to use enum. Did you run at least
> dt_bindings_check?
>
Sorry. I didn't. I fixed it as below and ran dt_bindings_check.
    compatible:
       oneOf:
           - enum:
               - samsung,s3fwrn5-i2c
               - samsung,s3fwrn82


> The compatible should be just "samsung,s3fwrn82". I think it was a
> mistake in the first s3fwrn5 submission to add a interface to
> compatible.
>
Ok. I will change the name.

> >
> >    en-gpios:
> >      maxItems: 1
> > @@ -47,10 +48,19 @@ additionalProperties: false
> >  required:
> >    - compatible
> >    - en-gpios
> > -  - interrupts
> > -  - reg
> >    - wake-gpios
> >
> > +allOf:
> > +  - if:
> > +      properties:
> > +        compatible:
> > +          contains:
> > +            const: samsung,s3fwrn5-i2c
> > +    then:
> > +      required:
> > +        - interrupts
> > +        - reg
> > +
> >  examples:
> >    - |
> >      #include <dt-bindings/gpio/gpio.h>
> > @@ -71,3 +81,17 @@ examples:
> >              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> >          };
> >      };
> > +  # UART example on Raspberry Pi
> > +  - |
> > +    &uart0 {
> > +        status = "okay";
> > +
> > +        s3fwrn82_uart {
>
> Just "bluetooth" to follow Devicetree specification.
Sorry. I don't understand this comment.
Could you explain it?
Does it mean i need to refer to the net/broadcom-bluetooth.txt?

>
> Best regards,
> Krzysztof
