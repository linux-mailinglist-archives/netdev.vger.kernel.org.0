Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A3A22BB26
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgGXAvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgGXAvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 20:51:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B033BC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:51:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C79011DB3159;
        Thu, 23 Jul 2020 17:34:46 -0700 (PDT)
Date:   Thu, 23 Jul 2020 17:51:25 -0700 (PDT)
Message-Id: <20200723.175125.1061358245366802716.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, andrea.mayer@uniroma2.it,
        rdunlap@infradead.org
Subject: Re: [PATCH net] vrf: Handle CONFIG_SYSCTL not set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723232309.48952-1-dsahern@kernel.org>
References: <20200723232309.48952-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 17:34:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu, 23 Jul 2020 17:23:09 -0600

> Randy reported compile failure when CONFIG_SYSCTL is not set/enabled:
> 
> ERROR: modpost: "sysctl_vals" [drivers/net/vrf.ko] undefined!
> 
> Fix by splitting out the sysctl init and cleanup into helpers that
> can be set to do nothing when CONFIG_SYSCTL is disabled. In addition,
> move vrf_strict_mode and vrf_strict_mode_change to above
> vrf_shared_table_handler (code move only) and wrap all of it
> in the ifdef CONFIG_SYSCTL.
> 
> Update the strict mode tests to check for the existence of the
> /proc/sys entry.
> 
> Fixes: 33306f1aaf82 ("vrf: add sysctl parameter for strict mode")
> Cc: Andrea Mayer <andrea.mayer@uniroma2.it>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied to net-next, thanks David.
