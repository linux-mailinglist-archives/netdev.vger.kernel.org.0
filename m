Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9AA4B269F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 14:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350339AbiBKNBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 08:01:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236101AbiBKNBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 08:01:47 -0500
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13F5F05;
        Fri, 11 Feb 2022 05:01:46 -0800 (PST)
Received: by mail-io1-f43.google.com with SMTP id s18so11187423ioa.12;
        Fri, 11 Feb 2022 05:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F/lpDU7A/oXQnioj6/dyXZqqVsCqJXhM5thA6Dejkuc=;
        b=Vw3EfskG9OovUvCVaQnLI1Y42MeiRIiXvYeRBcJI5lPRH/bQkVuIuueTna5qSr3ZyI
         pMMV8D0R6OKSCIhX8qwIhxwYPO0szRwAWjnI5KK8A13hsz4BkGbvYcQb9DFcXZAGLV6p
         cchQHIMOPbmAiwyL09BMYXqHeMqFaUWjyxCN8l/zDY6MBUffzJiLeXmF6dDehtgYCytq
         iCk30oF6usOzWFfvBO4oSjs2MhJTKT8WDqLXHahOWNaVbtrMW5GrbAiVS/DQtj4mXf2J
         XfBGUVpPDMxUlsm3ZsEqsht9txOw8Kem2KXkc60Bt6ARTKGBOFthfaVd1SZw4HP0dfb9
         vi+A==
X-Gm-Message-State: AOAM530b78HJ4bvHy9Sid83g+wTby0Im3k8df5pHJYX9Cpgho+ylsmu2
        UNu6U+e8SXoKCOrBrhctKc2rVzlQBg==
X-Google-Smtp-Source: ABdhPJyCsJeoYeMmw5Xm+zi2G97lQ332DHNyc8xG7IhXT7F4vvP93P8LoX/BbSHuiGqUmWKMNyLlsg==
X-Received: by 2002:a6b:4e18:: with SMTP id c24mr783163iob.179.1644584505910;
        Fri, 11 Feb 2022 05:01:45 -0800 (PST)
Received: from robh.at.kernel.org ([172.58.139.71])
        by smtp.gmail.com with ESMTPSA id x10sm4250461ill.60.2022.02.11.05.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 05:01:45 -0800 (PST)
Received: (nullmailer pid 216466 invoked by uid 1000);
        Fri, 11 Feb 2022 13:01:42 -0000
Date:   Fri, 11 Feb 2022 07:01:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Michael Walle <michael@walle.cc>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] dt-bindings: mfd: add "fsl,ls1028a-qds-qixis-i2c"
 compatible to sl28cpld
Message-ID: <YgZeNqAbdisyeT+s@robh.at.kernel.org>
References: <20220127172105.4085950-1-vladimir.oltean@nxp.com>
 <20220127172105.4085950-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127172105.4085950-3-vladimir.oltean@nxp.com>
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

On Thu, Jan 27, 2022 at 07:21:04PM +0200, Vladimir Oltean wrote:
> The LS1028A-QDS QIXIS FPGA has no problem working with the
> simple-mfd-i2c.c driver, so extend the list of compatible strings to
> include that part.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> index eb3b43547cb6..8c1216eb36ee 100644
> --- a/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> +++ b/Documentation/devicetree/bindings/mfd/kontron,sl28cpld.yaml
> @@ -16,7 +16,9 @@ description: |
>  
>  properties:
>    compatible:
> -    const: kontron,sl28cpld
> +    enum:
> +      - fsl,ls1028a-qds-qixis-i2c
> +      - kontron,sl28cpld

Is there some relationship between these besides happening to use the 
same driver? Sharing a generic driver is not a reason to have the same 
binding doc.

Your DT has a mux-controller which is undocuemnted in this binding.

Rob
