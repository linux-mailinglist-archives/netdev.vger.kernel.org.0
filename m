Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA012AEF9
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfLZVlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:41:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43754 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:41:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D3AFB151BBE01;
        Thu, 26 Dec 2019 13:41:39 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:41:39 -0800 (PST)
Message-Id: <20191226.134139.1734199063143329763.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: Warning about use of deprecated TX
 checksum offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1577396099-3831-3-git-send-email-tom@herbertland.com>
References: <1577396099-3831-1-git-send-email-tom@herbertland.com>
        <1577396099-3831-3-git-send-email-tom@herbertland.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Dec 2019 13:41:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Thu, 26 Dec 2019 13:34:59 -0800

> +	/* NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are deprecated */
> +	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
> +		netdev_warn(dev, "NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM are considered deprecated. Please fix driver to use NETIF_F_HW_CSUM.\n");

So let's put useless messages in people's kernel logs because grep
apparently doesn't work on your computer?

Fix drivers that use that flag that you care about.

No way I am applying this series, it is ill conceived.
