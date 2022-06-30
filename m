Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BCB562013
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbiF3QRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbiF3QRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:17:35 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326F62E087;
        Thu, 30 Jun 2022 09:17:35 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id 9so12711122ill.5;
        Thu, 30 Jun 2022 09:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=q/SFM7tlCbPG9MPt9DVFEuD2pGYii3RFWX7VVRKazOI=;
        b=HF/wT857fNrJv3dugodIxp6CHjG5x9w8CfgZBoPB/G3nTb+ZH+CThGA7StnH25vwNq
         AheX16MrhLAvW0QyTmHKZf2aTRS5ylYBTx9E73SMXzaHL2ou9i03bO4pSbijSSc8gkqc
         x11OaW1kqoB4Cb9Vil530r/dlJ6N10L6Ic3IcIYhvVwczXxnHfnI73PkdOmag+1mF6zJ
         uCfvsl0Lp7WzxFzYKGHyKDEESZ+NoTRS5aYSj+81Ss5VhUf26lHaw0AvRv3es0w5ByOK
         ZuK4uIcNaAeGdGIUegPBcX0EGn29wYaUvnGupA9FXIIXmZ7JFF5AAuzBF6TvortdmtjO
         XuoQ==
X-Gm-Message-State: AJIora9UqlmMU2Ccytcok2k6DLTneNd6KeyJfj0LKMKmY29TMn9zOO4h
        FxoWYjfqaWiWC1caPNw0suAZxmvcQg==
X-Google-Smtp-Source: AGRyM1ug+M9kyReUNbTWDDSl6F6kAbLlRpJAtMHlaAXsWsTP0S7OgFkMXyOCqKekOQy8Ugh+oOD2Iw==
X-Received: by 2002:a05:6e02:b24:b0:2d9:2ad3:3153 with SMTP id e4-20020a056e020b2400b002d92ad33153mr5670692ilu.208.1656605854462;
        Thu, 30 Jun 2022 09:17:34 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p13-20020a056638216d00b00339ea90fa80sm8677059jak.71.2022.06.30.09.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 09:17:34 -0700 (PDT)
Received: (nullmailer pid 2830875 invoked by uid 1000);
        Thu, 30 Jun 2022 16:17:31 -0000
Date:   Thu, 30 Jun 2022 10:17:31 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Herve Codina <herve.codina@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: renesas,rzn1-a5psw: add
 interrupts description
Message-ID: <20220630161731.GA2830744-robh@kernel.org>
References: <20220629091305.125291-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220629091305.125291-1-clement.leger@bootlin.com>
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

On Wed, 29 Jun 2022 11:13:04 +0200, Clément Léger wrote:
> Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> are connected to the GIC.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
