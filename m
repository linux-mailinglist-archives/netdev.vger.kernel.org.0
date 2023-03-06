Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EEC6AC05A
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjCFNHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjCFNHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:07:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18F4234C6;
        Mon,  6 Mar 2023 05:07:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CFEB60EC2;
        Mon,  6 Mar 2023 13:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777DC433D2;
        Mon,  6 Mar 2023 13:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678108037;
        bh=V+XEXGIqCCu3rhQTr42OXRAyd8vuMjOkQ9yhZ2KzNug=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Nwikr6PHDlPcaeHNgeyBDYxLsZxiDvahkVNkDeqPQez9t2UzxdiO7gFZ/yEejJa9u
         v2Ob7tz8txwT4ykTwewW367hJzhVQIW6mAiCIHoNtsWlQSA1z/VIJ2dq0Cawtp+K3V
         36vSivDqIhjUWQlncNmdfww5T86qfsY26Og3WieTH0qq6vUXAZ5hXXDvBYmcMZtyHp
         jPR2QiWQ92RPxjixhexF4+OoCZekIxt716lcrDJK5fiEO3WO9hTCA7u6Moacgw4Zpq
         Kqb+R3RkkqD5h6on1CZ7KMxOcNNv1RGm3q+NMywA5HA8Q/6MaG5HItnytan3TOq1BB
         4C5em8rtA/1KA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bastian Germann <bage@debian.org>
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
References: <20230305210245.9831-1-bage@debian.org>
        <20230306125041.2221-1-bage@debian.org>
Date:   Mon, 06 Mar 2023 15:07:12 +0200
In-Reply-To: <20230306125041.2221-1-bage@debian.org> (Bastian Germann's
        message of "Mon, 6 Mar 2023 13:50:40 +0100")
Message-ID: <87wn3uowov.fsf@kernel.org>
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

Bastian Germann <bage@debian.org> writes:

> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
> correctly claimed to be supported by carl9170.
>
> Supposedly, the successor 802AIN2 which has an ath9k compatible chip
> whose USB ID (unknown) could be inserted instead.
>
> Drop the ID from the wrong driver.
>
> Signed-off-by: Bastian Germann <bage@debian.org>

Thanks, I see this patch now.

I guess there's a bug report somewhere, do you have a link?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
