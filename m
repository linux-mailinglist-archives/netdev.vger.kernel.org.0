Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A805E84B2A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfHGMEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:04:49 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:35253 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfHGMEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 08:04:48 -0400
Received: from localhost (lpr83-1-88-168-111-231.fbx.proxad.net [88.168.111.231])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 7D6CD200002;
        Wed,  7 Aug 2019 12:04:46 +0000 (UTC)
Date:   Wed, 7 Aug 2019 14:04:45 +0200
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: snps,dwmac: update reg minItems
 maxItems
Message-ID: <20190807120445.yje57g6mwcmyztki@flea>
References: <20190806125041.16105-1-narmstrong@baylibre.com>
 <20190806125041.16105-2-narmstrong@baylibre.com>
 <CAL_Jsq+6kCO8x53d1670VjgEjfs5opKY+R3OgsAo0WsXqq512Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+6kCO8x53d1670VjgEjfs5opKY+R3OgsAo0WsXqq512Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Aug 06, 2019 at 09:22:12AM -0600, Rob Herring wrote:
> +Maxime
>
> On Tue, Aug 6, 2019 at 6:50 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
> >
> > The Amlogic Meson DWMAC glue bindings needs a second reg cells for the
> > glue registers, thus update the reg minItems/maxItems to allow more
> > than a single reg cell.
> >
> > Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> > ---
> >  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
>
> I haven't checked, but the derivative schema could be assuming this
> schema enforced reg is 1 item.

Yeah, we do for
Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.yaml
(but somehow not allwinner,sun8i-a83t-emac.yaml)

Neil, can you add it to sun7i-a20-gmac?

> I don't think that's a major issue
> though.
>
> Acked-by: Rob Herring <robh@kernel.org>

With that fixed,
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
