Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7024613DBFF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgAPNbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:31:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38646 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgAPNbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:31:17 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5922915B6A351;
        Thu, 16 Jan 2020 05:31:14 -0800 (PST)
Date:   Thu, 16 Jan 2020 05:31:07 -0800 (PST)
Message-Id: <20200116.053107.2118682332070479073.davem@davemloft.net>
To:     madhuparnabhowmik04@gmail.com
Cc:     gregkh@linuxfoundation.org, paulmck@kernel.org,
        joel@joelfernandes.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        frextrite@gmail.com
Subject: Re: [PATCH] net: wan: lapbether.c: Use built-in RCU list checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115114101.13068-1-madhuparnabhowmik04@gmail.com>
References: <20200115114101.13068-1-madhuparnabhowmik04@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 Jan 2020 05:31:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik04@gmail.com
Date: Wed, 15 Jan 2020 17:11:01 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> 
> The only callers of the function lapbeth_get_x25_dev()
> are lapbeth_rcv() and lapbeth_device_event().
> 
> lapbeth_rcv() uses rcu_read_lock() whereas lapbeth_device_event()
> is called with RTNL held (As mentioned in the comments).
> 
> Therefore, pass lockdep_rtnl_is_held() as cond argument in
> list_for_each_entry_rcu();
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

Applied.
