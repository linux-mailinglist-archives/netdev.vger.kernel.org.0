Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D9F6C4294
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCVGBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCVGBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:01:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAB48E;
        Tue, 21 Mar 2023 23:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC541B818F9;
        Wed, 22 Mar 2023 06:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252D3C433EF;
        Wed, 22 Mar 2023 06:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679464884;
        bh=1PbyDiNq8356uMQ5xQE1fOosfBkAfAEvSTW5NauMxn4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eU+ekPV/0cRUqXSCl04ridhv/zFZBa8VVqZPGcqSJFmyU2os/k/Q/2TmTyKUZfQuu
         C4ME/Gg22YwxeW8wk5yUbdggz/hhSGh/GPqCfPmkdCaIqBh29gA/luSpvIoHY8JXfj
         Dpt0xTWy97pD0Ezk60NcbhmaN2NyEIgvCmm4QS1hRuEImsceCuCQmiuWUQ7rtCa78i
         p2Cu35l6X9sBIMyTPryhpvpqIAthWEEaiG2UiFXK5RzQVMQYfrTqUaZ/D3DfQzNggT
         VKS1c1qOmXioJ1vbVZqFkv8DQSJOFHsevZ/rjGj7+Cv+fbUH3VO4fq3tHwK/uMu3UG
         BlKJFkrKvSCbQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: wireless: add ath11k pcie bindings
References: <20230321094011.9759-1-johan+linaro@kernel.org>
        <20230321094011.9759-2-johan+linaro@kernel.org>
Date:   Wed, 22 Mar 2023 08:01:18 +0200
In-Reply-To: <20230321094011.9759-2-johan+linaro@kernel.org> (Johan Hovold's
        message of "Tue, 21 Mar 2023 10:40:10 +0100")
Message-ID: <87mt45e34h.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan+linaro@kernel.org> writes:

> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6855
> for which the calibration data variant may need to be described.
>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  .../net/wireless/qcom,ath11k-pci.yaml         | 58 +++++++++++++++++++

I talked with Bjorn, our plan is that I take patch 1 to ath-next and he
takes patch 2. I just rename this patch to:

dt-bindings: net: wireless: add ath11k pcie bindings

Everyone ok with the plan?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
