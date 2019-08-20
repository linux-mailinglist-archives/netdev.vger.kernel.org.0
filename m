Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3BE96A0C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbfHTUSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:18:01 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41956 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTUSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:18:00 -0400
Received: by mail-oi1-f194.google.com with SMTP id g7so5151682oia.8;
        Tue, 20 Aug 2019 13:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Do7rgk/e6SkhLJFZ//u+bS6ASixL3x/VgaGx7XQsINQ=;
        b=P2NLC74e2Xs4De0rALlzIE89sgPJa7ppZiJEI9MWLGs0qL2LH2HICwhHdHB3ZKksYB
         rB6zdVMTZjDHASjONz8yzVN77nDdxdKc68tT0WSOQFhMIuG2OB2yUqpPpz+QNIuAdSLl
         ZW3vPXRtqZMk2lcw3bykA/IjHi/b1+p78uzKpcFWqHMXLEz+JiumEsaUigTCdHzW6mZY
         qo557pm2wEkp3Cc/LqJpTnXLEFXbAv186VF1dX+wtWCOh+QjUTdZ41a5jsY9JttG/NdV
         1HJs7dGhKckeqyro77ZmRwnT3C911pJxRwMUir9fM1+tFMWjaoOhXStFjjuh6RkVduln
         JN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Do7rgk/e6SkhLJFZ//u+bS6ASixL3x/VgaGx7XQsINQ=;
        b=j5hGR+C6dkGWuE2uDmJVRf4A1w1FAW7c9LJpMsqB+0nMPS/TBsDZa+RzH3lyVFpU4l
         6mz1FC4oSUdca4Ev2lb2WFQNPaF5OPYd4PcdEICslH61P8jdO/TrnYLJqw6k98eOZB1l
         ZeIep9NjwczKLyqKG0B/vLefjCvwuMVSFAIcDFGicGG5bJZszGN+go1UeWloxawsc3xU
         Bri6wzYU+oJb8yPUFQ2gklIN+eCSIjVEySmVcDBHkKqUY0QqORCahRxNqtb+ZTVgaDQ8
         dst8e+t+D3mDAFrG8HHGm4MDRT/4b2eVdK8rTwdPt4T9E5qkdGzJQR5EYhebHPq8WkW3
         TBSQ==
X-Gm-Message-State: APjAAAXO35dhkB6u9dqauIR9SG9WvyqWCvaoZIkSaxYKDv0vuf5Qu7ag
        8R92bGgc1JFW6Ps3lLHIpYUXj7zF3j1bIUvI+VSOLsFW
X-Google-Smtp-Source: APXvYqz8QBrUZytquR+jcvW5t0XCKEchKH1yCSzPctu/Wl30VX0pR70g4FhY1GPwzBppfd5C5vdN/whftMemITke8kg=
X-Received: by 2002:a05:6808:b14:: with SMTP id s20mr1332830oij.15.1566332279621;
 Tue, 20 Aug 2019 13:17:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190820075742.14857-1-narmstrong@baylibre.com> <20190820075742.14857-2-narmstrong@baylibre.com>
In-Reply-To: <20190820075742.14857-2-narmstrong@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 20 Aug 2019 22:17:48 +0200
Message-ID: <CAFBinCDP898fhoqh8wApfrsqAuv1dEQSoxy0yDA2hHKxoFsr+g@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] dt-bindings: net: snps,dwmac: update reg
 minItems maxItems
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 9:57 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> The Amlogic Meson DWMAC glue bindings needs a second reg cells for the
> glue registers, thus update the reg minItems/maxItems to allow more
> than a single reg cell.
>
> Also update the allwinner,sun7i-a20-gmac.yaml derivative schema to specify
> maxItems to 1.
this looks good to me because:
- allwinner,sun7i-a20-gmac.yaml now restricts reg to maxItems 1
- allwinner,sun8i-a83t-emac.yaml already restricts reg to maxItems 1
- amlogic,meson-dwmac.yaml (introduced in patch 2 from this series)
will need maxItems 2
- (these are all yaml based schemas for DWMAC IP)

> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Acked-by: Rob Herring <robh@kernel.org>
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
