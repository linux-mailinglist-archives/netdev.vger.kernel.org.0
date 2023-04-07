Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC3F6DB2E3
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 20:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjDGSeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 14:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjDGSeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 14:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E21A279;
        Fri,  7 Apr 2023 11:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F9F66531D;
        Fri,  7 Apr 2023 18:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D14C433D2;
        Fri,  7 Apr 2023 18:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680892441;
        bh=hfcFjImYkaoNK57mAMP077eellND4IKRA635mra2rE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OZJcgklmTtlVvE5nhA3PKL4+tVnFI7COhkarip5Hrg5yjnjMg0+svTfWGpf9XolRc
         G2fVjLxXihgg0xYu1STx8JkuXSdAm2pFEx5/h7izadsOA9IMpwZPoab4ueJyeGDeud
         b9ngJL86HhCA9rR3pw1LzanUp8j+f/V0Qc8Ix+JMIvBiwiSJZVlf/LsbCeD176bvpl
         xvgh6JhvaALvy9hSYdedIEY2H35Qui9k3CHA4IttHJwojY2Zbiv6xBXeK9yx3QpHwN
         4mVhtnRmiqAdorgsdmhcgmGDxokOQDWW5yhc11ZjRFV2CWEtc30sh1ELxjvwx1MGy5
         drK+a1Jwet56Q==
From:   Bjorn Andersson <andersson@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Andy Gross <agross@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     ath10k@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: (subset) [PATCH v3 0/2] ATH10K YAML conversion
Date:   Fri,  7 Apr 2023 11:36:46 -0700
Message-Id: <168089260339.2666024.1798307335025317148.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
References: <20230406-topic-ath10k_bindings-v3-0-00895afc7764@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Apr 2023 14:55:43 +0200, Konrad Dybcio wrote:
> v2 -> v3:
> - Ran dt_binding_check explicitly to uncover an issue with the
>   example - I had 2 levels of wifi-firmware{}.. Fixed that..
> 
> I hope you folks don't mind me resending so quickly, but it was a
> trivial issue. Patch 2 unchanged.
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: qcom: sdm845-polaris: Drop inexistent properties
      commit: fbc3a1df2866608ca43e7e6d602f66208a5afd88

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
