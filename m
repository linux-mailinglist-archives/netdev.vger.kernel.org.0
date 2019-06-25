Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CDF527C8
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbfFYJTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 05:19:05 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59942 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730620AbfFYJTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:19:05 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hfhbT-0000Wt-50; Tue, 25 Jun 2019 11:19:03 +0200
Date:   Tue, 25 Jun 2019 11:19:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ran Rozenstein <ranro@mellanox.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Message-ID: <20190625091903.gepfjgpiksslnyqy@breakpoint.cc>
References: <20190617140228.12523-1-fw@strlen.de>
 <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
 <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran Rozenstein <ranro@mellanox.com> wrote:
> > On 6/17/2019 5:02 PM, Florian Westphal wrote:
> > > Tariq reported a soft lockup on net-next that Mellanox was able to
> > > bisect to 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list").
> > >
> > > While reviewing above patch I found a regression when addresses have a
> > > lifetime specified.
> > >
> > > Second patch extends rtnetlink.sh to trigger crash (without first
> > > patch applied).
> > >
> > 
> > Thanks Florian.
> > 
> > Ran, can you please test?
> 
> Tested, still reproduce.

Can you be a little more specific? Is there any reproducer?
