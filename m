Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC536D9744
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 14:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237129AbjDFMsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 08:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238194AbjDFMr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 08:47:58 -0400
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEACC7EFE;
        Thu,  6 Apr 2023 05:47:49 -0700 (PDT)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-17e140619fdso42161610fac.11;
        Thu, 06 Apr 2023 05:47:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680785269;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BszaOi3VfoZ90tN4391m9kropE1X/xTMd1Swvq/J1lE=;
        b=xN87WZagLV+rZZufG5+T8o3kspPP/La8Qxywr9WmRuQT8MKXnVtYe35JEhh4xmG3Zd
         7RFJFmkzRtCBnEEdZnacpZt8FGSITVGRvgroApa794CuuEWt5/DbrXhy3j5FLUdRL3Gh
         sDWb8EiZLPULSn3RQvGWJzjXvinwccNbhbiPTpWfJMiJaL7oVQG4I2jmmhkXbAxqSkhl
         nG9yMHcoKn+tmNfOIJHd3BrJI4d0qaccVKGXjEOH3nP0dTfRU7DmQb/ng0bqwsSjboE9
         EMT6pFxazhdxic6IKV96Ofe3znmc3YmPCdrfydfnjUvr3i9174kcSHLZqB9McY8Px9JR
         asdw==
X-Gm-Message-State: AAQBX9fKuFr+wAZ4CYDaABb42jguzNgbzNt8q5t2wnMCj2FBsjJKCaV2
        +KVxwmLiULkaSp6Hmmn26w==
X-Google-Smtp-Source: AKy350aHfgyvOlHaaUubqc72VI2bWEQERiHZhcTbdnBBZy5poL7MEMeWIJ+CFh5x5h3r+lFMOjwhQQ==
X-Received: by 2002:a05:6870:9615:b0:180:3fcf:9bb6 with SMTP id d21-20020a056870961500b001803fcf9bb6mr5498408oaq.26.1680785269237;
        Thu, 06 Apr 2023 05:47:49 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f7-20020a9d6c07000000b006a205a8d5bdsm651090otq.45.2023.04.06.05.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 05:47:48 -0700 (PDT)
Received: (nullmailer pid 2742580 invoked by uid 1000);
        Thu, 06 Apr 2023 12:47:48 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>, linux-wireless@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Kalle Valo <kvalo@kernel.org>, Andy Gross <agross@kernel.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ath10k@lists.infradead.org
In-Reply-To: <20230406-topic-ath10k_bindings-v2-1-557f884a65d1@linaro.org>
References: <20230406-topic-ath10k_bindings-v2-0-557f884a65d1@linaro.org>
 <20230406-topic-ath10k_bindings-v2-1-557f884a65d1@linaro.org>
Message-Id: <168078494959.2736424.13312532374051031538.robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Convert ATH10K to YAML
Date:   Thu, 06 Apr 2023 07:47:48 -0500
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 06 Apr 2023 13:54:04 +0200, Konrad Dybcio wrote:
> Convert the ATH10K bindings to YAML.
> 
> Dropped properties that are absent at the current state of mainline:
> - qcom,msi_addr
> - qcom,msi_base
> 
> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
> be reconsidered on the driver side, especially the latter one.
> 
> Somewhat based on the ath11k bindings.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          | 215 ------------
>  .../bindings/net/wireless/qcom,ath10k.yaml         | 359 +++++++++++++++++++++
>  2 files changed, 359 insertions(+), 215 deletions(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.example.dtb: wifi@18800000: wifi-firmware: 'wifi-firmware' does not match any of the regexes: 'pinctrl-[0-9]+'
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.example.dtb: wifi@18800000: wifi-firmware: 'iommus' is a required property
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml

doc reference errors (make refcheckdocs):
MAINTAINERS: Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230406-topic-ath10k_bindings-v2-1-557f884a65d1@linaro.org

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

