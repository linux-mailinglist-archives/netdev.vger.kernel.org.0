Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3694E2EBF4A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAFOGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:06:08 -0500
Received: from smtp-out.xnet.cz ([178.217.244.18]:34645 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725803AbhAFOGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 09:06:08 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 09:06:03 EST
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 0812A18C68;
        Wed,  6 Jan 2021 14:58:04 +0100 (CET)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 0dfe3687;
        Wed, 6 Jan 2021 14:57:46 +0100 (CET)
Date:   Wed, 6 Jan 2021 14:58:01 +0100
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7915: fix misplaced #ifdef
Message-ID: <20210106135801.GA27377@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <20210103135811.3749775-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103135811.3749775-1-arnd@kernel.org>
X-PGP-Key: https://gist.githubusercontent.com/ynezz/477f6d7a1623a591b0806699f9fc8a27/raw/a0878b8ed17e56f36ebf9e06a6b888a2cd66281b/pgp-key.pub
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> [2021-01-03 14:57:55]:

Hi,

just a small nitpick,

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The lone '|' at the end of a line causes a build failure:
> 
> drivers/net/wireless/mediatek/mt76/mt7915/init.c:47:2: error: expected expression before '}' token
> 
> Replace the #ifdef with an equivalent IS_ENABLED() check.
> 
> Fixes: af901eb4ab80 ("mt76: mt7915: get rid of dbdc debugfs knob")

I think, that the correct fixes tag is following:

 Fixes: 8aa2c6f4714e ("mt76: mt7915: support 32 station interfaces")

I've used the af901eb4ab80 as well first in
https://github.com/openwrt/mt76/pull/490 but then looked at it once more and
actually found the probably correct 8aa2c6f4714e.

Cheers,

Petr
