Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D97433019
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhJSHyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhJSHyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:54:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0F9C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:51:59 -0700 (PDT)
Date:   Tue, 19 Oct 2021 09:51:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634629916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N1138KQmyg/Cv85ZRX5laSJsJNe0tQXKE/tcTyF22c4=;
        b=JMFMSOKutfCH2gdQ1BJyY8O7ilx9ZJP8UGWL/l8RAj7CJpviXQ9UOgtTgAVUbk2ZsGpbAt
        FnqQ7X2GRBGXm0JoQj1u1wwhm3De2KeRuhQz41OQudn30vqoId9/DvSo6dNHaMwqDtDKWi
        xrZyV0bowPMHW4NkPOG+5iQhhrHHmrm1Hnizi4E/hFWW3ZHHssRO30QdV1OgBcXEtsrvif
        nwCBavZbAYvcYgGnydO6Xj/b2VvQ5M8dKOlEPtRrRNFkClfXkEG3WsdZqmRvPzO8yms3ae
        cObZDyeZykvoDVxL1Cy5UfgMBz7w4sounJnIYsvYmSiIbjhTi1wHP+mtorHE/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634629916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N1138KQmyg/Cv85ZRX5laSJsJNe0tQXKE/tcTyF22c4=;
        b=z/YdBb/szbbB1cw+Cc5gYt0s+A+bQjVAJzYfXIp/6BEY+7Lf1oYgAgpZP0dGLHweZaAkI6
        N+fGwwHVChbqW4DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH net-next 1/2] net: sched: fix logic error in
 qdisc_run_begin()
Message-ID: <20211019075155.5pn35sebyoxqqesq@linutronix.de>
References: <20211019003402.2110017-1-eric.dumazet@gmail.com>
 <20211019003402.2110017-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211019003402.2110017-2-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-18 17:34:01 [-0700], Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
> __QDISC_STATE_RUNNING and should return true if the bit was not set.
> 
> test_and_set_bit() returns old bit value, therefore we need to invert.
> 
> Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
