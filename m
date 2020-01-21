Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2FC144025
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 16:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAUPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 10:06:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38424 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUPG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 10:06:28 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B179153C716A;
        Tue, 21 Jan 2020 07:06:27 -0800 (PST)
Date:   Tue, 21 Jan 2020 16:06:23 +0100 (CET)
Message-Id: <20200121.160623.280587258366100601.davem@davemloft.net>
To:     w.dauchy@criteo.com
Cc:     netdev@vger.kernel.org, pshelar@nicira.com, u9012063@gmail.com,
        nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] net, ip_tunnel: fix namespaces move
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121142624.40174-1-w.dauchy@criteo.com>
References: <8f942c9f-206e-fecc-e2ba-8fa0eaa14464@6wind.com>
        <20200121142624.40174-1-w.dauchy@criteo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 07:06:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Dauchy <w.dauchy@criteo.com>
Date: Tue, 21 Jan 2020 15:26:24 +0100

> in the same manner as commit 690afc165bb3 ("net: ip6_gre: fix moving
> ip6gre between namespaces"), fix namespace moving as it was broken since
> commit 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.").
> Indeed, the ip6_gre commit removed the local flag for collect_md
> condition, so there is no reason to keep it for ip_gre/ip_tunnel.
> 
> this patch will fix both ip_tunnel and ip_gre modules.
> 
> Fixes: 2e15ea390e6f ("ip_gre: Add support to collect tunnel metadata.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>

Applied and queued up for -stable, thanks.
