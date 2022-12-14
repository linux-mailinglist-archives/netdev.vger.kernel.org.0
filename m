Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA0E64C8FC
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 13:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbiLNMZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 07:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbiLNMZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 07:25:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05202981A;
        Wed, 14 Dec 2022 04:22:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CC8E619E1;
        Wed, 14 Dec 2022 12:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D50BC433EF;
        Wed, 14 Dec 2022 12:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671020553;
        bh=lUA3ej4Kq3cPTrBeqhTmtXKzFkDbZTjpqcOzdC+8+rQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ppKdE7Yhsev4718vpf9N7sFiYviSXngUlPDw14KFCBHK+2PShV0Ps5pMmbKWn+bpG
         PTcSpmbmmyDMs5uIs4kaBvBHKaTKwiAdDD4vZhOPlD2ryDaqEtw6XKALFQxcI02dxX
         6z2wA6Covjn7wiYZmq6f0isRk6+IkjTKMCU5/KAFj3qA1hzbrZGt1aWKkPk47Kiz21
         oXM7/QK08PopcNZExelh+OrwnM+DQyzYiFjYPPRP7ZgdgonCobfXpbjAVRDJIDYpm4
         PI4rxHQ0gUwrxbHZ0gBiXYBaxR1GxrjEsLe0xkLxJvfBDDWCQzaU1FujVIrQ384asp
         JDcg9yFyH+HbQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: libertas: fix memory leak in lbs_init_adapter()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221208121448.2845986-1-shaozhengchao@huawei.com>
References: <20221208121448.2845986-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <johannes.berg@intel.com>, <dcbw@redhat.com>,
        <linville@tuxdriver.com>, <hs4233@mail.mn-solutions.de>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167102054878.7997.15438501425115316737.kvalo@kernel.org>
Date:   Wed, 14 Dec 2022 12:22:30 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> wrote:

> When kfifo_alloc() failed in lbs_init_adapter(), cmd buffer is not
> released. Add free memory to processing error path.
> 
> Fixes: 7919b89c8276 ("libertas: convert libertas driver to use an event/cmdresp queue")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Patch applied to wireless-next.git, thanks.

16a03958618f wifi: libertas: fix memory leak in lbs_init_adapter()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221208121448.2845986-1-shaozhengchao@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

