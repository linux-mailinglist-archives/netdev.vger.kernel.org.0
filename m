Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D08947C37E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 17:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbhLUQHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 11:07:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46556 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbhLUQHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 11:07:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526A361677;
        Tue, 21 Dec 2021 16:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14B8C36AE9;
        Tue, 21 Dec 2021 16:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640102821;
        bh=+A5CotCYMy5/wBS++iRFQtujLaoDsilscRyY3Hv42uU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qlyKK+eUAcQw2XAn1lMfe8QzOAVEIkac7xtJhiGt+tjCjyAECzBkNBAhCdmGEXEpl
         yWKHlDmsDcEnwCQFjD1AtquAPG/2Dmc2OB1UCHwkMMdrFDk17x1SHW0lES3Xe7v6MN
         ecE4PGJ/634d5wpTXlBSTzGQAQwv7rTcQpehFNO3nS9YxnAgtPuZkYsxf/Rg3BxPRe
         gsCzeBleCSW9ssKMd4ftHqGBhwkL2CuVrxGzDde1e/RFIN36c4Yeyjkp9T3HhZlE8f
         gFblTOwxpAonvUMMt1IDPwwyH7C/CgRQRNJoS3TqjNW/oMzqIFuMgfSx6M/exo7TXT
         w8GyuiJviZhJQ==
Date:   Tue, 21 Dec 2021 08:07:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2021-12-21
Message-ID: <20211221080700.3554579d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211221112532.28708-1-johannes@sipsolutions.net>
References: <20211221112532.28708-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Dec 2021 12:25:31 +0100 Johannes Berg wrote:
> We have a couple more changes in the wireless stack,
> and in part I'm asking you to pull them in order to
> fix linux-next.
> 
> Note that there are two merge conflicts with net-next:
> 
>  1) There's a merge conflict in net/wireless/reg.c,
>     which is pretty simple, but you can see a sample
>     resolution from Stephen here:
>     https://lore.kernel.org/r/20211221111950.57ecc6a7@canb.auug.org.au
> 
>  2) There's an API change in mac80211-next that affects
>     code I didn't yet have, a change for ath10k is needed,
>     again from Stephen we have a sample here:
>     https://lore.kernel.org/r/20211221115004.1cd6b262@canb.auug.org.au
> 
> If you prefer I pull back net-next and fix these first,
> I can do that as well, just let me know.

Thanks for the links, pulled.

> Please pull and let me know if there's any (further) problem.

There was one faulty Fixes tag in there, FWIW.
