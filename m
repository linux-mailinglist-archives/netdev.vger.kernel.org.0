Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415E52ACC8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352952AbiEQUfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239770AbiEQUfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:35:12 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A5F52B08;
        Tue, 17 May 2022 13:35:11 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-f17f1acffeso115047fac.4;
        Tue, 17 May 2022 13:35:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GmVQSVvz0XOG6SjnV7V4V6/T41LZgX89awI2HyE+m1g=;
        b=M16Wo2uODFOMFu7LdbBn+yuWEHPxaWaHGQG0zRhOSXTlFMb6XbcrmKqXUCTsgm+NZf
         SKudcSJGY+9jLqa/p8TPEuSpUgiOeYILAkjcZAwrUgse3U3ko0wI/DalI2cZHsmxBu07
         AnYifBKNTWSArJHJH4MJsY0xF4dwVF70aWWU1+fiRkS0Zr88+6U5vRlxzx81HQEbVvMz
         RUbx3kxZqqQnp/unR4qVdrng6cLl2J4IyW08qIn/PbEHEYalzre22x9QNtSQxpLpYIon
         nKyetfzPv6H6BWb+1X6mkWvXmdE2fkgSR1s5KnZBQsYCxHhybOkjv/vVA4Q9OrzLCZuG
         Y+HQ==
X-Gm-Message-State: AOAM531jb3JeXT1J6a7O1q7yIPbg5qjsosZD7qotm1Krv5lbOFwJQzFk
        ktCsHUjgT8G5I3bubk/IeIyHeTFn1Q==
X-Google-Smtp-Source: ABdhPJwVy5rMYvBSm6iJXKOoWVCYoOCbHdrII8531VFVtPAVHhEAMU0+Vo7aEjXF+Qq/rl3ZVqG6rw==
X-Received: by 2002:a05:6870:311e:b0:de:bd67:b6c3 with SMTP id v30-20020a056870311e00b000debd67b6c3mr19403147oaa.268.1652819710483;
        Tue, 17 May 2022 13:35:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p206-20020acabfd7000000b0032617532120sm106697oif.48.2022.05.17.13.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:35:09 -0700 (PDT)
Received: (nullmailer pid 1590333 invoked by uid 1000);
        Tue, 17 May 2022 20:35:08 -0000
Date:   Tue, 17 May 2022 15:35:08 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH RESEND 1/5] dt-bindings: net: add bitfield defines for
 Ethernet speeds
Message-ID: <20220517203508.GA1587170-robh@kernel.org>
References: <20220505135512.3486-1-zajec5@gmail.com>
 <20220505135512.3486-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220505135512.3486-2-zajec5@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 03:55:08PM +0200, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows specifying multiple Ethernet speeds in a single DT uint32
> value.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
>  include/dt-bindings/net/eth.h | 27 +++++++++++++++++++++++++++

ethernet.h

>  1 file changed, 27 insertions(+)
>  create mode 100644 include/dt-bindings/net/eth.h
> 
> diff --git a/include/dt-bindings/net/eth.h b/include/dt-bindings/net/eth.h
> new file mode 100644
> index 000000000000..89caff09179b
> --- /dev/null
> +++ b/include/dt-bindings/net/eth.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */

Dual license

> +/*
> + * Device Tree constants for the Ethernet
> + */
> +
> +#ifndef _DT_BINDINGS_ETH_H
> +#define _DT_BINDINGS_ETH_H
> +
> +#define SPEED_UNSPEC		0
> +#define SPEED_10		(1 << 0)
> +#define SPEED_100		(1 << 1)
> +#define SPEED_1000		(1 << 2)
> +#define SPEED_2000		(1 << 3)
> +#define SPEED_2500		(1 << 4)
> +#define SPEED_5000		(1 << 5)
> +#define SPEED_10000		(1 << 6)
> +#define SPEED_14000		(1 << 7)
> +#define SPEED_20000		(1 << 8)
> +#define SPEED_25000		(1 << 9)
> +#define SPEED_40000		(1 << 10)
> +#define SPEED_50000		(1 << 11)
> +#define SPEED_56000		(1 << 12)
> +#define SPEED_100000		(1 << 13)
> +#define SPEED_200000		(1 << 14)
> +#define SPEED_400000		(1 << 15)

These should probably have some namespace. ETH_*?
> +
> +#endif
> -- 
> 2.34.1
> 
> 
