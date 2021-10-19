Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56A04330BC
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhJSIII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbhJSIHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:07:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602F4C061765
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 01:05:16 -0700 (PDT)
Date:   Tue, 19 Oct 2021 10:05:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634630715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1OhzQB5x7Q+0dc3smSUhqKZH2JWGk9iyku0oN4R1i7o=;
        b=zyOWSpcpmA0+0Cevb6zEjTedz2V/glZLgjOCJ0/sfICjaDrD1WLz+0XZAn9HS08TJxonfF
        jmbs2/1IwlzCPumTI2VHL5XIshNFUSK8NW9fybD0nunwIHvdz6jQ8MrSV3KjsosA6q3eeb
        n+utcm9IC7EwB7BNCc6NBgb1nHOoClMCeZv0axJto1l7MxgSYWTtldrt0EOM6zbyp2u0RY
        iBy9YJ3BoDQekS0spIo8r1EY5rJ4FIlzDmK6/IHvqOlYf3RilXvzWd8IljvM/2jg+au2nU
        lG0BVgq6Jpea4ZpC1oWJcjsiqgcJyuCZS4umlALr9utv0qPPIo0AqAW1kSH9ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634630715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1OhzQB5x7Q+0dc3smSUhqKZH2JWGk9iyku0oN4R1i7o=;
        b=Oh5pwnr8OPPWB1tK3wsdBO/CB4OmCh0k/xkq8OO0/FSqMukJntDTVznhHbmY7F+bDOPMXc
        QIkcYVGxZ8Ri5cBQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH net-next 2/2] net: sched: remove one pair of atomic
 operations
Message-ID: <20211019080513.iryw6ixjh4mgatcy@linutronix.de>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-3-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211019003402.2110017-3-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-18 17:34:02 [-0700], Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> __QDISC_STATE_RUNNING is only set/cleared from contexts owning qdisc lock.
> 
> Thus we can use less expensive bit operations, as we were doing
> before commit f9eb8aea2a1e ("net_sched: transform qdisc running bit into a seqcount")
> 
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
