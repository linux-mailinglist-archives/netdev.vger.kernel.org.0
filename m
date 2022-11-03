Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6344A618ABD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiKCVmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiKCVmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:42:17 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628273B0;
        Thu,  3 Nov 2022 14:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fVVm0UAPV8PeIs24HUioytOqVaGv1XZJE9Q90cebhwg=; b=iw0l6qgc/RQ4+wlGGfXRCdn8y/
        SswSYeVBl7yBLF90HMMfQ4cQq5D7ar5JO4HEUptTBpVuJt6Qi7gTJ1C0INfO/itp8kSZU/Dxyozje
        rLDKggCKSE99LN5ucupdhGFHYR17ipn2jqvhqJ8nY9CaZQ9/1NTO3aRbIPPMvu0ZifRHNed760PYP
        y7qDd6QvJCBbO4EGyCm6gPS7cNmqh5l2WFuyn8vOa4BA9jvyc3aMWKkTVkSm8TTZVccuCLxBm8sq8
        wsbvPahKUMGU9EvFUZyMnO44Oqq1NLlIytLcZHi2FMCSh0PZeLcfARp5s0E+u8fDJxMam8YNCmvvx
        2Mp5+VSw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqhy4-008n8S-VV; Thu, 03 Nov 2022 21:41:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EA674300137;
        Thu,  3 Nov 2022 22:41:41 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CAE9420ADE7AA; Thu,  3 Nov 2022 22:41:41 +0100 (CET)
Date:   Thu, 3 Nov 2022 22:41:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/3] jump_label: Add static_key_fast_inc()
Message-ID: <Y2Q1laQoklgDtVg9@hirez.programming.kicks-ass.net>
References: <20221103212524.865762-1-dima@arista.com>
 <20221103212524.865762-2-dima@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103212524.865762-2-dima@arista.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:25:22PM +0000, Dmitry Safonov wrote:
> A helper to add another user for an existing enabled static key.

Utter lack of clue what for.

> +/***
> + * static_key_fast_inc - adds a user for a static key
> + * @key: static key that must be already enabled
> + *
> + * The caller must make sure that the static key can't get disabled while
> + * in this function. It doesn't patch jump labels, only adds a user to
> + * an already enabled static key.
> + */
> +static inline void static_key_fast_inc(struct static_key *key)
> +{
> +	STATIC_KEY_CHECK_USE(key);
> +	WARN_ON_ONCE(atomic_read(&key->enabled) < 1);
> +	atomic_inc(&key->enabled);
> +}

And no, that's racy as heck. We have things like atomic_inc_not_zero(),
I suggest looking into it.
