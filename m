Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920194F200B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242907AbiDDXOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243475AbiDDXLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:11:41 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E412CC82;
        Mon,  4 Apr 2022 15:48:37 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-e1dcc0a327so7943076fac.1;
        Mon, 04 Apr 2022 15:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IDVzKKe8bBDBKudRXLtOu1I28mv+pTyfCDNX1XmjnE0=;
        b=WU4/330iQiE+hoYU0By9iZCjhWdyrqZ/wTphg+h/sMrsJkyMm53VOKL/pIw312EueR
         SkLsYOxnDzX+sF36gvDDcN+pbw25cL31KahzcQ7oPQSNsKFblQxBpr+x8JLKyLr+G9Br
         8V6X5f1purt4FPKrk+DqTN8FZzzMuCSUs9E3VhmdcaO8cp9ocuxAT+wtbk1ViK3tRel9
         eIeXXLcgQ5jtjEqyA9ej/qFd3MTTJzllXh9rK2bmFozwYk+YjKxMOyTCMoPbvp+1oZt3
         KZyDwhgsy3GmNZIu7nv/BaAn3AlA74eg5u9RUCCNkb9rPtJRNSVHtig3Cl6Wr5fo/93V
         Afew==
X-Gm-Message-State: AOAM5311sbroh6+GxWeDEHB8fEY2OMDZ0+EL2ragBwLDXp1MxMY0hMHU
        KnvsC/nEJDtF3cFaSmhRpQ==
X-Google-Smtp-Source: ABdhPJwxFmZcTOz+cwYgRxVxHJoCqnjta6b6GE3N+PBaVi4FAstZEvaVo4pb6JsSjYBxOBeHv9hdKA==
X-Received: by 2002:a05:6870:ec90:b0:de:33ac:8100 with SMTP id eo16-20020a056870ec9000b000de33ac8100mr270569oab.192.1649112516376;
        Mon, 04 Apr 2022 15:48:36 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i28-20020a9d4a9c000000b005ce06a77de2sm5309018otf.48.2022.04.04.15.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 15:48:35 -0700 (PDT)
Received: (nullmailer pid 2148408 invoked by uid 1000);
        Mon, 04 Apr 2022 22:48:34 -0000
Date:   Mon, 4 Apr 2022 17:48:34 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jassi Brar <jassisinghbrar@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH 2/2] dt-bindings: net: qcom,ipa: finish the qcom,smp2p
 example
Message-ID: <Ykt1wm0sfVyEKZiK@robh.at.kernel.org>
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

The netdev folks probably won't pick this up, so applied, thanks!
