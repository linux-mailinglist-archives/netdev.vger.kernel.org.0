Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D170163362
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBRUqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:46:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37084 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727747AbgBRUqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:46:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2F09212446870;
        Tue, 18 Feb 2020 12:46:48 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:46:47 -0800 (PST)
Message-Id: <20200218.124647.1818327768943953431.davem@davemloft.net>
To:     madhuparnabhowmik10@gmail.com
Cc:     pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org
Subject: Re: [PATCH 3/4] datapath.c: Use built-in RCU list checking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218195802.2702-1-madhuparnabhowmik10@gmail.com>
References: <20200218195802.2702-1-madhuparnabhowmik10@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Feb 2020 12:46:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: madhuparnabhowmik10@gmail.com
Date: Wed, 19 Feb 2020 01:28:02 +0530

> From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> 
> hlist_for_each_entry_rcu() has built-in RCU and lock checking.
> 
> Pass cond argument to list_for_each_entry_rcu() to silence
> false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
> by default.
> 
> Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Applied.
