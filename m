Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15EA66DD02
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbjAQL6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbjAQL6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:58:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9384298F2;
        Tue, 17 Jan 2023 03:58:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9F4612F2;
        Tue, 17 Jan 2023 11:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB2DC433D2;
        Tue, 17 Jan 2023 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956680;
        bh=CfY0vKBLLa78iuxTi6W0/d/1e7iUQFA5mLDhSfHHTao=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=E0OO6GabjV2cNT1r2R4mEd2T0B+XUQGP4ZfCmveHjMaYwqEyiM2Adq/TurSWPz9Ob
         lP8KJ+oUa7a7wx2WoS0G+qg1yWN6lpaj5tPLvBBPSYWiptz9WcGKn7y2WJNi9/jNyp
         eFflKhpJr5/A52fXssPo1yFZfdjqDoKIN9f4CIQVVred1W851v/bYwH3S0vL8mpd3P
         4FBnkCG4uIl+52O5r6teZQoIYzdps2GBEud+C5PJvKFD4VO1IRp6jStCvE8R2UFHE7
         +Qsskn5aSOS0aYeH8ZXAVFIBttwGdim5Z6nIo5D3h868GQCat97JpV40j9JfmHfAO9
         c54d/LXHzSSAg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: ath10k: Remove the unused function
 ath10k_ce_shadow_src_ring_write_index_set()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221219132041.91418-1-jiapeng.chong@linux.alibaba.com>
References: <20221219132041.91418-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167395667652.22891.15435711500083496948.kvalo@kernel.org>
Date:   Tue, 17 Jan 2023 11:57:58 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> The function ath10k_ce_shadow_src_ring_write_index_set is defined in the
> ce.c file, but not called elsewhere, so remove this unused function.
> 
> drivers/net/wireless/ath/ath10k/ce.c:212:1: warning: unused function 'ath10k_ce_shadow_dest_ring_write_index_set'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3519
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

179340dd4b39 wifi: ath10k: Remove the unused function ath10k_ce_shadow_src_ring_write_index_set()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221219132041.91418-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

