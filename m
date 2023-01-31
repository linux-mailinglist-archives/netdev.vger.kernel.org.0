Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBB6682195
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjAaBwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjAaBwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:52:37 -0500
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608129165;
        Mon, 30 Jan 2023 17:52:31 -0800 (PST)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-15ff0a1f735so17626984fac.5;
        Mon, 30 Jan 2023 17:52:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkhOVKtwqGjloVyH5HhA0nwe/ERN2VhbSaTeDIUnuS8=;
        b=OjLQWr5jOPQZMPvnoXWdSNH5+ByMgB6O/3OlSBn6TWIlOygW9QjJZvH3vFEdXApCuM
         5kh2pQMyMQVXDVldCMJnw3a1U/a1H6E/Vsi0psa5UhRKA/ftvIllDY1+PHXUbwc1TAG4
         Ov+u7VIV1XukhXIzcUre3usnN0SOPIF3311BBfqYPVUMZZj+aDx6AsB9JXq1mI+0uSEL
         9RuF4iP5Oxjym5PPEngpCU2dmI0gwC85geCLaODt4pr8NUh1p/xKbId69P6cVgp7i2YB
         Drwk127sYlfIniCzy0t3Q4mfvR4+OsMEcyE8u4x2Ost6X+PdyPiL62OMw8CkZc/jgfe9
         8BBA==
X-Gm-Message-State: AO0yUKWuss6nCQkczBZc4SWOnWC1HBBDQg/F47xrbfVjYVIFFDIx8fDz
        vkDNXfHlBsiuVOkmbKqfhA==
X-Google-Smtp-Source: AK7set/8OytAoPy2uP+IdddqTcDlyRj6kfw+2UPVg402hqcTw/35UG6u+SQaeuAv7aBL8FshJLZteA==
X-Received: by 2002:a05:6870:d10e:b0:163:88f7:d947 with SMTP id e14-20020a056870d10e00b0016388f7d947mr4388118oac.43.1675129950231;
        Mon, 30 Jan 2023 17:52:30 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v9-20020a05687105c900b00163c90c1513sm1309223oan.28.2023.01.30.17.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 17:52:29 -0800 (PST)
Received: (nullmailer pid 4086481 invoked by uid 1000);
        Tue, 31 Jan 2023 01:52:28 -0000
Date:   Mon, 30 Jan 2023 19:52:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v2 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth
 support
Message-ID: <20230131015228.GA4082140-robh@kernel.org>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-3-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130180504.2029440-3-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:35:03PM +0530, Neeraj Sanjay Kale wrote:
> Add binding document for generic and legacy NXP bluetooth
> chipsets.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v2: Resolved dt_binding_check errors. (Rob Herring)
> v2: Modified description, added specific compatibility devices,
> corrected indentations. (Krzysztof Kozlowski)
> ---
>  .../bindings/net/bluetooth/nxp-bluetooth.yaml | 40 +++++++++++++++++++
>  MAINTAINERS                                   |  6 +++
>  2 files changed, 46 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> new file mode 100644
> index 000000000000..9c8a25396b49
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/bluetooth/nxp-bluetooth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Bluetooth chips
> +
> +description:
> +  This binding describes UART-attached NXP bluetooth chips.
> +
> +maintainers:
> +  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,w8987-bt
> +      - nxp,w8997-bt
> +      - nxp,w9098-bt
> +      - nxp,iw416-bt
> +      - nxp,iw612-bt
> +
> +  firmware-name:
> +    description:
> +      Specify firmware file name.

default?


No interrupts or power supplies on these chips?

> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    uart2 {

serial {

> +        bluetooth {
> +          compatible = "nxp,iw416-bt";
> +          firmware-name = "uartuart_n61x_v1.bin";
> +        };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 32dd41574930..d465c1124699 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
>  S:	Maintained
>  F:	mm/zswap.c
>  
> +NXP BLUETOOTH WIRELESS DRIVERS
> +M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
> +M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
> +
>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
>  L:	linux-kernel@vger.kernel.org
> -- 
> 2.34.1
> 
