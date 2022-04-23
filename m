Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D08850C8A3
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbiDWJdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiDWJdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:33:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6AD23529B;
        Sat, 23 Apr 2022 02:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D114960E15;
        Sat, 23 Apr 2022 09:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF40FC385A5;
        Sat, 23 Apr 2022 09:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650706202;
        bh=uYpUk5+sN0P3nqhmmuGUesP6y8QLTNMXcU77kia2qFE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SmRdB1dO1YCHMLFOBv7Wbz1+hejcLVpMTNWXxgBx0kM5ie60V5M1PnPMhH/K0+66Y
         ttTyc4BEPTKQHH7a/ePsZVnFQ+r5qfd0mgaNIN+7qbBNO+90m3noM5RipkTWUvMebJ
         VQupcuq8YLaRUQxMA9JO0MePDbm5iE012mH+SVUsUwbzgOBA5Lk4jHNVnhbEw8IKUm
         /SXiuQLpoK2O9jEZx8/9U4xd2mk6JQKuEhnSUUjPr/KYkxbmX6QJ2bqcnw0Mxb+Hrw
         qrs3zy/VOZcqjkYpUcx4z+7T5QUbVBf9U+o4NhBiJbQ9yaccXe8IuRJejAb4qgsttL
         bit2ldzNFvpHQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath11k: Fix build warning without CONFIG_IPV6
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220411020843.10284-1-yuehaibing@huawei.com>
References: <20220411020843.10284-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <quic_cjhuang@quicinc.com>, <quic_bqiang@quicinc.com>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165070619766.959.11490520883578406450.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 09:29:59 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/ath/ath11k/mac.c:8175:13: error: ‘ath11k_mac_op_ipv6_changed’ defined but not used [-Werror=unused-function]
>  static void ath11k_mac_op_ipv6_changed(struct ieee80211_hw *hw,
>              ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Wrap it with #ifdef block to fix this.
> 
> Fixes: c3c36bfe998b ("ath11k: support ARP and NS offload")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

67888630adde ath11k: Fix build warning without CONFIG_IPV6

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220411020843.10284-1-yuehaibing@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

