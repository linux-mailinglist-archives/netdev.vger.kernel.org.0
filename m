Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F865B951B
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiIOHR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOHR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:17:57 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01D285FC5;
        Thu, 15 Sep 2022 00:17:56 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-127f5411b9cso46252296fac.4;
        Thu, 15 Sep 2022 00:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=3eRFLEw88J0uDES9QZxJA5FfKWOIMUyzr/FCySFPpBE=;
        b=MpfbXbkPqkhnqHuK4tvefSXgGdcbsfY6BduF4PN1VFScLg0Xp88X3cSpeWCTE40zDW
         Jkqxx0erc1MkGdoHJ5k0dnpM0+5CsLmif7IBl/ffenE6g2bD4udWWczGnLSpr3YNh0jV
         jjuuxcpq7qfh9uUtAgn+XELcbk5Y5M7g2nIFwbATtk24ps8O3JdN7TXZ99yeyx0Cyu0U
         Pmcf288QaLMpUL0pYaitfmlEICA+e8qZQcnZbjMSMzhKDKbWNTEvIIGUyXiyKcwT8gAs
         ZtIIgGqt4B/f0+Llhat6ry3/wkKKGnzSzwYV4+QuAg7tvoMdeJsIwofp/eP1IwTKa7D/
         zu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=3eRFLEw88J0uDES9QZxJA5FfKWOIMUyzr/FCySFPpBE=;
        b=E9mWvZIcN+05OPFexHAp4RpJie7gd85YGqR88KM00hpV+SubIEfx+k8A0+pl3uMJCZ
         28St9mKXmN2OYEyAXBHlbn0X4LFGdeoM5ty9o7jOMm3Nsp1+UeirElw2OOLpZgFgMSc/
         du8p9hJNlK3hMlnJBRAZrbbKvLByM5eMPnA6QTGfxrOCQi515R1u3GxcmvOsgfwNvBlK
         sp8+ILScdxiPrbV8HToPX1l/IDf2VeRYlGYKwHH/5VeC1jrTZZ0axhFvjdjOlMmzmqWV
         6XLQn+eAfGeo5fZLlB4hgNPySz7RzGxSQq1+e6q3XkgKSF9H6sz/DMiFKsv8pjPFSjr4
         PmHA==
X-Gm-Message-State: ACgBeo2baKJk0pnrQ3uQwwKTZLS8Abu1z70llj4VgyI4LFCDTs//x2yN
        1m/x9UgzV0eRdfBXsIFk5w+VRONLTTCHimX/2uE=
X-Google-Smtp-Source: AA6agR4BiNIZdNj+Xh8UoedK2TVbdyHmFFVpeiNBf/cBDd2uukNp4R4umTxBVNCUtKy9Lm3Q7Vkf8ouAyihUDRkiM24=
X-Received: by 2002:a05:6870:f5a7:b0:12b:4a0d:57c6 with SMTP id
 eh39-20020a056870f5a700b0012b4a0d57c6mr4609523oab.83.1663226276217; Thu, 15
 Sep 2022 00:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220915065542.13150-1-arinc.unal@arinc9.com> <20220915065542.13150-6-arinc.unal@arinc9.com>
In-Reply-To: <20220915065542.13150-6-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Thu, 15 Sep 2022 09:17:44 +0200
Message-ID: <CAMhs-H87WFJJgFEkZ7XeBsBMJKfZdzUjVChqb3_KbRqPodwTrg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arinc,

On Thu, Sep 15, 2022 at 8:56 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc=
9.com> wrote:
>
> Fix the dtc warnings below.
>
> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/serial/8250.yaml
> uartlite@c00: Unevaluated properties are not allowed ('clock-names' was u=
nexpected)
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/serial/8250.yaml
> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$=
'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/mmc/mtk-sd.yaml
> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap=
-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-s=
upply', 'vqmmc-supply' were unexpected)
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/mmc/mtk-sd.yaml
> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/usb/mediatek,mtk-xhci.yaml
> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/usb/mediatek,mtk-xhci.yaml
> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@=
.*)?$'
>         From schema: /home/arinc9/Documents/linux/Documentation/devicetre=
e/bindings/net/dsa/mediatek,mt7530.yaml
> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>         From schema: /home/arinc9/.local/lib/python3.10/site-packages/dts=
chema/schemas/dt-core.yaml
>
> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the
> aliases node.
> - Remove "clock-names" from the serial0 node. The property doesn't exist =
on
> the 8250.yaml schema.
> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
> - Add "mediatek,mtk-xhci" as the second compatible string on the usb node=
.
> - Change "switch0: switch0@0" to "switch0: switch@0"
> - Change "off" to "disabled" for disabled nodes.
>
> Remaining warnings are caused by the lack of json-schema documentation.

The followings needs to be ported to yaml schema but exist in its
previous txt format:

>
> /cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt=
-controller']

https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/b=
indings/mips/cpu_irq.txt#L13

> /palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['=
mediatek,mt7621-wdt']

https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/b=
indings/watchdog/mt7621-wdt.txt#L4

> /palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['=
mediatek,mt7621-i2c']

https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/b=
indings/i2c/i2c-mt7621.txt#L6

> /palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['=
ralink,mt7621-spi']

https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/b=
indings/spi/spi-mt7621.txt#L5

> /ethernet@1e100000: failed to match any schema with compatible: ['mediate=
k,mt7621-eth']

https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/b=
indings/net/ralink,rt2880-net.txt#L15

>
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
>  .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
>  arch/mips/boot/dts/ralink/mt7621.dtsi         | 28 ++++++++-----------
>  3 files changed, 13 insertions(+), 19 deletions(-)

Reviewed-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
