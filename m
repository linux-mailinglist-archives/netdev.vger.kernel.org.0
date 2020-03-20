Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5622918C659
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCTERf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:17:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgCTERe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:17:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A56BD158FADB2;
        Thu, 19 Mar 2020 21:17:33 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:17:33 -0700 (PDT)
Message-Id: <20200319.211733.294170518187045557.davem@davemloft.net>
To:     christian.brauner@ubuntu.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org, rdunlap@infradead.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] sysfs: fix static inline declaration of
 sysfs_groups_change_owner()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319144741.3864191-1-christian.brauner@ubuntu.com>
References: <20200319142002.7382ed70@canb.auug.org.au>
        <20200319144741.3864191-1-christian.brauner@ubuntu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:17:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Thu, 19 Mar 2020 15:47:41 +0100

> The CONFIG_SYSFS declaration of sysfs_group_change_owner() is different
> from the !CONFIG_SYSFS version and thus causes build failurs when
> !CONFIG_SYSFS is set.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 303a42769c4c ("sysfs: add sysfs_group{s}_change_owner()")
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Applied, thank you.
