Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1FF107535
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 16:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfKVPuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 10:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbfKVPuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 10:50:46 -0500
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B087D20721;
        Fri, 22 Nov 2019 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574437844;
        bh=YyVgvQ275e3tv6kQYPq05Cdmt5/g44Jwrrc70QXxg0Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=lCh/GGuFABRGLpa77QaxVyOzcPZwPwcBWn8bzNYXZuu7I9azFITQRJLxRNAn8NT7C
         qpns74d3vbTGjo+5q1X6cQ4qmI/n18DAZzXx5IqtC7z1lwfMBN75k0eMBkkwY2PVK5
         0o5GnnfzVGg58itoNZNcH6zgJykSMZnC+DTa7IuA=
Received: by mail-qv1-f45.google.com with SMTP id x14so3075721qvu.0;
        Fri, 22 Nov 2019 07:50:44 -0800 (PST)
X-Gm-Message-State: APjAAAU+NFInupP4/DZfXasBerLu27ZLeuRQybMEvNOR/eSOr9UB9ioA
        yVbsvxbubvZAJtwbKDM13/ofxSmSdV0d5Yxe/g==
X-Google-Smtp-Source: APXvYqwGGJblDyLrod013TGs3RdLWg22H1HuGkGQ1TL0T/oqtvU6mgVVePtuiNDWsbDa/2MkKnaLB0nx29hNdiuDJeE=
X-Received: by 2002:a0c:aee1:: with SMTP id n33mr5260909qvd.135.1574437843805;
 Fri, 22 Nov 2019 07:50:43 -0800 (PST)
MIME-Version: 1.0
References: <20191118192123.82430-1-abhishekpandit@chromium.org>
 <20191118110335.v6.3.I18b06235e381accea1c73aa2f9db358645d9f201@changeid>
 <20191121212923.GA24437@bogus> <06AE1B9D-F048-4AF1-9826-E8CAFA44DD58@holtmann.org>
In-Reply-To: <06AE1B9D-F048-4AF1-9826-E8CAFA44DD58@holtmann.org>
From:   Rob Herring <robh@kernel.org>
Date:   Fri, 22 Nov 2019 09:50:32 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKso2Us5VW-Qp8mENAkMmoEh7YDT+HfhRMD1BKi7q=qAw@mail.gmail.com>
Message-ID: <CAL_JsqKso2Us5VW-Qp8mENAkMmoEh7YDT+HfhRMD1BKi7q=qAw@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] dt-bindings: net: broadcom-bluetooth: Add pcm config
To:     Marcel Holtmann <marcel@holtmann.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        devicetree <devicetree@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 6:34 AM Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Rob,
>
> >> Add documentation for pcm parameters.
> >>
> >> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> >> ---
> >>
> >> Changes in v6: None
> >> Changes in v5: None
> >> Changes in v4: None
> >> Changes in v3: None
> >> Changes in v2: None
> >
> > Really? I'm staring at v2 that looks a bit different.
> >
> >> .../bindings/net/broadcom-bluetooth.txt       | 16 ++++++++++
> >> include/dt-bindings/bluetooth/brcm.h          | 32 +++++++++++++++++++
> >> 2 files changed, 48 insertions(+)
> >> create mode 100644 include/dt-bindings/bluetooth/brcm.h
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> >> index c749dc297624..8561e4684378 100644
> >> --- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> >> +++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
> >> @@ -29,10 +29,20 @@ Optional properties:
> >>    - "lpo": external low power 32.768 kHz clock
> >>  - vbat-supply: phandle to regulator supply for VBAT
> >>  - vddio-supply: phandle to regulator supply for VDDIO
> >> + - brcm,bt-sco-routing: PCM, Transport, Codec, I2S
> >> + - brcm,bt-pcm-interface-rate: 128KBps, 256KBps, 512KBps, 1024KBps, 2048KBps
> >> + - brcm,bt-pcm-frame-type: short, long
> >> + - brcm,bt-pcm-sync-mode: slave, master
> >> + - brcm,bt-pcm-clock-mode: slave, master
> >
> > Little of this seems unique to Broadcom. We already have some standard
> > audio related properties for audio interfaces such as 'format',
> > 'frame-master' and 'bitclock-master'. Ultimately, this would be tied
> > into the audio complex of SoCs and need to work with the audio
> > bindings. We also have HDMI audio bindings.
> >
> > Maybe sco-routing is unique to BT and still needed in some form though
> > if you describe the connection to the SoC audio complex, then maybe
> > not? I'd assume every BT chip has some audio routing configuration.
>
> so we tried to generalize this some time before and failed to get a proper consensus.
>
> In general I am with you that we should just expose generic properties from the attached audio codec, but nobody has come up with anything like that. And I think aligning all chip manufacturers will take some time.
>

That shouldn't be hard. It's a solved problem for codecs and HDMI. I
don't think BT is any more complicated (ignoring phones). I suspect
it's not solved simply because no one wants to do the work beyond
their 1 BT device they care about ATM.

> Maybe in the interim we just use brcm,bt-pcm-int-params = [00 00 ..] as initially proposed.

What's the device using this? Some chromebook I suppose. I think it
would be better to first see how this fits in with the rest of the
audio subsystem. Until then, the driver should probably just default
to "transport" mode which I assume is audio routed over the UART
interface. That should work on any platform at least, but may not be
optimal.

Rob
