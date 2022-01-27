Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C0449E6D5
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243298AbiA0QBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:01:20 -0500
Received: from mout.gmx.net ([212.227.17.20]:48409 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbiA0QBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 11:01:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643299256;
        bh=Bt8OqLgnOxynRLY4b2b2o4iqKvPISP4pVOnQlE40P0Q=;
        h=X-UI-Sender-Class:Subject:From:In-Reply-To:Date:Cc:References:To;
        b=TmRhxbZnjdLWeK8AtacEJ8cY2Wjxnwhyk2/DWgDYS0FiGHFnsU3dI6u+Ozsbtgk3m
         ne87gvT76DJUbIYDeXb6O3bliXHP7jBuJTUm2eAmNKkPaSNyW+m3pA7I1p4BJ5WZKW
         Pik3thMZt62P2MzfQpUM7wE3eFfVN4cJnE6h1GbM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from smtpclient.apple ([77.8.117.92]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MRCKC-1msAZQ329s-00N8nl; Thu, 27
 Jan 2022 17:00:56 +0100
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [Cake] [PATCH net] sch_cake: diffserv8 CS1 should be bulk
From:   Sebastian Moeller <moeller0@gmx.de>
In-Reply-To: <db81c2b5bd1fb2fb6410ce0d04e577bbff61ee1e.camel@codeconstruct.com.au>
Date:   Thu, 27 Jan 2022 17:00:54 +0100
Cc:     =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        cake@lists.bufferbloat.net, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <82BBD116-4A04-4E19-9833-0DCB5134C73C@gmx.de>
References: <20220125060410.2691029-1-matt@codeconstruct.com.au>
 <87r18w3wvq.fsf@toke.dk> <242985FC-238B-442D-8D86-A49449FF963E@gmx.de>
 <db81c2b5bd1fb2fb6410ce0d04e577bbff61ee1e.camel@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Provags-ID: V03:K1:mHn1nyR0QjM3nDrP4h2GaDb4oo0n5u506IeJLiHOZX7NSGb6ujf
 vgUx78oY2I5h3cUmqeQx1W9OljmlDlQYgdzB3jBOawcYyExtnamDErbuwWxFKHePT+7q9JV
 Oisc33pcwrwTd5B3QEp+/7kgyo+vMmB9atwUekM8Vf6jVrWn1UwGPgAZfrxiSChE4bvF26d
 CjoIHKhzyU/mdyeZc3igg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TZMT8aeK80E=:dr9EtUL9ZOEnRAKO83tyhI
 larrGUABQmYtEnKrCyVlVvbV5hbiBIthnUxqhFFtek7RIHujSPLTJEKl8hxuxj1ciqBpeMta7
 i5KE1ijuismryE27Um3wOpPf8RsXha0YWNsV3l1r6dI/am2MLek7qQEnDK01Fugl22yuo6tkr
 f9i8u2azpC76lA64DmPE2RolbOrGRGlgLZNcNsWacWMoxW7tvA3NQJecFHTXvziQYyrTapHHu
 67Glhapok8bjudoJ1iHOW1jU0gMsPfBfArKS4pbU322UV6+/588cMqeQZB4RteFsnY3fWHu/F
 T6/VcA3yB/1GYvE62gs0c3PqP1GcRobuOhAZX904ToLhDxBfadMTwQUGLlZZQ9Hd+VIlUJffJ
 d033wmmqAIFkVhI8s6ZPMU4QWXj0mVXowi3JSCDPHXqA2FAO0FvcvzugNvOXQ8b152rVqxtXL
 Svf0f7m2+WUv7k/dwUCMGTay17vOm5wcgr4zwhLUUFTyzI9GMR/z+BsAAPPZxIS2anN7ZGXd6
 BSYxmE5kE12/JFyDv8XHsFIs372tIjW8rDoKWX59iA2VJkxYIyU6egPUX+WbppNG/Y76pt7S4
 BjCXSpGDYhv/6xkojRiy/l4au+HhvMtYbIUmcgQsYdXUdTZhdTQpAU+Kn+8hj5XCIeh+NwyJ6
 ly9isr0T+DiMwNAh1JHiXr0VvkM23EbN0mkR2inUHCGDUWzcKL9ZzQOZP/ybS7/PiMi1bQlrV
 7PDriMcM0SccBOEPRMWLyQzo3srnxCalxCtoYhvuMJd61R1P4ZKdgZu2sVsQ44JkYmGlvZcjR
 v2H12MApYPgkC4K+YM9mBf55nx3efPf++r7kI5iEtBDCagrRLYuN/pTrck5yhfWrAjzfDEHoW
 PmLs1Kp0YL/R3wuZ+sEBYAt1EAlGgkgHcHo7SbVkLe/S3spuidr2DURDXiiCDfFXlqv1Diwgz
 FTp4CMppt7L6s1s1x2V/Tv/uXrWfsEe72fVZOhphdOG2ruJoaWICY6yaojZhSAeYiAx17rhFZ
 aU14re3uV2MeuLxAR75E+lOXiEfOw3Li2H7KzfoQki7RN3AjetldwbIETrrH+J3BZMdU7asRF
 2c8s2gJBxQj9bg=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matt,


> On Jan 27, 2022, at 04:14, Matt Johnston <matt@codeconstruct.com.au> =
wrote:
>=20
> On Tue, 2022-01-25 at 12:54 +0100, Sebastian Moeller wrote:
>>=20
>> LE(1) is tin 0 the lowest
>> CS1(8) is 1 slightly above LE
>> CS0/BE(0) is 2
>> AF1x (10, 12, 14) are all in tin 1 as is CS1
> ...
>> Just as documented in the code:
>>=20
>> *		Bog Standard             (CS0 etc.)
>> *		High Throughput          (AF1x, TOS2)
>> *		Background Traffic       (CS1, LE)
>=20
> The documentation doesn't match the code though.

	Since I did not see your original mail, only Toke's response, =
which documentation is wrong here?


> Almost, but it's off by one.

	I fully believe you, but could you spell it out by showing the =
line of code and the line of documentation that are off?


> I can submit a patch instead to change the docs, though it's not clear =
the
> divergence between code and docs was intended in the first place.
>=20
> (diffserv8 also needs a description in the cake manpage, I'll send a =
patch
> for that once the order is clarified)


Regards
	Sebastian
>=20
> Cheers,
> Matt
>=20

