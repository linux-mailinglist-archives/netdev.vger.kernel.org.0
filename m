Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE242EB6DB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbhAFA1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:27:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55102 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbhAFA1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:27:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 255934D87FCEF;
        Tue,  5 Jan 2021 16:26:41 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:26:40 -0800 (PST)
Message-Id: <20210105.162640.1289650521957881983.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        jouni.hogander@unikie.com
Subject: Re: [PATCH net] net: vlan: avoid leaks on register_vlan_dev()
 failures
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201231034027.1570026-1-kuba@kernel.org>
References: <20201231034027.1570026-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:26:41 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 30 Dec 2020 19:40:27 -0800

> VLAN checks for NETREG_UNINITIALIZED to distinguish between
> registration failure and unregistration in progress.
> 
> Since commit cb626bf566eb ("net-sysfs: Fix reference count leak")
> registration failure may, however, result in NETREG_UNREGISTERED
> as well as NETREG_UNINITIALIZED.
> 
> This fix is similer to cebb69754f37 ("rtnetlink: Fix
> memory(net_device) leak when ->newlink fails")
> 
> Fixes: cb626bf566eb ("net-sysfs: Fix reference count leak")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Found by code inspection and compile-tested only.

This entire area is inconsistent, and confusing at best.

Applied and queued up for -stable, thanks.

