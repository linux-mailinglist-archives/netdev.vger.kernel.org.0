Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85AE2693A0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgINRg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:36:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33972 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726034AbgINRgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 13:36:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHsPL-00Edzb-0U; Mon, 14 Sep 2020 19:36:51 +0200
Date:   Mon, 14 Sep 2020 19:36:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914173650.GD3485708@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
 <20200911170724.4b1619d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200912001542.fqn2hcp35xkwqoun@skbuf>
 <20200911174246.76466eec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <08108451-6f6a-6e89-4d2d-52e064b1342c@gmail.com>
 <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914085306.5e00833b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Can we consider using get_ethtool_stats and ETH_SS_PAUSE_STATS as a 
> > stringset identifier? That way there is a single point within driver to 
> > fetch stats.
> 
> Can you say more? There are no strings reported in this patch set.

Let me ask another question. Is pause stats the end of the story? Or
do you plan to add more use case specific statistics?

ethtool -T|--show-time-stamping could show statistics for PTP frames
sent/received?

ethtool --show-eee could show statistics for sleep/wake cycles?

ethtool --show-rxfh-indir could show RSS statistics?

Would you add a new ethtool op for each of these? Or maybe we should
duplex them all through get_ethtool_stats()?

       Andrew
