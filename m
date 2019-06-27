Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246C5587BE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 18:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfF0Qy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 12:54:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbfF0Qy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 12:54:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A723714DB71B4;
        Thu, 27 Jun 2019 09:54:58 -0700 (PDT)
Date:   Thu, 27 Jun 2019 09:54:58 -0700 (PDT)
Message-Id: <20190627.095458.1221651269287757130.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, ranro@mellanox.com, tariqt@mellanox.com
Subject: Re: [PATCH net-next 0/2] net: ipv4: fix circular-list infinite loop
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190627120333.12469-1-fw@strlen.de>
References: <20190627120333.12469-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 09:54:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Thu, 27 Jun 2019 14:03:31 +0200

> Tariq and Ran reported a regression caused by net-next commit
> 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list").
> 
> This happens when net.ipv4.conf.$dev.promote_secondaries sysctl is
> enabled -- we can arrange for ifa->next to point at ifa, so next
> process that tries to walk the list loops forever.
> 
> Fix this and extend rtnetlink.sh with a small test case for this.

Series applied, thanks Florian.
