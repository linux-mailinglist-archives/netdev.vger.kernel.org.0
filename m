Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428D164C8E6
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 13:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238461AbiLNMXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 07:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiLNMWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 07:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABFB427DC2;
        Wed, 14 Dec 2022 04:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ABFB619F2;
        Wed, 14 Dec 2022 12:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4843DC433EF;
        Wed, 14 Dec 2022 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671020393;
        bh=RVUTBRWg+X7pH1T8AAlEjkLc82S+tpqW8QeflyZujIs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sxnicfX68XA3v4Yqx+nYVSHKTzOle5Wy2HoqJB09iVruPQexioVsDb6uNuZH1C1oY
         2/vsr9+QZJOoAgKFvWrRWJh3jmkjW5aKpWTNrTWntz21kHv7V9DhAl642NLi6pAeEN
         q3fUhYI3jc3wILCALjYCjZjXTYtC2f3nCSYYtz9hXwuwAWFnfFyZCQR2B6kYPm0+vT
         kVY/8/jGtRE8X3zvuOXtegDN+K6CPN6JC+t1kD+r/mCpQS29UDtm81O8J2gd+8qCcO
         MnOBXFkviEzi3KCgC9kOUEeRRtDKf53qOJZOaKIeOmJtx6xi1xg1VbpGD7ODNGLgAI
         Uy7EVafWWl7ow==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rsi: Fix memory leak in rsi_coex_attach()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221205061441.114632-1-yuancan@huawei.com>
References: <20221205061441.114632-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     <amitkarwar@gmail.com>, <siva8118@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <prameela.j04cs@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <yuancan@huawei.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167102038627.7997.15208655960822089397.kvalo@kernel.org>
Date:   Wed, 14 Dec 2022 12:19:51 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yuan Can <yuancan@huawei.com> wrote:

> The coex_cb needs to be freed when rsi_create_kthread() failed in
> rsi_coex_attach().
> 
> Fixes: 2108df3c4b18 ("rsi: add coex support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

956fb851a6e1 wifi: rsi: Fix memory leak in rsi_coex_attach()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221205061441.114632-1-yuancan@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

