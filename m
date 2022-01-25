Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC249B36C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 13:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386899AbiAYL50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:57:26 -0500
Received: from mout.gmx.net ([212.227.17.22]:42741 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387457AbiAYLy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 06:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643111645;
        bh=ysRRjGKIMqKJerfGK+e2tfi9u6nC1fsZO+7hFmeCsFY=;
        h=X-UI-Sender-Class:Subject:From:In-Reply-To:Date:Cc:References:To;
        b=iC9vY4YGgpXhX4vxgin8/aGaKJjNNohx05ioIwODlFtvmmGGiGkO8GGdcoSaPEQFV
         YeK6FS+9/11vHnVG3M43KSY+f6LeV+V7Wg0zju8QdhHCzRZ1bw751L601WeKcsJtiv
         LB+NSydzx4PY6R+Pnipf5i5LjKYGNLKjsmkJbQ1Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from smtpclient.apple ([77.10.95.53]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mel81-1mbc8O2nBd-00aqRr; Tue, 25
 Jan 2022 12:54:05 +0100
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [Cake] [PATCH net] sch_cake: diffserv8 CS1 should be bulk
From:   Sebastian Moeller <moeller0@gmx.de>
In-Reply-To: <87r18w3wvq.fsf@toke.dk>
Date:   Tue, 25 Jan 2022 12:54:02 +0100
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        cake@lists.bufferbloat.net, Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <242985FC-238B-442D-8D86-A49449FF963E@gmx.de>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
 <87r18w3wvq.fsf@toke.dk>
To:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Provags-ID: V03:K1:xRBUq0p2cmL2Tyd6//F4hI9GaSs0n7SFSjfHP0lnGCDNQdKcOIz
 3pyXPemrgYl+ts4qUDvbT6izfF4btaRhPH1X7T1siYDZJng6HVHtqUzKolAK5pS874ECcEu
 3xmJgK5Px8YVoIFvXw0PGBPtDO6VAf1T0O2j+zbqeXAXvI+5mrYPeTu7qyYLiBZGPCUtq8x
 2GwwPoLppbgmuewixHfrA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kXKGvUB50tI=:L5TISX4mLzPRFPACaxW6XI
 ks29m20WZ2EfwYd++gNW69R7YTf01f4dsma/9zjNO4EAwPH1J8t3b9krtueIKwe3cv+NvLAeD
 NJ7Y00YUMLfixi2cz43XELqVo/35Zyo6NMfUoGCnfEZUWZX74+0m6/5Ygo3gWK08YlnuVQH+S
 Y9EdGptQlQ3yBsE7gRn92L+YeOIIHGh95lrgnUbb8d/vUEgLmc4Mtlm4nA5iS/l/EIgxElBMA
 BVBUsTt5L+Zki8GsEHlVz8CYLry08SESGQ7fh7Nkmjc2nbgh1N15tUfr0bbfQgMPuvDD4qHzz
 sCKWupZSTPdeluJgDCqZxP8OEvVxUXvdokIuU1MVYIf5FwDBvUnTspzZIwko+J1Wnr08YEog7
 XKpyBeDt1ysHAS8VESK2vp7pYXAl2ZKYxYeDyRdMiqrSqsdBOu0MoiZS9EbYW46n/MTVgEUvD
 ZO+M0mJKJLbiYDds6Vi9N99QhAIxkeojqtCUIc7W9/v7RMEQ7+8kZWy1HGmbkPg1AEXeD3JBD
 7KlM7NcdURlEsY9XHTPYf3+Nj0p6pKa6FrJl8gWOZ99wANFxr0mdos56K/LWxHj7gTGtZH45p
 emzPU8fCxVe/HkOShiSagCUP2xZg6pzn23IEPBs4Q2yKSmDkZKDLzLD8hlf7hmc3PNA5lTcGs
 u+fYDBm58QJydyoanKlAWgA5cewcSfNiRMHqikQb0859CtHkFlfMmCGH8/tiKooM7ieU0yS2m
 ZBBMCb4+G+++Mz4lY4goJRSm+Yd6bZmOEILiv2Bc32xUU+349LY7Q6RE8RvxUacklSK6Dye99
 JQYxcB84JmAb9hS41MnaQezU8lb/94rAgo3jMjVtF0Ya+pbo9Hh1dDW/wG8pB93pbEut3aM4L
 9UEPokDXiX9c8Sr2VATC6+HG5zm/eeP/BtBov2osoxtSgcu8IO/nUC4jD+N40l7ufdLhk30CO
 RzOS1JzNBgb1KbJPHULei6yWYJRKqiytdBq2NKDQoWpfbJygJiJ/k64XWas5DoLbNZ9r2gHTL
 TaW5AfLhD71/W3WI0BuUuY4euFbFHQbUa2Ksoed1b6KwfRh26K6/wklPbuss4nMDoaSH6XSuD
 N2tRsspTHfhZuc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mmmh,


> On Jan 25, 2022, at 11:58, Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
>=20
> Matt Johnston <matt@codeconstruct.com.au> writes:
>=20
>> The CS1 priority (index 0x08) was changed from 0 to 1 when LE (index
>> 0x01) was added. This looks unintentional, it doesn't match the
>> docs and CS1 shouldn't be the same tin as AF1x
>=20
> Hmm, Kevin, any comments?

I am clearly not Kevin, but....

https://elixir.bootlin.com/linux/v5.16.2/source/net/sched/sch_cake.c
static const u8 diffserv8[] =3D {
2, 0, 1, 2, 4, 2, 2, 2,=09
1, 2, 1, 2, 1, 2, 1, 2,
5, 2, 4, 2, 4, 2, 4, 2,
3, 2, 3, 2, 3, 2, 3, 2,
6, 2, 3, 2, 3, 2, 3, 2,
6, 2, 2, 2, 6, 2, 6, 2,
7, 2, 2, 2, 2, 2, 2, 2,
7, 2, 2, 2, 2, 2, 2, 2,
};

LE(1) is tin 0 the lowest
CS1(8) is 1 slightly above LE
CS0/BE(0) is 2
AF1x (10, 12, 14) are all in tin 1 as is CS1
AF2x (18, 20, 22) in tin4
AF3x (26, 28, 30) in tin3
AF4x (34, 36, 38) in tin3

Just as documented in the code:
{
/*	Pruned list of traffic classes for typical applications:
 *
 *		Network Control          (CS6, CS7)
 *		Minimum Latency          (EF, VA, CS5, CS4)
 *		Interactive Shell        (CS2, TOS1)
 *		Low Latency Transactions (AF2x, TOS4)
 *		Video Streaming          (AF4x, AF3x, CS3)
 *		Bog Standard             (CS0 etc.)
 *		High Throughput          (AF1x, TOS2)
 *		Background Traffic       (CS1, LE)
 *
 *		Total 8 traffic classes.
 */

I note that this seems backwards, as I assumed the AFN to be in =
increasing order of priority, but at the same time I care very little =
for he 12 AF codepoints, they are not reliably end to end, and many =
important devices only allow 3 priority bits anyway, so I question =
whether they actually ever see much use at all, but that is =
tangential...


BUT IMHO the main reason for introducing LE in the first place was/is =
that CS1 often is interpreted as higher priority than CS0 (e.g. by gear =
that looks at the 3 highest TOS bits), resulting in an priority =
inversion where BK packets end up with higher priority than BE in spite =
of the senders intention being the other way round. Having CS1 in the =
same tin/priority tier as CS0 seems harmless (priorities are not =
guaranteed e2e anyway, so CS1/LE will be routinely treated equally as =
CS0/BE already and senders will need to have made peace with that =
already).


So I argue  with the introduction of LE, CS1 should be treated =
equivalently to CS0 (giving it higher priority will actively do the =
wrong thing for senders still using CS1 for background). So I agree that =
there is potential for cahnge, but that change should IMHO be to move =
CS1 to tin2 in diffserv8...

BUT to be really, really frank, none of this matters much, since DSCPs =
are not stable end to end, so local remapping seems required anyway, and =
then the re-mapper needs to look at the actual mapping scheme =
independent of the narratives given for different DSCPs/PHBs in IETF =
documents (affectionately called "DSCP-fan-fiction").

Regards
	Sebastian




>=20
> -Toke
>=20
> _______________________________________________
> Cake mailing list
> Cake@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/cake

