Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A112D8EED
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 18:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgLMQ76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 11:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgLMQ76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 11:59:58 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F19C0613CF;
        Sun, 13 Dec 2020 08:59:17 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id n26so19265790eju.6;
        Sun, 13 Dec 2020 08:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=II3z2KtGXYfccGsk4AiZsYqrzwoXcVMGnMLgumJisoY=;
        b=SAHUtmIarY7j7e4zeN3fFvTYIChAGt+Y7GNnQPhDC0+IPhzQJopCVLzBGPCQ5eFaiq
         L6j+nOGMJgIGwajqVssbzaKzuaBQrpADs0OPacCgrLoEUP89l+DvXKAWnAI7YZxJT/Ki
         T7PGOUupcgHjLrwfXc2TYUJwa1eoPQ+yowBNhUhZpvn4SCLxZ32xYEjt/x+jtPK3BTVB
         x90FSoflQ/kMvA2zgF86AeYL9ftHV+sy/51siMs2PT1oBQDRWywhaEfHUE0mmcAlTVUC
         5oD4MqiKMIyunrjoTks9w9RC/Lr8kaqPOqkxeZ8XwBfRzC7g6XqBKTUY3mKrc4SYbm9S
         N83g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=II3z2KtGXYfccGsk4AiZsYqrzwoXcVMGnMLgumJisoY=;
        b=KmSM6tYcefX9IdgXmo2u+v1Xoyw1rFGTczG8b1EnNsB5Z779uz3+BPcHaSk9/3N1E3
         WaK2JdbsLsvyqDw9BnNiGp3AiurTZcwe8+N9FpeCLGSuadMl9kvmqM2lOKXsKkor4wS7
         53I5Yc7JH0VK/aRGVB0ExR+F0BCBmXIzEq3MBCFV4wpAbYrLyLW2L2z25andPSNcOnSP
         lR3j3IXULrZUgHzeiXQ1pPHTMfNHUCrbQG5tRgxSDXGidsqJrzeti+JCsKVYMcPFqiJc
         bU2CXWjHed3e+zDZgLmDDWPA/HdFTGGq1l5v9yrYXq5jdMK318nkZ5SlbGAxyypx62Yc
         3GYw==
X-Gm-Message-State: AOAM532Im/JwA+TlvyiAhwWGn/U+Kto/O6Vfeii5sX8bOinfV2aFyyLf
        D1CUJfHbhql4FJALhOEEp1UVO3zFmqh66ZZI2JQ=
X-Google-Smtp-Source: ABdhPJxTfbMDN5oNcaUz9aMPM/tB7U1x+Iz17INemv3bReSILPHPG9p0mVcWKxhWANbZ6WNgGkXDAuybmWqfDwG+G5s=
X-Received: by 2002:a17:906:2798:: with SMTP id j24mr19280203ejc.328.1607878756610;
 Sun, 13 Dec 2020 08:59:16 -0800 (PST)
MIME-Version: 1.0
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-2-martin.blumenstingl@googlemail.com> <20201207191716.GA647149@robh.at.kernel.org>
In-Reply-To: <20201207191716.GA647149@robh.at.kernel.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 13 Dec 2020 17:59:05 +0100
Message-ID: <CAFBinCDXqnPQtu4ZQW2ngxKVSbRQNFbnhy6M04gE+Mc8HOTM8g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/5] dt-bindings: net: dwmac-meson: use picoseconds
 for the RGMII RX delay
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, jianxin.pan@amlogic.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        khilman@baylibre.com, Neil Armstrong <narmstrong@baylibre.com>,
        jbrunet@baylibre.com, andrew@lunn.ch, f.fainelli@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Mon, Dec 7, 2020 at 8:17 PM Rob Herring <robh@kernel.org> wrote:
>
> On Sun, Nov 15, 2020 at 07:52:06PM +0100, Martin Blumenstingl wrote:
> > Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> > delay register which allows picoseconds precision. Deprecate the old
> > "amlogic,rx-delay-ns" in favour of a new "amlogic,rgmii-rx-delay-ps"
> > property.
> >
> > For older SoCs the only known supported values were 0ns and 2ns. The new
> > SoCs have 200ps precision and support RGMII RX delays between 0ps and
> > 3000ps.
> >
> > While here, also update the description of the RX delay to indicate
> > that:
> > - with "rgmii" or "rgmii-id" the RX delay should be specified
> > - with "rgmii-id" or "rgmii-rxid" the RX delay is added by the PHY so
> >   any configuration on the MAC side is ignored
> > - with "rmii" the RX delay is not applicable and any configuration is
> >   ignored
> >
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
> >  .../bindings/net/amlogic,meson-dwmac.yaml     | 61 +++++++++++++++++--
> >  1 file changed, 56 insertions(+), 5 deletions(-)
>
> Don't we have common properties for this now?
I did a quick:
$ grep -R rx-delay Documentation/devicetree/bindings/net/

I could find "rx-delay" without vendor prefix, but that's not using
any unit in the name (ns, ps, ...)
Please let me know if you aware of any "generic" property for the RX
delay in picosecond precision


Best regards,
Martin
