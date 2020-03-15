Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A20185AE2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgCOHO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:14:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgCOHO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:14:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3E24013DA748D;
        Sun, 15 Mar 2020 00:14:56 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:14:55 -0700 (PDT)
Message-Id: <20200315.001455.368308354303819591.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, u9012063@gmail.com, lucien.xin@gmail.com,
        mvohra@vmware.com
Subject: Re: [PATCH net] net: ip_gre: Separate ERSPAN newlink / changelink
 callbacks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <557d411272605c1611a209389ee198c534efde56.1584099517.git.petrm@mellanox.com>
References: <557d411272605c1611a209389ee198c534efde56.1584099517.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:14:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Fri, 13 Mar 2020 13:39:36 +0200

> ERSPAN shares most of the code path with GRE and gretap code. While that
> helps keep the code compact, it is also error prone. Currently a broken
> userspace can turn a gretap tunnel into a de facto ERSPAN one by passing
> IFLA_GRE_ERSPAN_VER. There has been a similar issue in ip6gretap in the
> past.
> 
> To prevent these problems in future, split the newlink and changelink code
> paths. Split the ERSPAN code out of ipgre_netlink_parms() into a new
> function erspan_netlink_parms(). Extract a piece of common logic from
> ipgre_newlink() and ipgre_changelink() into ipgre_newlink_encap_setup().
> Add erspan_newlink() and erspan_changelink().
> 
> Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Applied and queued up for -stable, thanks.
