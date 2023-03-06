Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97FFB6ABB38
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 11:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCFKL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 05:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjCFKLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 05:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F1624CB6;
        Mon,  6 Mar 2023 02:10:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F68CB80D1F;
        Mon,  6 Mar 2023 10:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF9CC433D2;
        Mon,  6 Mar 2023 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678097423;
        bh=3yk8H0xfAC2Ooz06Br49vxObbkr0kpq3DEn6Ph+o1Cs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Su7sgbgaJlTaZ68ZyEqMpOdLHAKsXqBnm8E4CTJFGNGqkpikSX8FqtiC8qBXqwfGl
         7H4ieoQ9wipGNwoq87d6NB/cVibJbIsd5DFJnYcozYmsxuYwYR+AFMaoLafy0rw51Q
         hO13Z7uKzH5IDCJd06xYyo9jVkvHJwZg4TCmxUlzi6juNgv/CVMLxflVe16raee1BP
         UHrxaDV7oK1mcr7Tnm6YMjzDXFqbyijWTyC+Zjv0Zx6M0BKwBn5JXYZb4fgQznAirC
         t9zh1H4H1nbQ7LyCc5MsAwknqi1bZDxZMMJNxzPZjw9tto39swAFT5pH6OFQDpbUw+
         FC5WfPutLBaSA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v4] wifi: rtlwifi: rtl8192se: Remove some unused variables
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230302023911.59278-1-jiapeng.chong@linux.alibaba.com>
References: <20230302023911.59278-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167809741914.16730.13655795800421510309.kvalo@kernel.org>
Date:   Mon,  6 Mar 2023 10:10:20 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Variables bcntime_cfg, bcn_cw and bcn_ifs are not effectively used, so
> delete them.
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c:1555:6: warning: variable 'bcntime_cfg' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4240
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

ff6f38eb920b wifi: rtlwifi: rtl8192se: Remove some unused variables

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230302023911.59278-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

