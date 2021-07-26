Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A091B3D5AFA
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhGZN2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:28:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45468 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhGZN2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 09:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zba7ivloW/GmHx9EVsC3PwYK2hWj1LO+rp/YmCsR4vw=; b=hYVqEEnCOvi66n624n6Bjs0jk8
        +XYjr6Sn1yEbi/Wn3v5nbe8KLCfXUzu/oLf2JE1ZAhGLDr/L4mSL5BdgOUucYEwwoCB3upLz/vzK4
        Krhrq5b74Y7mG81yq1sWrhkqOW+1IMuN5irm1YrKsb47MB86ToE5S41LBJ+M340mLIPs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m81H8-00EsKY-3B; Mon, 26 Jul 2021 16:08:10 +0200
Date:   Mon, 26 Jul 2021 16:08:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6 net-next 5/7] net: bridge: switchdev: let drivers
 inform which bridge ports are offloaded
Message-ID: <YP7ByrIz4LvrvIY5@lunn.ch>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
 <20210721162403.1988814-6-vladimir.oltean@nxp.com>
 <CA+G9fYtaM=hexrmMvDXzeHZKuLCp53kRYyyvbBXZzveQzgDSyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtaM=hexrmMvDXzeHZKuLCp53kRYyyvbBXZzveQzgDSyA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 07:21:20PM +0530, Naresh Kamboju wrote:
> On Wed, 21 Jul 2021 at 21:56, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >
> > On reception of an skb, the bridge checks if it was marked as 'already
> > forwarded in hardware' (checks if skb->offload_fwd_mark == 1), and if it
> > is, it assigns the source hardware domain of that skb based on the
> > hardware domain of the ingress port. Then during forwarding, it enforces
> > that the egress port must have a different hardware domain than the
> > ingress one (this is done in nbp_switchdev_allowed_egress).

> [Please ignore if it is already reported]
> 
> Following build error noticed on Linux next 20210723 tag
> with omap2plus_defconfig on arm architecture.

Hi Naresh

Please trim emails when replying. It is really annoying to have to
page down and down and down to find your part in the email, and you
always wonder if you accidentally jumped over something when paging
down at speed.

     Andrew
