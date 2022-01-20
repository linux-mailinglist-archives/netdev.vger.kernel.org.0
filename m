Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBE0494EA2
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 14:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343821AbiATNKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 08:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237896AbiATNKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 08:10:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31395C061574;
        Thu, 20 Jan 2022 05:10:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5547616B7;
        Thu, 20 Jan 2022 13:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A4C340E0;
        Thu, 20 Jan 2022 13:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642684242;
        bh=gGwrEjOgJPJihyAavR50xStBg7PD6ki0zNFrHHd3ZiE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=eTZ/DunVp5l4tt0A7I5CC7GVOZXmt/H3qih3WhWEoLFcJZM9X93YgIm1uvAKIC4Ko
         iiS9h91C8DGeXp8pnrmdkgwVybvBcYRIPZ5Ci6aNcwr41NhZFp6SSTqvWxq9ZVbiY1
         rdLOplCW17HHp9j5vlm2UB6f46U1u6UOap1Y5Mj63BWywanG8Z56aztGr0vreZbQfj
         CzM7pOKQcOeSjNhE1O6tADVG1AkuAJkvwzj4pCtKN0VMFIRUg9ZxsgscN4jopxFmtB
         4oUShwloOUN5rNee2I2T3WZnBNwLoy5uTqKCrFhBgdVUKnvcuo5bm9B3FbmqoZXu9f
         9nbtgdG2h5l0w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next 0/4] ieee802154: General preparation to scan support
References: <20220120004350.308866-1-miquel.raynal@bootlin.com>
Date:   Thu, 20 Jan 2022 15:10:37 +0200
In-Reply-To: <20220120004350.308866-1-miquel.raynal@bootlin.com> (Miquel
        Raynal's message of "Thu, 20 Jan 2022 01:43:46 +0100")
Message-ID: <87r192imcy.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miquel Raynal <miquel.raynal@bootlin.com> writes:

> These few patches are preparation patches and light cleanups before the
> introduction of scan support.
>
> David Girault (4):
>   net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
>   net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
>     menu
>   net: ieee802154: Move the address structure earlier
>   net: ieee802154: Add a kernel doc header to the ieee802154_addr
>     structure
>
>  include/net/cfg802154.h | 28 +++++++++++++++++++---------
>  net/Kconfig             |  3 +--
>  net/ieee802154/Kconfig  |  1 +
>  3 files changed, 21 insertions(+), 11 deletions(-)

Is there a reason why you cc linux-wireless? It looks like there's a
separate linux-wpan list now and people who are interested about wpan
can join that list, right?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
