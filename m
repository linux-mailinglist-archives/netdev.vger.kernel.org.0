Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE811B58E
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbfEMMLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:11:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:59740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727830AbfEMMLs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:11:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E70BBAF45;
        Mon, 13 May 2019 12:11:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AC891E014B; Mon, 13 May 2019 14:11:45 +0200 (CEST)
Date:   Mon, 13 May 2019 14:11:45 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Weilong Chen <chenweilong@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
Message-ID: <20190513121145.GE22349@unicorn.suse.cz>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
 <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
 <20190513114900.GD22349@unicorn.suse.cz>
 <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 08:06:37PM +0800, Weilong Chen wrote:
> On 2019/5/13 19:49, Michal Kubecek wrote:
> > One idea is that there may be applications using current time as a seed
> > for random number generator - but then such application is the real
> > problem, not having correct time.
> > 
> Yes, the target computer responded to an ICMP timestamp request. By
> accurately determining the target's clock state, an attacker can more
> effectively attack certain time-based pseudorandom number generators (PRNGs)
> and the authentication systems that rely on them.
> 
> So, the 'time' may become sensitive information. The OS should not leak it
> out.

So you are effectively saying that having correct time is a security
vulnerability?

I'm sorry but I cannot agree with that. Seeding PRNG with current time
is known to be a bad practice and if some application does it, the
solution is to fix the application, not obfuscating system time.

Michal Kubecek
