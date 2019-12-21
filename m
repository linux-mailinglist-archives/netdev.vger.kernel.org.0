Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5118B1287A9
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 06:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfLUFuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 00:50:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfLUFuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 00:50:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56648153D8CF9;
        Fri, 20 Dec 2019 21:50:49 -0800 (PST)
Date:   Fri, 20 Dec 2019 21:50:48 -0800 (PST)
Message-Id: <20191220.215048.1634942767816580703.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hv_netvsc: Fix unwanted rx_table reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1576808890-71212-1-git-send-email-haiyangz@microsoft.com>
References: <1576808890-71212-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Dec 2019 21:50:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Thu, 19 Dec 2019 18:28:10 -0800

> In existing code, the receive indirection table, rx_table, is in
> struct rndis_device, which will be reset when changing MTU, ringparam,
> etc. User configured receive indirection table values will be lost.
> 
> To fix this, move rx_table to struct net_device_context, and check
> netif_is_rxfh_configured(), so rx_table will be set to default only
> if no user configured value.
> 
> Fixes: ff4a44199012 ("netvsc: allow get/set of RSS indirection table")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied.
