Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37A25F3526
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJCSBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJCSB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:01:28 -0400
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336172BE34;
        Mon,  3 Oct 2022 11:01:21 -0700 (PDT)
Received: by mail-oo1-f45.google.com with SMTP id c17-20020a4aa4d1000000b0047653e7c5f3so7243432oom.1;
        Mon, 03 Oct 2022 11:01:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=TFv9P5jQ9zifFnLwFf++mqfW7DNNGIgHHIkwyTFAQZo=;
        b=eB3d+ky/kQaF5j/LDrE5ZPK2Mm5owR29+IZL9XFvPgjf7fWUgj+1YII/U3YP2l79E2
         Nr+dwjx3iXtKqhcnU6rfIcijyOVinyZncJFTKvU/09HgL4fKOGx1eWF8YO+6leIVbiHh
         AkhTbdQckZvcYnqXfz9uAqUWY0rLx4jc10T1wG2IREZ3scKoSOERgg/9eqBz5Ej2sF/9
         MkpTa1Vz8JgX4YCEF+INwRF6/m/48786RgFvwJ3iZulSlIaNks0LpQS3pEABs+ppz3mr
         W7XgDymlpsdvHMebhv26uV6puirQDZSWWppCY4wEoLAQg2OHTfythx+GQtURpmaT1ilE
         dg+w==
X-Gm-Message-State: ACrzQf0HRGLQSySYtcQKpUryBlw+z/xQzEntu7SFig5+fkH5QdLzrTrk
        Gb8aqGGXh//NmAVLXyP382Ighu++lA==
X-Google-Smtp-Source: AMsMyM4NeG/hFaHjh2k/7Qg0r/xi5qa6+tQbM7yB3A0IWWC2dcK/CxPRblA68lN7FiO/OLM0vjHrdg==
X-Received: by 2002:a9d:4e88:0:b0:654:1012:85bd with SMTP id v8-20020a9d4e88000000b00654101285bdmr8247324otk.136.1664820080360;
        Mon, 03 Oct 2022 11:01:20 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z11-20020a056830128b00b00639749ef262sm2538200otp.9.2022.10.03.11.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 11:01:19 -0700 (PDT)
Received: (nullmailer pid 2515061 invoked by uid 1000);
        Mon, 03 Oct 2022 18:01:18 -0000
Date:   Mon, 3 Oct 2022 13:01:18 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, Luka Perkov <luka.perkov@sartura.hr>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew@lunn.ch>,
        David Jander <david@protonic.nl>, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v8 6/7] dt-bindings: net: pse-dt: add bindings
 for regulator based PoDL PSE controller
Message-ID: <166482007742.2514990.4199800576904693685.robh@kernel.org>
References: <20221003065202.3889095-1-o.rempel@pengutronix.de>
 <20221003065202.3889095-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003065202.3889095-7-o.rempel@pengutronix.de>
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

On Mon, 03 Oct 2022 08:52:01 +0200, Oleksij Rempel wrote:
> Add bindings for the regulator based Ethernet PoDL PSE controller and
> generic bindings for all PSE controllers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---
> changes v6:
> - add description of PSE controller
> - change "^ethernet-pse(@[a-f0-9]+)?$" to "^ethernet-pse(@.*)?$"
> changes v5:
> - rename to podl-pse-regulator.yaml
> - remove compatible description
> - remove "-1" on node name
> - add pse-controller.yaml for common properties
> changes v4:
> - rename to PSE regulator
> - drop currently unused properties
> - use own compatible for PoDL PSE
> changes v2:
> - rename compatible to more generic "ieee802.3-pse"
> - add class and type properties for PoDL and PoE variants
> - add pairs property
> ---
>  .../net/pse-pd/podl-pse-regulator.yaml        | 40 +++++++++++++++++++
>  .../bindings/net/pse-pd/pse-controller.yaml   | 33 +++++++++++++++
>  2 files changed, 73 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
