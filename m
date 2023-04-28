Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7F56F137A
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbjD1Iu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjD1Iu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE8F12C;
        Fri, 28 Apr 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 123F3641FC;
        Fri, 28 Apr 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37006C433D2;
        Fri, 28 Apr 2023 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671819;
        bh=b6TIE+j62mouk8vF7zxdk5VKpO0bAzC4Lo/zxvwsqZ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=QlN17eClVs4IZxoT/wNh6nnZ+0bGzF0pbqXJaDfnU0qZyHRRQtNY7GqurwdjO34GO
         9UezhrXzRklPrJ6TxybLnUbfQhWsC1LG+ZrohKCap0a95HHkkQsCY+pPfcdItm/9gx
         qyEHKHF2NxTeT1gWO1M/4+WuxqZK+cl3sdEhmOPnZyQFNt+AMhbf0nlacUvGoD14uo
         WZhhSg5zA5iW4YVGHhLSXoKwexSCu3fQOjECjJmdl1YrwOxR+kCvio+Z7k/U+9QcPv
         x0/DV1fDMxTWCIf8FOIO+W4KtEuXzCeoyZH8k1N3XvkTEY5ktWuw2HT8t/flVuVZZE
         xEUphI+fadVWA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: pull-request: wireless-next-2023-04-21
References: <20230421104726.800BCC433D2@smtp.kernel.org>
        <20230421073934.1e4bc30c@kernel.org>
Date:   Fri, 28 Apr 2023 11:50:16 +0300
In-Reply-To: <20230421073934.1e4bc30c@kernel.org> (Jakub Kicinski's message of
        "Fri, 21 Apr 2023 07:39:34 -0700")
Message-ID: <87leics853.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 21 Apr 2023 10:47:26 +0000 (UTC) Kalle Valo wrote:
>> Hi,
>> 
>> here's a pull request to net-next tree, more info below. Please let me know if
>> there are any problems.
>
> Sparse warning to follow up on:
>
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25: warning: invalid assignment: |=
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25:    left side has type restricted __le32
> drivers/net/wireless/mediatek/mt76/mt7996/mac.c:1091:25:    right side has type unsigned long

This patch should fix it:

https://patchwork.kernel.org/project/linux-wireless/patch/16fa938373e3b145cb07a2c98d2428fea2abadba.1682285873.git.ryder.lee@mediatek.com/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
