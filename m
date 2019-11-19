Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 129431029C5
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbfKSQua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:50:30 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41021 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbfKSQu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:50:28 -0500
Received: by mail-io1-f68.google.com with SMTP id r144so23945578iod.8
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJZxSWnOG8Gs2dy+Q5ughCz+Da0hQ1yJBJ+RDGbHpkw=;
        b=nDDU/6xBhkkZKiUVL5Ocxj7cHCsYU4c0MefmZkqPYH0eKRB2JYB2UZt217GSyNryga
         i0HmYl3s5H1A1Q62MU6oqERAk5Fn4PH/oL86+g4t4+AlS+MaRN/h6GJfSTST69GkI0G4
         W5eu6cHoHNLVEfYFYA4fFqOuBbWxy2p78Vonc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJZxSWnOG8Gs2dy+Q5ughCz+Da0hQ1yJBJ+RDGbHpkw=;
        b=CQoV3QR7EbYvgFeGo/NzlgkTZwVG7HBgiOb0mNt4GaJJkbgZqw+yatHmcHbBtT3Cc+
         c+op9o/o6hALxBN7v4EGkqhbzweaprSQ3TBIfTqOjZi3BJ2mEFPIJMXuychlM5FXH2wZ
         AQ36c0/w29L5rtz4cUDWsVg8k8RupxRqPEOsxDyIK9xJrtYx3QixjKxvxnxbmdBev5io
         mv+yAD2476jRtPjLY1Pxghe6uc3Te7lrU5vcKAItpX4qWNx/b+1M6umdHfeS+WtUKifT
         in0Ktx9Lqa36umlFkQKEy+4AqETgI6BwDBuckZh2+641KaL+2alfDFbcBtJZfhKpVuf6
         rTyw==
X-Gm-Message-State: APjAAAWi0Y3yHUYkjYz2q0fkkwEP8vepss26VqPnBXv2hqJKiMsmUQi9
        5RMXeY+PHogHoWClg0hsGqFz53tcOg4=
X-Google-Smtp-Source: APXvYqwJ3hBdcUAPP0Kpil0eG5as7X6aSyV/W3tHktC1ywH8csiXm5GpWvp+kIOX/wZDwnQopFnnHw==
X-Received: by 2002:a6b:5505:: with SMTP id j5mr7804066iob.37.1574182226897;
        Tue, 19 Nov 2019 08:50:26 -0800 (PST)
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com. [209.85.166.172])
        by smtp.gmail.com with ESMTPSA id d11sm5527638ill.17.2019.11.19.08.50.24
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:50:25 -0800 (PST)
Received: by mail-il1-f172.google.com with SMTP id s5so235000iln.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:50:24 -0800 (PST)
X-Received: by 2002:a92:ca8d:: with SMTP id t13mr21900377ilo.58.1574182224501;
 Tue, 19 Nov 2019 08:50:24 -0800 (PST)
MIME-Version: 1.0
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid> <079C85BE-FBC5-4A2B-9EBF-0CEDB6F30C18@holtmann.org>
In-Reply-To: <079C85BE-FBC5-4A2B-9EBF-0CEDB6F30C18@holtmann.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Tue, 19 Nov 2019 08:50:11 -0800
X-Gmail-Original-Message-ID: <CAD=FV=U4qOyLWTg3w-AfF3o_0VBTxanpaa6of70viL2v9g3Xgg@mail.gmail.com>
Message-ID: <CAD=FV=U4qOyLWTg3w-AfF3o_0VBTxanpaa6of70viL2v9g3Xgg@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm config
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Nov 18, 2019 at 9:39 PM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Abhishek,
>
> > Add documentation for pcm parameters.
> >
> > Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> > ---
> >
> > Changes in v6: None
> > Changes in v5: None
> > Changes in v4: None
> > Changes in v3: None
> > Changes in v2: None
> >
> > .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
> > include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
> > 2 files changed, 48 insertions(+)
> > create mode 100644 include/dt-bindings/bluetooth/brcm.h
> >
> > diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > index c749dc297624..8561e4684378 100644
> > --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> > @@ -29,10 +29,20 @@ Optional properties:
> >    - "lpo": external low power 32.768 kHz clock
> >  - vbat-supply: phandle to regulator supply for VBAT
> >  - vddio-supply: phandle to regulator supply for VDDIO
> > + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
> > + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
> > + - brcm,bt-pcm-frame-type: short, long
> > + - brcm,bt-pcm-sync-mode: slave, master
> > + - brcm,bt-pcm-clock-mode: slave, master
> >
> > +See include/dt-bindings/bluetooth/brcm.h for SCO/PCM parameters. The default
> > +value for all these values are 0 (except for brcm,bt-sco-routing which requires
> > +a value) if you choose to leave it out.
> >
> > Example:
> >
> > +#include <dt-bindings/bluetooth/brcm.h>
> > +
> > &uart2 {
> >        pinctrl-names = "default";
> >        pinctrl-0 = <&uart2_pins>;
> > @@ -40,5 +50,11 @@ Example:
> >        bluetooth {
> >                compatible = "brcm,bcm43438-bt";
> >                max-speed = <921600>;
> > +
> > +               brcm,bt-sco-routing        = <BRCM_SCO_ROUTING_TRANSPORT>;
>
> in case you use transport which means HCI, you would not have values below. It is rather PCM here in the example.
>
> > +               brcm,bt-pcm-interface-rate = <BRCM_PCM_IF_RATE_512KBPS>;
> > +               brcm,bt-pcm-frame-type     = <BRCM_PCM_FRAME_TYPE_SHORT>;
> > +               brcm,bt-pcm-sync-mode      = <BRCM_PCM_SYNC_MODE_MASTER>;
> > +               brcm,bt-pcm-clock-mode     = <BRCM_PCM_CLOCK_MODE_MASTER>;
> >        };
> > };
>
> And I am asking this again. Is this adding any value to use an extra include file? Inside the driver we are not really needing these values since they are handed to the hardware.

Personally I find that they add value in that it makes it easier for
someone tweaking the device tree to know what the expected valid
values are and what they mean.  I think Matthias also found value in
them since he suggested them in:

https://lore.kernel.org/r/20191114175836.GI27773@google.com

There, he said:

> I'd suggest to define constants in include/dt-bindings/bluetooth/brcm.h
> and use them instead of literals, with this we wouldn't rely on (optional)
> comments to make the configuration human readable.

...which seems to make sense to me.

-Doug
