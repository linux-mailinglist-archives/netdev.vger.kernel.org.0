Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4FA8351D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbfHFPW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbfHFPW0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 11:22:26 -0400
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26EA5216B7;
        Tue,  6 Aug 2019 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565104945;
        bh=JMOEGp6KBvPBaAeXLbOqrCVjJ676yUa1QkpMH2rvtq4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WB6QyejA8rC5KTGkiRanEHrenr2L+WDGFEwbW+24bcL6OUKddBHt1Km2Qppjg/bK5
         g6/jDc8o51vd81bcLHPWsTds7N81BByiFL2CDoWg7U0NJOyGa1kRPubYoEDiXKxvsd
         u0YsfNugfJZSgo/DSk6wYjlQaQsowFhNnHCQfeI8=
Received: by mail-qt1-f175.google.com with SMTP id z4so84965007qtc.3;
        Tue, 06 Aug 2019 08:22:25 -0700 (PDT)
X-Gm-Message-State: APjAAAXSy73EV+nKfl3TTWFwJf2TUDd6QsvH5WGdcQaLiMJ0utQWFOT9
        AN3vdVIcAQl7aM945yhqMLPrhXRip+ntDgrGow==
X-Google-Smtp-Source: APXvYqxiYQR/HHbmEVYeeT1TCkPHwlx94sDjj7D7ngVhqwAXC1LaYwuz8JDKA4JGq7UFpO7Gh+2kiQyApncgjpmPu2I=
X-Received: by 2002:aed:3fb0:: with SMTP id s45mr3591713qth.136.1565104944340;
 Tue, 06 Aug 2019 08:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190806125041.16105-1-narmstrong@baylibre.com> <20190806125041.16105-2-narmstrong@baylibre.com>
In-Reply-To: <20190806125041.16105-2-narmstrong@baylibre.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 6 Aug 2019 09:22:12 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+6kCO8x53d1670VjgEjfs5opKY+R3OgsAo0WsXqq512Q@mail.gmail.com>
Message-ID: <CAL_Jsq+6kCO8x53d1670VjgEjfs5opKY+R3OgsAo0WsXqq512Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: snps,dwmac: update reg minItems maxItems
To:     Neil Armstrong <narmstrong@baylibre.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Maxime

On Tue, Aug 6, 2019 at 6:50 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> The Amlogic Meson DWMAC glue bindings needs a second reg cells for the
> glue registers, thus update the reg minItems/maxItems to allow more
> than a single reg cell.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

I haven't checked, but the derivative schema could be assuming this
schema enforced reg is 1 item. I don't think that's a major issue
though.

Acked-by: Rob Herring <robh@kernel.org>
