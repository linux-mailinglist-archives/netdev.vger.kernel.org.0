Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB06D732E
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 06:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbjDEEII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 00:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236877AbjDEEHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 00:07:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC705248;
        Tue,  4 Apr 2023 21:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3D6F63978;
        Wed,  5 Apr 2023 04:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D4C433D2;
        Wed,  5 Apr 2023 04:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680667598;
        bh=54g1GZ40q/MOoM4C5tZtiA8bbju9etErocbfMT+yLlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qeeiQlaNghYo7mMO7qSyTuFdJ5T6jq5c7+ppxFgplOAZwu3rSJkApnOPRQpBy6ZBc
         qtbniycGB7tFHT5UVevgrzRX7q2UOY+bS8m9oYy0mwI1nkEfmt/SM7MG3Z2twc+4M/
         OAcK+WKtx5B7n5ABKgjrkT1Cvv1Srt41z5pzeBZl+kE4zbg3QD9+JmN36NFbGXvvWZ
         c98FsKbWnQlcg0YO1YyU1jgB3hqrhcN+ifnBtMDQRrTInW6WVRknuYGAe48LECqmGn
         CcIm4s9MxvWU12sZqZAaNWxKmvSaXhrPmqBYJ6IYYroBOQqt23/1KIbAJolJybHjEP
         eJVtlm6fr2+xQ==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Sven Peter <sven@svenpeter.dev>, linux-arm-msm@vger.kernel.org,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        devicetree@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gross <agross@kernel.org>,
        linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v5 0/4] Add WCN6855 Bluetooth support
Date:   Tue,  4 Apr 2023 21:09:08 -0700
Message-Id: <168066774410.443656.1184532467375073499.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230209020916.6475-1-steev@kali.org>
References: <20230209020916.6475-1-steev@kali.org>
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

On Wed, 8 Feb 2023 20:09:12 -0600, Steev Klimaszewski wrote:
> First things first, I do not have access to the specs nor the schematics, so a
> lot of this was done via guess work, looking at the acpi tables, and looking at
> how a similar device (wcn6750) was added.
> 
> The 5th revision addresses comments from Luiz about the Bluetooth driver, as
> well as Konrad's comments on the dts file.
> 
> [...]

Applied, thanks!

[1/4] dt-bindings: net: Add WCN6855 Bluetooth
      (no commit info)
[2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
      (no commit info)
[3/4] arm64: dts: qcom: sc8280xp: Define uart2
      commit: 9db28f297526f17c6575ec0eefc93a8b1642cff7
[4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
      (no commit info)

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
