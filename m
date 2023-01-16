Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAA066BFE8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbjAPNgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjAPNgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:36:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70621E1C3;
        Mon, 16 Jan 2023 05:36:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BFEBB80E96;
        Mon, 16 Jan 2023 13:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CEFC433EF;
        Mon, 16 Jan 2023 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673876188;
        bh=eyYIBkTc+aU5rlU29lHgxKy0T+h5OUzw65jzZNbXujU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Bm5O53gFx9vK77BY7dGcTm1p1nvPvVgjuWT4h3LdiJmqXPT9r5FUBTBWJSAAzr3lt
         bwTtIQqPnlPOw7qTszmAKbXG8W1YgTnawhilcjbsjrshDf99JmJeDp2r/MaRfcekc+
         wMLfX4rr72LPcZik9OZgn/IE7Jwz84LM1XJZqjTZ1VPZ+z0m/rIfC9mKlmU3rZnpDM
         8+IOoCZ0KvNEESQzaRd4J89u6E6KDzf1+tN8JPZ9sgOTDnkLEoRlnt/IzNmPT1HF+U
         UfN45rcf418e7Zn4E328UTljRqZQm7N2FkSoXpg8bg/JtbDEaOAP1rG+mfLQXALQ9t
         sMsFOdZZN1ewA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: rtw89: Add missing check for alloc_workqueue
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
References: <20230104142901.1611-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     leon@kernel.org, pkshih@realtek.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167387618418.32134.12212618077257685528.kvalo@kernel.org>
Date:   Mon, 16 Jan 2023 13:36:25 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:

> Add check for the return value of alloc_workqueue since it may return
> NULL pointer.
> Moreover, add destroy_workqueue when rtw89_load_firmware fails.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Patch applied to wireless-next.git, thanks.

ed9e6166eb09 wifi: rtw89: Add missing check for alloc_workqueue

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230104142901.1611-1-jiasheng@iscas.ac.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

