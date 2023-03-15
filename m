Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A626BACF7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjCOKFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjCOKFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:05:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0752F79F;
        Wed, 15 Mar 2023 03:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0AFF61CBF;
        Wed, 15 Mar 2023 10:04:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BA8C43444;
        Wed, 15 Mar 2023 10:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678874656;
        bh=HrEyR4EtUwhwq/8VCDY+hWQLVJjd6XlOp2Hyd8XWyjo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tUSNpIrFCX0NaH/EWp8LTLDvWlkaFLEaq3SJ4G+/G+s5Mxsa1H/SsrtcYUhPwHcKQ
         V1j0iTjH0OsuDdvdfYM54ds/DhbspC0A1Bpi6UyyMHGmHqhAmFxCbXtqf2ONOks7fV
         XYwt71k9yMKC7Uu4/9cooSkno2KpIKurq+wh0WJ5/neieQCj7//I/Pin9l8fcoR7cQ
         2UgzfPi9pQklk6h0K6XAfJXr8xWUsM69wa/Z7958B0kZyPV6l58u2bgPiKxspDAIjR
         xjCNq27n1pRbQAR/Fjus1ogQfNTBPBjNKJuwzd1hTNfb2FUl9n3KKQOh8hraRyGfNE
         ItF8N1I/axU1w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: mwifiex: mark OF related data as maybe unused
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230312132523.352182-1-krzysztof.kozlowski@linaro.org>
References: <20230312132523.352182-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167887464998.17341.1753931700389519426.kvalo@kernel.org>
Date:   Wed, 15 Mar 2023 10:04:13 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> The driver can be compile tested with !CONFIG_OF making certain data
> unused:
> 
>   drivers/net/wireless/marvell/mwifiex/sdio.c:498:34: error: ‘mwifiex_sdio_of_match_table’ defined but not used [-Werror=unused-const-variable=]
>   drivers/net/wireless/marvell/mwifiex/pcie.c:175:34: error: ‘mwifiex_pcie_of_match_table’ defined but not used [-Werror=unused-const-variable=]
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless.git, thanks.

139f6973bf14 wifi: mwifiex: mark OF related data as maybe unused

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230312132523.352182-1-krzysztof.kozlowski@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

