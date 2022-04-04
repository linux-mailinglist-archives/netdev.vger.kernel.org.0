Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F88A4F1FFC
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 01:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237551AbiDDXK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 19:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242840AbiDDXJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 19:09:58 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE806E01A;
        Mon,  4 Apr 2022 15:45:48 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-d39f741ba0so12460134fac.13;
        Mon, 04 Apr 2022 15:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vno8+PfEL3kUsJ7oNBHQjjCgNlx0nOd+QsMhMTC0oYA=;
        b=t4QijxGmuSYAxPET4O3rUnfwkhY6UgOnossRHszboSdx3FT8AXfKdwqSsfplB0CNU1
         yvfome2+Hnmb/KTauguJoBHvQ4bkXWVYJkFOpPHKflLHIr1Arlv66YWOuS7QD+CRVR6I
         MF7I0uETU/mN6AqsAypyl5Mjxj8AiOi7EM8kp7OEqB/tOUHnYigeGorgqJz3bxrrGT26
         viuZjeaTwqFMixh/6wWiPoLVegRWpg4VGIoNypAWWrgw0br4ceqt+4EuedeW7mSO//dx
         7iG1hxmV2ORCgFy4xFoGgMXHWEhEwfW1VxLc4Wwam0KtJ3CPlzvDLMiOaK9c0Q5zXdho
         MAxw==
X-Gm-Message-State: AOAM532PlFyV7SwZGp07RevTa5Ct9B4lOlsngDCdJZ08+1lslh26utU3
        HzkUhFfi2QarYzuewetkoA==
X-Google-Smtp-Source: ABdhPJzuvODzgaY5109s85DqZS7pLQXJW+7oDxVfM97jS08vwaULAXug/WmXiKd82qCCYEl9zqXUBA==
X-Received: by 2002:a05:6870:5390:b0:de:f680:db03 with SMTP id h16-20020a056870539000b000def680db03mr231595oan.237.1649112348097;
        Mon, 04 Apr 2022 15:45:48 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k4-20020a9d4b84000000b005b2310ebdffsm5174759otf.54.2022.04.04.15.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 15:45:47 -0700 (PDT)
Received: (nullmailer pid 2143502 invoked by uid 1000);
        Mon, 04 Apr 2022 22:45:46 -0000
Date:   Mon, 4 Apr 2022 17:45:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     devicetree@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: mailbox: qcom-ipcc: simplify the example
Message-ID: <Ykt1GiGdV9HAfQxt@robh.at.kernel.org>
References: <20220402155551.16509-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220402155551.16509-1-krzysztof.kozlowski@linaro.org>
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

On Sat, 02 Apr 2022 17:55:50 +0200, Krzysztof Kozlowski wrote:
> Consumer examples in the bindings of resource providers are trivial,
> useless and duplicating code.  Additionally the incomplete qcom,smp2p
> example triggers DT schema warnings.
> 
> Cleanup the example by removing the consumer part and fixing the
> indentation to DT schema convention.
> 
> Reported-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/mailbox/qcom-ipcc.yaml           | 29 +++++++------------
>  1 file changed, 10 insertions(+), 19 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
