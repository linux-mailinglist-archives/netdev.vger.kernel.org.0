Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373905A8CB8
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 06:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIAElu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 00:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAEls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 00:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B69E3407;
        Wed, 31 Aug 2022 21:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7CFF614A0;
        Thu,  1 Sep 2022 04:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDE1C433D6;
        Thu,  1 Sep 2022 04:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662007304;
        bh=k1iJM+v4douG1sTrz3KM2OrUcG3NQP6r/KTcxHrpFc4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DHKfHGgfHGTGCJYU8/hQ4E6CJiYS4pSpexAFepjpo0tczp66FyAl0JdqDVLJzzvc3
         GAYKhjkxMylB94n4X9esy/Z4dHkw4PCYksi//43STh9wMhuaVGMbMvsljMcwqndvIW
         9ktXIhJ0zBKZ0lN8dWW2m/3iWvGMiYESW8IsiAEGuQhMl1xM+UkLqwxFiGRwWmLZBS
         COlJsd3O83IxSH5H9gUDE6dbTZFVDeks1w8hv7kawMCCnFRmfgJ9+UI4ckOc7PLai4
         7uZ4xuClyQsAm/bm+6zLx7P83wfYV134KtCHatob98SnE83OUibht689pRpprH7Xow
         Jeg+GoHQ8VHHg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Sun Ke <sunke32@huawei.com>
Cc:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: fix potential deadlock in ieee80211_key_link()
References: <20220827022452.823381-1-sunke32@huawei.com>
Date:   Thu, 01 Sep 2022 07:41:38 +0300
In-Reply-To: <20220827022452.823381-1-sunke32@huawei.com> (Sun Ke's message of
        "Sat, 27 Aug 2022 10:24:52 +0800")
Message-ID: <87v8q7emf1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun Ke <sunke32@huawei.com> writes:

> Add the missing unlock before return in the error handling case.
>
> Fixes: ccdde7c74ffd ("wifi: mac80211: properly implement MLO key handling")
> Signed-off-by: Sun Ke <sunke32@huawei.com>

The title is missing "wifi:".

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
