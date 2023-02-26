Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F696A3344
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 18:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjBZRkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 12:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBZRkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 12:40:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44BD510EE;
        Sun, 26 Feb 2023 09:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D45CB60C2B;
        Sun, 26 Feb 2023 17:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04BCC433D2;
        Sun, 26 Feb 2023 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677433222;
        bh=7hEe5jL1NmUs7E1ixEMaAhFQkGeW/Pfn8I04E4VXPVY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=X4ptmXZBN4CfmtlqRlxDbIk6XIXx8zeqUpSdIc2eW+NOrzENjaF89mVJjOTssKH1M
         /oGQxfgWbG+tNr6eq6myndteM9ciVXZQR6KtmlXB3EK0/FQ1wjT61skBYwPZNwWRPx
         gcGrd/2X/3N7qKEQMbDMr58ZMWC5SkUTgmsBBngflp5YS2TC1LETN989HSVOemiXUF
         YuILJ73fQFzd49MmpuaEjbIbsG4Xr4hvH2Ne2fUAeIzzkEo4iXaEqldkSaYKHj5TrM
         4M4Z0T5deKKXIZyFUqHZcFLtseh9fKv7fVncE2J470eS5OTHc53VQlkOZXu2czUlAI
         XBOQOcyrl1YmA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
        <167743301673.28904.15521250684332419538.kvalo@kernel.org>
Date:   Sun, 26 Feb 2023 19:40:18 +0200
In-Reply-To: <167743301673.28904.15521250684332419538.kvalo@kernel.org> (Kalle
        Valo's message of "Sun, 26 Feb 2023 17:36:58 +0000 (UTC)")
Message-ID: <87ttz81g1p.fsf@kernel.org>
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

Kalle Valo <kvalo@kernel.org> writes:

> Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> From: Johannes Berg <johannes.berg@intel.com>
>> 
>> Warn only once since the ratelimit parameters are still
>> allowing too many messages to happen. This will no longer
>> tell you all the different processes, but still gives a
>> heads-up of sorts.
>> 
>> Also modify the message to note that wext stops working
>> for future Wi-Fi 7 hardware, this is already implemented
>> in commit 4ca69027691a ("wifi: wireless: deny wireless
>> extensions on MLO-capable devices") and is maybe of more
>> relevance to users than the fact that we'd like to have
>> wireless extensions deprecated.
>> 
>> The issue with Wi-Fi 7 is that you can now have multiple
>> connections to the same AP, so a whole bunch of things
>> now become per link rather than per netdev, which can't
>> really be handled in wireless extensions.
>> 
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Patch applied to wireless-next.git, thanks.
>
> 35c2dcbb64d4 wifi: wext: warn about usage only once

Oops, wrong tree. Please ignore the mail, I'll take this into wireless
tree.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
