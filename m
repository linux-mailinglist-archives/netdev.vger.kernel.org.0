Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7548561479A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 11:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKAKUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 06:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKAKUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 06:20:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7625260FA;
        Tue,  1 Nov 2022 03:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16E2561547;
        Tue,  1 Nov 2022 10:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25199C433D6;
        Tue,  1 Nov 2022 10:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667298042;
        bh=1I05wtll6/CHogEqtDf9neeBlDMZ+tVZTPcLDXFJg5A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Q8332Lxw3nymtZFCxYxGvTYBTpAKzVnuxnoFk1hY4nVNbrLXW5wXIBrBLAs863ZZ6
         H9RuaGg551NAl0e/5rhBsNFDa1Cjn7r3LO4lrZlFGfH0USx53Yzjcbia/4ZmBTfvGg
         lr+Z/rHQQnTkIBZExbC6VKFhZecDDGFfd8pQNVVJ8l+UAs7ADPhJX6kS6sKe2gtvNa
         Gmy6jRPf5hKZ1QO6FBIOzmMXqPXoS4H2e2Htm5xmzY2dcbZSnX8O7R0PcvcH4FXplL
         mIK/ct9Tp3WHQxXgzvVVH6ufQAIdxU4yUEbe+NWnusEtbocCq6Mw1966O2tfO9zc3m
         eCl02SYziXL/g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: ipw2200: Remove the unused function ipw_alive()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221017071746.118685-1-jiapeng.chong@linux.alibaba.com>
References: <20221017071746.118685-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166729803673.21401.16710194192988626348.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 10:20:39 +0000 (UTC)
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> The function ipw_alive() is defined in the ipw2200.c file, but not called
> elsewhere, so delete this unused function.
> 
> drivers/net/wireless/intel/ipw2x00/ipw2200.c:3007:19: warning: unused function 'ipw_alive'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2410
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Patch applied to wireless-next.git, thanks.

7bb09fb8f577 wifi: ipw2200: Remove the unused function ipw_alive()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221017071746.118685-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

