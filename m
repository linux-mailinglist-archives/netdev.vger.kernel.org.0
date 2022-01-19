Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B980A493604
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 09:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352190AbiASIGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 03:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352034AbiASIGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 03:06:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6815BC061574;
        Wed, 19 Jan 2022 00:06:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A094A61382;
        Wed, 19 Jan 2022 08:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A523CC004E1;
        Wed, 19 Jan 2022 08:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642579591;
        bh=SCcj6+eO+kqSABLbbxGColCwz9zINcvY/v3iEtnNcdY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=OcifZszkXCKpys3gR0718mwYXkj75AYEa71+hznSsXKUHXnCYh7Glk++kCejZmcLh
         v7NTrt1Z7SDAbrxNfJJQpKKu4NojE7Rn4Ryg+e757C95vgQ2jdIbahkuW+FC5IThL4
         beQzx5eG3LXO7352iO3+h895KZfufSWQVE7RIvdVlSL57QwusZVExB9MjrnYx6E53N
         AOkSZWWHkbW5YmYIORl6DuWF31yczL6HguhVd950if0MyyppIHQwA/BSYDHWL7RcFy
         5EQwBejj6+QR3j7MR4Bt/Ke0GoiwTHisa2ghDVVhfjhh+AZ9NPEsxc/bdeAATd3QD7
         6gJ31GRLQ0wEw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless,v2,1/2] MAINTAINERS: add common wireless and
 wireless-next trees
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220117181958.3509-1-kvalo@kernel.org>
References: <20220117181958.3509-1-kvalo@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au, lkp@intel.com
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164257958520.12296.8537972680747712627.kvalo@kernel.org>
Date:   Wed, 19 Jan 2022 08:06:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> wrote:

> For easier maintenance we have decided to create common wireless and
> wireless-next trees for all wireless patches. Old mac80211 and wireless-drivers
> trees will not be used anymore.
> 
> While at it, add a wiki link to wireless drivers section and a patchwork link
> to 802.11, mac80211 and rfkill sections. Also use https in patchwork links.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Kalle Valo <kvalo@kernel.org>

2 patches applied to wireless.git, thanks.

51b667a32d61 MAINTAINERS: add common wireless and wireless-next trees
a1222ca0681f MAINTAINERS: remove extra wireless section

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220117181958.3509-1-kvalo@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

