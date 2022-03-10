Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5254D52AE
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiCJT5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 14:57:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244051AbiCJT5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 14:57:41 -0500
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECAE13FAE8;
        Thu, 10 Mar 2022 11:56:40 -0800 (PST)
Received: by mail-oo1-f42.google.com with SMTP id q1-20020a4a7d41000000b003211b63eb7bso8086686ooe.6;
        Thu, 10 Mar 2022 11:56:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+BCVEbogmptpP2FcQSv9ORdKXR1+nLC/fAvUoIg6CDo=;
        b=rJXE1p19FPVEQTeA3QMf6gLmCHTUaS2KB8vV576ArkXvnjUxHr5SOpkWM4PCK9+iUn
         un1GiL6vPIS43Fl3CPxCwCGNReWGl4tSyW04UK+oUReftEjmm5PLFkmIwAoz0DPghrNj
         tH29Qks06jEB/lSHy07eESgw2kOxnVroXiU9R0WfLivTNV+iJi+aBq/1tsKX7AIAfaYl
         Pn55Xk37M+fTUTMnAFewV/C5F7+K21XJDchBITTUqTFHgTSdtLrvgANn7U25LSUpeFzL
         MjkJEG6u4oE27qNSMHO9Vhr56ZbkF72kFJTjBuRZoENh/aZAv8kxNLJ3UYyS41eluA42
         sxIQ==
X-Gm-Message-State: AOAM530jTP822vc27DryhccHB4i09/MAprxZKvJOrIfuSO3PuBZayxFp
        oFeiUy0A8G4Vsznzxl0TTA==
X-Google-Smtp-Source: ABdhPJxObGVC0f19olhG4M8cmWlqVxZR8pAJHrhnEfmTGKsmxRwDp+r2zHZSXPjHMwtdqTD0wbTmCg==
X-Received: by 2002:a05:6870:8984:b0:ce:c0c9:63b with SMTP id f4-20020a056870898400b000cec0c9063bmr9685769oaq.141.1646942199414;
        Thu, 10 Mar 2022 11:56:39 -0800 (PST)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n6-20020a056870970600b000d8a7483548sm2725488oaq.43.2022.03.10.11.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 11:56:38 -0800 (PST)
Received: (nullmailer pid 1958881 invoked by uid 1000);
        Thu, 10 Mar 2022 19:56:37 -0000
Date:   Thu, 10 Mar 2022 13:56:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: mscc,vsc7514-switch: convert txt
 bindings to yaml
Message-ID: <YipX9dqb75i9g69T@robh.at.kernel.org>
References: <20220304103225.111428-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220304103225.111428-1-clement.leger@bootlin.com>
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

On Fri, 04 Mar 2022 11:32:25 +0100, Clément Léger wrote:
> Convert existing txt bindings to yaml format.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  .../bindings/net/mscc,vsc7514-switch.yaml     | 191 ++++++++++++++++++
>  .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --------
>  2 files changed, 191 insertions(+), 83 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
> 

Applied, thanks!
