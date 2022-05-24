Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DD6532104
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 04:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbiEXCeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 22:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiEXCeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 22:34:06 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3579E644EC;
        Mon, 23 May 2022 19:34:05 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id s188so16167902oie.4;
        Mon, 23 May 2022 19:34:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kQ55kASZf8+ZtGhpJrtLtWAceVZ4Lu6mQKOAAsP+HjE=;
        b=xgNB77iITv3utYj9i/Bdw2vqcEXKeOUd9ERd+hLWKy/kQkqJhFOq5JyvF2CUHM9xYw
         IPkEhCoPt6U59lYv6QZUCXXOOM4b0FsVLSgHHGu4E4pypKkKBZyw5fFi9JGiyLz5d0Ja
         jsWh5lbfGxBsed4DwvsGgybQ5/UzZCTpLPp5unjbaQJR7VfU+7b9XsIpCNIdzarGZkXl
         CNwoU7GgPwe9PaCJOugZ6RiXyLEJcnpMn4A48AtMKA9/fh/5VkIRI8yOlXbSblR/4s9Y
         bNyidEwuH82G8QJ5V0KsNs3qj/73PHS9q9pScf8N/0shxmSWRWV6kA6ajkBd+J4R6eKt
         Ec9w==
X-Gm-Message-State: AOAM533Y44fK+iiW3MVWOKzNyQJWnmxHzl1k+ELBzu5d++GvIwjYH+aM
        UTMkkVI2dMlX4Su/M+dYXQ==
X-Google-Smtp-Source: ABdhPJypQll2k7ZYAoY+Gpf9jQFK21Au4QtiXZhkqWhp3nFPoN2gmmKBt4xbE8plesHRgyXN106yMQ==
X-Received: by 2002:a05:6808:1902:b0:32b:2141:f5c3 with SMTP id bf2-20020a056808190200b0032b2141f5c3mr1163828oib.143.1653359644456;
        Mon, 23 May 2022 19:34:04 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id dx28-20020a056870769c00b000f20ac7e5a8sm4393103oab.53.2022.05.23.19.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 19:34:03 -0700 (PDT)
Received: (nullmailer pid 2651689 invoked by uid 1000);
        Tue, 24 May 2022 02:34:02 -0000
Date:   Mon, 23 May 2022 21:34:02 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Jimmy Lalande <jimmy.lalande@se.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Eric Dumazet <edumazet@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Herve Codina <herve.codina@bootlin.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-renesas-soc@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v5 06/13] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220524023402.GA2651571-robh@kernel.org>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-7-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-7-clement.leger@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 17:31:00 +0200, Clément Léger wrote:
> Add bindings for Renesas RZ/N1 Advanced 5 port switch. This switch is
> present on Renesas RZ/N1 SoC and was probably provided by MoreThanIP.
> This company does not exists anymore and has been bought by Synopsys.
> Since this IP can't be find anymore in the Synospsy portfolio, lets use
> Renesas as the vendor compatible for this IP.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 131 ++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
