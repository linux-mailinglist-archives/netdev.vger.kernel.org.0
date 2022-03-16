Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE64DB4DB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355102AbiCPPaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbiCPPaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0BA5DE72;
        Wed, 16 Mar 2022 08:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA1F9B81C15;
        Wed, 16 Mar 2022 15:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DF5C340E9;
        Wed, 16 Mar 2022 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647444546;
        bh=tLsQsEekDLagjJvzvIb1lBapSnmZsIRBUrwB8Dzj1Rk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dgx0peC2eiNxqmsJ+56a2TejDUI+ova+ImH5N0zR7adwN99m7W9v5YA59BVSsVkWC
         Q5xSGJoHvrvzQIKqKlru2S0A41oseBuByt/vNO8GO8NUywlfj9Jv+D4/tG+Iy/1bnJ
         Ur37OMtRNcGdKJYQDu5awAnZ+Gh4Jf2lJ6suIvSLap9zQaKW0LSCYbXJxnJNNmtse0
         mOKFCbomd8udTx6kzJRwx7HW2e0UxKM58C+xz0u6qqae5ipvcfVTxJor4SvcTnCDII
         JVJJfEUavL1cDD8hkukkW6NQk9PNtE4CAVO4LhmAV5MQKbxNe5r6y0oH90o82gfpQ+
         XvK+ekxEpdfJA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 5/6] zd1201: use kzalloc
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220312102705.71413-6-Julia.Lawall@inria.fr>
References: <20220312102705.71413-6-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164744454291.16413.16962718539524275233.kvalo@kernel.org>
Date:   Wed, 16 Mar 2022 15:29:04 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> Use kzalloc instead of kmalloc + memset.
> 
> The semantic patch that makes this change is:
> (https://coccinelle.gitlabpages.inria.fr/website/)
> 
> //<smpl>
> @@
> expression res, size, flag;
> @@
> - res = kmalloc(size, flag);
> + res = kzalloc(size, flag);
>   ...
> - memset(res, 0, size);
> //</smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

Patch applied to wireless-next.git, thanks.

3c0e3ca6028b zd1201: use kzalloc

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220312102705.71413-6-Julia.Lawall@inria.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

