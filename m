Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7F5781C0
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiGRMLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiGRMLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:11:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF41BF;
        Mon, 18 Jul 2022 05:11:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE975B81244;
        Mon, 18 Jul 2022 12:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D28BC341C0;
        Mon, 18 Jul 2022 12:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146302;
        bh=tpMd1KFHboCyeC2lUMJJbDfuX/R7Ooq5hXAos1sA/LI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fTBwTFendICKj8xIaPtDhBp+0dRtKfvZqMjqFw9J999w76FkFF8smxygiiD8aKgqn
         vQ2Lc13VjNLUEaDPxZ0EXolW0oLoVOfAfy9RHB0Zfv/6Ghmj1GV+MZBwG/PBz1LWwf
         wPMVeqTWEE28ni6NTh51MxsnNaA42crE2t0dvp34KhWBiAt9D9whghNRBVJEzGKK8D
         jc6okPsw21mgHbB87RbrBemlth95kyCF26Fd7ao/PvS30PCXnBq+PA2J7rIsNT68wC
         2emSsLBedEkjXcW712miZXRbhY0BKPwo4V9RQnm4fjALMHtl6kEZ8gz+tO8r4UaMG/
         utIciaCirLG8g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtl8192se: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710042546.28504-1-yuanjilin@cdjrlc.com>
References: <20220710042546.28504-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814629862.32602.11558003708539112519.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:11:40 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'not'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

9c817cb7e674 wifi: rtl8192se: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710042546.28504-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

