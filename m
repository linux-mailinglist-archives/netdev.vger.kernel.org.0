Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9F16EE8E
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbgBYTCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:02:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgBYTCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:02:06 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CE2EF13B3AC26;
        Tue, 25 Feb 2020 11:02:05 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:02:05 -0800 (PST)
Message-Id: <20200225.110205.1860690641020290592.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, chenzhou10@huawei.com, hulkci@huawei.com
Subject: Re: [PATCH net] icmp: allow icmpv6_ndo_send to work with
 CONFIG_IPV6=n
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225100535.45146-1-Jason@zx2c4.com>
References: <20200225100535.45146-1-Jason@zx2c4.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2020 11:02:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 25 Feb 2020 18:05:35 +0800

> The icmpv6_send function has long had a static inline implementation
> with an empty body for CONFIG_IPV6=n, so that code calling it doesn't
> need to be ifdef'd. The new icmpv6_ndo_send function, which is intended
> for drivers as a drop-in replacement with an identical function
> signature, should follow the same pattern. Without this patch, drivers
> that used to work with CONFIG_IPV6=n now result in a linker error.
> 
> Cc: Chen Zhou <chenzhou10@huawei.com>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 0b41713b6066 ("icmp: introduce helper for nat'd source address in network device context")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Applied, thanks Jason.
