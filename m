Return-Path: <netdev+bounces-9088-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 125987272AC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 01:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7E00281528
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 23:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 232BD3B3FF;
	Wed,  7 Jun 2023 23:05:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179903B3E0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:05:06 +0000 (UTC)
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F6B10DE;
	Wed,  7 Jun 2023 16:05:05 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-77a1cad6532so131455139f.1;
        Wed, 07 Jun 2023 16:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686179104; x=1688771104;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SKlzSAskxYQjFMQrq1GcFEOvXKAgtJCbeNAdADGIZQM=;
        b=ko/v1TjFCs19BEP2w8YXPul+VsvJUfxoz9+NS7yFPGKG1F4jb/ASGJWKQ8Ig05aQ4g
         2usqjpEvgj2EHnm6QzIVt5T7E45+/trqQC4jY07/yjHAkNJjSVrHDPkXul6pZdeJF20g
         KH5GI5Hl4kWavKnEFi2/o55VX8m+5AP82jwWMrvIlbmKKsdZbGK3UbiwBlPOold0/bNP
         EvP5NyWCQU8vzi4OBrNb9kL/SNbjeYPXisDJhQzGh17IrDDe5nSTZiYL3brT2vKiKGrf
         1UWRWX9alrcDKx9sLqnGjEuF5xG21L4Lr0jHv40fuk5zOiSLyy+WCJQ5PnBwMluMOLGy
         8BYA==
X-Gm-Message-State: AC+VfDwEziqGsMOOiVsJ8wtqJubJG6rwk5Or/QJUseFmwAxYJbsz5GKm
	5HklvpKEfboqrNQ2+4IS0g==
X-Google-Smtp-Source: ACHHUZ6tk+oTIhwIPYYov3AbcNbbjKddfdX4uFboDrcRsYwo3fRyb/y/XYtMePP7i5wgf8PrNnjPbw==
X-Received: by 2002:a05:6602:2001:b0:776:fd07:3c96 with SMTP id y1-20020a056602200100b00776fd073c96mr9432362iod.7.1686179104733;
        Wed, 07 Jun 2023 16:05:04 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id d26-20020a5d9bda000000b00763699c3d02sm4150726ion.0.2023.06.07.16.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 16:05:04 -0700 (PDT)
Received: (nullmailer pid 153358 invoked by uid 1000);
	Wed, 07 Jun 2023 23:04:59 -0000
Date: Wed, 7 Jun 2023 17:04:59 -0600
From: Rob Herring <robh@kernel.org>
To: Leonard =?iso-8859-1?Q?G=F6hrs?= <l.goehrs@pengutronix.de>
Cc: Woojung Huh <woojung.huh@microchip.com>, UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Vladimir Oltean <olteanv@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Marek Vasut <marex@denx.de>, kernel@pengutronix.de, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/8] dt-bindings: net: dsa: microchip: add missing
 spi-{cpha,cpol} properties
Message-ID: <20230607230459.GA151104-robh@kernel.org>
References: <20230607115508.2964574-1-l.goehrs@pengutronix.de>
 <20230607115508.2964574-5-l.goehrs@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230607115508.2964574-5-l.goehrs@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 01:55:04PM +0200, Leonard Göhrs wrote:
> This patch allows setting the correct SPI phase and polarity for KSZ
> switches.
> 
> Signed-off-by: Leonard Göhrs <l.goehrs@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> index e51be1ac03623..f7c620d9ee8b4 100644
> --- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> @@ -49,6 +49,9 @@ properties:
>        Set if the output SYNCLKO clock should be disabled. Do not mix with
>        microchip,synclko-125.
>  
> +  spi-cpha: true
> +  spi-cpol: true

These should only be needed if the mode is configurable or variable. 
Otherwise, the driver for the device should set the mode correctly.

Rob

