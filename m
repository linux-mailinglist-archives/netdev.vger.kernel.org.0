Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE93495DC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfFQX2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:28:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQX2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:28:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A53E2151BAEDC;
        Mon, 17 Jun 2019 16:27:59 -0700 (PDT)
Date:   Mon, 17 Jun 2019 16:27:59 -0700 (PDT)
Message-Id: <20190617.162759.1679095918480150552.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org, tariqt@mellanox.com, ranro@mellanox.com,
        maorg@mellanox.com, edumazet@google.com
Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement
 of list pointer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617140228.12523-1-fw@strlen.de>
References: <20190617140228.12523-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 16:27:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 17 Jun 2019 16:02:26 +0200

> Tariq reported a soft lockup on net-next that Mellanox was able to
> bisect to 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list").
> 
> While reviewing above patch I found a regression when addresses have a
> lifetime specified.
> 
> Second patch extends rtnetlink.sh to trigger crash
> (without first patch applied).

Series applied, thanks Florian.
