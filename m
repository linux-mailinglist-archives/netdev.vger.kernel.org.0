Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB95129FCD
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfLXJpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:45:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39056 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfLXJpu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 04:45:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CmZQpfF2KKqCrQSDgtE1O/PMKGP2vPbKUhGPW2McPRs=; b=N36NasjLedBvnaJrK5WjjpVduR
        sERBFVPgJ7/8ItPkYl3JJe8Zrd6M7jyV9D3fmGWzlhKKbaxMRwLhoRc02ynKqmNM5AHubm5VqGe6Q
        AQ9FT4jxWgMaWmnfGapj06acX7jRhB44QhJyAAVdwT1QYF5Kcrcs2UeySA00vBa5Jazc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ijgku-00015i-Gl; Tue, 24 Dec 2019 10:45:32 +0100
Date:   Tue, 24 Dec 2019 10:45:32 +0100
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
Subject: Re: [PATCH net-next v8 01/14] ethtool: introduce ethtool netlink
 interface
Message-ID: <20191224094532.GA3395@lunn.ch>
References: <cover.1577052887.git.mkubecek@suse.cz>
 <580d57d8cef89dd2a84d63f1a78a0d9a9b3d458f.1577052887.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580d57d8cef89dd2a84d63f1a78a0d9a9b3d458f.1577052887.git.mkubecek@suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 12:45:19AM +0100, Michal Kubecek wrote:
> Basic genetlink and init infrastructure for the netlink interface, register
> genetlink family "ethtool". Add CONFIG_ETHTOOL_NETLINK Kconfig option to
> make the build optional. Add initial overall interface description into
> Documentation/networking/ethtool-netlink.rst, further patches will add more
> detailed information.
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
