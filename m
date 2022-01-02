Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052EF482A4E
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 07:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbiABGjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 01:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbiABGjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 01:39:05 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87E2C06173E
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 22:39:04 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id bp20so68613747lfb.6
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 22:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0NN21CO30QOaTaxAaJ5AbktneIROV++1RQZxhix79+U=;
        b=adwQ4yB1OiKycYPbmmGYpHgLqc0ghoGRjpPAhnGN2+0uyGUIMEBZvab1LKKPwJDVqW
         5d83q3P0SM60Frn7aH6dM30K4yipJayJVqVJmpv6Vrfa3rXUQ9fWlKOZEbApoDnhodnb
         H07RP7+ImBk/O6IX1UeDumV4fuQ1UzFrYddM3/C+WdbHcCRjEvN/Rd6IgtJEF1yf1sV6
         jGKxMZhW/qckY+BRymxWtjmvOKMzr4ObssWKrf5goFNA52l/V84q/J45o7GYUz13FwbT
         mbxs3UwHvKqXcXLOhJrjWcPXpRfGV6YXZUGrDnBNbaCNDsceMxp3zrCpT/ZtzWKKcPj4
         nlYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0NN21CO30QOaTaxAaJ5AbktneIROV++1RQZxhix79+U=;
        b=CBA+w62ZThVJxLHX0+lpNlRe4by34Fk34ibVM0RNR++ZLsVZ4wINkJ6dQZaD2eWC9A
         QnzYJSGJfqsOwCVykq1LPMmer49Oj+uuJeoV0LnbgS+UgZJzLq4vGanAmXDMTSBrbzJd
         4bDikEYf1dT3uMnhXtzd9Qmzn3PkpQp+QdAH4OzbxwzttK7zGKCUBGYmqtf2n7jCB03g
         Hi9e94xMQTwFLJTXb0qih15BmA3Z1cGrtDc6KRiUhNW7iu41wBbBJsIgnDL1zaXG1AcV
         G7xBR6Um7gc/uWUYfzzFjPa6pwPq15x33lSDyPZ6TVuztKcLG3kW0IKEqbV4Vv3mqlTq
         iA8g==
X-Gm-Message-State: AOAM532lQ1YfpoHx0HGsSoCCevXwId5SAp6hemkEwn9o1kNFYzKwCmF4
        j7aWmPliHYUzPwXBKZppyPvyieLuB4b67eYZCcIhSg==
X-Google-Smtp-Source: ABdhPJxo5GKtHTR8DNorJV6j4esL9GMgX6B7y0bciBPzP+HmNAh2eTWi+R6vc3Ty73naclRWJTDzE9rbaaiBM2qJo6M=
X-Received: by 2002:a05:6512:2303:: with SMTP id o3mr36857827lfu.362.1641105543253;
 Sat, 01 Jan 2022 22:39:03 -0800 (PST)
MIME-Version: 1.0
References: <20211228072645.32341-1-luizluca@gmail.com>
In-Reply-To: <20211228072645.32341-1-luizluca@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 2 Jan 2022 07:38:50 +0100
Message-ID: <CACRpkdbEGxWSyPd=-xM_1YFzke7O34jrHLdmBzWCFZXt-Nve8g@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML schema
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 8:27 AM Luiz Angelo Daros de Luca
<luizluca@gmail.com> wrote:

> Schema changes:
>
> - "interrupt-controller" was not added as a required property. It might
>   still work polling the ports when missing
> - "interrupt" property was mentioned but never used. According to its
>   description, it was assumed it was really "interrupt-parent"
>
> Examples changes:
>
> - renamed "switch_intc" to make it unique between examples
> - removed "dsa-mdio" from mdio compatible property
> - renamed phy@0 to ethernet-phy@0 (not tested with real HW)
>   phy@ requires #phy-cells
>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Thanks for doing this! Very nice!

> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>

You can add yourself too (if you want)

> +    description: |
> +      realtek,rtl8365mb: 4+1 ports
> +      realtek,rtl8366:
> +      realtek,rtl8366rb:

4 + 1 ports

With that fix:
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
