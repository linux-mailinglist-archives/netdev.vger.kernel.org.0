Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA96163770
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 00:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBRXpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 18:45:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgBRXpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 18:45:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24D0215B6BECB;
        Tue, 18 Feb 2020 15:45:10 -0800 (PST)
Date:   Tue, 18 Feb 2020 15:45:09 -0800 (PST)
Message-Id: <20200218.154509.1725883151561088993.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/9] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218222101.635808-1-pablo@netfilter.org>
References: <20200218222101.635808-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 15:45:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 18 Feb 2020 23:20:52 +0100

> This batch contains Netfilter fixes for net:
> 
> 1) Restrict hashlimit size to 1048576, from Cong Wang.
> 
> 2) Check for offload flags from nf_flow_table_offload_setup(),
>    this fixes a crash in case the hardware offload is disabled.
>    From Florian Westphal.
> 
> 3) Three preparation patches to extend the conntrack clash resolution,
>    from Florian.
> 
> 4) Extend clash resolution to deal with DNS packets from the same flow
>    racing to set up the NAT configuration.
> 
> 5) Small documentation fix in pipapo, from Stefano Brivio.
> 
> 6) Remove misleading unlikely() from pipapo_refill(), also from Stefano.
> 
> 7) Reduce hashlimit mutex scope, from Cong Wang. This patch is actually
>    triggering another problem, still under discussion, another patch to
>    fix this will follow up.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
