Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1739A50C893
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 11:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbiDWJbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 05:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbiDWJbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 05:31:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560C51FB0FF;
        Sat, 23 Apr 2022 02:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BD965CE1407;
        Sat, 23 Apr 2022 09:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E63C385A5;
        Sat, 23 Apr 2022 09:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650706096;
        bh=/+CKqgTbK9rNNHE8MCzIbx+SObxDR4c6qp5yN1sWSCA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nsi8Z8QiLbKVacOfIA9KGhtcV9Xr7+bgaXaPA5pfwyoixWIoYFg0ur3QNd/zaT6UN
         KusmWz19YQwdUOJNJUyMBTP9kltY1bhpJDdnUjuYske192NBEENzUq6IMVlaDj4btF
         H2AMx/oxlw/jx5VyELmXrILkLhIs7nwPg/NBMpq5WgaZ/eNH2o1iO8dGk6hIHz6U8F
         mZQbEwMLeQa+UfpP1LwByasAfFc2EdgntqzQZBHwpQ9OhGK+/LWIx3mPSBRWoBQFX3
         WqHyuZm27sBpCVqY+jJjBr+h4UA3EKxiAjSvevqAbB3HGIZDGE/yAqzBaAiiHNacgr
         0vj6cys8g4+Jg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] ath11k: fix missing unlock on error in
 ath11k_wow_op_resume()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408030912.3087293-1-yangyingliang@huawei.com>
References: <20220408030912.3087293-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>,
        <quic_kvalo@quicinc.com>, <quic_cjhuang@quicinc.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165070609282.959.52286614356518398.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 09:28:14 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> Add the missing unlock before return from function ath11k_wow_op_resume()
> in the error handling case.
> 
> Fixes: 90bf5c8d0f7e ("ath11k: purge rx pktlog when entering WoW")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

605194411d73 ath11k: fix missing unlock on error in ath11k_wow_op_resume()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408030912.3087293-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

