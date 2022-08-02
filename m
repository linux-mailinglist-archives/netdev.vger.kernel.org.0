Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878E587849
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 09:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbiHBHtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 03:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236218AbiHBHtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 03:49:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404894D150
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 00:49:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y11so20757378lfs.6
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 00:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IrNRhOKsz1OWQDYQfQKh2l69GmIOmDxrnod2nDb+hTE=;
        b=LGrbtkKa5FlEWBiJIK2ScPpVy3bynVh7tvYjYjB87raIQxlW0OdvG3ouGoEEc2T15T
         0yRdWAh3Qge6H1wlDuwYut2DtOB58f/zjTN94K83sRjJpZAjOmRbpBzw1/uuLgM/oFna
         OGTxjMnDNeMIN02NZUzx57HznPlpw+O6raYRKK1r51Rdcq5xhtvn2s5NYkwnaID0fyDd
         2XmP8lpx6Tnj0nvl82/qVX+ASr/jaF1WW/Up0sS8lRquuey13KP+aK9HliQypitY60av
         zlkKyZaRsda9kS5NuDwaVD0vyypA3l2PqQs6VzHEG72OdCa/c5XvlmcIeMBIsdnWDbhL
         9IiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IrNRhOKsz1OWQDYQfQKh2l69GmIOmDxrnod2nDb+hTE=;
        b=QLNDFKCoyztLUzfKaW1Bcv0ThWJAy1Dox+fSIp1iD3x2el1sryOg10zE7A0ce21sH9
         7Xz3ehMDUjnRjtGYjb3MHEsIlDPnt/rm+X+mEk6ShsIXIZcAYKxYhy28KtCjh5piGsA9
         gUThJwAgETysYgPTxVxDJxoh4+9n7zF2n8EnTJOH6e8wVszm+qyOz2tXbFUql3dfWUoJ
         O05J15N7x94mlBpuakih1KNmXgoSY0NmOqawm2B8A6eVrXNZpdFHX6ANbUYWh0hzSERh
         v9iqZ229vxuHA17m6nQOHjXHwwrQODUWOmRUS0MzF64Vu0Z2+8aYoIjgZzlsH8cifMK5
         PmFQ==
X-Gm-Message-State: ACgBeo3GWhsM/6WQEJeJ6hckHAv+S11FXUtVdDhizyE7l3BVNkk1vo27
        jl5ClWSpY7ImdpYfU3BU4nEvqg==
X-Google-Smtp-Source: AA6agR7B2rnsQhxphn9IMN0Q3PUKu0HYhD//NSx5eVl6YpWvO9a/EbTKATTlcdT4E8cO3L0+F9iC4w==
X-Received: by 2002:a19:6414:0:b0:48a:eb80:816b with SMTP id y20-20020a196414000000b0048aeb80816bmr4571106lfb.360.1659426545550;
        Tue, 02 Aug 2022 00:49:05 -0700 (PDT)
Received: from [192.168.1.6] ([213.161.169.44])
        by smtp.gmail.com with ESMTPSA id o20-20020a056512053400b0048a73d83b7csm1173385lfc.133.2022.08.02.00.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Aug 2022 00:49:05 -0700 (PDT)
Message-ID: <cb88bd4a-5f42-477d-c419-c4d90bf06b1f@linaro.org>
Date:   Tue, 2 Aug 2022 09:49:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 2/3] dt-bindings: can: ctucanfd: add another clock for
 HW timestamping
Content-Language: en-US
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
 <20220801184656.702930-3-matej.vasilevski@seznam.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220801184656.702930-3-matej.vasilevski@seznam.cz>
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

On 01/08/2022 20:46, Matej Vasilevski wrote:
> Add second clock phandle to specify the timestamping clock.
> You can even use the same clock as the core, or define a fixed-clock
> if you need something custom.
> 
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  .../bindings/net/can/ctu,ctucanfd.yaml        | 23 +++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> index 4635cb96fc64..90390530f909 100644
> --- a/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/ctu,ctucanfd.yaml
> @@ -44,9 +44,23 @@ properties:
>  
>    clocks:
>      description: |
> -      phandle of reference clock (100 MHz is appropriate
> -      for FPGA implementation on Zynq-7000 system).
> -    maxItems: 1
> +      Phandle of reference clock (100 MHz is appropriate for FPGA
> +      implementation on Zynq-7000 system). If you wish to use timestamps
> +      from the controller, add a second phandle with the clock used for
> +      timestamping. The timestamping clock is optional, if you don't
> +      add it here, the driver will use the primary clock frequency for
> +      timestamp calculations. If you need something custom, define
> +      a fixed-clock oscillator and reference it.

This should not be a guide how to write DTS, but description of
hardware. The references to driver are also not really appropriate in
the bindings (are you 100% sure that all other operating systems and SW
have driver which behaves like this...)

> +    minItems: 1
> +    items:
> +      - description: core clock
> +      - description: timestamping clock
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: core-clk
> +      - const: ts-clk
>  
>  required:
>    - compatible
> @@ -61,6 +75,7 @@ examples:
>      ctu_can_fd_0: can@43c30000 {
>        compatible = "ctu,ctucanfd";
>        interrupts = <0 30 4>;
> -      clocks = <&clkc 15>;
> +      clocks = <&clkc 15>, <&clkc 16>;
> +      clock-names = "core-clk", "ts-clk";
>        reg = <0x43c30000 0x10000>;
>      };


Best regards,
Krzysztof
