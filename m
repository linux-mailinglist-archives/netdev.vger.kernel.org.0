Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDC520B93F
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgFZTTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFZTTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 15:19:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46109C03E979;
        Fri, 26 Jun 2020 12:19:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E602120F19CB;
        Fri, 26 Jun 2020 12:19:21 -0700 (PDT)
Date:   Fri, 26 Jun 2020 12:19:20 -0700 (PDT)
Message-Id: <20200626.121920.1999662353247081439.davem@davemloft.net>
To:     natechancellor@gmail.com
Cc:     kuba@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jarod@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] bonding: Remove extraneous parentheses in
 bond_setup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200626041001.1194928-1-natechancellor@gmail.com>
References: <20200626041001.1194928-1-natechancellor@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jun 2020 12:19:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>
Date: Thu, 25 Jun 2020 21:10:02 -0700

> Clang warns:
> 
> drivers/net/bonding/bond_main.c:4657:23: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
>              ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> drivers/net/bonding/bond_main.c:4681:23: warning: equality comparison
> with extraneous parentheses [-Wparentheses-equality]
>         if ((BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP))
>              ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This warning occurs when a comparision has two sets of parentheses,
> which is usually the convention for doing an assignment within an
> if statement. Since equality comparisons do not need a second set of
> parentheses, remove them to fix the warning.
> 
> Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1066
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Applied, thank you.
