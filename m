Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B300170D3F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 01:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgB0Acb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 19:32:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727987AbgB0Acb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 19:32:31 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E869315ADD8E8;
        Wed, 26 Feb 2020 16:32:30 -0800 (PST)
Date:   Wed, 26 Feb 2020 16:32:28 -0800 (PST)
Message-Id: <20200226.163228.593757014713725708.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226225442.9598-1-pablo@netfilter.org>
References: <20200226225442.9598-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 16:32:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 26 Feb 2020 23:54:36 +0100

> The following patchset contains Netfilter fixes:
> 
> 1) Perform garbage collection from workqueue to fix rcu detected
>    stall in ipset hash set types, from Jozsef Kadlecsik.
> 
> 2) Fix the forceadd evaluation path, also from Jozsef.
> 
> 3) Fix nft_set_pipapo selftest, from Stefano Brivio.
> 
> 4) Crash when add-flush-add element in pipapo set, also from Stefano.
>    Add test to cover this crash.
> 
> 5) Remove sysctl entry under mutex in hashlimit, from Cong Wang.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
