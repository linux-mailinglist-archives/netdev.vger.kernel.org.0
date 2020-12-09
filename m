Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB2E2D4451
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732996AbgLIO2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:28:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbgLIO2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 09:28:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kn0RC-00B44Y-9V; Wed, 09 Dec 2020 15:27:26 +0100
Date:   Wed, 9 Dec 2020 15:27:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209142726.GF2611606@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201204022025.GC2414548@lunn.ch>
 <87v9dd5n64.fsf@waldekranz.com>
 <20201207232622.GA2475764@lunn.ch>
 <87h7ov5pcu.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7ov5pcu.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I disagree. A LAG is one type of netdev that a DSA port can offload. The
> other one is the DSA port's own netdev, i.e. what we have had since time
> immemorial.
> 
> dsa_port_offloads_netdev(dp, dev)?

That is better. But a comment explaining what the function does might
be useful.

   Andrew
