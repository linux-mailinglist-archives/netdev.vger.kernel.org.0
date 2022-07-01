Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF656277E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiGAAAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 20:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiGAAAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 20:00:07 -0400
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7644E11C10;
        Thu, 30 Jun 2022 17:00:06 -0700 (PDT)
Received: by mail-il1-f182.google.com with SMTP id a16so415152ilr.6;
        Thu, 30 Jun 2022 17:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=alaOAxac/whasDo+F0SLlYnMNG4UT3+tKraIB0ld9sU=;
        b=Ql3cb4M4tybaqP04CQxWCBkvqnLHG01UdySK60y1AaJex/I/Zrj1SyHMVZ2MCnBXBY
         05iZeY9TIcxENYsWTOUl1WxH0dIhbjVsFC+78lU4ZvIjxWHGaNm1fglD6kW1shUtK+83
         AZAADw0OH1beqL+XIZqjwGDjxnFf8NSiUnbSxB+sPCKPp1VSWLQzhXp/oEHTmQo6Pk0V
         HwW9AZhPde0RqQRuzMK7QN+m3o8iDXh5qLbs6Ef+dJByXonoGFdqOlKXSE9j7VwbTkAA
         LPWEUsj+8poWphVpmqel1Sj/hymu7jQpmbys/pIq6cQWVsxwE0tLcMdgSwG0Xmjpk1jZ
         5YjQ==
X-Gm-Message-State: AJIora/7C0P6m1VrI0cSIbNw4bcUW/r2SKsVvu+JxKXrPgrzu+yepauY
        8UyL4cXZFcT0sUWbzuJ49w==
X-Google-Smtp-Source: AGRyM1upbMkLP2rl+RR+ByeAK0sVONUQtA5X3aak4lRl3y0M9b4b1+XGOebPSYcQAoIu79d6FWPifw==
X-Received: by 2002:a05:6e02:154a:b0:2da:8a02:bcba with SMTP id j10-20020a056e02154a00b002da8a02bcbamr6797198ilu.167.1656633605730;
        Thu, 30 Jun 2022 17:00:05 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q1-20020a02a981000000b0032b3a78178bsm9124749jam.79.2022.06.30.17.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 17:00:05 -0700 (PDT)
Received: (nullmailer pid 3585421 invoked by uid 1000);
        Fri, 01 Jul 2022 00:00:01 -0000
Date:   Thu, 30 Jun 2022 18:00:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Herve Codina <herve.codina@bootlin.com>,
        linux-renesas-soc@vger.kernel.org,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2] dt-bindings: net: dsa: renesas,rzn1-a5psw:
 add interrupts description
Message-ID: <20220701000001.GA3585383-robh@kernel.org>
References: <20220630162515.37302-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220630162515.37302-1-clement.leger@bootlin.com>
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

On Thu, 30 Jun 2022 18:25:15 +0200, Clément Léger wrote:
> Describe the switch interrupts (dlr, switch, prp, hub, pattern) which
> are connected to the GIC.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
> Changes in V2:
>  - Fix typo in interrupt-names property.
> 
>  .../bindings/net/dsa/renesas,rzn1-a5psw.yaml  | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
