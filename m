Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808C64CC1EB
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiCCPts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiCCPtr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:49:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7131EDF4AC
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:49:00 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646322537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PT6mEspkujtD5q8J30KVsTiU9pQDppJ7lGidCZAnxwM=;
        b=sfbJ4ba/v6Jlh7/wYGSzlMFkovwUq6Hw4JslfaYigyzE6/ZzKbNYrj6GS/u9/n7Nnv4MQS
        D7haiVpME/UiFQr4Z08bhZb3QGfq+fQ8/8ZyJOQ5MBAe4IiVQXrDQveXTfUK9JwZk35Wqj
        oTNjM+LhBbzjnPNkLcmXRf1B8405D7EWFJFmtfDVkb6SPbZh83dFXBB/WYjRcY5kR5RcvP
        1ngIohPEEtsEwmPwzmQ/KKViUK2My1jJJH822yF/98DHAt2M9XLeRcaVkNrWA2MEXgplJy
        hDVHD1BFsj9ThCfQJc5Lq9tQocxsADAa9n+qLq/sK5jn0/jPUpwJTmbzo2fFVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646322537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PT6mEspkujtD5q8J30KVsTiU9pQDppJ7lGidCZAnxwM=;
        b=9x6wPVxC1ET/3ltA6iBS0YGc/LjANA5e9QtHFOeoquH4LZRlXhA0Q/zV9MytYvDl8r/1gq
        /260JRF33VzxYjAA==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next v1] flow_dissector: Add support for HSR
In-Reply-To: <20220303073103.6fb2e995@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20220228195856.88187-1-kurt@linutronix.de>
 <20220302224425.410e1f15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <87ilsva264.fsf@kurt>
 <20220303073103.6fb2e995@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Date:   Thu, 03 Mar 2022 16:48:55 +0100
Message-ID: <87mti782ag.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Mar 03 2022, Jakub Kicinski wrote:
> On Thu, 03 Mar 2022 09:08:35 +0100 Kurt Kanzenbach wrote:
>> It's this statement here:
>>=20
>>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tre=
e/include/linux/skbuff.h#n2483
>>=20
>> I tried to look up, why is this a BUG_ON() in Thomas' history tree
>> [1]. Couldn't find an explanation. It's been introduced by this commit:
>
> I meant fix the caller to discard a frame if it doesn't have enough
> data - call pskb_may_pull() first, then skb_pull().

I see. Yes, the caller (hsr_forward_skb) needs fixing too.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmIg42cTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgn92D/wLg1NrYXZGZnf4nNOJnbg4lkrrWUh7
uV2Hog5o/Cq3+jrqSctwTWGOG71hZGAuaBIYHGQqOXSJyPs03r7ta0BsfbBQwzbO
wo3yDH0Y2E4cmqiYXOA7y8mNIfusm2itMbXXoN6LmtrnOmsLWq/e3kRF1dnMS3j+
EnaBZygTC+se1LWfc+07xCEC4oWjokgkS9w+2xN7j3trdXBPm/z9S0JDr9NryrZ/
yh/Hm0613GnzspEA+owwD+kBjXo8pR8SxdLFVkDuwZMex4+iVfxPUzvKFg90ZNul
vFSu7HrD0C3yrLWvx9c1Q1jHhrsUwfG+fUacza35jPS7k1iDXAfFYDATSwAw9/6i
wa3Bbxf+XQkHsdP7za0wnQgvHtdb0cDE+RMAzUqIddAOtxmaRsIOOB9GJDIICR+J
dUJD3cFljQsHo76PUs2upgOJm/wn8JwWyQLSXDdPOtDPFIibEy+fLFbo6GitL/Eu
J5CJB5uZlrjNsjQPFCvksvXCt0KmUbkHBEOwo63nG00FJzbj6tQFZOOgXQd0wl/t
h/ie3Y+ckhTEg7S9XXzelo4Wk6pXHONoBIlG6vISQGyn8KtYG6SNlzeM/N4KoWVJ
wPww+V+s15Pyo9/UJ5fuw0ED//hvB7CTzqFgNru5BgT5fYgUUy9qr/WQC/cbDBMI
iM2wxhlPuCI8Dg==
=/+0O
-----END PGP SIGNATURE-----
--=-=-=--
