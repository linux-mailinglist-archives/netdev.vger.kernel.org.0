Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAFD1982AB
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgC3Rs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:48:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728124AbgC3Rs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:48:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9069D15C34B09;
        Mon, 30 Mar 2020 10:48:58 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:48:57 -0700 (PDT)
Message-Id: <20200330.104857.921940685428035705.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/26] Netfilter/IPVS updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:48:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 30 Mar 2020 02:36:42 +0200

> The following patchset contains Netfilter/IPVS updates for net-next:
> 
> 1) Add support to specify a stateful expression in set definitions,
>    this allows users to specify e.g. counters per set elements.
> 
> 2) Flowtable software counter support.
> 
> 3) Flowtable hardware offload counter support, from wenxu.
> 
> 3) Parallelize flowtable hardware offload requests, from Paul Blakey.
>    This includes a patch to add one work entry per offload command.
> 
> 4) Several patches to rework nf_queue refcount handling, from Florian
>    Westphal.
> 
> 4) A few fixes for the flowtable tunnel offload: Fix crash if tunneling
>    information is missing and set up indirect flow block as TC_SETUP_FT,
>    patch from wenxu.
> 
> 5) Stricter netlink attribute sanity check on filters, from Romain Bellan
>    and Florent Fourcot.
> 
> 5) Annotations to make sparse happy, from Jules Irenge.
> 
> 6) Improve icmp errors in debugging information, from Haishuang Yan.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thanks.
