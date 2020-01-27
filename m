Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F41149E30
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 03:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgA0CLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 21:11:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55158 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgA0CLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 21:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y7YuVKCXqFUYF08PynV1zLsYzbNxNQ3jNx/XdrnhwM8=; b=3eLgOqDQ92tcKjx7fglJfBqCAT
        BBS/OC4CDGd/+El84Ouvrof2JgBV+0d2Ni84XolBXFyNtXqHWdVXPxtehEOKHRygOHQ/e9sVsrpX6
        jrpiPKMNhTWKN8wF8CIHGIGtfoNKA9yuR4bRYzZ/o0SeMtEoWFfu58JC7sqMBpPx7WjE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ivts4-0003xj-2k; Mon, 27 Jan 2020 03:11:24 +0100
Date:   Mon, 27 Jan 2020 03:11:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/7] ethtool: provide WoL settings with WOL_GET
 request
Message-ID: <20200127021124.GF12816@lunn.ch>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <a52977208338f48ef1383a5cd7288dd916245669.1580075977.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a52977208338f48ef1383a5cd7288dd916245669.1580075977.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 26, 2020 at 11:11:13PM +0100, Michal Kubecek wrote:
> Implement WOL_GET request to get wake-on-lan settings for a device,
> traditionally available via ETHTOOL_GWOL ioctl request.
> 
> As part of the implementation, provide symbolic names for wake-on-line

Hi Michal

LAN, not line.

> modes as ETH_SS_WOL_MODES string set.

I think it would also be good to repeat here what you have in the
cover note, that unlike the ioctl version, CAP_NET_ADMIN is required.
The cover note does get committed to the git history, but it is a lot
less likely to be seen than this patches commit message.

> +WOL_GET
> +=======
> +
> +Query device wake-on-lan settings. Unlike most "GET" type requests,
> +``ETHTOOL_MSG_WOL_GET`` requires (netns) ``CAP_NET_ADMIN`` privileges as it
> +(potentially) provides SecureOn(tm) password which is confidential.

provides _the_ SecureOn(tm)

Apart from that:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
