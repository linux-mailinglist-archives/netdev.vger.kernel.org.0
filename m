Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CE1118A28
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbfLJNtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:49:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfLJNtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 08:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TxOgTAvMrFvIY/xWQTFemzYKWt8cKg0T6qd8rkjWoAc=; b=3ktR9TNw8012Jk5deFD8YQVULI
        Tf+1U9L8eOuV8HnnIbtHluBDDixrZI/hzORPC0nme6llG5uf0hcHBzdS6k2Ra6HAmbcxDK+6e9uZC
        3t37gGvLNpYAcFXnTDrXNqa3qZ/3l/pKGmaWFkOv5mUufQDDNQsCnIqQwG2RudI9QScI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieftI-0004OR-WF; Tue, 10 Dec 2019 14:49:29 +0100
Date:   Tue, 10 Dec 2019 14:49:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/5] ethtool: provide link mode names as a
 string set
Message-ID: <20191210134928.GC16369@lunn.ch>
References: <cover.1575982069.git.mkubecek@suse.cz>
 <fe689865e1e8cda85dd0ca259c820c473bd9576c.1575982069.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe689865e1e8cda85dd0ca259c820c473bd9576c.1575982069.git.mkubecek@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 02:08:13PM +0100, Michal Kubecek wrote:
> Unlike e.g. netdev features, the ethtool ioctl interface requires link mode
> table to be in sync between kernel and userspace for userspace to be able
> to display and set all link modes supported by kernel. The way arbitrary
> length bitsets are implemented in netlink interface, this will be no longer
> needed.
> 
> To allow userspace to access all link modes running kernel supports, add
> table of ethernet link mode names and make it available as a string set to
> userspace GET_STRSET requests. Add build time check to make sure names
> are defined for all modes declared in enum ethtool_link_mode_bit_indices.
> 
> Once the string set is available, make it also accessible via ioctl.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
