Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B481B53D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfEMLtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 07:49:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:55726 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728716AbfEMLtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 07:49:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC453ACC4;
        Mon, 13 May 2019 11:49:01 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 7EE1BE014B; Mon, 13 May 2019 13:49:00 +0200 (CEST)
Date:   Mon, 13 May 2019 13:49:00 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Weilong Chen <chenweilong@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
Message-ID: <20190513114900.GD22349@unicorn.suse.cz>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
 <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 07:38:37PM +0800, Weilong Chen wrote:
> 
> On 2019/5/13 15:49, Michal Kubecek wrote:
> > On Mon, May 13, 2019 at 09:33:13AM +0800, Weilong Chen wrote:
> > > The remote host answers to an ICMP timestamp request.
> > > This allows an attacker to know the time and date on your host.
> > 
> > Why is that a problem? If it is, does it also mean that it is a security
> > problem to have your time in sync (because then the attacker doesn't
> > even need ICMP timestamps to know the time and date on your host)?
> > 
> It's a low risk vulnerability(CVE-1999-0524). TCP has
> net.ipv4.tcp_timestamps = 0 to disable it.

That does not really answer my question. Even if "CVE" meant much more
back in 1999 than it does these days, none of the CVE-1999-0524
descriptions I found cares to explain why it's considered a problem that
an attacker knows time on your machine. They just claim it is. If we
assume it is a security problem, then we would have to consider having
correct time a security problem which is something I certainly don't
agree with.

One idea is that there may be applications using current time as a seed
for random number generator - but then such application is the real
problem, not having correct time.

Michal Kubecek
