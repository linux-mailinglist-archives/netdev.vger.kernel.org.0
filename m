Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C2E5B695C
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 10:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiIMIUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 04:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiIMIT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 04:19:59 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677F3BF64;
        Tue, 13 Sep 2022 01:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663057151; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cbD2oH6qV+7f5NwVYgIJya2nvrNAGDpLFrbMwDhNRhRq0ADLO5oIbXtGn0ZFWg3c0wH64WMNrrxOmfk1KtU6Mn+04VafA9n4Uwt2U6R/iUCRywgzxhPUfYJ1msr6DG7vevuM2kEOPpI1sgPmC6EKMmlkjFFOyyqzCHOSFR5+aag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663057151; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=5ta8cGICr0VOJM3jC+pGpsMR/rkOeJqhzZDkRQ4xBHw=; 
        b=ZrR99btLqzgG+9bJWWYITysE2GBxYdI5P2IhlexV2cyxX7ySwd+GhWnz9Yh9v/SYZCzkOPDSZDLj3AYqqY+juPsOv1RZu7Ogeojk8mb05opMb6v+7gIRXeCrJxb/1XxoRwASJcuErKWTcsR2CQi110VygrpKD0A9Ac8JDssjlWs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663057151;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=5ta8cGICr0VOJM3jC+pGpsMR/rkOeJqhzZDkRQ4xBHw=;
        b=FIMUqSjX4QdqKRIUAo/ZmX4QYgTQV628cIf8ACY3Gc4sGipLUi5K8tD4+ZB2KbUZ
        NMXt/GQc/Kiuj1GsXiEmqc1MhTkN7XiQOJC2tlZDwHVCFnmEa/oMThCUcOto7R+DpTy
        O0cUbIdWZv4RXIaEFJXVXtE+0hTrXhlLyR6uBipY=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663057148935836.8616576818519; Tue, 13 Sep 2022 01:19:08 -0700 (PDT)
Message-ID: <a2dd3f5d-9d25-bb24-9db2-1587487c80a2@arinc9.com>
Date:   Tue, 13 Sep 2022 11:19:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: dsa: mt7530: replace label
 = "cpu" with proper checks
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Marek Vasut <marex@denx.de>, John Crispin <john@phrozen.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-2-vladimir.oltean@nxp.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220912175058.280386-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.09.2022 20:50, Vladimir Oltean wrote:
> The fact that some DSA device trees use 'label = "cpu"' for the CPU port
> is nothing but blind cargo cult copying. The 'label' property was never
> part of the DSA DT bindings for anything except the user ports, where it
> provided a hint as to what name the created netdevs should use.
> 
> DSA does use the "cpu" port label to identify a CPU port in dsa_port_parse(),
> but this is only for non-OF code paths (platform data).
> 
> The proper way to identify a CPU port is to look at whether the
> 'ethernet' phandle is present.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Arınç

> ---
>   .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index f9e7b6e20b35..fa271ee16b5e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -163,9 +163,7 @@ patternProperties:
>           allOf:
>             - $ref: dsa-port.yaml#
>             - if:
> -              properties:
> -                label:
> -                  const: cpu
> +              required: [ ethernet ]
>               then:
>                 required:
>                   - phy-mode
> @@ -187,9 +185,7 @@ $defs:
>           patternProperties:
>             "^(ethernet-)?port@[0-9]+$":
>               if:
> -              properties:
> -                label:
> -                  const: cpu
> +              required: [ ethernet ]
>               then:
>                 if:
>                   properties:
> @@ -215,9 +211,7 @@ $defs:
>           patternProperties:
>             "^(ethernet-)?port@[0-9]+$":
>               if:
> -              properties:
> -                label:
> -                  const: cpu
> +              required: [ ethernet ]
>               then:
>                 if:
>                   properties:
