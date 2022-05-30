Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2515379C0
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiE3LYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232729AbiE3LYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:24:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F017CB6E;
        Mon, 30 May 2022 04:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C08A16116C;
        Mon, 30 May 2022 11:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5C9C385B8;
        Mon, 30 May 2022 11:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653909888;
        bh=3rCztYnL0uwrE4akRgpJAA1Ox2xAa2Imi8tNSao/Wvo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lwwCq3/da6jzkONa3Z68CTJR3Wbet5w5EWEF2UNn3ElmDPry5TahB8vUmS/NkbGX4
         bU9mFXcmDwMTgvWHaenKGWgmDiK1rO/VvGeftkogYnbdkzm8arECa0X+4RfPOAuT5W
         MCAg/ZYj33WG11GDYysxAxSAI+tM/XadN9T+WeP4WnyYCiEI3VCMJ7KlajaI1J5l/E
         aYA+BbRAvZ53cEAg9bV3JSQnwS0y/3aulmGJ77A1Ls69kcKUU98BxsHYxyG00rKBqn
         yf4NaBkiRfokwHtAa7lKvNwhE2fE31Z7WxnWS1wuzSfjabm+cpu7877vGNVIG0+q5Q
         KSfjC6++B4qeQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix IRQ affinity warning on shutdown
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220523143258.24818-1-johan+linaro@kernel.org>
References: <20220523143258.24818-1-johan+linaro@kernel.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165390988385.3436.2436370511020233863.kvalo@kernel.org>
Date:   Mon, 30 May 2022 11:24:45 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan+linaro@kernel.org> wrote:

> Make sure to clear the IRQ affinity hint also on shutdown to avoid
> triggering a WARN_ON_ONCE() in __free_irq() when stopping MHI while
> using a single MSI vector.
> 
> Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3
> 
> Fixes: e94b07493da3 ("ath11k: Set IRQ affinity to CPU0 in case of one MSI vector")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3bd0c69653ac ath11k: fix IRQ affinity warning on shutdown

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220523143258.24818-1-johan+linaro@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

