Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD31145CF2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVUPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:15:31 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50892 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:15:31 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 969F515A15CF5;
        Wed, 22 Jan 2020 12:15:28 -0800 (PST)
Date:   Wed, 22 Jan 2020 21:15:27 +0100 (CET)
Message-Id: <20200122.211527.985762914729826752.davem@davemloft.net>
To:     w.dauchy@criteo.com
Cc:     netdev@vger.kernel.org, ast@kernel.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net, ip6_tunnel: fix namespaces move
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121204954.49585-1-w.dauchy@criteo.com>
References: <20200121204954.49585-1-w.dauchy@criteo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 12:15:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>
Date: Tue, 21 Jan 2020 21:49:54 +0100

> in the same manner as commit d0f418516022 ("net, ip_tunnel: fix
> namespaces move"), fix namespace moving as it was broken since commit
> 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel"), but for
> ipv6 this time; there is no reason to keep it for ip6_tunnel.
> 
> Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnel")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>

Applied and queued up for -stable.
