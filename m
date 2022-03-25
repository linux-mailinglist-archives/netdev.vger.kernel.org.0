Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73E14E70A1
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 11:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352527AbiCYKKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 06:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358745AbiCYKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 06:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B60C329BD;
        Fri, 25 Mar 2022 03:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8302060ED7;
        Fri, 25 Mar 2022 10:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA03C340E9;
        Fri, 25 Mar 2022 10:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648202914;
        bh=VBttjChkFw1UXnGJ78buMMYVdi2J+mnqNsmcRmkvvHg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RkXrLwgFLXMYmsyJrQajZYg9jUU1WA5KFvcTrijyxWnxym2RloCLV8SI8+TyXLday
         TV95p6GfEJDLWJ5E1Ak5qdaQb7nOb4XvxNhWXAtBV7c61RhtI+SYiMHltuRfx0xgH/
         QxbNPDpDljQzHjO/gdPsZnOPo9ME+8E95lmTPRyYeoFxHQ17iQ/NpwPBpV3hnNL1yI
         1llUMK0ZITMhmbrEGaNJp0WvN0jY3xlji9T4a27YriVl4XZQc8pUZ03i72kCo46Mo9
         gkgyMxxPsrVPjGDufxGLMxO/uwMd37HdpN2WnI7mrYRnA/F/Ty1y7D1f/p8JbMX4/G
         9z6wO0klFggGQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: broadcom: b43: Fix assigning negative value to unsigned variable
References: <1648109046-28108-1-git-send-email-baihaowen@meizu.com>
Date:   Fri, 25 Mar 2022 12:08:31 +0200
In-Reply-To: <1648109046-28108-1-git-send-email-baihaowen@meizu.com> (Haowen
        Bai's message of "Thu, 24 Mar 2022 16:04:06 +0800")
Message-ID: <87lewy8huo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haowen Bai <baihaowen@meizu.com> writes:

> fix warning reported by smatch:
> drivers/net/wireless/broadcom/b43/phy_n.c:585 b43_nphy_adjust_lna_gain_table()
> warn: assigning (-2) to unsigned variable '*(lna_gain[0])'
>
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/wireless/broadcom/b43/phy_n.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The prefix should be only "b43:", I can fix that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
