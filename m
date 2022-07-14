Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9920C5751AF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbiGNPVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbiGNPVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:21:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA87A57E05
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:21:44 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1oC0ef-0004Q5-Lq; Thu, 14 Jul 2022 17:21:29 +0200
Message-ID: <1ba2b493-2ee2-e4b9-b11f-4fbb48473531@pengutronix.de>
Date:   Thu, 14 Jul 2022 17:21:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] dt-bindings: bcm4329-fmac: add optional
 brcm,ccode-map-trivial
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        van Spriel <arend@broadcom.com>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20220711123005.3055300-1-alvin@pqrs.dk>
 <20220711123005.3055300-2-alvin@pqrs.dk>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20220711123005.3055300-2-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.07.22 14:30, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The bindings already offer a brcm,ccode-map property to describe the
> mapping between the kernel's ISO3166 alpha 2 country code string and the
> firmware's country code string and revision number. This is a
> board-specific property and determined by the CLM blob firmware provided
> by the hardware vendor.
> 
> However, in some cases the firmware will also use ISO3166 country codes
> internally, and the revision will always be zero. This implies a trivial
> mapping: cc -> { cc, 0 }.
> 
> For such cases, add an optional property brcm,ccode-map-trivial which
> obviates the need to describe every trivial country code mapping in the
> device tree with the existing brcm,ccode-map property. The new property
> is subordinate to the more explicit brcm,ccode-map property.
> 
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>

Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

> ---
>  .../bindings/net/wireless/brcm,bcm4329-fmac.yaml       | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index c11f23b20c4c..53b4153d9bfc 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> @@ -75,6 +75,16 @@ properties:
>      items:
>        pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
>  
> +  brcm,ccode-map-trivial:
> +    description: |
> +      Use a trivial mapping of ISO3166 country codes to brcmfmac firmware
> +      country code and revision: cc -> { cc, 0 }. In other words, assume that
> +      the CLM blob firmware uses ISO3166 country codes as well, and that all
> +      revisions are zero. This property is mutually exclusive with
> +      brcm,ccode-map. If both properties are specified, then brcm,ccode-map
> +      takes precedence.
> +    type: boolean
> +
>  required:
>    - compatible
>    - reg


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
