Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C9035F4D6
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhDNNZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 09:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351349AbhDNNZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 09:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B7EB61132;
        Wed, 14 Apr 2021 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618406705;
        bh=KsfaSXwOVw8QET+rbrgc/Q2gfMGscvpWJQ5f6uP0bDI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Iks8ZnUzibOCOteCTqLQDc3sO5dWbVeFufkJSHTUyiuVNtcpRqRXS0SLs11jkHmkb
         MM3xrtvIwsBTm4XeXa+KJBW5otpGgsXJdBf1PLWoFl6S+6jknNP+IEbgGHPls7OmuQ
         kHZnazrVjYdMCTbHdbaTM5brZS9X3pnAGdhY44N6GEnw95SrMNdrMDcDwkciMq/Ps/
         ffiJEXI7SmS/tWpFVde8yq8BhxsCkNgrrh030U5t5Z0HuTWY+1VXdnFLwC83BoOBOe
         b0rnWYbgFPS4Xq0+Lz4Jqn8YGEFMv/iS7JktC43lK2k8yNa3ddhxjTHd2GzY/MAK3Z
         GW8y9TNcG0/KA==
Received: by mail-qt1-f181.google.com with SMTP id y2so15369137qtw.13;
        Wed, 14 Apr 2021 06:25:05 -0700 (PDT)
X-Gm-Message-State: AOAM532rKQpNZzGme299M/aVLuKhG/gFDtGPqldHy/7NodD/sBWr1Npy
        CK4qHwXhAVtJtRDx2Xm4/3u3ldV/kEs8uFExLA==
X-Google-Smtp-Source: ABdhPJwJA1ciQB+OakY6pTjV36EpJWrGm4YT0HjQNhSLoyqhAQXeNhsuTJc+12R0uWC9xI3XPGMST7pxg0owMnX4v58=
X-Received: by 2002:a05:622a:8:: with SMTP id x8mr26156855qtw.31.1618406704544;
 Wed, 14 Apr 2021 06:25:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210409134056.18740-1-a-govindraju@ti.com> <20210409134056.18740-4-a-govindraju@ti.com>
 <20210412175134.GA4109207@robh.at.kernel.org> <e1c2b752-5a2b-e973-c188-5916d8a2e31f@ti.com>
In-Reply-To: <e1c2b752-5a2b-e973-c188-5916d8a2e31f@ti.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 14 Apr 2021 08:24:52 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ6OW6Pwtj7yTiCguvXDPfMreVpEsxAg59pwfa2qWvqEA@mail.gmail.com>
Message-ID: <CAL_JsqJ6OW6Pwtj7yTiCguvXDPfMreVpEsxAg59pwfa2qWvqEA@mail.gmail.com>
Subject: Re: [PATCH 3/4] dt-bindings: net: can: Document transceiver
 implementation as phy
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-phy@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 1:49 AM Aswath Govindraju <a-govindraju@ti.com> wrote:
>
> Hi Rob,
>
> On 12/04/21 11:21 pm, Rob Herring wrote:
> > On Fri, Apr 09, 2021 at 07:10:53PM +0530, Aswath Govindraju wrote:
> >> From: Faiz Abbas <faiz_abbas@ti.com>
> >>
> >> Some transceivers need a configuration step (for example, pulling the
> >> standby or enable lines) for them to start sending messages. The
> >> transceiver can be implemented as a phy with the configuration done in the
> >> phy driver. The bit rate limitation can the be obtained by the driver using
> >> the phy node.
> >>
> >> Document the above implementation in the bosch mcan bindings
> >>
> >> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
> >> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> >> ---
> >>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> >> index 798fa5fb7bb2..2c01899b1a3e 100644
> >> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> >> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> >> @@ -109,6 +109,12 @@ properties:
> >>    can-transceiver:
> >>      $ref: can-transceiver.yaml#
> >>
> >> +  phys:
> >> +    minItems: 1
> >
> > maxItems: 1
>
> Will add this in the respin.
>
> >
> >> +
> >> +  phy-names:
> >> +    const: can_transceiver
> >
> > Kind of a pointless name. You don't really need a name if there's a
> > single entry.
> >
>
> This name used by devm_phy_optional_get() in m_can driver to get the phy
> data structure.

With no name, you'll get the 1st one. Looks like the phy subsystem
warns on this. That's wrong, so please fix that.

Rob
