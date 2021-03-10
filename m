Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C158333260
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhCJAbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:31:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48546 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhCJAal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:30:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lJmkD-00A5na-OQ; Wed, 10 Mar 2021 01:30:33 +0100
Date:   Wed, 10 Mar 2021 01:30:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <YEgTKSS+3ZmeXB66@lunn.ch>
References: <20210309184244.1970173-1-tobias@waldekranz.com>
 <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
 <87h7lkow44.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7lkow44.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 10:28:11PM +0100, Tobias Waldekranz wrote:

Hi Tobias

As with Florian, i've not been following the discussion.

> Yeah sorry, I can imagine that makes no sense whatsoever without the
> context of the recent discussions. It is basically guarding against this
> situation:
> 
> .100  br0  .100
>    \  / \  /
>    lan0 lan1
> 
> $ ip link add dev br0 type bridge vlan_filtering 1
> $ ip link add dev lan0.100 link lan0 type vlan id 100
> $ ip link add dev lan1.100 link lan1 type vlan id 100
> $ ip link set dev lan0 master br0
> $ ip link set dev lan1 master br0 # This should fail

Given the complexity at hand, maybe consider putting this all into the
code?

	Andrew
