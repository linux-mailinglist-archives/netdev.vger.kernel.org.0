Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF34336DE
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhJSNWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231563AbhJSNWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 09:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AAF1610E7;
        Tue, 19 Oct 2021 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634649608;
        bh=xGEIDfi1JKH3eqvvi6gZj8PD5RM7Y9UpbqwvaVzs/Wo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=m49h4VW6MoCd4zMCdev/m86jNWKuJXK1Pvme1TuC3s7014zUBOYNyR0oDjYStrz6h
         HcGQ3SsdxazHbz+uU7eyGedc0n58OXoh9hWtnzJP3mFb+T4F8bC5TBftgPhjALJsAa
         UmT5EKpoEXNh9lU4lG/uDCByq5+sY8uHY9gQXCTB0+YqyElgM9IoBOUMHVRdcYcAY2
         aKssdW17ZWuW9g5wd+XRVoBk9ndAmAVWY0/O7y992m/ewf6T1/8JSCe2zbkzBaVuxR
         VvLaA4qhc0hOINVPN8nU58AT/0VOW96gBOkPway5Lz7KAYBR/CnvcGU430bvMNKmQO
         kojxFIc+kLPmA==
Received: by mail-ed1-f45.google.com with SMTP id a25so12763134edx.8;
        Tue, 19 Oct 2021 06:20:08 -0700 (PDT)
X-Gm-Message-State: AOAM531yp/c+Y2E8ypiSWONOxsy3RlCTKCTn50xiIc/6aUtTVkpsthy6
        /1aBN92EBvYuF7BgRo8GYo+IAXLMlHY1QRdynQ==
X-Google-Smtp-Source: ABdhPJwuCT2accakT1n8HM9H8FZqhzJoiBD2H7LJdGtKC3BtNmJwjl0n52dVamz1Jg6FtFki6Znb7OXYl78LT011sgY=
X-Received: by 2002:a17:906:c350:: with SMTP id ci16mr36562486ejb.466.1634649595458;
 Tue, 19 Oct 2021 06:19:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211011141733.3999-1-stephan@gerhold.net> <20211011141733.3999-4-stephan@gerhold.net>
 <YW3XgaiT2jBv4D+L@robh.at.kernel.org> <YW5t01Su5ycLm67c@gerhold.net>
In-Reply-To: <YW5t01Su5ycLm67c@gerhold.net>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 19 Oct 2021 08:19:42 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLWV56ehsT2HHpg_qCDxhWmTHgCQoKgZLot_Q8xCdF-OA@mail.gmail.com>
Message-ID: <CAL_JsqLWV56ehsT2HHpg_qCDxhWmTHgCQoKgZLot_Q8xCdF-OA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add schema for Qualcomm BAM-DMUX
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:DMA GENERIC OFFLOAD ENGINE SUBSYSTEM" 
        <dmaengine@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
        <devicetree@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>, Andy
        Shevchenko <andy.shevchenko@gmail.com>," 
        <~postmarketos/upstreaming@lists.sr.ht>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 2:03 AM Stephan Gerhold <stephan@gerhold.net> wrote:
>
> On Mon, Oct 18, 2021 at 03:22:25PM -0500, Rob Herring wrote:
> > On Mon, Oct 11, 2021 at 04:17:35PM +0200, Stephan Gerhold wrote:
> > > The BAM Data Multiplexer provides access to the network data channels of
> > > modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> > > MSM8974. It is built using a simple protocol layer on top of a DMA engine
> > > (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
> > >
> > > The device tree node combines the incoming interrupt with the outgoing
> > > interrupts (smem-states) as well as the two DMA channels, which allows
> > > the BAM-DMUX driver to request all necessary resources.
> > >
> > > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > > ---
> > > Changes since RFC: None.
> > > ---
> > >  .../bindings/net/qcom,bam-dmux.yaml           | 87 +++++++++++++++++++
> > >  1 file changed, 87 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > > new file mode 100644
> > > index 000000000000..33e125e70cb4
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
> > > @@ -0,0 +1,87 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/qcom,bam-dmux.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Qualcomm BAM Data Multiplexer
> > > +
> > > +maintainers:
> > > +  - Stephan Gerhold <stephan@gerhold.net>
> > > +
> > > +description: |
> > > +  The BAM Data Multiplexer provides access to the network data channels
> > > +  of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> > > +  or MSM8974. It is built using a simple protocol layer on top of a DMA engine
> > > +  (Qualcomm BAM DMA) and bidirectional interrupts to coordinate power control.
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: qcom,bam-dmux
> >
> > Is this block the same on every SoC? It needs to be SoC specific.
> >
>
> Hm, I think describing it as *SoC*-specific wouldn't be accurate:
> This node does not describe any hardware block, it's more a "firmware
> convention". The only hardware involved is the BAM DMA engine, which
> already has SoC/IP-specific compatibles in its own device tree node.
>
> This means that if anything there should be "firmware version"-specific
> compatibles, because one SoC might have different (typically signed)
> firmware versions that provide slightly different functionality.
> However, I have to admit that I'm not familiar enough with the different
> firmware versions to come up with a reasonable naming schema for the
> compatible. :/
>
> In general, I cannot think of any difference between different versions
> that would matter to a driver. The protocol is quite simple, and minor
> firmware differences can be better handled through the control channel
> that sets up the connection for the modem.
>
> Does that make sense?

Okay. Please add some of the above details to the binding.

Rob
