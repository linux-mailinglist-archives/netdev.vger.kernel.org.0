Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3469F490
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 13:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjBVMag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 07:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjBVMaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 07:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A552313B;
        Wed, 22 Feb 2023 04:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A98E1B8125F;
        Wed, 22 Feb 2023 12:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F41C433EF;
        Wed, 22 Feb 2023 12:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677069014;
        bh=tkoEGy62ppDmmm4ymendbNyJ8TLlOAHfYLvaP+StFJc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MIG66V4ikNdcT8Me/J4Oe0yrRMrUHZES9A9Hc751Qv6eYKppkFguaa7s9xyPBWACp
         U9OTm6Ky+pWrZ5vHRtOT09BPfneej7Fv0egCf1U+0VRwQrwQUbCZedP7RcOF/roxZc
         Yx09CCX7UigSKOP68gGlNktMqYMClQVmwI301ZR6KnQrTsj7Enz0OgVz0fNSJJznru
         Be1kgKc4c6Lz0aQhB3AXfvNdOB/ADaJx41q5TriT5yr+Uk+cwlVwbBv4cXf1AOHKOa
         b1svuLgWCKGD33YUzVlB8TayyMbInWmv/nlMS8XKJuvlKJPIp2qTsj0dCqZY7aLdk9
         QRJ9SKCxvSQ6g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: rtl8192de: Remove the unused variable
 bcnfunc_enable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230217092529.105899-1-jiapeng.chong@linux.alibaba.com>
References: <20230217092529.105899-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706901023.20055.833795751773606339.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 12:30:11 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Variable bcnfunc_enable is not effectively used, so delete it.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:1050:5: warning: variable 'bcnfunc_enable' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4110
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

db5e4b364553 wifi: rtlwifi: rtl8192de: Remove the unused variable bcnfunc_enable

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230217092529.105899-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

