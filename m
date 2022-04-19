Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392D2506152
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244136AbiDSAwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 20:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244828AbiDSAv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 20:51:57 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492982F017;
        Mon, 18 Apr 2022 17:48:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1650329268; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=QcaCwx2tEtPiNTdnkKN6Dj7Rv8qJ9UHg9CnAWnP6QlW2g6WtsGjLiSEp/2FfU9Q2E2Spn0h7kGD/yVdjhAjSzzxCeW8w5fT9x7Chf1tTEhhQZi1qgwcKgyEvU8y5dhYUFPhdf8rVZTzp79PkAtWFu9JNoDcp+IBHATKVaOYFh18=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1650329268; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dF0t/rFrfNtgkFwm0QyH3WiEwxfiDRKe8DJYZakIpnE=; 
        b=Q+FIq0HYvZ/i73eupC0luBDunzKmcYz8VarEMfeEjoBSCsMVur3uL3beaFFFuUU3ZDEML+2mkP8J52yKwEHk3vOk/kRadVeXkBB6+QPVWRaqEVDvqa2OhKddDj//Zjxfykn0Km8sNJzfaXA5lseOnJa/nfqDPaNQV0uaGD1qMQw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1650329268;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=dF0t/rFrfNtgkFwm0QyH3WiEwxfiDRKe8DJYZakIpnE=;
        b=IsEkdLn+1zj7HvFYKO26G51iZ9eDmRJHWmn8Hdkzwigu9GSEfF5O0rYdL3RCB0RK
        MgGAa7mott606upMVs2eiCjFu20dra+Q+OEG0xnw8h8ciua/s+CucPqimPU72RfpnCI
        QeWOsGfEDmyMghWVioS48nXO+QR4tlN036SqqE/U=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1650329265893232.18636976893617; Mon, 18 Apr 2022 17:47:45 -0700 (PDT)
Message-ID: <41b4c9c7-871a-83c4-5df0-24b85ce0cb24@arinc9.com>
Date:   Tue, 19 Apr 2022 03:47:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, devicetree@vger.kernel.org
References: <20220418233558.13541-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2022 02:35, Luiz Angelo Daros de Luca wrote:
> Compatible strings are used to help the driver find the chip ID/version
> register for each chip family. After that, the driver can setup the
> switch accordingly. Keep only the first supported model for each family
> as a compatible string and reference other chip models in the
> description.
> 
> The removed compatible strings have never been used in a released kernel.
> 
> CC: devicetree@vger.kernel.org
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>

Do we know the chip ID and version of all of the switches this driver 
_can_ support? So we have all the switches actually supported under a 
single compatible string.

The chip ID seems to be the same across all the switches under this 
defacto rtl8367c family.

Alvin, could your contacts at Realtek provide the chip ID and version 
for the switches we don’t know:
RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB, RTL8364NB, 
RTL8364NB-VB, RTL8366SC, RTL8367SB, RTL8370MB, RTL8310SR

The switch chip IP/versions currently defined:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/realtek/rtl8365mb.c?id=a997157e42e3119b13c644549a3d8381a1d825d6#n104

Other than that:

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Cheers.
Arınç

> ---
>   .../devicetree/bindings/net/dsa/realtek.yaml  | 35 ++++++++-----------
>   1 file changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> index 8756060895a8..99ee4b5b9346 100644
> --- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
> @@ -27,32 +27,25 @@ description:
>     The realtek-mdio driver is an MDIO driver and it must be inserted inside
>     an MDIO node.
>   
> +  The compatible string is only used to identify which (silicon) family the
> +  switch belongs to. Roughly speaking, a family is any set of Realtek switches
> +  whose chip identification register(s) have a common location and semantics.
> +  The different models in a given family can be automatically disambiguated by
> +  parsing the chip identification register(s) according to the given family,
> +  avoiding the need for a unique compatible string for each model.
> +
>   properties:
>     compatible:
>       enum:
>         - realtek,rtl8365mb
> -      - realtek,rtl8366
>         - realtek,rtl8366rb
> -      - realtek,rtl8366s
> -      - realtek,rtl8367
> -      - realtek,rtl8367b
> -      - realtek,rtl8367rb
> -      - realtek,rtl8367s
> -      - realtek,rtl8368s
> -      - realtek,rtl8369
> -      - realtek,rtl8370
>       description: |
> -      realtek,rtl8365mb: 4+1 ports
> -      realtek,rtl8366: 5+1 ports
> -      realtek,rtl8366rb: 5+1 ports
> -      realtek,rtl8366s: 5+1 ports
> -      realtek,rtl8367:
> -      realtek,rtl8367b:
> -      realtek,rtl8367rb: 5+2 ports
> -      realtek,rtl8367s: 5+2 ports
> -      realtek,rtl8368s: 8 ports
> -      realtek,rtl8369: 8+1 ports
> -      realtek,rtl8370: 8+2 ports
> +      realtek,rtl8365mb:
> +        Use with models RTL8363NB, RTL8363NB-VB, RTL8363SC, RTL8363SC-VB,
> +        RTL8364NB, RTL8364NB-VB, RTL8365MB, RTL8366SC, RTL8367RB-VB, RTL8367S,
> +        RTL8367SB, RTL8370MB, RTL8310SR
> +      realtek,rtl8366rb:
> +        Use with models RTL8366RB, RTL8366S
>   
>     mdc-gpios:
>       description: GPIO line for the MDC clock line.
> @@ -335,7 +328,7 @@ examples:
>               #size-cells = <0>;
>   
>               switch@29 {
> -                    compatible = "realtek,rtl8367s";
> +                    compatible = "realtek,rtl8365mb";
>                       reg = <29>;
>   
>                       reset-gpios = <&gpio2 20 GPIO_ACTIVE_LOW>;
