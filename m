Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEF1740C3
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 21:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB1UNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 15:13:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55908 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgB1UNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 15:13:20 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 114A6159F02C3;
        Fri, 28 Feb 2020 12:13:20 -0800 (PST)
Date:   Fri, 28 Feb 2020 12:13:19 -0800 (PST)
Message-Id: <20200228.121319.2252602037485603404.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        ktkhai@virtuozzo.com
Subject: Re: [PATCH net-next v2 0/2] net: cleanup datagram receive helpers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1582897428.git.pabeni@redhat.com>
References: <cover.1582897428.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Feb 2020 12:13:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 28 Feb 2020 14:45:20 +0100

> Several receive helpers have an optional destructor argument, which uglify
> the code a bit and is taxed by retpoline overhead.
> 
> This series refactor the code so that we can drop such optional argument,
> cleaning the helpers a bit and avoiding an indirect call in fast path.
> 
> The first patch refactor a bit the caller, so that the second patch
> actually dropping the argument is more straight-forward
> 
> v1 -> v2:
>  - call scm_stat_del() only when not peeking - Kirill
>  - fix build issue with CONFIG_INET_ESPINTCP

Series applie, thanks Paolo.
