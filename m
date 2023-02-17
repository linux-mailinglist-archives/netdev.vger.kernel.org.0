Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D531269B0C7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjBQQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBQQZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:25:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED201714B6;
        Fri, 17 Feb 2023 08:24:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5314AB82C83;
        Fri, 17 Feb 2023 16:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEFBC433EF;
        Fri, 17 Feb 2023 16:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676651037;
        bh=qFslmSzBHq1AFgtu6b6trKJWgxNQcXfdeaGjKzspQjQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pdJrv020MefvyaJULoXEM8dLdq3YxM5+3Dp+vb0I9W3dq9XWz0h1Y16dmS1ICAfLi
         IJdilmpBtjSmWsxBcKjZJhTmzjEn3JQry8d3O3RRpxrEOjhqtPdkUOB4iszl4QFmGO
         tWR30HwYQNUlvRf4WP5p8n1wEYzTU2OwTntN9mP6qrQaV2LFW+LY1ftnOlr4NE1onO
         Zbma96q2u+qle4NNGIMHbGuXYUf4CaD2/R1/R2qgoW65IyyLZME0qKaqCWTIz7Umj6
         xvRXbCHue1fhpmoGyuCGxlEvRcn9wC8dkxZiTq3kDxHjOF2aPQbJVl3pm0bnrihi//
         bvxrxs9G711qA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] wifi: ath10k: Remove the unused function
 shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230215014058.116775-1-yang.lee@linux.alibaba.com>
References: <20230215014058.116775-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167665103358.8263.4713649480781562258.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:23:55 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> The function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()
> are defined in the ce.c file, the code calling them has been removed,
> so remove these unused functions.
> 
> Eliminate the following warnings:
> drivers/net/wireless/ath/ath10k/ce.c:80:19: warning: unused function 'shadow_dst_wr_ind_addr'
> drivers/net/wireless/ath/ath10k/ce.c:441:20: warning: unused function 'ath10k_ce_error_intr_enable'
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4063
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

3c3ab8c9a296 wifi: ath10k: Remove the unused function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230215014058.116775-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

