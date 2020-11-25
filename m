Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9092C3A38
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 08:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgKYHhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 02:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:52166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgKYHhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 02:37:34 -0500
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95CB206D9;
        Wed, 25 Nov 2020 07:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606289853;
        bh=pfubf2Eam/M4OwhA361SdUjqP5Jpv5yEhn0hQW/qEXM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=t1ilZtQl84DIdUr/Ndzh2aOEoxPNsNOyqAs7YwWNxFOl4LZqMrxDzTxTLVGwV/ARZ
         5aMRl7wAttYA+TX0jAvo+IgqvlbpsuyYEN2a6trloHLJYgVsExhLbnlcjOQSpjKNr0
         0tlBSE7OqbHnbe4fyyRNmWOx2CXBLCX3nLHFn8kY=
Received: by mail-ed1-f42.google.com with SMTP id q16so1456589edv.10;
        Tue, 24 Nov 2020 23:37:32 -0800 (PST)
X-Gm-Message-State: AOAM530Apxe1P79mtr70UXq5kx/+vDBYha0N+VvJAlDzjKGv7uT8izpj
        dlnReu7YE3x7Ezi2qc765D++eNAOJj2VcllCnUo=
X-Google-Smtp-Source: ABdhPJwuArKsAqTsBCAJDIDSansjrfy5FPVUgH9SvGi2jdhaUnKWI21oZXoXdA3HGRZkIUlEqhKaZTPWEalobRnY4l8=
X-Received: by 2002:a05:6402:2218:: with SMTP id cq24mr2305279edb.246.1606289851348;
 Tue, 24 Nov 2020 23:37:31 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123080123.GA5656@kozik-lap> <CACwDmQBh77pqivk=bBv3SJ14HLucY42jZyEaKAX+n=yS3TSqFw@mail.gmail.com>
 <20201124114151.GA32873@kozik-lap> <CACwDmQDWtfa8tXkG8W+EQxjdYJ6rkVgN9PjOVQdK8CwUXAURMg@mail.gmail.com>
In-Reply-To: <CACwDmQDWtfa8tXkG8W+EQxjdYJ6rkVgN9PjOVQdK8CwUXAURMg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 25 Nov 2020 08:37:19 +0100
X-Gmail-Original-Message-ID: <CAJKOXPc1sBvuZACRM_4fjiSJECg7eRqWB+c2aQPDE1iPWHbdmA@mail.gmail.com>
Message-ID: <CAJKOXPc1sBvuZACRM_4fjiSJECg7eRqWB+c2aQPDE1iPWHbdmA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
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

On Wed, 25 Nov 2020 at 04:08, Bongsu Jeon <bongsu.jeon2@gmail.com> wrote:
>
> On 11/24/20, krzk@kernel.org <krzk@kernel.org> wrote:
> > On Tue, Nov 24, 2020 at 08:39:40PM +0900, Bongsu Jeon wrote:
> >> On Mon, Nov 23, 2020 at 5:02 PM krzk@kernel.org <krzk@kernel.org> wrote:
> >> >
> >> > On Mon, Nov 23, 2020 at 04:55:26PM +0900, Bongsu Jeon wrote:
> >  > >  examples:
> >> > >    - |
> >> > >      #include <dt-bindings/gpio/gpio.h>
> >> > > @@ -71,3 +81,17 @@ examples:
> >> > >              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
> >> > >          };
> >> > >      };
> >> > > +  # UART example on Raspberry Pi
> >> > > +  - |
> >> > > +    &uart0 {
> >> > > +        status = "okay";
> >> > > +
> >> > > +        s3fwrn82_uart {
> >> >
> >> > Just "bluetooth" to follow Devicetree specification.
> >> Sorry. I don't understand this comment.
> >> Could you explain it?
> >> Does it mean i need to refer to the net/broadcom-bluetooth.txt?
> >
> > The node name should be "bluetooth", not "s3fwrn82_uart", because of
> > Devicetree naming convention - node names should represent generic class
> > of a device.
> >
> Actually, RN82 is the nfc device.
> So, is it okay to use the name as nfc instead of Bluetooth?

Oops, of course, nfc, I don't know why the Bluetooth stuck in my mind.

Best regards,
Krzysztof
