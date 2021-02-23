Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2AAA3234C8
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhBXAzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 19:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234986AbhBXAbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:31:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD3B964E05;
        Tue, 23 Feb 2021 23:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614124190;
        bh=mMfhtKCjG9wujFC2z7QhKXA24Yc4aOn4meW0ekujo7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u+vdvz7DVoKQVvutvpD21Not+T8X9M66uLchJcKVM8VuTEgYQ7j6wcu4ca8tZyutn
         Pk5r7HHXRRFmtouEvhuSrc2vVgcyRB69ya5x4qKDraZ+g77ls3emlAkJIf6LsmITyY
         Wj8zM3qp282sfUEpq452VMw6ikuZjSHmQwNkyIhANO8mmqtROK+xkCvCX5Z41RFIL7
         JCAFslnJvxn8np2pwOVtclLBGljKDG9+9dSHgqm2tyXCV3yb7jxJpL8EWyO8cIpfrk
         8362/fqZN5M2gDe7zvHGGca7XfH7XPIYWVvrnNH1dt03vHC9qML4xGeivvR/wvDDHZ
         nD99KiURNa0DA==
Date:   Tue, 23 Feb 2021 15:49:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: support MDB operations
Message-ID: <20210223154945.7723cd35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222100717.451-1-dqfext@gmail.com>
References: <20210222100717.451-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 18:07:17 +0800 DENG Qingfang wrote:
> Support port MDB add to/delete from MT7530 ARL.
> 
> As the hardware can manage multicast forwarding itself, trapping
> multicast traffic to the CPU is no longer required.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.12 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.12-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
