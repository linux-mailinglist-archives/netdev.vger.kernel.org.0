Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A734FE406
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353160AbiDLOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiDLOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 10:44:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481E11155;
        Tue, 12 Apr 2022 07:42:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E9686114A;
        Tue, 12 Apr 2022 14:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88B6C385A5;
        Tue, 12 Apr 2022 14:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649774554;
        bh=Q52tCbAaRn1P664NKV7dZwxginIy/el2s/AYgozHef4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ssTA9KpdYm40RCouhGZ+/ajNjpVuu6ytq5iM8LRk9C4kgaH5PH/dWbFO3lMVafwqx
         5703RBhnTYQ3dzI+nekBH0j7TpqscM58jiZM8BL1ViMM0+JDRA2ybnwzEH7D1Tmv+A
         8TDTgUm1HC9zD6rWsQeNm9rRtO2gUc+xOl1p+5xQ2VRP2ve+tncf+gMpjkePbwBZgT
         DQOzXwGc6vSNXAC52cmh/zRpo3iMO+zKqtMJvRZnESqdO23it5Mt98PWirJAGIlrrl
         HlhzgzM+bIbdtEjVV0YMFzi/6ZqhcXq68pdid5FaePk8yhwxvIUBzWNxWRg9m96avr
         0D5sWbWx1z16w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com> <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42> <878rslt975.fsf@tynnyri.adurom.net>
        <20220404232247.01cc6567@kernel.org>
        <20220404232930.05dd49cf@kernel.org> <878rskrod1.fsf@kernel.org>
        <20220405092046.465ff7e5@kernel.org> <875ynmr8qu.fsf@kernel.org>
        <Yk8iiZKFpYNgCbCz@kroah.com>
Date:   Tue, 12 Apr 2022 17:42:29 +0300
In-Reply-To: <Yk8iiZKFpYNgCbCz@kroah.com> (Greg Kroah-Hartman's message of
        "Thu, 7 Apr 2022 19:42:33 +0200")
Message-ID: <871qy2nz1m.fsf@kernel.org>
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

+ stephen

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Wed, Apr 06, 2022 at 10:06:33AM +0300, Kalle Valo wrote:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> 
>> > On Tue, 05 Apr 2022 10:16:58 +0300 Kalle Valo wrote:
>> >> Sure, that would technically work. But I just think it's cleaner to use
>> >> -rc1 (or later) as the baseline for an immutable branch. If the baseline
>> >> is an arbitrary commit somewhere within merge windows commits, it's more
>> >> work for everyone to verify the branch is suitable.
>> >> 
>> >> Also in general I would also prefer to base -next trees to -rc1 or newer
>> >> to make the bisect cleaner. The less we need to test kernels from the
>> >> merge window (ie. commits after the final release and before -rc1) the
>> >> better.
>> >> 
>> >> But this is just a small wish from me, I fully understand that it might
>> >> be too much changes to your process. Wanted to point out this anyway.
>> >
>> > Forwarded!
>> 
>> Awesome, thank you Jakub!
>> 
>> Greg, I now created an immutable branch for moving wfx from
>> drivers/staging to drivers/net/wireless/silabs:
>> 
>> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git
>> wfx-move-out-of-staging
>> 
>> The baseline for this branch is v5.18-rc1. If you think the branch is
>> ok, please pull it to staging-next and let me know. I can then pull the
>> branch to wireless-next and the transition should be complete. And do
>> let me know if there are any problems.
>
> Looks great to me!  I've pulled it into staging-next now.  And will not
> take any more patches to the driver (some happened before the merge but
> git handled the move just fine.)

Great, thanks Greg! I now merged the immutable branch also to
wireless-next:

79649041edc8 Merge branch 'wfx-move-out-of-staging'
4a5fb1bbcdf1 wfx: get out from the staging area

So from now on wfx patches should be submitted for wireless-next via the
linux-wireless mailing list, instructions in the wiki link below.

Stephen, I want to warn you in advance about this driver move but
hopefully everything goes smoothly.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
