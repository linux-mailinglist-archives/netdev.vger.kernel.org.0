Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF9912AEBE
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfLZVL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:11:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:11:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BEBFA15110425;
        Thu, 26 Dec 2019 13:11:58 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:11:58 -0800 (PST)
Message-Id: <20191226.131158.1220959102941548829.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226163956.672174-1-pablo@netfilter.org>
References: <20191226163956.672174-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:11:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 26 Dec 2019 17:39:52 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix endianness issue in flowtable TCP flags dissector,
>    from Arnd Bergmann.
> 
> 2) Extend flowtable test script with dnat rules, from Florian Westphal.
> 
> 3) Reject padding in ebtables user entries and validate computed user
>    offset, reported by syzbot, from Florian Westphal.
> 
> 4) Fix endianness in nft_tproxy, from Phil Sutter.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thank you.
