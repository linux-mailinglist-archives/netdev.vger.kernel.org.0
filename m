Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2F314F2A5
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgAaTXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:23:04 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:37490 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaTXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 14:23:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1580498581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=475KMUwh+W/5/54fUMNMhVrEiGEgG0BkyP5o/poCjIk=;
        b=Y1wkZ6At5ZQ1bhcC6hZKYluFT+vJPz6yK7Ljag2xjl8U4ZAujGX6rx+W8OlSQrIfAhXCaQ
        yO+11tdDhDi08PgkU/0ig1SLo0K6F70Yqg/1/9+ela2yPYDyuiKjCbIwt4kulktZZ8BgRK
        0K54wdA1O+ZlJo1HJ7XxIwmuEWATVN4=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+37bad4f9cb2033876f32@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Subject: Re: KMSAN: uninit-value in batadv_bla_tx
Date:   Fri, 31 Jan 2020 20:22:48 +0100
Message-ID: <2584399.6Er73V5Qae@sven-edge>
In-Reply-To: <0000000000004701a9059d7351dd@google.com>
References: <0000000000004701a9059d7351dd@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5323429.oYtFQFovjn"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5323429.oYtFQFovjn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday, 31 January 2020 18:58:13 CET syzbot wrote:
[...]
> HEAD commit:    686a4f77 kmsan: don't compile memmove
> git tree:       https://github.com/google/kmsan.git master
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b1da4ee00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e10654781bc1f11c
> dashboard link: https://syzkaller.appspot.com/bug?extid=37bad4f9cb2033876f32
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102be0a1e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=123105a5e00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+37bad4f9cb2033876f32@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in batadv_bla_tx+0x2675/0x3730 net/batman-adv/bridge_loop_avoidance.c:1960
> CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.5.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[...]

Looks like the same problem in HSR as 
 https://syzkaller.appspot.com/bug?extid=24458cef7d37351dd0c3

#syz dup: KMSAN: uninit-value in batadv_interface_tx (2)

Kind regards,
	Sven
--nextPart5323429.oYtFQFovjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl40fokACgkQXYcKB8Em
e0YVug/+Lq5g6TG+P5pDoP29Gwz/VR393Sy1CVg08+qKhg4xaXgYCd/N+qdrhHFL
9nF44JbNEcTr56+hwr382xo9Er5dwmPt2bdWqQfmg7p3gcdgNunW6E2fepA8gbrK
Xs4FQC2nmLhIS0xFPEOq39RsaCg+fuwvqufInXiG65FjasecPqqmHL8bJjsxmWK0
OJKqANFKtmLc47bvDhY8iln3snvRdqVCoT35QKkGYaCmHmOSR6029idnAXpU/4Mm
8feJ1z6oN3InoX41CHbeonATimjUvTwNuQ7w6BcrixzIACh/dM+xFEoeeaoXeFYb
ym6WH5v2e4LjrI5HkoHNqvsPAIeh/VTdvTLNEmzqhISzLZjhX4SJKE9wjIZzP7qI
ifpcRFI4a5rzedS+HzOAP417UIqXcLwVqWEWmN8F/VljEWI/ZR3LCzeNFDSzujBh
Dy+0p/te5IpWgBhAtEDfkcME1PjFIZrQSQo8DwTEE2ZrBc7rID0kmsc3m2xDcoHZ
44pdVRptM6IzSfqqdKyODB2/Q+6rusCWNFLhO9dVshacYN1MOvQzbtqQ63+TpbAe
0RqtaQGYRRhnM54tO5Ms7AzayWftal2zra2ftyFWtsok6THqNxRvYNCXiB8NGFch
VJl/HZFnh+RbgP6DnCqT0GxXpd9dEnrr/VXSq3XRsTf7rk5OR+A=
=fZ5+
-----END PGP SIGNATURE-----

--nextPart5323429.oYtFQFovjn--



