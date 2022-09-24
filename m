Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F05C5E8B2E
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 11:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiIXJxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 05:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiIXJxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 05:53:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471F9B0894;
        Sat, 24 Sep 2022 02:53:03 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1664013180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ILxHY3TWz3amCTghU14AmHcO8sLhIbTOfXDqfFVic+0=;
        b=uPDA+iTSI6Zaa1ooqbeSoL8d7JhZbTsAhpvzmdOSZof6w1+Q1hy6Mar7GQyPX5NtwkRxJs
        vKaXrluD3fpLw3Mm126+oqMrnSiU9yueznrWcifR4K7vyo0PP2rEV/L+32sGrBdaPxhcCP
        zKKhrGqQQzg2rnWSN1Z7indpMFqjoTVU3NEnah2rI/D0JNjIx/3yYI2p0AQwQc0sLcBhe1
        ZZSNzxs10bhDqdL3DREEVvwnxTWeQPS/w8JqJcHRcGLgaO1yxPvZ+fKqdFsOZSgeCX6rqk
        cFgk+I79G8mXokijmJe/Eb0gOiK9xhGGGDP4tIARL3gW0UpKH+BjddWuDQcnng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1664013180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ILxHY3TWz3amCTghU14AmHcO8sLhIbTOfXDqfFVic+0=;
        b=2oCnuv8LHrTsMXgDCJap1SqMJorMTwJZhmzUCe3VAEYe1Lvc3RNJnOYbTQJHj11Icc6DLo
        STAAjqHqh4uHqLAA==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] Improve tsn_lib selftests for future
 distributed tasks
In-Reply-To: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
References: <20220923210016.3406301-1-vladimir.oltean@nxp.com>
Date:   Sat, 24 Sep 2022 11:52:59 +0200
Message-ID: <87bkr5aykk.fsf@kurt>
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

On Sat Sep 24 2022, Vladimir Oltean wrote:
> Some of the boards I am working with are limited in the number of ports
> that they offer, and as more TSN related selftests are added, it is
> important to be able to distribute the work among multiple boards.
> A large part of implementing that is ensuring network-wide
> synchronization, but also permitting more streams of data to flow
> through the network. There is the more important aspect of also
> coordinating the timing characteristics of those streams, and that is
> also something that is tackled, although not in this modest patch set.
> The goal here is not to introduce new selftests yet, but just to lay a
> better foundation for them. These patches are a part of the cleanup work
> I've done while working on selftests for frame preemption. They are
> regression-tested with psfp.sh.

For this series,

Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMu03sTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgnCCD/9gvTfAyxuU9tn7yTA/6CsNP2bI/5bK
HtAcw3lFVdGfVqLciUpopSZN+/pCuqit32naMsM1DqhR37aZTYjdDm1cvu26UUhg
gGmXC8RVToLt42bcRRSvRLdcvt+zyqxeCoV051DMGXmn0XF0jJe59AjLStwoK/It
nfMa4i4Jojw/ttnJqyAbQDjh2aCSkLH0xFS1MJdCKBmOMjclWLKYGsa1Ctg3YE5I
ARnEVjzz8p95QMoFUFObW5h92nIxNKikcEFD4satk8ql5GfxJOMBNR7eoYj0Y+fy
Bwr1lGbDLf8Cg3H6NURQJyrRrWWQJDftk1fzpSw5q5MCnLQuA3QZcz8P0YCAyFIt
y+83pc2E5ifVsZISXtJzERHDx063lylVM2DL7gFhNBXofnOTZ61S15vggkL8pINr
y3cicITEeJWDhRO/g0+n0u+foVLxDSMKYLG43nK0btgpkEl8Vpvr4FFUBVdU39Z0
ar0RkVGb3YVriKOfl+nv5xWX/FvCbuQFSuETv1f6XrwO+y3L8TVpLfwgkK3KyMPt
H0GUnZcPfij9qD5IZ0Jv/GlhyN2KsB6FhzQPcZ09fH6yXZBswOhs3a4TdXlDKGEH
gWYI+QN4E8aE9dZLN6sw8rV/08KIfyPzsSk5Su+exw0C9Px7jCMK2AW2QXqaTTqK
Kh2YHmzetobEHA==
=gUDW
-----END PGP SIGNATURE-----
--=-=-=--
