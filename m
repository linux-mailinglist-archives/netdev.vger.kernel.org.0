Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD6F14A1A0
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbgA0KOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:14:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbgA0KOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:14:45 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86F741512894A;
        Mon, 27 Jan 2020 02:14:43 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:14:42 +0100 (CET)
Message-Id: <20200127.111442.1993972247561151893.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jiri@mellanox.com, idosch@mellanox.com, vadimp@mellanox.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] mlxsw: minimal: Fix an error handling path in
 'mlxsw_m_port_create()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200125211847.12755-1-christophe.jaillet@wanadoo.fr>
References: <20200125211847.12755-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:14:45 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 25 Jan 2020 22:18:47 +0100

> An 'alloc_etherdev()' called is not ballanced by a corresponding
> 'free_netdev()' call in one error handling path.
> 
> Slighly reorder the error handling code to catch the missed case.
> 
> Fixes: c100e47caa8e ("mlxsw: minimal: Add ethtool support")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied and queued up for -stable, thanks.
