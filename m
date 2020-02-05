Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6DF1534F9
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 17:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbgBEQHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 11:07:46 -0500
Received: from nautica.notk.org ([91.121.71.147]:32879 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbgBEQHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 11:07:45 -0500
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 738DAC009; Wed,  5 Feb 2020 17:07:44 +0100 (CET)
Date:   Wed, 5 Feb 2020 17:07:29 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     l29ah@cock.li
Cc:     v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] 9pnet: allow making incomplete read requests
Message-ID: <20200205160729.GA10862@nautica>
References: <20200205003457.24340-1-l29ah@cock.li>
 <20200205073504.GA16626@nautica>
 <20200205154829.wbgdp2r4gslnozpa@l29ah-x201.l29ah-x201>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205154829.wbgdp2r4gslnozpa@l29ah-x201.l29ah-x201>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l29ah@cock.li wrote on Wed, Feb 05, 2020:
> On Wed, Feb 05, 2020 at 08:35:04AM +0100, Dominique Martinet wrote:
> > I'm not sure I agree on the argument there: the waiting time is
> > unbounded for a single request as well. What's your use case?
> 
> I want to interface with synthetic file systems that represent
> arbitrary data streams.
> The one where i've hit the problem is reading the log of a XMPP chat
> client that blocks if there's no new data available.

Definitely a valid use case for 9p, please rephrase your commit message
to describe the problem a bit better.

I'll wait for a v2 removing the 'total' variable from
p9_client_read_once anyway, unless you disagree.


Thanks,
-- 
Dominique
