Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA022D6A01
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 22:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404771AbgLJVhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 16:37:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46700 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393963AbgLJVg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 16:36:57 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 4F12C4D2ED6E5;
        Thu, 10 Dec 2020 13:36:17 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:36:16 -0800 (PST)
Message-Id: <20201210.133616.1791494623281467625.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] rtnetlink: RCU-annotate both dimensions of
 rtnl_msg_handlers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201210021608.1105566-1-kuba@kernel.org>
References: <20201210021608.1105566-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 10 Dec 2020 13:36:17 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed,  9 Dec 2020 18:16:08 -0800

> We use rcu_assign_pointer to assign both the table and the entries,
> but the entries are not marked as __rcu. This generates sparse
> warnings.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
Applied.
