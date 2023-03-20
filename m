Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7C6C0FBD
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCTKwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCTKwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:52:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDD312070;
        Mon, 20 Mar 2023 03:49:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFA9961444;
        Mon, 20 Mar 2023 10:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F1AC433EF;
        Mon, 20 Mar 2023 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679309288;
        bh=H362FRaRLTPpqbrdTPkO0txUWwDidvve8th1nvkt7zI=;
        h=From:To:Cc:Subject:Date:From;
        b=I+QRlUmEiDRUtHEY1ZiKIg+xPMvpxGs4m0hits6Hj1zmwHTytcqkabSDMBjiwFS/C
         BqVePcP/xOJeS0+cp4EiVoXAFKDh94FI1IgjjiAdbqiJtPVUgQLpEo4iuM+c6kTLJS
         uBLht59rWc9F3dRttLePDkBHKFLr9k9+9anfk6jfxpkogkGuAmemVcZcQCBlum8Dy+
         ax7sWyxfEkusC9tzx5RoDo0vrdC+bRPsInzw2ndIC/eKxKZbp1FJCBB4fQZIf+ngrh
         6UfbJEHSV9sCkgkuKBm7VA1e97ZZl/ThNWy8B+LporPKQPlI0Vxy9xtlSI1/FhaiN+
         Es0BxAgAbQWUw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peD4y-0005nT-86; Mon, 20 Mar 2023 11:49:28 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 0/3] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
Date:   Mon, 20 Mar 2023 11:46:55 +0100
Message-Id: <20230320104658.22186-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the missing calibration variant devicetree property
which is needed to load the (just released) calibration data and use the
ath11k wifi on the X13s and sc8280xp-crd.

Kalle, do you want to take the binding through your tree or should Bjorn
take it all through the Qualcomm tree?

Johan


Johan Hovold (3):
  dt-bindings: wireless: add ath11k pcie bindings
  arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
  arm64: dts: qcom: sc8280xp-crd: add wifi calibration variant

 .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts     | 17 ++++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 17 ++++++
 3 files changed, 90 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml

-- 
2.39.2

