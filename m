Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1D85781BD
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbiGRMLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiGRMLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:11:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DBDDF04;
        Mon, 18 Jul 2022 05:11:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D3F961226;
        Mon, 18 Jul 2022 12:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3A5C341C0;
        Mon, 18 Jul 2022 12:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146277;
        bh=VERHYGvcgWKHCpefeV+Ju34Jq129cnan45oM4zLyu1w=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=tsq1CpTduSktkwQjZTiDINQYOY5A4gVnFY+HhVIOe9PFe7F412/I86TosoRQi58c1
         Wfi+PIVGM7i2lSbbHle24b5KIEIZ+HUmGIUqYhkL66l+uyh3S78G/e4pCAd7zRimCu
         mye9iiEyOfY/K6peuYH9mc6Is6Q2yn4/S3tAklE9nZVa7XK9NwsCevz42EVxA8VMcd
         M4nD8EZ+JOfzqe2Xnc1o3+qw5PpOb9EMkeTNaK784H5S6+cP7axtdyl8QAEGKMD3Tv
         FbGAZYTo5G6eL+gmDLLhJEuGPtJ4b05mj8xBeY+6DPTUBvtqE2qy2+zMnUdeSPkzjz
         FB96+vYwN6exA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710042040.22456-1-yuanjilin@cdjrlc.com>
References: <20220710042040.22456-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814627380.32602.13329626558301666035.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:11:15 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant words 'in' and 'scan'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

4a7fb1c67ef4 wifi: rtlwifi: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710042040.22456-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

