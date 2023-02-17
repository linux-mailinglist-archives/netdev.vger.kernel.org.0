Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB6069B039
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBQQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjBQQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:09:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28FD6A051;
        Fri, 17 Feb 2023 08:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BA7961C01;
        Fri, 17 Feb 2023 16:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FF5C433EF;
        Fri, 17 Feb 2023 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676650162;
        bh=z8ad3IPFM8xp59zw3jM5/vmke5RHnre99d6D95D/pzI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TFJMYEnBaVSVknRizyF9JWrV0Q/vxIqwcQBhkf/vRekrgZw3zLrxbOP1un4lmgdvP
         cF/Qd6fPcwBDDcivYEyiP2GqRoo2BDGSV97+DBP2c+gCGf1WjRQK7imvN2hbqC3Vnl
         G/jOAaa25JkuWWjxLqftPxwnbwYntlN4IcN0beIFkcd6SEo+Yj3lCsBA/Vp1Im73/m
         OwNy1E/YxONZKRDO4BRibCe0tTqP50Oh5Y3Whmz279PF4k8D7qVSIEBYAXT5oyT8PY
         wum6Gvh1tEHlFtlSc6ML4tZgswMfClOk33j4oKfA/oaRh0wWvJcxQ9RrNisGnWjXIO
         RCqR1R0NbN9uQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] wifi: ath12k: dp_mon: Fix unsigned comparison with
 less
 than zero
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230215011453.73466-1-yang.lee@linux.alibaba.com>
References: <20230215011453.73466-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167665015810.8263.7706809167524564713.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:09:20 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> The return value from the call to idr_alloc() is int.
> However, the return value is being assigned to an unsigned
> int variable 'buf_id', so making 'buf_id' an int.
> 
> Eliminate the following warning:
> ./drivers/net/wireless/ath/ath12k/dp_mon.c:1300:15-21: WARNING: Unsigned expression compared with zero: buf_id < 0
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4060
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

731e1b36656a wifi: ath12k: dp_mon: Fix unsigned comparison with less than zero

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230215011453.73466-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

