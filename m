Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE5E6C850D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCXSbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCXSbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F86716AE5;
        Fri, 24 Mar 2023 11:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1DEDB82565;
        Fri, 24 Mar 2023 18:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD02C433A7;
        Fri, 24 Mar 2023 18:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679682688;
        bh=EyfY0rlchlhdbsx6lA17xyjUo29eM3oqgBh+IZ8tAk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyNQ3xpqWyFxqVmTf/X/1Q/x9pbfYQs36lb0l2P4yIqamq5FeV3aUI02SKz+cmZcE
         fsdu8Cs2XEqDzMM9otoTQqpbGlUr6cNRHoLkMNTLHORkROY51/53c3hbAxyi/lMPWm
         E/6TRP3ONxbBX3aYWMSOKLc6NIbGnxwDe5HrIEcKJP3F+XKWqXd+iVmxbjbnXhE2xF
         T8vWKUSidnjcCKkrSVYvIIHIen5XB4mBz8zPu6CaFCBa/aUGs4Tdwpx9p8WZ7e6lXs
         7ih0Lj/Yjp4DFG4b6QO8n5H2sjSpx2MwwMGdHJGhd3AwXet88kDp6tb4N/dR0XxZih
         HD1f8GqiCL2tg==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath11k@lists.infradead.org, Steev Klimaszewski <steev@kali.org>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, Andy Gross <agross@kernel.org>
Subject: Re: (subset) [PATCH v2 0/2] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
Date:   Fri, 24 Mar 2023 11:34:28 -0700
Message-Id: <167968287203.2233401.18027204097957860016.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321094011.9759-1-johan+linaro@kernel.org>
References: <20230321094011.9759-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 10:40:09 +0100, Johan Hovold wrote:
> This series adds the missing calibration variant devicetree property
> which is needed to load the (just released) calibration data and use the
> ath11k wifi on the Lenovo Thinkpad X13s.
> 
> Kalle, can you take the binding through your tree and then Bjorn can
> take the devicetree update through the qcom tree?
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
      commit: 2702f54f400ad3979632cdb76553772414f4c5e3

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
