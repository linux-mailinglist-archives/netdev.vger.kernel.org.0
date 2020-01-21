Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA3E143B37
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 11:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgAUKkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 05:40:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgAUKka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 05:40:30 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAF6715C024FA;
        Tue, 21 Jan 2020 02:40:26 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:40:22 +0100 (CET)
Message-Id: <20200121.114022.1894174168297214093.davem@davemloft.net>
To:     ndev@hwipl.net
Cc:     kgraul@linux.ibm.com, ubraun@linux.ibm.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: allow unprivileged users to read
 pnet table
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200121000446.339681-1-ndev@hwipl.net>
References: <20200121000446.339681-1-ndev@hwipl.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 02:40:27 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Wippel <ndev@hwipl.net>
Date: Tue, 21 Jan 2020 01:04:46 +0100

> The current flags of the SMC_PNET_GET command only allow privileged
> users to retrieve entries from the pnet table via netlink. The content
> of the pnet table may be useful for all users though, e.g., for
> debugging smc connection problems.
> 
> This patch removes the GENL_ADMIN_PERM flag so that unprivileged users
> can read the pnet table.
> 
> Signed-off-by: Hans Wippel <ndev@hwipl.net>

Seems reasonable, applied, thanks.
