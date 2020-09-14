Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08426826B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 04:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgINCIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 22:08:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgINCIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 22:08:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHdug-00EXQv-EK; Mon, 14 Sep 2020 04:08:14 +0200
Date:   Mon, 14 Sep 2020 04:08:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, mkubecek@suse.cz,
        michael.chan@broadcom.com, tariqt@nvidia.com, saeedm@nvidia.com,
        alexander.duyck@gmail.com
Subject: Re: [PATCH net-next v2 0/8] ethtool: add pause frame stats
Message-ID: <20200914020814.GE3463198@lunn.ch>
References: <20200911232853.1072362-1-kuba@kernel.org>
 <20200911234932.ncrmapwpqjnphdv5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911234932.ncrmapwpqjnphdv5@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> DSA used to override the "ethtool -S" callback of the host port, and
> append its own CPU port counters to that.

That was always a hack. It was bound to break sooner or later.

Ido planned to add statistics to devlink. I hope we can make use of
that to replace the CPU port statistics, and also add DSA port
statistics, since these interfaces do exist in devlink.

      Andrew
