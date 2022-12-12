Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66CA649C62
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiLLKl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbiLLKkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:40:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D668EFCF7;
        Mon, 12 Dec 2022 02:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7310360F40;
        Mon, 12 Dec 2022 10:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DD8C433D2;
        Mon, 12 Dec 2022 10:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841283;
        bh=vrFxeli8F3EO2DuQDN+jCz2CjmUYhcY2TDhvXHFi1sY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ih/zua0q5zv06/kPWeiWPGYMeRX+Z4H3lNCbZs3KtqqI2GB2fJomdYLYtmCf9vsvY
         kP6LB990E27y5DI3Ihs1NK9+n17LsSiMnZ0InA6FBEpmKs4J6WPUBzVINC5nfDU6F0
         cPeqVZ6e38b2ETLg8HW4bsSTv0VKIQtrKWlH3si7Npx/YlVPbnUPbFvfdl2f9GqdzB
         bIDwXvwKIxRpWuY6nACaWV3zt0ynOCy0yDsX3HfzHVLrf5iXGAcxueXUIpw6jzD7Vo
         0Lb5efMzUWHXTwRt2DP++//CX8VK89BF6xcJaef1FCUli5EOxuPwvsuQG1RasWxHCx
         tY4seVfMFg7Iw==
From:   Kalle Valo <kvalo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-12-12
References: <20221212093026.5C5AEC433D2@smtp.kernel.org>
Date:   Mon, 12 Dec 2022 12:34:39 +0200
In-Reply-To: <20221212093026.5C5AEC433D2@smtp.kernel.org> (Kalle Valo's
        message of "Mon, 12 Dec 2022 09:30:26 +0000 (UTC)")
Message-ID: <877cywnc5c.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
>
> Kalle
>
> The following changes since commit 65e6af6cebefbf7d8d8ac52b71cd251c2071ad00:
>
>   net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill (2022-12-02 21:23:02 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2022-12-12
>
> for you to fetch changes up to 832c3f66f53f1eb20f424b916a311ad82074ef0d:
>
>   Merge tag 'iwlwifi-next-for-kalle-2022-12-07' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2022-12-08 16:54:33 +0200)
>
> ----------------------------------------------------------------
> wireless-next patches for v6.2
>
> Fourth set of patches for v6.2. Few final patches, a big change is
> that rtw88 now has USB support.
>
> Major changes:
>
> rtw88
>
> * support USB devices rtw8821cu, rtw8822bu, rtw8822cu and rtw8723du
>
> ----------------------------------------------------------------

Sorry for sending this so late, I was supposed to send it on Friday but
didn't manage to. All the patches have been in wireless-next since
Thursday so this should be safe to merge. But if it's too late please do
drop this, I'll then submit these again for v6.3.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
