Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92F26D7333
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 06:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbjDEEIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 00:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236967AbjDEEHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 00:07:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3D65594;
        Tue,  4 Apr 2023 21:06:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84F71639A7;
        Wed,  5 Apr 2023 04:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74066C433A1;
        Wed,  5 Apr 2023 04:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680667599;
        bh=jT/2zkWq1kpMZM9EJKrwaCUHOri4Z7ZvlFY8/qkgQcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGzkUlJO8R96gOAjDLZquxrmWD3XdcQYdV8JNk55s0K41+5/gGJKRjQOIbkLl12/y
         cGyb6544ImHVgU3mvO/+984ooZNqCII2X5ukz24IYJbDYrl7TT1zCdpfMPhCU8C7QR
         oajq+UuiRTLSdjRDqm/E5p5nhBhTRA4kAuHj49Qg/8jrVv47nQZ03l1f61POnqnW5R
         4z/JjlKCKDYXYDQH4xU8PDx97U1bX87mDTTFw51B7Fbj7l/5Mwa/zuMurKR7Zjrk/d
         9lHeCfPbLFuYrfWFoEj+zVj4J86H26E8LLxOGcK6XTp9sruZY8Yyl27os9FpU+giUl
         Y+UqiFrsh7hag==
From:   Bjorn Andersson <andersson@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Sven Peter <sven@svenpeter.dev>, linux-arm-msm@vger.kernel.org,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan@kernel.org>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: (subset) [PATCH v8 0/4] Add WCN6855 Bluetooth support
Date:   Tue,  4 Apr 2023 21:09:09 -0700
Message-Id: <168066774422.443656.15310898054593060870.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230326233812.28058-1-steev@kali.org>
References: <20230326233812.28058-1-steev@kali.org>
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

On Sun, 26 Mar 2023 18:38:08 -0500, Steev Klimaszewski wrote:
> First things first, I do not have access to the specs nor the schematics, so a
> lot of this was done via guess work, looking at the acpi tables, and looking at
> how a similar device (wcn6750) was added.
> 
> This patchset has 2 patchsets that it depends on, for the bindings so that they
> pass dtbs_check, as well as adding in the needed regulators to make bluetooth
> work.
> 
> [...]

Applied, thanks!

[3/4] arm64: dts: qcom: sc8280xp: Define uart2
      commit: 9db28f297526f17c6575ec0eefc93a8b1642cff7
[4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
      commit: 105560b4fca4df0d42dba6656105b5e4131d8ad3

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
