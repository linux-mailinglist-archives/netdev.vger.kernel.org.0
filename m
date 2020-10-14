Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A428D9A4
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 07:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbgJNFmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 01:42:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725983AbgJNFmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 01:42:55 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 936BB2177B;
        Wed, 14 Oct 2020 05:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602654174;
        bh=w10HAUvHzI4K2dPPA6eBw0IIFtp11qCCa0wUzKaUmD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cKsoRdZk0/7P9W5KQIcB78oxj7gSK1YWQM+hrVcStVlKqV5euxdawGaIKjsJO+YUU
         /usInNdGonQCzHNv/4cuzYg3D1kAHdZbtEGHplDqaWK5j6M3yEug5qW6hLhVGcPu6C
         Ur12VOGAV45LDfAlhlt9kErfzTLPyFZ2XWjKnbEc=
Date:   Wed, 14 Oct 2020 08:42:50 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 00/12] net: add and use function
 dev_fetch_sw_netstats for fetching pcpu_sw_netstats
Message-ID: <20201014054250.GB6305@unreal>
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
 <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013173951.25677bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 13, 2020 at 05:39:51PM -0700, Jakub Kicinski wrote:
> On Mon, 12 Oct 2020 10:00:11 +0200 Heiner Kallweit wrote:
> > In several places the same code is used to populate rtnl_link_stats64
> > fields with data from pcpu_sw_netstats. Therefore factor out this code
> > to a new function dev_fetch_sw_netstats().
> >
> > v2:
> > - constify argument netstats
> > - don't ignore netstats being NULL or an ERRPTR
> > - switch to EXPORT_SYMBOL_GPL
>
> Applied, thank you!

Jakub,

Is it possible to make sure that changelogs are not part of the commit
messages? We don't store previous revisions in the git repo, so it doesn't
give too much to anyone who is looking on git log later. The lore link
to the patch is more than enough.

44fa32f008ab ("net: add function dev_fetch_sw_netstats for fetching pcpu_sw_netstats")

Thanks
