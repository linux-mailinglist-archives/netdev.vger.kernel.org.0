Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 477B269F26B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 11:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjBVKFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 05:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjBVKFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 05:05:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375691287D;
        Wed, 22 Feb 2023 02:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDA5661312;
        Wed, 22 Feb 2023 10:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC80C433EF;
        Wed, 22 Feb 2023 10:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677060300;
        bh=uQlRtmWEOuKqiHVFwu6hu4e8QQoptuSNe09bNvb9sqo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OBWGuSpEa4PtrBK5nkaKAm72pq4D0vPUxSGW2P5zpKxgItfzt0RpPCR1DPeJO3l7N
         ZPJ6nhW2GncXFA615Vcxxm/xVgZ70HCLcerf44X6gahaS1118cShj9nz2PWj94aHmF
         hiqK0H2zTzYDsznPua3nIpmfgd2G4nLfpvG3nHWdeZXC/YWtTXJr6+ignPR2s2Wf1y
         6q3yOOmM0XpChKvmRC9/Hii6+7pKX/xzggGy1G2X4Mnd/Cor9nXuJ8t9CXHgDe/5sK
         7D6Cs7pcViDuL146Rt0KyhYcOS9yUmlaBpG63izn4acVAET6ZZhWIH2IClhmajDSql
         kCuiHeZoypOZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Remove redundant assignment to changed_flags
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230207052410.26337-1-jiapeng.chong@linux.alibaba.com>
References: <20230207052410.26337-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167706029271.5928.12785836137133624745.kvalo@kernel.org>
Date:   Wed, 22 Feb 2023 10:04:57 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Variable changed_flags is assigned, but is not effectively used, so
> delete it.
> 
> drivers/net/wireless/ath/ath10k/mac.c:6024:22: warning: parameter 'changed_flags' set but not used.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3963
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

7c4c511f74ba wifi: ath10k: Remove redundant assignment to changed_flags

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230207052410.26337-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

