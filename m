Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC833664738
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjAJRRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjAJRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:17:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE081CB3B;
        Tue, 10 Jan 2023 09:17:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB02C61827;
        Tue, 10 Jan 2023 17:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39245C433F0;
        Tue, 10 Jan 2023 17:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673371048;
        bh=+miFXvh4SnQnHEBkU9GY4B1xU7pBks44PiSq7mNwM88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=stVnQ1xn6jbJeCNAHI9X8Ait4EzyypqGiGhFm8ycTchPMCGI3MOrdFEuj7RmaXdad
         Ng8lXtliYIInwxiWglNRZ5cms1Rg86tDE3t7yB7T3q3Z8mo/QQHb+g71dZ9E3zUhS6
         rTepwI1QCmkyJMiWooFkR7/tlvq9DtQPS43p7kZa8lWn4pVJX3mR5UtnJC9fnyzT83
         Wm+aWD8WijBtWQvoOHhmTOt2jWljdOParQ6h5ArnHrCy30mB2CsWnQOwnTYOTRCo12
         p3FNi98DAcMs7TcTlOh8WRft4JNu+Hedz3Z9UAlycEBv+VQZ8M0yZcs+ngkmEqzL80
         aKhXdceXi+tFg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     robh+dt@kernel.org, sboyd@kernel.org, djakov@kernel.org,
        mturquette@baylibre.com, richardcochran@gmail.com,
        agross@kernel.org, linus.walleij@linaro.org,
        jassisinghbrar@gmail.com, will@kernel.org, elder@kernel.org,
        brgl@bgdev.pl, srinivas.kandagatla@linaro.org,
        robin.murphy@arm.com, krzysztof.kozlowski+dt@linaro.org,
        catalin.marinas@arm.com, joro@8bytes.org, vkoul@kernel.org,
        mani@kernel.org, konrad.dybcio@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        bartosz.golaszewski@linaro.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        iommu@lists.linux.dev, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: (subset) [PATCH 00/18] arm64: qcom: add support for sa8775p-ride
Date:   Tue, 10 Jan 2023 11:17:23 -0600
Message-Id: <167337103771.2139708.6906663825110688484.b4-ty@kernel.org>
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

[13/18] dt-bindings: power: qcom,rpmpd: document sa8775p
        commit: b4f0370d3ce276397f5c48af99d0b77548825eb1
[14/18] soc: qcom: rmphpd: add power domains for sa8775p
        commit: 91e910adc59a6954e475dd2d6a4534ac56dd8eed

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
