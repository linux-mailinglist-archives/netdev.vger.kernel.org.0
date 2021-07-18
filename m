Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBB3CC9FB
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRRIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 13:08:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45278 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGRRIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 13:08:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B994D4D31EF42;
        Sun, 18 Jul 2021 10:05:01 -0700 (PDT)
Date:   Sun, 18 Jul 2021 10:04:57 -0700 (PDT)
Message-Id: <20210718.100457.250657299500744178.davem@davemloft.net>
To:     vvs@virtuozzo.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, dsahern@kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH NET v4 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <922a110c-4d20-a1e9-8560-8836d4ddbba1@virtuozzo.com>
References: <cover.1626177047.git.vvs@virtuozzo.com>
        <dc51dab2-8434-9f88-d6cd-4e6754383413@virtuozzo.com>
        <922a110c-4d20-a1e9-8560-8836d4ddbba1@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 18 Jul 2021 10:05:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Date: Sun, 18 Jul 2021 13:44:33 +0300

> Dear David,
> I've found that you have added v3 version of this patch into netdev-net git.
> This version had one mistake: skb_set_owner_w() should set sk not to old skb byt to new nskb.
> I've fixed it in v4 version.
> 
> Could you please drop bad v3 version and pick up fixed one ?
> Should I perhaps submit separate fixup instead?

Always submit a fixup in these situations..

Thank you.
