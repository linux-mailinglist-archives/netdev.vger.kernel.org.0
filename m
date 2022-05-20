Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5A552E584
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346128AbiETHAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345993AbiETHAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:00:39 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60094.outbound.protection.outlook.com [40.107.6.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F9414FC9A;
        Fri, 20 May 2022 00:00:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko7Si5J4VsdTtphpP1Pwfl28ghP+NVBplHDyRz2MM17732qHvxXNZesiWfgzPFm7ncp7a14rtY1vg/4/8KmvjJgaWzBN6DALyIyVRCIDED9v1S+R4g1yS7wLBckUM2NLEefXOShW2ONJjGmmyo6uO1S8Hx//cjtH1ASDjl7SerjS2TZmeY8wM0kQ8x9B4u3zrpQObdwUvzavFKDtNANEmcsI0Wi7uzdYCnU0K3HvtnuCteeqqNb6HAAeUdxyqjX019lhysG20tlGFv03kdVxy9L9TeWnUSh+SgxPJzZFx0UlGqCi62HPs0G9VyOdIaZZZyD0TR/9VIPD3lI5rSij4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILkdyp31e/czmzBwOsv7r7u4wwn6hSGwm7K3iEyfIPQ=;
 b=iN566/JdSAAfed/88LMsSznMk0wJsvT7v+jHemHxSEnPqpRdDyMfd2i6gSKW5R7uqvwYVRHi1iBs5AHBcLvaJgOkZ7l4KNUha+WjWKBRAjKeJjZWApZtIMsdEf6WgDaZTIDy+BFl0RzcsSyvXeUO5GHNMapVJZQSvlRnhEAa+jgqnAlwdZizI37OZYFCIID8fck9e8ibwAecYIc+mh/ZbWq84Q+szheAeHbKVsL0FWC4NVImc02FST+9aTipp1IULUtWK3l8pASFqeJOBAMv+SojsDiaZwias/ujG4o9PK2hcyTjWC9b+53mx+vZyLUvAAetVsMUro1aIeVKutrgQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILkdyp31e/czmzBwOsv7r7u4wwn6hSGwm7K3iEyfIPQ=;
 b=pAyr+E57+AwRaLTipFFCSc2ngdaZ/G8T5JalxlADIZHOtsM0f0YYMSW+lH4e5OJvn4KdbqNLZSD/hwSXQyUB58VPhRxalBi06oQv4kNNs7YLqEHrbM41tEcuSc8f1f2tjNZhE8uJhtrn9ED5OiVQHIYTIIHstXobcYTudj09Bt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=axentia.se;
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com (2603:10a6:208:ed::15)
 by DB3PR0202MB3385.eurprd02.prod.outlook.com (2603:10a6:8:12::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 07:00:31 +0000
Received: from AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::dcef:9022:d307:3e8a]) by AM0PR02MB4436.eurprd02.prod.outlook.com
 ([fe80::dcef:9022:d307:3e8a%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 07:00:31 +0000
Message-ID: <7ce2a5a1-b5b3-a119-c298-5100e4d54145@axentia.se>
Date:   Fri, 20 May 2022 09:00:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
Content-Language: sv
To:     Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>
Cc:     dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
References: <20220519211411.2200720-1-robh@kernel.org>
From:   Peter Rosin <peda@axentia.se>
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: OL1P279CA0050.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:e10:14::19) To AM0PR02MB4436.eurprd02.prod.outlook.com
 (2603:10a6:208:ed::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 712ea269-799c-4ed2-bf75-08da3a2e6d68
X-MS-TrafficTypeDiagnostic: DB3PR0202MB3385:EE_
X-Microsoft-Antispam-PRVS: <DB3PR0202MB3385AA538E3C789B61569A59BCD39@DB3PR0202MB3385.eurprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCduVen22PqGN4JWn7F+jU+Btuysz8BYwRNIy+tKi58lq9t9X53v28ijRvfrvF//DTY8hCKVefIDQ9RTVeWS5hP+d5FPqpFG9Oqn087cb6NRIp0jKlzt5NfwJLKVb5OycYMkcb33somoxoKFOZ3RJGtxLgmKIgbtwUo889ElwcicTJDxIGhM3bDBoXbpZ1IWKWbSPAPZuC9cGfbYVHZuHoEju7CcQhTFXV0as+FvxBWkxdrvzMrKT15UFc2YxgQNXX2km8VBu1AQJvTH+kgKh4fp2lYGc5BJ+n58MzNGdPby3PXeASfSNo0jrCAVgqYgXCCbfZtAN4RbFWIEIpLrr51J8RwmKCdWXcQP06WD4cxN0D8d+DClDWrXKhbec+yR2Ytux8w/hiJDh8KiwDtICWKIZXQGomivjbH2JzaBVVDzvYr8I5/E2n/Y3fgZ+UYerCP5trUkDbnY6vHP/Xfq56R6MUUEGWIKuIlcTmh6w9xiQPzK3CLJLfuOETsYGCx2gHkbXZq9SlL/NIY5PY4Z/A/Y7yJkRLGeKr7S9ZYkBatJ9PFDfVGi3D5fmlLkiDvSZhYdv+zqJPldRZbcdolQekJzVRxj7u9O+seiPhum4s7QPAmQm6KvY7iejaZpOVwyxHVGiwVdUAcofzcb8+n+bRyf5PM+hNOZLinYVZDfLw7GFn+FS3ASwB2FSsJRNDYadm7OgiTaOuxQfldazcJOTf+87N1yVlujXdFRazfstYImxeUzk6ttUl++azf3HSXw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4436.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(346002)(136003)(376002)(366004)(4326008)(2906002)(508600001)(6666004)(6486002)(8676002)(66556008)(66476007)(66946007)(6506007)(5660300002)(7416002)(30864003)(7406005)(921005)(8936002)(316002)(38100700002)(2616005)(36756003)(31686004)(41300700001)(83380400001)(110136005)(186003)(86362001)(6512007)(31696002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHBkazVTVlIxUFBHTUkwNjBVR0RzWDN5aHhUeVNwL1F6U1M3UEJQWEpLa29L?=
 =?utf-8?B?M3RuS3lnYjMwK0FrRlpWSXhBUi9RT3V0ekhEdXlkV0xEdHZ2bTlxTklzOUFr?=
 =?utf-8?B?TGdtU0d6Q01zaTZZQTFuL2c2QmR4ajZTUDh3NCtSYjE1VUpZdmQwOW1PU0Fa?=
 =?utf-8?B?YlZ0ZUtJSlNYQXcycnNOQVZiZG1lQlpqVGNCV1VUTDdOeHJZZWZNTktEWXdy?=
 =?utf-8?B?VDJxRTkyZkFOS2gveVBuSEM0YjFXS3lLdUk0RHo1YzJMWG1vQnVFdDY5MVVO?=
 =?utf-8?B?UXJGa0R5SEFGaThqL1Uyai9TQXdhWlU3KytUWFE1VGMxSFpieDd3Zldob0dU?=
 =?utf-8?B?VmpJN3ZoWWhvWi9saTgrMlB4bDR5L1hKVEVUcSt2L24zMWp5ejVqUDhFTVQr?=
 =?utf-8?B?dWZyYll0cUJKRlluUERuRmhVWkJOM0VNb2NrOTNnU1VIUjh5eHI1alZkNUp4?=
 =?utf-8?B?K1VudlZVVlY4a3lubks3TE01R2ZiZVgrcWJ0dXc0bVRYTThLdWNaNE43TTha?=
 =?utf-8?B?bVk5MHJkWGxLc2Vab1hQMVNVNEFma29oRU9RZjlOTFl0T2owcjRHYU1ibm9C?=
 =?utf-8?B?N01SMU44SXBIajdJQnBZd3h0cWJDcG45cVMvVjNEUGVoNE9sQzA3QlEvVHRm?=
 =?utf-8?B?anJXY3RIRkcyZGN3aTlmRWhxTUtVcVNkNDN6cVozMHJSYXhiREdOb0NGaHdY?=
 =?utf-8?B?ZzF4d3RCVm4reHJ4eHdtUUNYcXZzQ2xYQ3p0cERVcndGMGRWOS9yZStVZG10?=
 =?utf-8?B?M0s5dDhnVjFoQ0RuYkEvSEdQZ0FHTUlJWXhnelYrbjFBejZFN0VvY3FUbVVZ?=
 =?utf-8?B?QUw0UVVoTVpUWkEzZ1hRa0xuSjh4TEVtQ1M3ZGs3aHlHdEpTNU45S3RWeDRZ?=
 =?utf-8?B?cjdKMHhNQ0kwMzhBeWtiZzNxVkpydHJuK3locGhQSnA0eEpydU8yZVd4K21O?=
 =?utf-8?B?c2hJWWpUbC8vYTg0RE5uM2dJQlQwOXNMU01hQ3NiWmpSN0t5UmFwSkxwWWgv?=
 =?utf-8?B?UVp6T1Y3dE9rZE9TNU80emZzRHorWjhpWVh2WW8zT0Ntb2xLMHh2Z29lL1hR?=
 =?utf-8?B?VXh6UXo2NThhd0lTZklrTTJrWXNOSHdzcWl1Y0FvZHliMTdyaHhRdjdkdTNk?=
 =?utf-8?B?aSt3Y1FVd0xjQ05aT2YyWWVySjdpRm9vKzBFRnNxc3dHSmVQRmZtOXJzRXR1?=
 =?utf-8?B?WjNBUmVMbnpvUWQ0YWwvU3JEbVZHNUorbjlWbWJObGpTdGYrdm1WZjcyMy9S?=
 =?utf-8?B?ZlZmaEFkaFg3ODZwUGJFWlhQb2o4dnh1bFdvQXVTRUhsRUNVcnpSZ0lTWHlz?=
 =?utf-8?B?dWtBUnZvSWFkbng3YTF1YjkvbnRsd0R6aGNNUFNmakk4Y3VNSlN1T1R3NGRY?=
 =?utf-8?B?WFZUQjF2amZxRDFkMlM4bzM5a21YY3B5UXhRam51MlhLV3NZQ215dE5BSS9Y?=
 =?utf-8?B?dlM0d2E0Q0ZrT0Y3bEw4QllJR1dpZkxGTGVWSmF3UUZpWndxM3dQaStYZFoz?=
 =?utf-8?B?eU8zY2xjR2JOMCttS2xHWDk3MEs1dElNTldvUHNNbnAxUGNJLzVWbUdwUEhn?=
 =?utf-8?B?YjAvazArZVp3dG5zM1FwTFN6TUE3cm96SnFrS1lwajVwdVc2WWIxak95eWI0?=
 =?utf-8?B?eDVxSER4UGkwczJDMmx5UGxlN09wNTlsaVlMU0pBNzAyb29hdlk1N2dvVTdY?=
 =?utf-8?B?MGhqRW5aMDdGTkdic1FOUHVwc1VxMXY0Q01talB3a2JGekhqaFVzaDMxTEV5?=
 =?utf-8?B?em10VmxvWk5yb3BsTWVqU0F0T2Z1cHdNd3puSWNiOElES1JCQTFTWjNtSWt1?=
 =?utf-8?B?aWI2NExTRW5KdGdrTzF0WmJrSE9vcSt1NkQrRTAvUW1BWnJ1WUd5UElMZ2FO?=
 =?utf-8?B?SHhOZ3FEOFU3R3FWK3lEenNkU3p3N0x2Nkpva3NlbzFUVUEyRm9aYy91RHFi?=
 =?utf-8?B?NXdsZ25NcVh0NlF4UW1PanlhKzEzeXVNc055Rm9WVTBpM01vNlFWVThhUjl1?=
 =?utf-8?B?VlhqVVJuZUM1c3dQbEUxMDhJRmZWM2ZxdVZFQUhGMzY5N3dQWmZYNkZZNTI0?=
 =?utf-8?B?enpSVEdqS2pUTFZiamNDK05UM0E0T2hndHpOcUEzUXhzQ0IvWUJVeFl3aEhk?=
 =?utf-8?B?WTh2K0FRc2JCZkJMblpGRC95cmdGeitLQW9vNnlCSmh2V2REbW1laXRKU1hG?=
 =?utf-8?B?clV6MnhmREZXYlh5NTFHZjRVZ3g3OG9xK3RDdXpPNi9GSXdYNFBwTkdwZHlu?=
 =?utf-8?B?VmgrcEVLdjIzSmNxdTZrbmxhYW1JYUJkdWNYSmN0K3IyUmpsczlsNkc5U1FW?=
 =?utf-8?B?cGgxYzlCdTY5dy9lWTV2ZlJiWGJOMUtGVC9xYmd5UUx5anVDa3Nwdz09?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 712ea269-799c-4ed2-bf75-08da3a2e6d68
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4436.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 07:00:30.8427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GQxgo4M+wcScy3LnRVEtaodIxvGqd66uPZY8V6mXxFV01MS8pfJCiiSHAjkv+tE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0202MB3385
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2022-05-19 at 23:14, Rob Herring wrote:
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
> 
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../arm/hisilicon/controller/hip04-bootwrapper.yaml       | 5 +++--
>  .../bindings/display/bridge/toshiba,tc358768.yaml         | 1 +
>  .../devicetree/bindings/display/panel/panel-timing.yaml   | 5 +++++
>  .../bindings/display/panel/raydium,rm67191.yaml           | 1 +
>  .../bindings/display/panel/samsung,s6e8aa0.yaml           | 1 +
>  .../devicetree/bindings/gpio/fairchild,74hc595.yaml       | 1 +
>  .../devicetree/bindings/input/google,cros-ec-keyb.yaml    | 1 +
>  .../devicetree/bindings/input/matrix-keymap.yaml          | 4 ++++
>  Documentation/devicetree/bindings/media/i2c/adv7604.yaml  | 3 ++-
>  Documentation/devicetree/bindings/mux/reg-mux.yaml        | 8 ++++++--
>  Documentation/devicetree/bindings/net/cdns,macb.yaml      | 1 +
>  Documentation/devicetree/bindings/net/ingenic,mac.yaml    | 1 +
>  .../devicetree/bindings/net/ti,davinci-mdio.yaml          | 1 +
>  .../devicetree/bindings/net/wireless/ti,wlcore.yaml       | 2 ++
>  .../devicetree/bindings/pci/snps,dw-pcie-ep.yaml          | 6 ++++--
>  Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml   | 2 ++
>  .../devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml    | 2 ++
>  Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml | 1 +
>  .../devicetree/bindings/power/supply/battery.yaml         | 7 ++++++-
>  .../devicetree/bindings/power/supply/charger-manager.yaml | 1 +
>  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml   | 1 +
>  Documentation/devicetree/bindings/serial/8250.yaml        | 1 +
>  .../devicetree/bindings/sound/audio-graph-card2.yaml      | 3 +++
>  .../devicetree/bindings/sound/imx-audio-hdmi.yaml         | 3 +++
>  Documentation/devicetree/bindings/usb/smsc,usb3503.yaml   | 1 +
>  25 files changed, 55 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> index 7378159e61df..483caf0ce25b 100644
> --- a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> +++ b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> @@ -17,14 +17,15 @@ properties:
>        - const: hisilicon,hip04-bootwrapper
>  
>    boot-method:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      description: |
>        Address and size of boot method.
>        [0]: bootwrapper physical address
>        [1]: bootwrapper size
>        [2]: relocation physical address
>        [3]: relocation size
> -    minItems: 1
> -    maxItems: 2
> +    minItems: 2
> +    maxItems: 4
>  
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> index 3bd670b8e5cd..0b6f5bef120f 100644
> --- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> +++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> @@ -58,6 +58,7 @@ properties:
>  
>              properties:
>                data-lines:
> +                $ref: /schemas/types.yaml#/definitions/uint32
>                  enum: [ 16, 18, 24 ]
>  
>        port@1:
> diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> index 7749de95ee40..229e3b36ee29 100644
> --- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> @@ -146,6 +146,7 @@ properties:
>        Horizontal sync pulse.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>  
>    vsync-active:
> @@ -153,6 +154,7 @@ properties:
>        Vertical sync pulse.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>  
>    de-active:
> @@ -160,6 +162,7 @@ properties:
>        Data enable.
>        0 selects active low, 1 selects active high.
>        If omitted then it is not used by the hardware
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>  
>    pixelclk-active:
> @@ -169,6 +172,7 @@ properties:
>        sample data on rising edge.
>        Use 1 to drive pixel data on rising edge and
>        sample data on falling edge
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>  
>    syncclk-active:
> @@ -179,6 +183,7 @@ properties:
>        sample sync on rising edge of pixel clock.
>        Use 1 to drive sync on rising edge and
>        sample sync on falling edge of pixel clock
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [0, 1]
>  
>    interlaced:
> diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> index 745dd247c409..617aa8c8c03a 100644
> --- a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> @@ -24,6 +24,7 @@ properties:
>  
>    dsi-lanes:
>      description: Number of DSI lanes to be used must be <3> or <4>
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [3, 4]
>  
>    v3p3-supply:
> diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> index ca959451557e..1cdc91b3439f 100644
> --- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> @@ -36,6 +36,7 @@ properties:
>  
>    init-delay:
>      description: delay after initialization sequence [ms]
> +    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    panel-width-mm:
>      description: physical panel width [mm]
> diff --git a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> index 5fe19fa5f67c..a99e7842ca17 100644
> --- a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> +++ b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> @@ -26,6 +26,7 @@ properties:
>      const: 2
>  
>    registers-number:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Number of daisy-chained shift registers
>  
>    enable-gpios:
> diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> index e8f137abb03c..aa61fe64be63 100644
> --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> @@ -31,6 +31,7 @@ properties:
>      type: boolean
>  
>    function-row-physmap:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 1
>      maxItems: 15
>      description: |
> diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> index 6699d5e32dca..9f703bb51e12 100644
> --- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> +++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> @@ -27,6 +27,10 @@ properties:
>        column and linux key-code. The 32-bit big endian cell is packed as:
>            row << 24 | column << 16 | key-code
>  
> +  linux,no-autorepeat:
> +    type: boolean
> +    description: Disable keyrepeat
> +
>    keypad,num-rows:
>      $ref: /schemas/types.yaml#/definitions/uint32
>      description: Number of row lines connected to the keypad controller.
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
> index c19d8391e2d5..7589d377c686 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.yaml
> @@ -60,7 +60,8 @@ properties:
>        enables hot-plug detection.
>  
>    default-input:
> -    maxItems: 1
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [ 0, 1 ]
>      description:
>        Select which input is selected after reset.
>  
> diff --git a/Documentation/devicetree/bindings/mux/reg-mux.yaml b/Documentation/devicetree/bindings/mux/reg-mux.yaml
> index 60d5746eb39d..e2f6b11f1254 100644
> --- a/Documentation/devicetree/bindings/mux/reg-mux.yaml
> +++ b/Documentation/devicetree/bindings/mux/reg-mux.yaml
> @@ -25,8 +25,12 @@ properties:
>      const: 1
>  
>    mux-reg-masks:
> -    description: an array of register offset and pre-shifted bitfield mask
> -      pairs, each describing a single mux control.
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    items:
> +      items:
> +        - description: register offset
> +        - description: pre-shifted bitfield mask
> +    description: Each entry describes a single mux control.

You have left out that we are dealing with "pairs". Is that implicit?

But why not explicit, so maybe like this?

+    description: Each entry pair describes a single mux control.

Either way, for reg-mux.yaml

Acked-by: Peter Rosin <peda@axentia.se>

Cheers,
Peter

>  
>    idle-states: true
>  
> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> index 6cd3d853dcba..59fe2789fa44 100644
> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
> @@ -129,6 +129,7 @@ patternProperties:
>        reset-gpios: true
>  
>        magic-packet:
> +        type: boolean
>          description:
>            Indicates that the hardware supports waking up via magic packet.
>  
> diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> index 8e52b2e683b8..93b3e991d209 100644
> --- a/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> +++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> @@ -37,6 +37,7 @@ properties:
>      const: stmmaceth
>  
>    mode-reg:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: An extra syscon register that control ethernet interface and timing delay
>  
>    rx-clk-delay-ps:
> diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> index 6f44f9516c36..a339202c5e8e 100644
> --- a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> @@ -34,6 +34,7 @@ properties:
>      maxItems: 1
>  
>    bus_freq:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      maximum: 2500000
>      description: MDIO Bus frequency
>  
> diff --git a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> index 8dd164d10290..d68bb2ec1f7e 100644
> --- a/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> @@ -54,9 +54,11 @@ properties:
>  
>  
>    ref-clock-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Reference clock frequency.
>  
>    tcxo-clock-frequency:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: TCXO clock frequency.
>  
>    clock-xtal:
> diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml b/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> index e59059ab5be0..b78535040f04 100644
> --- a/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> +++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie-ep.yaml
> @@ -55,13 +55,15 @@ properties:
>        Translation Unit) registers.
>  
>    num-ib-windows:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: number of inbound address translation windows
> -    maxItems: 1
>      deprecated: true
>  
>    num-ob-windows:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: number of outbound address translation windows
> -    maxItems: 1
>      deprecated: true
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml b/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> index a5345c494744..c90e5e2d25f6 100644
> --- a/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> +++ b/Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml
> @@ -68,6 +68,8 @@ properties:
>        Translation Unit) registers.
>  
>    num-viewport:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    maximum: 256
>      description: |
>        number of view ports configured in hardware. If a platform
>        does not specify it, the driver autodetects it.
> diff --git a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> index 53e963e090f2..533b4cfe33d2 100644
> --- a/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> +++ b/Documentation/devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml
> @@ -120,6 +120,7 @@ patternProperties:
>        input-schmitt-disable: true
>  
>        input-polarity-invert:
> +        type: boolean
>          description:
>            Enable or disable pin input polarity inversion.
>  
> @@ -132,6 +133,7 @@ patternProperties:
>        output-low: true
>  
>        output-polarity-invert:
> +        type: boolean
>          description:
>            Enable or disable pin output polarity inversion.
>  
> diff --git a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> index 3301fa0c2653..301db7daf870 100644
> --- a/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> +++ b/Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml
> @@ -51,6 +51,7 @@ properties:
>        supported by the CPR power domain.
>  
>    acc-syscon:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: A phandle to the syscon used for writing ACC settings.
>  
>    nvmem-cells:
> diff --git a/Documentation/devicetree/bindings/power/supply/battery.yaml b/Documentation/devicetree/bindings/power/supply/battery.yaml
> index d56ac484fec5..491488e7b970 100644
> --- a/Documentation/devicetree/bindings/power/supply/battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/battery.yaml
> @@ -85,8 +85,13 @@ properties:
>      description: battery factory internal resistance
>  
>    resistance-temp-table:
> +    $ref: /schemas/types.yaml#/definitions/uint32-matrix
> +    items:
> +      items:
> +        - description: the temperature in degree Celsius
> +        - description: battery internal resistance percent
>      description: |
> -      An array providing the temperature in degree Celsius
> +      A table providing the temperature in degree Celsius
>        and corresponding battery internal resistance percent, which is used to
>        look up the resistance percent according to current temperature to get an
>        accurate batterty internal resistance in different temperatures.
> diff --git a/Documentation/devicetree/bindings/power/supply/charger-manager.yaml b/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
> index c863cfa67865..fbb2204769aa 100644
> --- a/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/charger-manager.yaml
> @@ -36,6 +36,7 @@ properties:
>  
>    cm-poll-mode:
>      description: polling mode
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 0
>      enum:
>        - 0 # disabled
> diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> index 9a6e4eaf4d3c..fcd86f822a9c 100644
> --- a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> +++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
> @@ -27,6 +27,7 @@ properties:
>      maxItems: 1
>  
>    clock-error-detect:
> +    type: boolean
>      description: If set enable the clock detection management
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/serial/8250.yaml b/Documentation/devicetree/bindings/serial/8250.yaml
> index 3bab2f27b970..5f6b113d378f 100644
> --- a/Documentation/devicetree/bindings/serial/8250.yaml
> +++ b/Documentation/devicetree/bindings/serial/8250.yaml
> @@ -138,6 +138,7 @@ properties:
>      description: The current active speed of the UART.
>  
>    reg-offset:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      description: |
>        Offset to apply to the mapbase from the start of the registers.
>  
> diff --git a/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> index f7e94b1e0e4b..7416067c945e 100644
> --- a/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> +++ b/Documentation/devicetree/bindings/sound/audio-graph-card2.yaml
> @@ -24,10 +24,13 @@ properties:
>        connection's sink, the second being the connection's source.
>      $ref: /schemas/types.yaml#/definitions/non-unique-string-array
>    multi:
> +    type: object
>      description: Multi-CPU/Codec node
>    dpcm:
> +    type: object
>      description: DPCM node
>    codec2codec:
> +    type: object
>      description: Codec to Codec node
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> index d5474f83ac2c..e7e7bb65c366 100644
> --- a/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> +++ b/Documentation/devicetree/bindings/sound/imx-audio-hdmi.yaml
> @@ -20,9 +20,11 @@ properties:
>      description: User specified audio sound card name
>  
>    audio-cpu:
> +    $ref: /schemas/types.yaml#/definitions/phandle
>      description: The phandle of an CPU DAI controller
>  
>    hdmi-out:
> +    type: boolean
>      description: |
>        This is a boolean property. If present, the transmitting function
>        of HDMI will be enabled, indicating there's a physical HDMI out
> @@ -30,6 +32,7 @@ properties:
>        block, such as an HDMI encoder or display-controller.
>  
>    hdmi-in:
> +    type: boolean
>      description: |
>        This is a boolean property. If present, the receiving function of
>        HDMI will be enabled, indicating there is a physical HDMI in
> diff --git a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml b/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
> index b9e219829801..321b6f166197 100644
> --- a/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
> +++ b/Documentation/devicetree/bindings/usb/smsc,usb3503.yaml
> @@ -45,6 +45,7 @@ properties:
>        property if all ports have to be enabled.
>  
>    initial-mode:
> +    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [1, 2]
>      description: >
>        Specifies initial mode. 1 for Hub mode, 2 for standby mode.
