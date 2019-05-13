Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4781C1B5C2
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfEMMWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:22:13 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60456 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728833AbfEMMWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 08:22:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hQ9xw-0000wc-Q9; Mon, 13 May 2019 14:22:00 +0200
Date:   Mon, 13 May 2019 14:22:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Weilong Chen <chenweilong@huawei.com>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
Message-ID: <20190513122200.nhiwznyx4hpkmmhg@breakpoint.cc>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
 <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Weilong Chen <chenweilong@huawei.com> wrote:
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

These are not the same.

TCP timestamps (before pseudo-randomized offset were added) used to leaked
system uptime.

ICMP timestamps "leak" milliseconds since midnight. Don't see how thats
a problem.
