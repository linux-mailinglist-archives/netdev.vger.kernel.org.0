Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEA14715BD
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhLKTfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhLKTfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:35:01 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96100C061714;
        Sat, 11 Dec 2021 11:35:01 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so13089103otv.9;
        Sat, 11 Dec 2021 11:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ThnTDByuTRKbLET20HfDuO4MA37AMxZPubz2iEC7OI=;
        b=RXL9AOmQ11Mn+hQAi6ZAi1MF4MicKAvwf7/4iEGwvZCzF+iR6+xbEfB+9Pk4wnl32g
         qdkjHMmB9ysF0BMPN3Tx46sh8oLvWHiR3TOMuCtI/QhAt+PQ5HhYzrca6XLp4BZM7gnx
         9m+rZr3vv/NxT1hqm2ONPj4bi47DSY9HrvtaZOC1feO4UvwirHdVtVc7nH8ozoDVnbr/
         tf2DjkaAODCX+2bWNFXHwII6c/ad5fr0lGnvOT/58bXfF9MKMjWpxG/0LnT452l3qwKP
         CskNiFIt17J/YfxrEktUV3qAwhG7rddCzXMf9zMfWeG13r3U72h/B4bwRyryQvba8Jfn
         7iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ThnTDByuTRKbLET20HfDuO4MA37AMxZPubz2iEC7OI=;
        b=FLMg/6VLoWBU4HxW0vacAAL3qN+9jLHPFsFr/Cgu5FNxRZ4X2JbEhvWQL6tT5bG0rb
         1LKe5sl4OubanKXj7oExrMahwjrUt/heZZdDvo3TPhdtb8Y6C4ptO9euwtoYcOigK7aV
         zMTBnrjMVzWBn9J5rOvu41ogXOJWX1S7FvIQ8cDvFntALHcK55ZWGCJIwEvG4Cf5AdAr
         QHVMbsug2WlFcIDKygqoqp5FZI10Ttk30SyPyJfzAiMdRA3JA90n3Ebi73zKJ6gD6q86
         ATgqbI4MFfzhavd4l6IC8rOVNBTP+PApL8S7TkJDslyadroVAPzcKRJ9uSNPs2WYvNw9
         94HA==
X-Gm-Message-State: AOAM532zE6Qg+kDvzOlsybsNdVL5SCw6KDyGReYh5DAQoMGNovZ8cqPH
        DLZUMqOHSYNYLaA913yGEOIsCIpsNCnxvEI87yg=
X-Google-Smtp-Source: ABdhPJxNEfKRHeU29NN6oWa8t/BJUcitJC2JZGrdiiUpp9GmzT5EwT4Ss9PMF7z5mqUUqag32OlCQpFbd3w0vP0yD4I=
X-Received: by 2002:a05:6830:4d1:: with SMTP id s17mr17362637otd.246.1639251300939;
 Sat, 11 Dec 2021 11:35:00 -0800 (PST)
MIME-Version: 1.0
References: <1638864419-17501-1-git-send-email-wellslutw@gmail.com>
 <1638864419-17501-2-git-send-email-wellslutw@gmail.com> <YbPHxVf1vXZj9GOC@robh.at.kernel.org>
In-Reply-To: <YbPHxVf1vXZj9GOC@robh.at.kernel.org>
From:   =?UTF-8?B?5ZGC6Iqz6aiw?= <wellslutw@gmail.com>
Date:   Sun, 12 Dec 2021 03:34:49 +0800
Message-ID: <CAFnkrsmXu9ceSQ7rzOAFy_kP6JMa7GvY7HCbT=_wfskH6wXuSw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] devicetree: bindings: net: Add bindings
 doc for Sunplus SP7021.
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, Wells Lu <wells.lu@sunplus.com>,
        vincent.shih@sunplus.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you very much for your review.
Please see my replies below:

> Add bindings documentation for Sunplus SP7021.
>
[...]
> > +
> > +  interrupts:
> > +    description: |
> > +      Contains number and type of interrupt. Number should be 66.
>
> Drop. That's every 'interrupts' and the exact number is outside the
> scope of the binding.

Yes, I'll drop the descriptions next patch.
interrupts property will be:

  interrupts:
    maxItems: 1


[...]
> > +
> > +  mdio:
>
> Just need:
>
>        $ref: mdio.yaml#
>        unevaluatedProperties: false
>
> and drop the rest.

Yes, I'll modify mdio node next patch.
mdio node will be:

  mdio:
    $ref: mdio.yaml#
    unevaluatedProperties: false


> > +    type: object
> > +    description: external MDIO Bus
> > +
> > +    properties:
> > +      "#address-cells":
> > +        const: 1
> > +
> > +      "#size-cells":
> > +        const: 0
> > +
> > +    patternProperties:
> > +      "^ethernet-phy@[0-9a-f]+$":
> > +        type: object
> > +        description: external PHY node
> > +
> > +        properties:
> > +          reg:
> > +            minimum: 0
> > +            maximum: 30

Can I limit value of 'reg' to no more than 30?


> > +
> > +        required:
> > +          - reg
> > +
> > +additionalProperties: false
> > +
[...]
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/irq.h>
> > +    emac: emac@9c108000 {
>
> ethernet@9c108000 {

I'll modify it next patch.


[...]
> > 2.7.4
> >


Best regards,
Wells
