Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA25E134FFA
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 00:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAHXW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 18:22:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49446 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHXW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 18:22:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D111D158823CA;
        Wed,  8 Jan 2020 15:22:56 -0800 (PST)
Date:   Wed, 08 Jan 2020 15:22:56 -0800 (PST)
Message-Id: <20200108.152256.61418150289376346.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 15:22:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu,  9 Jan 2020 00:17:04 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Missing netns context in arp_tables, from Florian Westphal.
> 
> 2) Underflow in flowtable reference counter, from wenxu.
> 
> 3) Fix incorrect ethernet destination address in flowtable offload,
>    from wenxu.
> 
> 4) Check for status of neighbour entry, from wenxu.
> 
> 5) Fix NAT port mangling, from wenxu.
> 
> 6) Unbind callbacks from destroy path to cleanup hardware properly
>    on flowtable removal.
> 
> 7) Fix missing casting statistics timestamp, add nf_flowtable_time_stamp
>    and use it.
> 
> 8) NULL pointer exception when timeout argument is null in conntrack
>    dccp and sctp protocol helpers, from Florian Westphal.
> 
> 9) Possible nul-dereference in ipset with IPSET_ATTR_LINENO, also from
>    Florian.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
