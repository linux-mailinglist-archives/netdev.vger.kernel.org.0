Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D114CE13C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiCDX4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCDX4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:56:18 -0500
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807691E2FED;
        Fri,  4 Mar 2022 15:55:29 -0800 (PST)
Received: by mail-oo1-f46.google.com with SMTP id s203-20020a4a3bd4000000b003191c2dcbe8so11213946oos.9;
        Fri, 04 Mar 2022 15:55:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tSliGbcTSyYzBFVpCZN6O+4ZDMOchGSsN4LqAQ8U/xg=;
        b=ECXVwP0y6CsC4ai6utWIYTngpLPMIrUBejiPNDc9mwES0hUGfnXuJFKjYETI72yhN5
         YzeIdYT83oDEEAlYoTC7GhQCTeLRN4/JiU3Z7j6I249YWTi4UCO1LGNl9m71hgzmOG5Y
         X6H0VM+DqrAYajodGYUxuHEeE2swESwvna0W6a8Zc4JhB6Yodj7S7UTe0gcItSIOw8rv
         NFEAOextzbnT6rcf8+2xrXizDHeRe4TTQ/a1BmWfvI09a0qKH4cUXj2xfotgjhW2ARoG
         HF9BuYP0NrXajnYtm5AGGadrXLeWlBcD9xpJSqtQjaIYdPJUTwTNg2Qevm/e+6s7z2VN
         YiQQ==
X-Gm-Message-State: AOAM532x549IBAq7q9BVmywG5jmvwriu2NdXQTAyjNjp5RM6oCwX2ZhQ
        JltDIAHGuyZvrdZv+JrJMw==
X-Google-Smtp-Source: ABdhPJwDll/7f5d8b0aYbIcWJFfsE9cWCdTQ2AfJhNqsJJJ6cfkTOdTcRm+Nvt4ZnlHXMIazqE4Vmg==
X-Received: by 2002:a05:6870:ac21:b0:da:b3f:2b63 with SMTP id kw33-20020a056870ac2100b000da0b3f2b63mr906904oab.258.1646438128840;
        Fri, 04 Mar 2022 15:55:28 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id u9-20020a4ab5c9000000b003182df292f7sm2802929ooo.18.2022.03.04.15.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 15:55:28 -0800 (PST)
Received: (nullmailer pid 715300 invoked by uid 1000);
        Fri, 04 Mar 2022 23:55:27 -0000
Date:   Fri, 4 Mar 2022 17:55:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: ipq4019-mdio: Add ipq6018
 compatible
Message-ID: <YiKm76II+51YXXAn@robh.at.kernel.org>
References: <8de887697c90cd432b7ab5fe0d833c87fc17f0f1.1646031524.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8de887697c90cd432b7ab5fe0d833c87fc17f0f1.1646031524.git.baruch@tkos.co.il>
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

On Mon, 28 Feb 2022 08:58:43 +0200, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> The IPQ60xx MDIO bus is the same as IPQ4019.
> 
> Update the schema to allow qcom,ipq4019-mdio compatible as fallback for
> newer IPQ series.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
> 
> v3:
> 
>   Correct the schema to fix yamllint failure (Rob's bot)
> 
> v2:
> 
>   Update the schema to allow fallback compatible (Rob Herring)
> ---
>  .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml     | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
