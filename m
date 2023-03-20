Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9201A6C11C4
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjCTMWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjCTMWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:22:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB01AF1C;
        Mon, 20 Mar 2023 05:22:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCF2614C3;
        Mon, 20 Mar 2023 12:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1344BC433EF;
        Mon, 20 Mar 2023 12:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679314938;
        bh=BwXhhA8RVno5R/kw9nxTeIoI1aF/85mBNNTYZQlKOc0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cQbrECNrtHCcuIICbrn9aspjtSa9rrbRKQqOFAbKBiSTTKm3QW6NZdN4AXOrGoEku
         A0856EO2bzsR9hiVjy0LVtxFiIifMA2zR0vJwBrejSSn/cyducW6/I0TL+83Cl0K5L
         jusrKOJbfPv3mFAh8dfSvy1pMyRAcRrXjOxhVj2lkDGH12uEowgIW+Z/TsuqCZPDLy
         iY0tdhRv87Hyc+zZJWl8+B69jEP7c3MrppoV6c6PPP17oWs2XH6caobg+Wg+YY1IkQ
         lk9zJAlEEfkIE/gXsr/rQhWlMOVgJs3I+ta8G/fBGB71Ofvy5vhw0IQmBKJrpxuoXQ
         EVmHFigWVlTgQ==
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
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
References: <20230320104658.22186-1-johan+linaro@kernel.org>
        <20230320104658.22186-2-johan+linaro@kernel.org>
Date:   Mon, 20 Mar 2023 14:22:12 +0200
In-Reply-To: <20230320104658.22186-2-johan+linaro@kernel.org> (Johan Hovold's
        message of "Mon, 20 Mar 2023 11:46:56 +0100")
Message-ID: <87ttyfhatn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan+linaro@kernel.org> writes:

> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
> for which the calibration data variant may need to be described.
>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml

I'm confused (as usual), how does this differ from
bindings/net/wireless/qcom,ath11k.yaml? Why we need two .yaml files?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
