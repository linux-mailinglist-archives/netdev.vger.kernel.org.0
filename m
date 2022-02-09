Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4414AE800
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244990AbiBIEHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 23:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347361AbiBIDny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:43:54 -0500
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632E0C0401C0;
        Tue,  8 Feb 2022 19:34:03 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id t199so1198072oie.10;
        Tue, 08 Feb 2022 19:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WAlxN8bgtyXgcYHA0KP+K5lEbx7cfGwSBqWcp3rk/io=;
        b=GI0UaHL2oOmHj+HzC2uvBS50HiVKqTfCvrgiIOMaUKFXKzNCnC5U8QknzgV659OKwg
         PYUGuTTDYODGNooElvN5GtxDm9nYUUuah9f9svS6L7j661KaXimOOaTpvgK72LuVA1Ep
         ACQoCnhuLwNNaas6f6r2pIHtdpvs5S8lE1gNnOSASpltdn3hX+UHmtrKyRmajtSpaPBw
         UN6iJ5/SruLTCjSVSlZD48nIfOhScYLKLrAQI2L0k0MluBhzwhPZm4uO/fWFgTc+xnW2
         3UKUyrZMq2vFZu1f4RtP2KVTtAzxJ8CzgPRjbGwKccsEgUW1/YPAnJFE2yCoUoCMJb4i
         1sIg==
X-Gm-Message-State: AOAM531Z1Kh2ZsFYa4K43SnX1UamqjXbtAznHKtx7UQnTgE9Pa6z51J7
        /ZTgG1jU68uELS0EE4GyWg==
X-Google-Smtp-Source: ABdhPJxEz3ptZ7VgzPkwMka157fr3gyleGSPsZ0XvNL3UkGAdZZgyX9IYK+UR8roZHlem1JQSR50OA==
X-Received: by 2002:a05:6808:30a3:: with SMTP id bl35mr492059oib.226.1644377642643;
        Tue, 08 Feb 2022 19:34:02 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id a15sm6348800oil.13.2022.02.08.19.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 19:34:01 -0800 (PST)
Received: (nullmailer pid 3588896 invoked by uid 1000);
        Wed, 09 Feb 2022 03:34:00 -0000
Date:   Tue, 8 Feb 2022 21:34:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     sboyd@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        bjorn.andersson@linaro.org, Vinod Koul <vkoul@kernel.org>,
        netdev@vger.kernel.org, mturquette@baylibre.com,
        bhupesh.linux@gmail.com, tdas@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org
Subject: Re: [PATCH 1/8] dt-bindings: net: qcom,ethqos: Document SM8150 SoC
 compatible
Message-ID: <YgM2KDD/oxxC+UKH@robh.at.kernel.org>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
 <20220126221725.710167-2-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126221725.710167-2-bhupesh.sharma@linaro.org>
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

On Thu, 27 Jan 2022 03:47:18 +0530, Bhupesh Sharma wrote:
> From: Vinod Koul <vkoul@kernel.org>
> 
> SM8150 has a ethernet controller and needs a different configuration so
> add a new compatible for this
> 
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ethqos.txt | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
