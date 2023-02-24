Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822026A1DF4
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjBXPDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjBXPDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:03:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035FA2E0CA;
        Fri, 24 Feb 2023 07:03:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85C4861839;
        Fri, 24 Feb 2023 15:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1CDC433EF;
        Fri, 24 Feb 2023 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677251024;
        bh=+qwnoeHBzppoVIm/VL0kDu/p/rJPsd2tDds8xTQZ1RU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DQ19V6WxYp3pIGDxjalZ+c3UPSCq7xkKm7MDAeIXPzeJZ5W8pcPzvxloz0WmB8hBL
         Oe1XBRc4zhNV63gopluZ4tidKH/G+4p8Tn3bfyr0nC85Xvo68Ph+CsX6yUZnzLOm3A
         RPukFHiH2U0Ox7EfHmzhLhATJ/F9EHqvu3YPP/ei7a+mXHpMOdnNiZ7Gt4X9mK8Ybn
         z80aA61ULiCKrLWRwhWKXozrNKLqSbkLz/qJtkENERa704VaOVbsvXpx4S8cuKW5cf
         rjPoTaCqi5QdXRDLFH7alCSyuDPe+3pwm6343KBQ/3TgqJjsOEGzdhIPwZdqBJ3gmz
         RWEUucqcwBXZQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
Date:   Fri, 24 Feb 2023 17:03:38 +0200
In-Reply-To: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
        (Johannes Berg's message of "Fri, 24 Feb 2023 13:59:34 +0100")
Message-ID: <87lekn2jhx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Warn only once since the ratelimit parameters are still
> allowing too many messages to happen. This will no longer
> tell you all the different processes, but still gives a
> heads-up of sorts.
>
> Also modify the message to note that wext stops working
> for future Wi-Fi 7 hardware, this is already implemented
> in commit 4ca69027691a ("wifi: wireless: deny wireless
> extensions on MLO-capable devices") and is maybe of more
> relevance to users than the fact that we'd like to have
> wireless extensions deprecated.
>
> The issue with Wi-Fi 7 is that you can now have multiple
> connections to the same AP, so a whole bunch of things
> now become per link rather than per netdev, which can't
> really be handled in wireless extensions.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Linus, do you want to apply this directly or should we send this
normally via the wireless tree? For the latter I would assume you would
get it sometime next week.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
