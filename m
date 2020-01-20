Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD1B142681
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgATJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:01:09 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54922 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgATJBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:01:09 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C8D27153CEC17;
        Mon, 20 Jan 2020 01:01:07 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:01:06 +0100 (CET)
Message-Id: <20200120.100106.108603305356538908.davem@davemloft.net>
To:     niko.kortstrom@nokia.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116094327.11747-1-niko.kortstrom@nokia.com>
References: <20200116094327.11747-1-niko.kortstrom@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:01:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niko Kortstrom <niko.kortstrom@nokia.com>
Date: Thu, 16 Jan 2020 11:43:27 +0200

> Support for moving IPv4 GRE tunnels between namespaces was added in
> commit b57708add314 ("gre: add x-netns support"). The respective change
> for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
> did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
> another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
> ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
> namespaces.
> 
> Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>

Applied, thanks.
