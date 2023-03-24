Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1146C8057
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCXOwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjCXOwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:52:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4D2C178;
        Fri, 24 Mar 2023 07:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9481B824C9;
        Fri, 24 Mar 2023 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19939C433D2;
        Fri, 24 Mar 2023 14:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679669529;
        bh=0PpDPmjLSqLkyprFWnCZwIMNanhy8NMfDChEItYUYNA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=kvEY9K6hJSrfGheCe0CCWiJvR7+SACqnTDQvORE8gcs3GXKHKrl8XyQh5xdLsjJGN
         f+RgCo4voThMwXliDU07e4JaZHMnU/A8CXebqL+OYdGaGOthpKlAl8Jjd2fjiSiA5s
         LjNVYwmpsHVbh0RifGqcwtu7N/6FZO1abie/+uGBq4AsHmCBJqympi80JQxxRt1zsG
         WYddlOuILALfgxi3bukwSc8UJxrMQmwr5V9JDVU2YHaZRgKZ+KyBzzk2maiI+l4wUb
         8l9L+PSnRbTvPAdjvn5jwNpzAri92KiyY6B25NGeZ0+VLG/zhWBjvawRHr1iF+R+mv
         qBASAYbByTAFw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] dt-bindings: wireless: add ath11k pcie bindings
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230321094011.9759-2-johan+linaro@kernel.org>
References: <20230321094011.9759-2-johan+linaro@kernel.org>
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
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167966952416.27260.9867436581416631920.kvalo@kernel.org>
Date:   Fri, 24 Mar 2023 14:52:05 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan+linaro@kernel.org> wrote:

> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6855
> for which the calibration data variant may need to be described.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

b6b88111c0db dt-bindings: net: wireless: add ath11k pcie bindings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230321094011.9759-2-johan+linaro@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

