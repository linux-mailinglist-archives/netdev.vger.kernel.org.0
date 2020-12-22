Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB632E0435
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 03:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgLVCA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 21:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725850AbgLVCAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 21:00:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9195622B3B;
        Tue, 22 Dec 2020 01:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608602385;
        bh=MpYfLO66Zem586idWaT6mjA3K0YrVVbMETgKtaR+fnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ax/o0iayyOnKobbTkdtRrbsmWbuOfUq1MmonmYQEgnA9GCKsweJ31OM02d0pH6GFH
         QpuvWlEZE9aesiB9si0y0NHdMVLZQgeUrhzJddIOcvmGSvLPG8JdS8+sQgurJ34u+/
         fPjDpxuemG6+NDVsetQFbvde1/Ueay0LQiG8P4l1aX4RXC29q9muVedpAifc4Z3sRu
         GgfJJWvLksfDNgoDaHxfLnrbHT1Z4bpdu4YWGePqq/4KTiVPZnHY/Pf7Z5NK8KUTXf
         +1OGX5qeJkj2U992Okvyycvxyuj17PxLrrXLxU5PlyZsN+wOOuB+y09jw9BIHbCfuY
         pWIMrvtIk/tpA==
Date:   Mon, 21 Dec 2020 17:59:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v6 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201221175943.0990ee18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201219195833.29197-3-o.rempel@pengutronix.de>
References: <20201219195833.29197-1-o.rempel@pengutronix.de>
        <20201219195833.29197-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Dec 2020 20:58:33 +0100 Oleksij Rempel wrote:
> +	stats->rx_nohandler += raw.filtered;
> +	stats->rx_errors += raw.rxfcserr + raw.rxalignerr + raw.rxrunt +
> +		raw.rxfragment + raw.rxoverflow + raw.filtered + raw.rxtoolong;

What happened to my suggestion to report filtered in dropped?

If you repost before -rc1 please post as RFC as net-next is currently
closed.

--

# Form letter - net-next is closed

We have already sent the networking pull request for 5.11 and therefore
net-next is closed for new drivers, features, code refactoring and
optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after 5.11-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
