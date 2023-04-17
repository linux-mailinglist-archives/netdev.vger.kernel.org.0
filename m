Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15A06E44F4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjDQKQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbjDQKQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:16:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C7140EC;
        Mon, 17 Apr 2023 03:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFB862196;
        Mon, 17 Apr 2023 10:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC68C433D2;
        Mon, 17 Apr 2023 10:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681726366;
        bh=GRAa2RVEdoP6sWFZTaUzor42MJUN7cAoBncwKS2n97w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=tUaLe0MUroPoDEhW71YLn96ifF/ylQ2u0qpI06Wi+jenuZJ1Yu39UVc/9jX0B3pk/
         bWnIC3Tlu3aRcrLzxjRcxVB0CXYgPUHh1c3tKwfPBHFXirI5lH7E5PVL6bLQs0uP6d
         bTMvxjN/ikO0GS6PP59POWkGeyEkja8rmfTnG46HIk6Ri3JNAOevyl/59C9RfgeQGg
         FR3zJ1e5M89rXAoD3wf5Y3tsdTNRI6mW/d+aSvpvvJHTfw6j+hmbOQD8ibVJ9kfOKC
         OskbZ+jaXv5z5J8qurxK/M9V480VClSYqj3x9ODtaKYCHrnEtRX35sElQa4Zr0qjk1
         iao4t/5D/nOkg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: Convert ATH10K to YAML
References: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
Date:   Mon, 17 Apr 2023 13:12:39 +0300
In-Reply-To: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
        (Konrad Dybcio's message of "Tue, 11 Apr 2023 20:19:22 +0200")
Message-ID: <87pm82x1ew.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> writes:

> Convert the ATH10K bindings to YAML.
>
> Dropped properties that are absent at the current state of mainline:
> - qcom,msi_addr
> - qcom,msi_base

Very good, thanks. Clearly I had missed that those were unused during
the review.

> qcom,coexist-support and qcom,coexist-gpio-pin do very little and should
> be reconsidered on the driver side, especially the latter one.

I'm curious, what do you mean very little? We set ath10k firmware
parameters based on these coex properties. How would you propose to
handle these?

> Somewhat based on the ath11k bindings.
>
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>

[...]

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
> @@ -0,0 +1,358 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/qcom,ath10k.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies ATH10K wireless devices

[...]

> +  wifi-firmware:
> +    type: object
> +    additionalProperties: false
> +    description: |
> +      The ATH10K Wi-Fi node can contain one optional firmware subnode.
> +      Firmware subnode is needed when the platform does not have Trustzone.

Is there a reason why you write ath10k in upper case? There are two case
of that in the yaml file. We usually write it in lower case, can I
change to that?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
