Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB15AAA77
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235930AbiIBIqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiIBIqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8A350185;
        Fri,  2 Sep 2022 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CEE56213E;
        Fri,  2 Sep 2022 08:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA4EC433D6;
        Fri,  2 Sep 2022 08:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662108348;
        bh=kbaCecPotDdfCJr5Dvy6j775i+9NGxyQBBveQhDxUkg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FFc60zQhtX/ckgYR8qZNwM+3zwo2uzEmpl3EpMqhFftGWcKqGtSzMonlTgwWso1qT
         hkRJhpH+MZjUVZ3MksGbpN4UvhYuR5jQuL/SICCq2X/mX4K1se08XB8CMtfdqHsgMb
         3qsMZUS36TpM4wq9x33PEl3Wr6V6X1f2vqpIcJEpSaLo0i/LLWi8jfBSp860VE2umm
         wb6KNeoDvELzWSE5a/W8OGkguYNFd2HAyTjFXX5Brh1MnT9/jH3OaOXACmvNr1G9Tw
         iYb1MwrWrCS23S5InPI/UkfcaFaFRT68ZFE1WZeqyRgg1zMxzckiamwpL79Sq55DCf
         Q/UpqalyiMXeQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next v2] wifi: rtw88: add missing destroy_workqueue() on
 error path in rtw_core_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220826023817.3908255-1-yangyingliang@huawei.com>
References: <20220826023817.3908255-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <tony0620emma@gmail.com>,
        <phhuang@realtek.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166210834567.24345.3696506856732369743.kvalo@kernel.org>
Date:   Fri,  2 Sep 2022 08:45:47 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Yingliang <yangyingliang@huawei.com> wrote:

> Add the missing destroy_workqueue() before return from rtw_core_init()
> in error path.
> 
> Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

b0ea758b30bb wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220826023817.3908255-1-yangyingliang@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

