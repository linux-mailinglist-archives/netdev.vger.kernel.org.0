Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D2BF5A7A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfKHV5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:57:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbfKHV5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:57:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4B9EC153B4324;
        Fri,  8 Nov 2019 13:57:48 -0800 (PST)
Date:   Fri, 08 Nov 2019 13:57:47 -0800 (PST)
Message-Id: <20191108.135747.597417047789132206.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next] xfrm: add missing rcu verbs to fix data-race
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108034701.77736-1-edumazet@google.com>
References: <20191108034701.77736-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 13:57:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu,  7 Nov 2019 19:47:01 -0800

> KCSAN reported a data-race in xfrm_lookup_with_ifid() and
> xfrm_sk_free_policy() [1]

Steffen please pick this up, thank you.
