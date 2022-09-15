Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB6A5B9561
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiIOH2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiIOH12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:27:28 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8501D93205;
        Thu, 15 Sep 2022 00:27:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663226756; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Zf0RkVlLGHXKl8ZCuBUFuXyD2Rs48ubT3CqDFtg/KK0kgOxY7Zvo+p0587fG9u1QbJr6TClsRL14h6DCul5gflkJzGVwhlxooWCGt9nbI4CVMyp5rqrI1FtyAsHQGKyS62Tsdi/XNMgkCYTUcr8eTQDLI5Rfvg6Z0OYZPVy5fkA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663226756; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=jQcUnE175UgPwnG9DUeOUoA4mKHCkNGSqfNYbiRshhA=; 
        b=Z3SDnKNdXslLMdbOqSirSnIqpxZYvXumwG54Ulwp/GcKx+EjF3/3+O9d1uiJXZ0A2o3LUWCrpyRtTiDyMSIR7Ag+2syNI/+l9YCI1wfmIWYSHjXQiLIH1qtjr1CxPa432Yc4c7CB2DqdldHdWk70O+P5dLcXRWB6353KaTz8VaI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663226756;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Content-Transfer-Encoding:From:From:Mime-Version:Subject:Subject:Date:Date:Message-Id:Message-Id:References:Cc:Cc:In-Reply-To:To:To:Reply-To;
        bh=jQcUnE175UgPwnG9DUeOUoA4mKHCkNGSqfNYbiRshhA=;
        b=DRTg/uP0tvuv85Mcylii770DvKWETLAwB1nyMFz6mRT6ujs2bIqdhJ7Hv74n2SUR
        6MzeR/E/DwzW81UTYcBEHbmYXq63KD/A+rYpPSwx18eGR12CwfQ863oR3VnQFK7od7k
        qhLbvjxJ71mCPnRDt0xciORHXaGqcioiecLGna8A=
Received: from [10.10.9.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663226754115994.2599106423463; Thu, 15 Sep 2022 00:25:54 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 net-next 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
Date:   Thu, 15 Sep 2022 10:25:44 +0300
Message-Id: <17638FC4-A129-4620-9BD3-E47AA653A113@arinc9.com>
References: <CAMhs-H87WFJJgFEkZ7XeBsBMJKfZdzUjVChqb3_KbRqPodwTrg@mail.gmail.com>
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
In-Reply-To: <CAMhs-H87WFJJgFEkZ7XeBsBMJKfZdzUjVChqb3_KbRqPodwTrg@mail.gmail.com>
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
X-Mailer: iPhone Mail (17H35)
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 15 Sep 2022, at 10:17, Sergio Paracuellos <sergio.paracuellos@gmail.com=
> wrote:
>=20
> =EF=BB=BFHi Arinc,
>=20
>> On Thu, Sep 15, 2022 at 8:56 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@ari=
nc9.com> wrote:
>>=20
>> Fix the dtc warnings below.
>>=20
>> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'=

>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/serial/8250.yaml
>> uartlite@c00: Unevaluated properties are not allowed ('clock-names' was u=
nexpected)
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/serial/8250.yaml
>> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$=
'
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/mmc/mtk-sd.yaml
>> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap=
-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-su=
pply', 'vqmmc-supply' were unexpected)
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/mmc/mtk-sd.yaml
>> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/usb/mediatek,mtk-xhci.yaml
>> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/usb/mediatek,mtk-xhci.yaml
>> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@=
.*)?$'
>>        =46rom schema: /home/arinc9/Documents/linux/Documentation/devicetr=
ee/bindings/net/dsa/mediatek,mt7530.yaml
>> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>        =46rom schema: /home/arinc9/.local/lib/python3.10/site-packages/dt=
schema/schemas/dt-core.yaml
>> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>        =46rom schema: /home/arinc9/.local/lib/python3.10/site-packages/dt=
schema/schemas/dt-core.yaml
>> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>        =46rom schema: /home/arinc9/.local/lib/python3.10/site-packages/dt=
schema/schemas/dt-core.yaml
>>=20
>> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the=

>> aliases node.
>> - Remove "clock-names" from the serial0 node. The property doesn't exist o=
n
>> the 8250.yaml schema.
>> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
>> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
>> - Add "mediatek,mtk-xhci" as the second compatible string on the usb node=
.
>> - Change "switch0: switch0@0" to "switch0: switch@0"
>> - Change "off" to "disabled" for disabled nodes.
>>=20
>> Remaining warnings are caused by the lack of json-schema documentation.
>=20
> The followings needs to be ported to yaml schema but exist in its
> previous txt format:
>=20
>>=20
>> /cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt=
-controller']
>=20
> https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/=
bindings/mips/cpu_irq.txt#L13
>=20
>> /palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['=
mediatek,mt7621-wdt']
>=20
> https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/=
bindings/watchdog/mt7621-wdt.txt#L4
>=20
>> /palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['=
mediatek,mt7621-i2c']
>=20
> https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/=
bindings/i2c/i2c-mt7621.txt#L6
>=20
>> /palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['=
ralink,mt7621-spi']
>=20
> https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/=
bindings/spi/spi-mt7621.txt#L5
>=20
>> /ethernet@1e100000: failed to match any schema with compatible: ['mediate=
k,mt7621-eth']
>=20
> https://elixir.bootlin.com/linux/v6.0-rc5/source/Documentation/devicetree/=
bindings/net/ralink,rt2880-net.txt#L15

This binding is old and does not represent the current mtk_eth_soc driver. I=
 already remove this with the first patch in the series so I=E2=80=99d rathe=
r do a new schema from scratch.

Ar=C4=B1n=C3=A7

