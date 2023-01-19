Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE80672ECA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 03:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjASCRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 21:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjASCRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 21:17:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F6E4F84E;
        Wed, 18 Jan 2023 18:17:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C799261A44;
        Thu, 19 Jan 2023 02:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4147DC433F0;
        Thu, 19 Jan 2023 02:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674094622;
        bh=glQ/PgA9zqubv53qFNmO39tcObD/Y/tqOtXqfhFISGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHGfxwtwyoMqiGJP1t08sRkhLRcmFRrwBW53xGAFp09CffxK20ryzr1zyj7bwTUoH
         WdCttEYfxjYOtBXMlHsVaTKz4GdLO5SoILqAa6XoJ0zXT73Jpgo/MD5oA7exDVra66
         Qm0zdDhYKpB2XJ+HAwBStnvdeA0N3KtG3mFaDC7LDQxK/rkGgmf3EelB6l/+8BDDDB
         6RhZ3I4thQyjwKPDKy/w7Sy44SsOFBYDLHT4bmFXZ7QScXrjQqmzMQ9XM07Pbw5uKL
         7EVOhmDoJjxrY6gIuX30spTzaKBF21pLLOdmyLJkPet5tCOwfBMOwMWbZpznxsP/k+
         D4tMo2mjjROnQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Andy Gross <agross@kernel.org>, linus.walleij@linaro.org,
        will@kernel.org, mani@kernel.org, brgl@bgdev.pl,
        richardcochran@gmail.com, srinivas.kandagatla@linaro.org,
        djakov@kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>, konrad.dybcio@linaro.org,
        catalin.marinas@arm.com,
        Michael Turquette <mturquette@baylibre.com>,
        robin.murphy@arm.com, jassisinghbrar@gmail.com, elder@kernel.org,
        vkoul@kernel.org, joro@8bytes.org, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, bartosz.golaszewski@linaro.org,
        iommu@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Date:   Wed, 18 Jan 2023 20:16:51 -0600
Message-Id: <167409461447.3017003.14729424591106979402.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230109174511.1740856-1-brgl@bgdev.pl>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
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

On Mon, 9 Jan 2023 18:44:53 +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> This adds basic support for the Qualcomm sa8775p platform and its reference
> board: sa8775p-ride. The dtsi contains basic SoC description required for
> a simple boot-to-shell. The dts enables boot-to-shell with UART on the
> sa8775p-ride board. There are three new drivers required to boot the board:
> pinctrl, interconnect and GCC clock. Other patches contain various tweaks
> to existing code. More support is coming up.
> 
> [...]

Applied, thanks!

[03/18] arm64: defconfig: enable the clock driver for Qualcomm SA8775P platforms
        commit: 1a87f7e5fa10b23633da03aed6b7c7e716457304

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
