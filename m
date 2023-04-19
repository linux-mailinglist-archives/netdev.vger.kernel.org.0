Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C486E7C48
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232725AbjDSOWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjDSOWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4074D10E4;
        Wed, 19 Apr 2023 07:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C866B634D7;
        Wed, 19 Apr 2023 14:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6BDC433EF;
        Wed, 19 Apr 2023 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681914117;
        bh=nIxVJXKZO4/TDitsa4jzrFVfLDv159DQSkCKOdIpB0c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pCWFjT8w1e1FtVFS79reBADBdHc9lJs9/7ePM9XCRlBEJ8xI0cUVFiw4OGF7L334i
         6B+rhR7xPVVqVhBWzccI/LoGk6B3tKjJVtM8hwfGymlWPUmps4WTzBDEwAJlEMI/tM
         8U/uz9E5sCP09PVSTfBBIIip0iJmAC8wyyJL65JIRKpU5FAOUv82IsdMyUGGvFA5Xl
         NMGsR8TDFwK6g4/JvkzxKJNcefX/WE6HorpFh/HJFA8oYpOQ7hgPhS4X5q5yi/AQZS
         e936xu5m2OMXKvIguqkcV8WUi5asmWLLsZ5h++elxO+wS7/iZOzZOlU8eVIbU9MguJ
         TNOZxECqUKwzA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] dt-bindings: net: Convert ATH10K to YAML
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
References: <20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org>
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
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168191411174.18451.3212029330615566766.kvalo@kernel.org>
Date:   Wed, 19 Apr 2023 14:21:53 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Konrad Dybcio <konrad.dybcio@linaro.org> wrote:

> Convert the ath10k bindings to YAML.
> 
> Dropped properties that are absent at the current state of mainline:
> - qcom,msi_addr
> - qcom,msi_base
> 
> Somewhat based on the ath11k bindings.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

ed09c61eb19d dt-bindings: net: Convert ath10k to YAML

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230406-topic-ath10k_bindings-v4-1-9f67a6bb0d56@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

