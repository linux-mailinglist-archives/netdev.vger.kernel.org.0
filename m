Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05C35824F6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiG0K6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiG0K6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:58:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13016481FB;
        Wed, 27 Jul 2022 03:58:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37AA2618A3;
        Wed, 27 Jul 2022 10:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CE9C433C1;
        Wed, 27 Jul 2022 10:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658919479;
        bh=ZU3Beu3wwhNdl8IZoDDsrOJjR04aPFQ0vIc7BF8L4y8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TZdwaJl/984ZHxC1AUDDbLMchbAFxvlH658thu8AoPQGgShh9WpYUEDl3e6Ybcqeg
         6lrVP5hhR97H4GkuS9cC4a6FQLPeqlp83rR+OVFRVVP9S1IYDRDY+KuBHR8wakPbuP
         gmCIGaDtcbBPj4sNNf/XmU/k5usaFXaViNyCYsObHvSI/B5LRcztxMCXTAjhGmEUJK
         VuXqUde7aWARX93m5Ipiut7cY0p8vG/u+OmCG12MsZJXHd9oGtxIMJCqESD/Iukwmp
         nzKAksTZeUpcFvYiWn9dOhXX12uhU6dQZ3H7zm2yoiBhwFbOYu36wsCW8k0FjoCVKb
         A9kTAB2fzT+dQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: brcmfmac: sdio: Fix typo in comment
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220618131305.13101-1-wangxiang@cdjrlc.com>
References: <20220618131305.13101-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiang wangx <wangxiang@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165891947499.17998.10174395154988805110.kvalo@kernel.org>
Date:   Wed, 27 Jul 2022 10:57:56 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiang wangx <wangxiang@cdjrlc.com> wrote:

> Delete the redundant word 'and'.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

3f368ed80201 wifi: mwl8k: use time_after to replace "jiffies > a"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220618131305.13101-1-wangxiang@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

