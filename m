Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85B8149CB1
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 21:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAZUGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 15:06:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59738 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgAZUGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 15:06:52 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0AC91556048F;
        Sun, 26 Jan 2020 12:06:49 -0800 (PST)
Date:   Sun, 26 Jan 2020 21:06:48 +0100 (CET)
Message-Id: <20200126.210648.1149937805028220282.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module
 for tunnelling different protocols like MPLS,IP,NSH etc.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
References: <cover.1579798999.git.martin.varghese@nokia.com>
        <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 26 Jan 2020 12:06:51 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Thu, 23 Jan 2020 23:34:15 +0530

> +#ifdef CONFIG_DST_CACHE
> +	dst_cache = (struct dst_cache *)&info->dst_cache;
> +	if (use_cache) {
> +		dst = dst_cache_get_ip6(dst_cache, &fl6->saddr);
> +		if (dst)
> +			return dst;
> +	}
> +#endif

This needs also an IPV6 ifdef guard.

The kbuild robot has reported this to you for at least v4 and v5
of this patch series.  Please do not ignore such reports.
