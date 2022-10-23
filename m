Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7F609478
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJWPlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiJWPlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:41:47 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFE361735
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:41:45 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id o2so4865837qkk.10
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qKm/ygaUyu+mdWLzI2FaUp8bVXs/rUKlSlQewbnTSq8=;
        b=xUlQPVd8BdW0EXinGs6JbgeWbbRb2E6nEjF1e5QxlsKvOVdLWCspZXCn8DwMXH2x4f
         f5zlNt+073Q+45PJK+1+JHUoQ9MLd8wNMz/GTu7f3ocBYFvm7HpA3Yaz+K6ZGhGe0NuX
         w+LUQZiCAcb4c2nM1DZEpkFRDs53bJ4N8vBNVS7tiGxYxv9tcDhNDMhJpDIX3YTFUB6H
         SMfGMfNT8e/AhAbs+4UWmeIprDihwsEIWlupxny8DtiVxuUwLSryDX2iDdeb/Ar7a4ew
         DP1u2OJ0NqVF1Vk0rOMMmU/faRWev8bYdTTr9+fuIvphaP70XCRTaFZhek6k6hB0bVV7
         oOXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKm/ygaUyu+mdWLzI2FaUp8bVXs/rUKlSlQewbnTSq8=;
        b=qNOftoVB9yySF1U39XKVSVcSwNiBS2gixaIsBscun6wybfG4yj37ohEgfzBkMEe/f/
         FVzQgrhbIRIOysMVEyFxDxOnsd7TVSptctXUg0rs0XPIe1j2LloKEgnaei9LblKVorJ4
         kEA6dpDkeV/JwdA4PfAl5uGoEGH72QmSQCirixLoFb2JNaqms4/R7LmyK82QIeI1J0C7
         LOl1DUbkMNcd8kKK9wvyfdlOSI5uRZntJeSU0dll3fpqQNdeboE1Zu+DTCpd/Q+euENL
         Su/3rVrMDfhE7rqZpMEHM9QNkqtYTnokI/icY9WRmJmV7353/A1XX5UW2VJsPzrtQ/xn
         MKGA==
X-Gm-Message-State: ACrzQf2laNaOavcQe0LiXCx3J6qJbNW53g6JsvV79h1CviDayhYJmsE4
        V+cZylhr2YtzdKNvQ2DFRzhBJw==
X-Google-Smtp-Source: AMsMyM40jB2uE9+zox0fYZalOOrH463HyfYcXRKYcp7jTFsC68pShoY7wPXpWxYf2EZXiQN0Lx4w3w==
X-Received: by 2002:a05:620a:2683:b0:6cf:3a7e:e006 with SMTP id c3-20020a05620a268300b006cf3a7ee006mr20082344qkp.474.1666539705070;
        Sun, 23 Oct 2022 08:41:45 -0700 (PDT)
Received: from [192.168.1.8] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id cg15-20020a05622a408f00b0039c37a7914csm11229206qtb.23.2022.10.23.08.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 08:41:44 -0700 (PDT)
Message-ID: <cfbde0da-9939-e976-52c1-88577de7d4cb@linaro.org>
Date:   Sun, 23 Oct 2022 11:41:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next V2] dt-bindings: net: ethernet-controller: Add
 ptp-hardware-clock
Content-Language: en-US
To:     Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, richardcochran@gmail.com
Cc:     krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangbo.lu@nxp.com, radhey.shyam.pandey@amd.com,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221021054111.25852-1-sarath.babu.naidu.gaddam@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/10/2022 01:41, Sarath Babu Naidu Gaddam wrote:
> There is currently no standard property to pass PTP device index
> information to ethernet driver when they are independent.
> 
> ptp-hardware-clock property will contain phandle to PTP clock node.
> 
> Freescale driver currently has this implementation but it will be
> good to agree on a generic (optional) property name to link to PTP
> phandle to Ethernet node. In future or any current ethernet driver
> wants to use this method of reading the PHC index,they can simply use
> this generic name and point their own PTP clock node, instead of
> creating separate property names in each ethernet driver DT node.
> 
> axiethernet driver uses this method when PTP support is integrated.
> 
> Example:
> 	fman0: fman@1a00000 {
> 		ptp-hardware-clock = <&ptp_timer0>;
> 	}
> 
> 	ptp_timer0: ptp-timer@1afe000 {
> 		compatible = "fsl,fman-ptp-timer";
> 		reg = <0x0 0x1afe000 0x0 0x1000>;
> 	}
> 
> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> ---
> We want binding to be reviewed/accepted and then make changes in freescale
> binding documentation to use this generic binding.

No, send entire set. We need to see the users of it.

> 
> DT information:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi#n23

Don't wrap links. It's not possible to click them...

> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/Documentation/devicetree/bindings/net/fsl-fman.txt#n320
> 
> Freescale driver:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
> tree/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c#n467
> 
> Changes in V2:
> 1) Changed the ptimer-handle to ptp-hardware-clock based on
>    Richard Cochran's comment.
> 2) Updated commit description.
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 3aef506fa158..d2863c1dd585 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -161,6 +161,11 @@ properties:
>        - auto
>        - in-band-status
>  
> +  ptp-hardware-clock:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Specifies a reference to a node representing a IEEE1588 timer.

Drop "Specifies a reference to". It's obvious from the schema.

Aren't you expecting here some specific Devicetree node of IEEE1588
timer? IOW, you expect to point to timer, but what this timer must
provide? How is this generic?

In your commit msg you use multiple times "driver", so are you adding it
only to satisfy Linux driver requirements? What about other drivers,
e.g. on BSD or U-Boot?

Best regards,
Krzysztof

