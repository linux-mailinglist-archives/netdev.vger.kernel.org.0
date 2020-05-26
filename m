Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC1C1E1918
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbgEZB3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZB3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:29:04 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075EFC061A0E;
        Mon, 25 May 2020 18:29:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23B33127B0440;
        Mon, 25 May 2020 18:29:03 -0700 (PDT)
Date:   Mon, 25 May 2020 18:29:01 -0700 (PDT)
Message-Id: <20200525.182901.536565434439717149.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org
Subject: Re: [PATCH 0/5] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200525215420.2290-1-pablo@netfilter.org>
References: <20200525215420.2290-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:29:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 25 May 2020 23:54:15 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Set VLAN tag in tcp reset/icmp unreachable packets to reject
>    connections in the bridge family, from Michael Braun.
> 
> 2) Incorrect subcounter flag update in ipset, from Phil Sutter.
> 
> 3) Possible buffer overflow in the pptp conntrack helper, based
>    on patch from Dan Carpenter.
> 
> 4) Restore userspace conntrack helper hook logic that broke after
>    hook consolidation rework.
> 
> 5) Unbreak userspace conntrack helper registration via
>    nfnetlink_cthelper.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
