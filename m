Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC08430918C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 03:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhA3CS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 21:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbhA3CRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 21:17:00 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F63C061756;
        Fri, 29 Jan 2021 18:02:31 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so15602650ejf.11;
        Fri, 29 Jan 2021 18:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lWOW7Am2jw5lybt8Sbf6Grdt5LyyZ81zyiJX1cf+NHM=;
        b=LnUDAChPDt9mSpaSfBx0iTbzwCCR2nqzECbqcY4XtvOOiwZkNcPP2cuxyP8o05XZ3X
         fy4KmV04FDAM1G+l2nzOVrW/RHyno/FIdvKw5sAdjqyC2xac6K6FOLacOK4bb1Q3sRR8
         mmVQgqY6sgpBKqxBROse3ZSBOGG5rYDD5SED+JbszNHSJvM8UzXD0OZO+vnMUex+6HeK
         PORuWS3cBxSbeI8ULzT0i1eyikb2dqIzFVmeNTD0kQBKGUvggcqY6BodpJqMHlLxqPF7
         T5t1d/RSLDXsIzkZyLxRaeNYGxypY+tcvy/hTjNvp/E93bFmKHcu4v4HxuHJfwK7VsyI
         4coQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lWOW7Am2jw5lybt8Sbf6Grdt5LyyZ81zyiJX1cf+NHM=;
        b=UGQKW++IQxuhpFea0R0FJtV9vL8A0yWX5CKRLy0J2ttIPFP2O8YTNIJVtWxpW/6VKY
         hGzMPM9lKehmTrKI2lihXCQoKfB4CU0fSZvraCxluuqXyjjfcqKW9JWFfu1VLbRjt34W
         mzhyiqPCYpZkEj1hGjeeXcu3q866mQEuITCgOqao8MLy5+brCxQJKmyb63MW/H6zUPru
         Bxe4OK9Lip5kle7/j+4X08xoLYo4eBxb5c/Idhvtp2NZIUVNTFagWo9fWXdoC/ymKxwC
         17N+pVHrmDAAvb0pVMNBef/iU9SwqDgzY3K18Am9+JPCzGgt7h685XhLyMsGuS2O36IT
         HhpA==
X-Gm-Message-State: AOAM530mFvQe4lMP81LmE8hIH5uCYwfcNZzSgH/lWm43SK4cr045F2hD
        abSRa7hOpcQourcH77mysJ8=
X-Google-Smtp-Source: ABdhPJzhn1Ok/ZrdJEVffsdAfcTDBUaiBkfIVk0nB5XKD2dRHM07QWNjji0MA9JaNpYm586EXE9QXg==
X-Received: by 2002:a17:906:eb95:: with SMTP id mh21mr7306422ejb.175.1611972149962;
        Fri, 29 Jan 2021 18:02:29 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm5556926edi.92.2021.01.29.18.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 18:02:29 -0800 (PST)
Date:   Sat, 30 Jan 2021 04:02:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, UNGLinuxDriver@microchip.com,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <20210130020227.ahiee4goetpp2hb7@skbuf>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
 <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128064112.372883-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 12:11:05PM +0530, Prasanna Vengateshan wrote:
> +  spi-max-frequency:
> +    maximum: 50000000

And it actually works at 50 MHz? Cool.

> +
> +  reset-gpios:
> +    description: Optional gpio specifier for a reset line
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    //Ethernet switch connected via spi to the host, CPU port wired to eth1
> +    eth1 {

So if you do bother to add the DSA master in the example, can this be
&eth1 so that we could associate with the phandle below?

> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi1 {

Is this a label or a node name? spi1 or spi@1?

> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      pinctrl-0 = <&pinctrl_spi_ksz>;
> +      cs-gpios = <0>, <0>, <0>, <&pioC 28 0>;
> +      id = <1>;

I know this is the SPI controller and thus mostly irrelevant, but what
is "id = <1>"?

> +
> +      lan9374: switch@0 {
> +        compatible = "microchip,lan9374";
> +        reg = <0>;
> +
> +        spi-max-frequency = <44000000>;
> +
> +        ethernet-ports {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +          port@0 {
> +            reg = <0>;
> +            label = "lan1";
> +          };
> +          port@1 {
> +            reg = <1>;
> +            label = "lan2";
> +          };
> +          port@2 {
> +            reg = <7>;

reg should match node index (port@2), here and everywhere below. As for
the net device labels, I'm not sure if the mismatch is deliberate there.

> +            label = "lan3";
> +          };
> +          port@3 {
> +            reg = <2>;
> +            label = "lan4";
> +          };
> +          port@4 {
> +            reg = <6>;
> +            label = "lan5";
> +          };
> +          port@5 {
> +            reg = <3>;
> +            label = "lan6";
> +          };
> +          port@6 {
> +            reg = <4>;
> +            label = "cpu";

label for CPU port is not needed/used.

> +            ethernet = <&eth1>;
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@7 {
> +            reg = <5>;
> +            label = "lan7";
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +        };
> +      };
> +    };
