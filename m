Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFA4614070C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgAQJ5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:57:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgAQJ5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:57:40 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B33BA1555624D;
        Fri, 17 Jan 2020 01:57:37 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:57:35 -0800 (PST)
Message-Id: <20200117.015735.420636894227257674.davem@davemloft.net>
To:     madhuparnabhowmik04@gmail.com
Cc:     wei.liu@kernel.org, paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paulmck@kernel.org, joel@joelfernandes.org, frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH] net: xen-netback: hash.c: Use built-in RCU list
 checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200115155553.13471-1-madhuparnabhowmik04@gmail.com>
References: <20200115155553.13471-1-madhuparnabhowmik04@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jan 2020 01:57:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik04@gmail.com
Date: Wed, 15 Jan 2020 21:25:53 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
> 
> list_for_each_entry_rcu has built-in RCU and lock checking.
> Pass cond argument to list_for_each_entry_rcu.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

Applied to net-next.
