Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8227D2625A7
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgIIDIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIIDIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:08:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A58C061573;
        Tue,  8 Sep 2020 20:08:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A8C111E3E4C3;
        Tue,  8 Sep 2020 19:51:28 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:08:14 -0700 (PDT)
Message-Id: <20200908.200814.605061181268198897.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908150947.12623-1-pablo@netfilter.org>
References: <20200908150947.12623-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:51:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue,  8 Sep 2020 17:09:42 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Allow conntrack entries with l3num == NFPROTO_IPV4 or == NFPROTO_IPV6
>    only via ctnetlink, from Will McVicker.
> 
> 2) Batch notifications to userspace to improve netlink socket receive
>    utilization.
> 
> 3) Restore mark based dump filtering via ctnetlink, from Martin Willi.
> 
> 4) nf_conncount_init() fails with -EPROTO with CONFIG_IPV6, from
>    Eelco Chaudron.
> 
> 5) Containers fail to match on meta skuid and skgid, use socket user_ns
>    to retrieve meta skuid and skgid.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
