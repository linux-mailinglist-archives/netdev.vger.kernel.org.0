Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322C96544C5
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiLVQFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiLVQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:05:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DF918B0F;
        Thu, 22 Dec 2022 08:05:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D87E61C27;
        Thu, 22 Dec 2022 16:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1CBC433D2;
        Thu, 22 Dec 2022 16:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671725134;
        bh=cW3jyW2N+O4Ffc3ACdzYPNrQDrjgtqNppbdLOaFyoYo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sZ0s1g2pfb9FrDyrko9a1DyZObmMLCuBH9Ba/4xravWvxivA3Vb3HhjKmZRE5x4CP
         5PUslVNXQwEnvb1eAjt9otWCZQBbngcqqYXcqlCVTJpZqWUa1tWYdSDh3VtobW7PGp
         A6x2kE69AnE61vdtsSiN4nP8gQvOyK3B6S4JN9diezukg/EFijKoiphDjkO5a0Ipu8
         EK7hUzEdLcKTfMGyF8aeRJFaxQPGrxyf0lu5/7rKrqmIXqRH+9H9amdWlruBraHxaR
         7OAvnAAn/v8d4IN3hrdb30BrgwXt9nXHjf+9qawOfovCwZu5sJFh3iM6EEx/QvbaXu
         mhmJZK++ZbE2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: ipw2200: fix memory leak in ipw_wdev_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221209012422.182669-1-shaozhengchao@huawei.com>
References: <20221209012422.182669-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <stas.yakovlev@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linville@tuxdriver.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>, <shaozhengchao@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167172512673.8231.13701483342037956356.kvalo@kernel.org>
Date:   Thu, 22 Dec 2022 16:05:31 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> wrote:

> In the error path of ipw_wdev_init(), exception value is returned, and
> the memory applied for in the function is not released. Also the memory
> is not released in ipw_pci_probe(). As a result, memory leakage occurs.
> So memory release needs to be added to the error path of ipw_wdev_init().
> 
> Fixes: a3caa99e6c68 ("libipw: initiate cfg80211 API conversion (v2)")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Patch applied to wireless-next.git, thanks.

9fe21dc62611 wifi: ipw2200: fix memory leak in ipw_wdev_init()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221209012422.182669-1-shaozhengchao@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

