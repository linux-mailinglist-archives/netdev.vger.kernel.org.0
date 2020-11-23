Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6F32C0109
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgKWIB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:01:28 -0500
Received: from mail-ej1-f66.google.com ([209.85.218.66]:37760 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKWIB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:01:28 -0500
Received: by mail-ej1-f66.google.com with SMTP id z5so1857023ejp.4;
        Mon, 23 Nov 2020 00:01:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NclaCJHXiBfJ0Rpl5FSpxC/w5EINjItcyb1F1x5YFWQ=;
        b=aKtJ2dbr4J4fzDan8g9hMdZrh1qzzX66WF27YdEWC3aneSBsjnZHuuXB0OObDQaheE
         MKof8BFU7gCHqfQYYqfjlhkOyoJfZMkaAtSUlcLCsRBmamziu6O4z0P/qgAZf4jb7Hj0
         5sW4q49/7EqcZ8+qL0lH2k3S3lFxpY+B9xGULH97XOzHgHyoCptvBskdVvJcbKhreqCH
         msmZ3CX8gpauZGVwwguI/n1qluHYO9ZhKS/ubfrv7EvjiGrsB/foH+2o8esuTMqJ/FDK
         9quqWp7uSG6nK8/sR9atIxsMYIxGohYWIwX6TlvhSzoCHq29Ul1CS2UdtImSmg7+x9dP
         eAbQ==
X-Gm-Message-State: AOAM531zLzOqlwwoRY6AKad7DDQ75rFp/UeVxM8OKxnjsaITH7Yu/m0n
        g/HrU+elRA4nURs7VJgZPWVEpDZ3xOc=
X-Google-Smtp-Source: ABdhPJxsrf7uRQesS+TQY5uPAJFd1MmlLT1cbPz+Ppl65azwyzxj2pEdLkjsnapnixfNYkjMu0oeVg==
X-Received: by 2002:a17:906:831a:: with SMTP id j26mr43630906ejx.450.1606118486218;
        Mon, 23 Nov 2020 00:01:26 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id y12sm4453869ejj.95.2020.11.23.00.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:01:25 -0800 (PST)
Date:   Mon, 23 Nov 2020 09:01:23 +0100
From:   "krzk@kernel.org" <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: nfc: s3fwrn5: Support a
 UART interface
Message-ID: <20201123080123.GA5656@kozik-lap>
References: <CGME20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
 <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201123075526epcms2p59410a8ba942f8942f53a593d9df764d0@epcms2p5>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 23, 2020 at 04:55:26PM +0900, Bongsu Jeon wrote:
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 28 +++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> index cb0b8a560282..37b3e5ae5681 100644
> --- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> +++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> @@ -13,6 +13,7 @@ maintainers:
>  properties:
>    compatible:
>      const: samsung,s3fwrn5-i2c
> +    const: samsung,s3fwrn82-uart

This does not work, you need to use enum. Did you run at least
dt_bindings_check?

The compatible should be just "samsung,s3fwrn82". I think it was a
mistake in the first s3fwrn5 submission to add a interface to
compatible.

>  
>    en-gpios:
>      maxItems: 1
> @@ -47,10 +48,19 @@ additionalProperties: false
>  required:
>    - compatible
>    - en-gpios
> -  - interrupts
> -  - reg
>    - wake-gpios
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: samsung,s3fwrn5-i2c
> +    then:
> +      required:
> +        - interrupts
> +        - reg
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> @@ -71,3 +81,17 @@ examples:
>              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
>          };
>      };
> +  # UART example on Raspberry Pi
> +  - |
> +    &uart0 {
> +        status = "okay";
> +
> +        s3fwrn82_uart {

Just "bluetooth" to follow Devicetree specification.

Best regards,
Krzysztof
