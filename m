Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884BB6A274A
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 05:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBYEyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 23:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBYEyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 23:54:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3F5126C0;
        Fri, 24 Feb 2023 20:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B19DB81CF7;
        Sat, 25 Feb 2023 04:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12895C433D2;
        Sat, 25 Feb 2023 04:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677300860;
        bh=rOEc26RCcLfUjD9Zty2t2zc49it4UokaAcduKqPAXcM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=n+qyRAGPb0GljWF1eoKJab1z3bKsk21DI2WxNs3XpzB3ExwWOSLJDVhlXbTJH2/6Z
         GGpLxi8O7FLiD10AGHukiom5FZdA6MjYp/ElpAxytB2S6DjML7p4BzUuWajHnue8C5
         IRMmsP6wWRbnib4lnlEnsP13s/H0VJe1o+uIPVbUO1xNIs0T/G4p6N3vOEdniZBWWe
         EWQvL/fpHPLjgG6+arvXaj1Zhtxdy7HhVFcBDm/nIe649185Idq44lWe5zAkodZRAZ
         2QaRsBikLPMcvoHpBBosBm8mcc6kKd4cy01NYrQVLek6xn0lMJVvWFPDM9pz//hPr+
         g0pwDL7Qxmo0g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
        <87lekn2jhx.fsf@kernel.org> <20230224114747.1b676862@kernel.org>
Date:   Sat, 25 Feb 2023 06:54:16 +0200
In-Reply-To: <20230224114747.1b676862@kernel.org> (Jakub Kicinski's message of
        "Fri, 24 Feb 2023 11:47:47 -0800")
Message-ID: <874jra2vlz.fsf@kernel.org>
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

Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 24 Feb 2023 17:03:38 +0200 Kalle Valo wrote:
>> Linus, do you want to apply this directly or should we send this
>> normally via the wireless tree? For the latter I would assume you would
>> get it sometime next week.
>
> FWIW the net PR will likely be on Monday afternoon, pending this fix
> and the Kconfig fix from Intel.

Ok, I'll try to send a pull request before that. I also have other
pending fixes in the queue.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
