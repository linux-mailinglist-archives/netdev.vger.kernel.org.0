Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0804F1FF7
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234507AbiDDXLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242878AbiDDXKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:10:00 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A000F10FD4;
        Mon,  4 Apr 2022 15:45:54 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-d39f741ba0so12460340fac.13;
        Mon, 04 Apr 2022 15:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WRM9WzB5Qz/K6aETNGyEI4dOK6iqW4l8bvHxC450j9Q=;
        b=1E1bzpo6wmOpNppuvvD+iAYDAhdWIZoD0Rgv5PP/YZXCmcYcg/IjAb9NHZj0ZuiHTn
         GI7tiJa+yaD1qi0bNLBeVjUiYc33e8Evu67oFqv2akB0Q99nhoJidWyqlyRAJFnRrEH7
         /Nl1Q1uRjpaPypz6YPIHXa/XhCObH65KuLAvpDyJmdsQN43EbH9xmC+5KD1nj+z06/hE
         l/wn33HH0unV2dWZEcUDhRDYkTsYIdKpvEumOt5zamHjMcrtXjBgPZoE8OsqX8RGGahU
         SOSc7FvD/2drPTnUshNJ5GQvyp7lfujTUHHAR57ycMyAwhEIxTHM64DCmIexU+tCN9R+
         IdYg==
X-Gm-Message-State: AOAM530vmpddR7oM0S4A8BOTSN3Ve3fTUrdZODPUMY64SYQKv0Z8UVyR
        dHssUTSwb1/0N1RFSGo3MQ==
X-Google-Smtp-Source: ABdhPJyy1avjwHAHjLhqQGywAap8haKayzoOtloxVtYd8OqawU5I4S9geqI6mUPzZDscxTQgxtNLTg==
X-Received: by 2002:a05:6871:822:b0:e2:10ff:b84e with SMTP id q34-20020a056871082200b000e210ffb84emr245837oap.103.1649112353731;
        Mon, 04 Apr 2022 15:45:53 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p1-20020a05683003c100b005c927b6e645sm5115082otc.20.2022.04.04.15.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 15:45:53 -0700 (PDT)
Received: (nullmailer pid 2143767 invoked by uid 1000);
        Mon, 04 Apr 2022 22:45:52 -0000
Date:   Mon, 4 Apr 2022 17:45:52 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Elder <elder@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH 2/2] dt-bindings: net: qcom,ipa: finish the qcom,smp2p
 example
Message-ID: <Ykt1IPcba+z1oX74@robh.at.kernel.org>
References: <20220402155551.16509-1-krzysztof.kozlowski@linaro.org>
 <20220402155551.16509-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402155551.16509-2-krzysztof.kozlowski@linaro.org>
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

On Sat, 02 Apr 2022 17:55:51 +0200, Krzysztof Kozlowski wrote:
> The example using qcom,smp2p should have all necessary properties, to
> avoid DT schema validation warnings.
> 
> Reported-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
