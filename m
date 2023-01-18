Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB4B672BAE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 23:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjARWud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 17:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjARWuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 17:50:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CEC4A1DD;
        Wed, 18 Jan 2023 14:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E16B61A7E;
        Wed, 18 Jan 2023 22:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697D4C433EF;
        Wed, 18 Jan 2023 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674082230;
        bh=eU3t7E1kJ8bwpugLyTtveqT2XvPWm3uToW/Yr7zPT5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGCr9GKKlPgFFJB/PzSNK6EW5+6KB6O8cjKBZN629EpMNFjTBjJXk43T1mVIhPMBr
         fcPgc0sk155N3Ti4se16sgTVK0I6qSr/qMjrL/vycV8B6WLmi2dhWyVBEqmEhtxt2W
         CaSowfji5+86JTIHecvRi4mYNWvDSSSR5DbbgQ096KIhMbs7SsYljI5FasOcn+QSGR
         InyH9qtmrlANZtuQTzYGXY8yKMYY2u7H6+PRWTmxeduNMQYn669dgZze+XGXBkbw5m
         gsOZY3FnmIdbhVJH5W6l+xF9IJWmdNrlW6mcM75rUE3SrxEx9o1J0jU8tkhVrihSlR
         Iq6J/t6b4noRw==
From:   Bjorn Andersson <andersson@kernel.org>
To:     konrad.dybcio@linaro.org, mturquette@baylibre.com, brgl@bgdev.pl,
        robh+dt@kernel.org, Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        sboyd@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        agross@kernel.org
Cc:     netdev@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bartosz.golaszewski@linaro.org
Subject: Re: [PATCH v2 0/2] qcom: sa8775p: add the GCC clock driver for Qualcomm SA8775P platforms
Date:   Wed, 18 Jan 2023 16:50:20 -0600
Message-Id: <167408222418.2952004.17876946319531324786.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230117180429.305266-1-brgl@bgdev.pl>
References: <20230117180429.305266-1-brgl@bgdev.pl>
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

On Tue, 17 Jan 2023 19:04:27 +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add the DT bindings and driver for the GCC clock on the sa8775p platform
> from Qualcomm.
> 
> v1 -> v2:
> - fix examples in DT bindings and make sure they pass tests
> - use lowercase letters in hex numbers
> - fix the name of DT compatible and headers (gcc-sa8775p -> sa8775p-gcc)
> - fix licensing of DT bindings
> - fix the regmap's max_register property
> - use clk_regmap_phy_mux_ops where applicable
> - other minor tweaks and improvements
> 
> [...]

Applied, thanks!

[1/2] dt-bindings: clock: qcom: document the GCC clock on Qualcomm sa8775p
      commit: 0fff9fa043f972b83935016b0e81d44d9a2229bd
[2/2] clk: qcom: add the GCC driver for sa8775p
      commit: 08c51ceb12f7ce2252513a38ad8a8ed26103a4e2

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
