Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633ED657229
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbiL1Clq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 21:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiL1Clp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 21:41:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366B8D2C3;
        Tue, 27 Dec 2022 18:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4E21612B7;
        Wed, 28 Dec 2022 02:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3BBC4339C;
        Wed, 28 Dec 2022 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672195303;
        bh=QnklbxEBG3COVRxv2QVCvdpAZpImQ2YsUCTp8vPcCbo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=DMU43Zs4PPqKU0/VYQXRJ7AcV3Z89R6H7NK72HAwb1eZwS3LmBMqOIDWrLxXldigr
         dRvMcZ26hri9kL2QN1FAvrT+BM5nb0EhPoYYCG8heyawsCdat1MzzxJ53ynt7D9HAm
         y43VEFRvEzowgVSHfyyC060E6FNeyuNo44Cq/c01my+/c5DflL8DfzLi/D/43ZwXiW
         ntxbXSPWfM4zIghmEBgyaxtH+WylqrqZzNvP96CQKEyQS++vcr2J3V+GFS1di7t/FY
         yb6a/7C+VVQEGwNnSpffyQILr+kU0uJGetdtClgdorVTkp66aJuLZ0zYcctURe9zz9
         hi7fRGLac+LCA==
From:   Bjorn Andersson <andersson@kernel.org>
To:     linux-kernel@vger.kernel.org, robimarko@gmail.com,
        pabeni@redhat.com, davem@davemloft.net, agross@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@linaro.org,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, edumazet@google.com
Subject: Re: (subset) [PATCH v2 1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018 compatible
Date:   Tue, 27 Dec 2022 20:41:36 -0600
Message-Id: <167219529289.794508.54060153961953073.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
References: <20221114194734.3287854-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 20:47:30 +0100, Robert Marko wrote:
> Document IPQ6018 compatible that is already being used in the DTS along
> with the fallback IPQ4019 compatible as driver itself only gets probed
> on IPQ4019 and IPQ5018 compatibles.
> 
> This is also required in order to specify which platform require clock to
> be defined and validate it in schema.
> 
> [...]

Applied, thanks!

[5/5] arm64: dts: qcom: ipq8074: add SoC specific compatible to MDIO
      commit: 36e830a5656d6c22110c5dcffb611fc69a57a269

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
