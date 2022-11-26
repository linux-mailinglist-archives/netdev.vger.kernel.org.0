Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FD6639514
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiKZJ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiKZJ6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:58:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C7183BC;
        Sat, 26 Nov 2022 01:58:21 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669456700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wi8dyZVc9G68XjdhvfH69E6KNFmTjqXlbORVLEosFQc=;
        b=LJKKvsBWN7LXHT5nzOA2v68vVqlrTAkX03Brma48/LtxbfnSZl/oj/iNuDHQZ+UUXtxHoz
        Vd/ejCgFAkLL6VDgcUCP3sGNZkxRqTkLaQLUgZ5HHFWDg4CA8+5DPQlnYTpCYJgX45MIda
        y01qSF3Gj8BAxOkLjVwm1w1FPvBX3MRnwv58uyAF9WJsdVN6TL48azd41ogOE3ybY2BKKw
        a+jvWhSdk5FhobeWNntT6+F2eszXtqEnQDXfw7sVeuGvjb60A0Y9RH69CDsYgB3fGgPaGP
        W0w1s0mbbW+Dju09yWVVWAmYPRyDPNGTrXe8tRlWl+XPXhz91rtzgjcerWuYgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669456700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Wi8dyZVc9G68XjdhvfH69E6KNFmTjqXlbORVLEosFQc=;
        b=h23byget21rMZ+xhpsHEnPCkPlduNa+YELBut/oVhy8qugde9/hK1A81ucR76p2ISiNjBG
        yweu3H01ToG779AA==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 8/8] selftests: Add a basic HSR test.
In-Reply-To: <20221125165610.3802446-9-bigeasy@linutronix.de>
References: <20221125165610.3802446-1-bigeasy@linutronix.de>
 <20221125165610.3802446-9-bigeasy@linutronix.de>
Date:   Sat, 26 Nov 2022 10:58:18 +0100
Message-ID: <877czidolh.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Fri Nov 25 2022, Sebastian Andrzej Siewior wrote:
> This test adds a basic HSRv0 network with 3 nodes. In its current shape
> it sends and forwards packets, announcements and so merges nodes based
> on MAC A/B information.
> It is able to detect duplicate packets and packetloss should any occur.
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

I guess, support for version 1 and PRP can be added later.

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOB4zoTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgoVVD/43y204sbfWj+CZzQriGx+rszYBWcuy
4kRUBBf1AFjch+HqVv+fRKn38vZ21CLyp+FI+8ZHzV+5MRCdtLmyNf66Oagt5hvg
vtDD1aM3hgI+bQZJAADXYaSTbuftbqLPKli4aRseg/ESzSye6Oyr2PgoxKL6Qja1
D2VKhkaGar2LMiD1aDjZCUJ7BCy5azNdpYiG4q0MmI9P7rY1XLwzH+fkVdvTJnSS
mDF8pOf9ClFn9GzsuGQi5IKew0ovlJ49z5eO/dUeaTzG96K/GpVPBi3j+1UWJTav
qa/Y9p4e3gHwe8eiRcwN23uqbTM0w3Lb55loEYrsezDvdgPIG/O1kw/s7laVaDMo
JC1qA/sD6b4Cts7QnliKwl6QXg4tbYXczglwQY0+tRNizE60z1TT30PSa07pSlAF
FzVJV3R45DFSIP5EXoOmOq/8/IU6EVC0jGZFWnij38d6XbfUNbRrgfnI7cnKX20Y
/qlbwrcL4ckG3PVYCy/4gSIac9EE/TVnBiKZgXcuKJc5KD6H8YiPKNUb4jlXX61x
rHYkHmjMsP6FkicLqZtESN/Cj4Px85bseevGDjHnR1k9wQ7GhniWpSWSBtfR8n6z
f6wYnyQvEXjDq+D08kuMBUuyeBrxHGup+1bpl5kCYWAYrMTKZRP5Ps0Fb/EHg+pq
7+RdlRzoCq+FtQ==
=Ghnb
-----END PGP SIGNATURE-----
--=-=-=--
