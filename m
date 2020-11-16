Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB5C2B547F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgKPWpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgKPWpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 17:45:23 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31B612244C;
        Mon, 16 Nov 2020 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605566722;
        bh=o0ylMVrVJM7IAJiP36bKMyH+sd1pQAuyImfQuhmIho4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AbOaC8o54CDzRWZkltrdBpsvzU3MqvdN1H8akopddv9CU4hXuGZ98LxpEReHn9XNW
         K+U39fVrcfn/JWO7jCnhTWTv1HpnVLBVFfRZEkoKn58AqWrzi6D8QSZwPq8NW6d/Xc
         GMY2+Nj7k7Vw8D7TBVejFrRA1cGuhiap1UhNA+xY=
Date:   Mon, 16 Nov 2020 14:45:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, razor@blackwall.org, jeremy@azazel.net
Subject: Re: [PATCH net-next,v3 0/9] netfilter: flowtable bridge and vlan
 enhancements
Message-ID: <20201116144521.771da0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116223615.GA6967@salvia>
References: <20201111193737.1793-1-pablo@netfilter.org>
        <20201113175556.25e57856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201114115906.GA21025@salvia>
        <87sg9cjaxo.fsf@waldekranz.com>
        <20201114090347.2e7c1457@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116221815.GA6682@salvia>
        <20201116142844.7c492fb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116223615.GA6967@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 23:36:15 +0100 Pablo Neira Ayuso wrote:
> > Are you saying A -> B traffic won't match so it will update the cache,
> > since conntrack flows are bi-directional?  
> 
> Yes, Traffic for A -> B won't match the flowtable entry, this will
> update the cache.

That's assuming there will be A -> B traffic without B sending a
request which reaches A, first.
