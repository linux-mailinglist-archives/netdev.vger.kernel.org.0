Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48269B0BB
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjBQQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBQQWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:22:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BDA711AA;
        Fri, 17 Feb 2023 08:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C65B82C8C;
        Fri, 17 Feb 2023 16:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F851C433D2;
        Fri, 17 Feb 2023 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676650894;
        bh=TuXNu3KLEBuwBD34TiklRTFUXZfjkU9djzAPGLfs2Ds=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FJbjRoyWr9mTlyVQ99ff594eBfcDE8JNQCJR9Vyq44Q9Io48kiVV2P4IP7Av7bujg
         /9BjKFqx0iMXwxzQaWtX18PCw0OHb8wCS6hVmvdWT8JBAhNP58NR+zgqjdd1jV3NGE
         ujRJEkEp2r8ts+3RkDjA+eo0w0wnwJX9zeCML5QQyS5kRvvSKcPzIEZq4qcLUlE9e/
         Uv/Kxohr0mMj6WgsSgUA5MeXzCnjPQjyqw8mbxll9psYsed++0JNPvyaL9eRS+Vgqq
         XTMSGFbLZgnQdx8MSaBGW+/Y5rU6jovI0J523nPZZvB0+MNPTEiyDGidBtM0LomQnu
         TkSm57ML2Bn5Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] wifi: ath12k: dp_mon: clean up some inconsistent
 indentings
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230215012548.90989-1-yang.lee@linux.alibaba.com>
References: <20230215012548.90989-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167665088778.8263.12054691463411607206.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:21:31 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> drivers/net/wireless/ath/ath12k/dp_mon.c:532 ath12k_dp_mon_parse_he_sig_su() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4062
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

df8e8db22c25 wifi: ath12k: dp_mon: clean up some inconsistent indentings

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230215012548.90989-1-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

