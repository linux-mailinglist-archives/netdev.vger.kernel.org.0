Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A326572C1
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 05:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiL1Ehv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 23:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiL1Eh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 23:37:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AF9E0D5;
        Tue, 27 Dec 2022 20:37:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37061612FD;
        Wed, 28 Dec 2022 04:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD325C433D2;
        Wed, 28 Dec 2022 04:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672202236;
        bh=U5ZIBD2RxAl4sdWTY4lrRwwCsWvMx4M9Zb14W8cTWyM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bz6doYlYtnMKBJjwTmlmkfafivOcOlIxJgU51l51fO/H+CZWnSkfqo44BLYWpuYHB
         rUpwBS/rLPlz3EfuIFwM9xwFnzZM3PBheA+sANqxOoxP6UPEru/KXtjPMUm2eRPo1P
         YB7KRvbAV1FSBm+y2X8nZvufWoNaw+OKJnikw48O3VH7o7etU4ZH/DEPoqzODVvi+d
         GGxdvdpg9vWmfih94OrcZOl3I7qOriALv98HuS4aBP5y6kcHvjs+eN+O44WjVmnC6h
         snAr33gJsJF2qOgvZgy6SE92cqSCZMvbxkqapVgXlzFt4olX4bODjR1hvi2tkiTeU+
         uT4Zx5nXGVmCA==
From:   Bjorn Andersson <andersson@kernel.org>
To:     luca@z3ntu.xyz, linux-arm-msm@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, netdev@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski@linaro.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, devicetree@vger.kernel.org, kuba@kernel.org,
        phone-devel@vger.kernel.org, pabeni@redhat.com
Subject: Re: (subset) [RESEND PATCH 1/2] dt-bindings: nfc: nxp,nci: Document NQ310 compatible
Date:   Tue, 27 Dec 2022 22:36:51 -0600
Message-Id: <167220221222.833009.16530727345050065132.b4-ty@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221128173744.833018-1-luca@z3ntu.xyz>
References: <20221128173744.833018-1-luca@z3ntu.xyz>
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

On Mon, 28 Nov 2022 18:37:43 +0100, Luca Weiss wrote:
> The NQ310 is another NFC chip from NXP, document the compatible in the
> bindings.
> 
> 

Applied, thanks!

[2/2] arm64: dts: qcom: sdm632-fairphone-fp3: Add NFC
      commit: 29dcf3c1a8159acdf56905c377a214381eda5a24

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
