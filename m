Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CD94D8BBE
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbiCNSXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244012AbiCNSXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:23:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2A13525C;
        Mon, 14 Mar 2022 11:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B2B7B80E56;
        Mon, 14 Mar 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1371BC340E9;
        Mon, 14 Mar 2022 18:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647282116;
        bh=d48bJCF5BlMDijxkXKjgOv1DZ45/ZWXjK0Q4hywRQ0Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KC5QFqIXwZMb8/pIMaLUj7bk75m9SbEb/l39DzXcuGQwfKE8J1q5Tm5Z/3R56ddkO
         eYPVuPVvxDykaPWRU3r5LafoMdOORKHKLhihpzChv9qTHc0SmeX146qJUjscxmbyCc
         bTYju44th59Ip1LQ/OZj/LbIzkVbksHX6Xt71u5Vw2zSplH941BeYWg4lIqzCE5dpB
         51WGBcPfIjVX51soieLrooZBb5oCODiSydzhvA991m41AhvszYDdLVYVF4lf+0zF/U
         o/nvhThIdsvYjBtHEIfdfTkbzZ9RxvesX9VZVW/e8vYrYb+cdwtbjZWoCZRobUtflF
         QdlggpX+xgEjA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
        <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Mon, 14 Mar 2022 20:21:53 +0200
In-Reply-To: <20220311170833.34d44c24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        (Jakub Kicinski's message of "Fri, 11 Mar 2022 17:08:33 -0800")
Message-ID: <87sfrkwg1q.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 11 Mar 2022 17:06:25 -0800 Jakub Kicinski wrote:
>> Seems to break clang build.
>
> No, sorry just some new warnings with W=1, I think.

I have not installed clang yet. You don't happen to have the warnings
stored someplace? I checked the patchwork tests and didn't see anything
there.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
