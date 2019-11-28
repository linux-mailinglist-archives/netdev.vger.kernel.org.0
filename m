Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5983510C567
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 09:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfK1Iq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 03:46:56 -0500
Received: from dvalin.narfation.org ([213.160.73.56]:51516 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfK1Iq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 03:46:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1574930812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s8TzhMdKiX5v4SAFsZkpzZcqBHz/OSQqMD7KCPXL3Rg=;
        b=NFvPS2Oa1a8d7d6Yck2Lp/F6l7WkAx9Ly8mi8YNZPmz83Zf2sdXmAtf1xh/YJyWEjcT3E8
        7UkE5Vf3I78wi6dHpeh7u1r/T/gH8mQIYrCLJ7SZo7956lSY4QnJLMJ+p4P1SBT4u+BBWQ
        44LoIaCEV5iFkAkJS377ae9KbtbxS54=
From:   Sven Eckelmann <sven@narfation.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzkaller <syzkaller@googlegroups.com>,
        syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        =?utf-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        LKML <linux-kernel@vger.kernel.org>, mareklindner@neomailbox.ch,
        netdev <netdev@vger.kernel.org>, sw@simonwunderlich.de,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        vinicius.gomes@intel.com, wang.yi59@zte.com.cn,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: WARNING in mark_lock (3)
Date:   Thu, 28 Nov 2019 09:46:49 +0100
Message-ID: <1809369.KjlzdqruN6@sven-edge>
In-Reply-To: <CACT4Y+YwNGWCXBazm+7GHpSw-gXsxmA8NA-o7O7Mpj3d-dhGYA@mail.gmail.com>
References: <0000000000009aa32205985e78b6@google.com> <2825703.dkhYCMB3mh@sven-edge> <CACT4Y+YwNGWCXBazm+7GHpSw-gXsxmA8NA-o7O7Mpj3d-dhGYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5668474.S8tDUuPlPh"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5668474.S8tDUuPlPh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday, 28 November 2019 09:40:32 CET Dmitry Vyukov wrote:
> On Thu, Nov 28, 2019 at 8:25 AM Sven Eckelmann <sven@narfation.org> wrote:
> >
> > On Thursday, 28 November 2019 03:00:01 CET syzbot wrote:
> > [...]
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=132ee536e00000
> > > start commit:   89d57ddd Merge tag 'media/v5.5-1' of git://git.kernel.org/..
> > > git tree:       upstream
> > > final crash:    https://syzkaller.appspot.com/x/report.txt?x=10aee536e00000
> >
> > Can the syzbot infrastructure be told to ignore this crash in the bisect run?
> > Because this should be an unrelated crash which is (hopefully) fixed in
> > 40e220b4218b ("batman-adv: Avoid free/alloc race when handling OGM buffer").
> 
> +syzkaller mailing list for syzbot discussion
> 
> Hi Sven,
> 
> There is no such functionality at the moment.
> What exactly do you mean? Somehow telling it interactively? Or
> hardcode some set of crashes for linux? I don't see how any of these
> options can really work...

I was thinking more about rerunning the same bisect but tell it to assume 
"crashed: general protection fault in batadv_iv_ogm_queue_add" as OK instead 
of assuming that it is a crashed like the previous "crashed: WARNING in 
mark_lock". Just to get a non-bogus bisect result. Or try to rerun the
bisect between 40e220b4218b and 89d57dddd7d319ded00415790a0bb3c954b7e386

Kind regards,
	Sven
--nextPart5668474.S8tDUuPlPh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl3fiXkACgkQXYcKB8Em
e0aUTRAAiE/aMO9dt/lEAQXh270FSDvpoZUUk/4MxbE9B3niUjxx5CIqtT27U/4L
I0dhj04aDedv/b5yWn4F7Ru1/dkMK8fPBrrkOwXWbU3UypUtgd3PEVC9m/6hU46v
stMjVKXfWRBIU+KhS+/RHokrjyzSCqiaHMy+XXTspHy/lHe+3wz97K6ilVw+K+Kd
nUIDzRiZgnuGmHXyUZCoZw8r79CXffr9Xrmdjf48zTwVMKTYXq+AfVT4oEvcYaj+
RZ0alFRimq4y1r/4qNOE7bb4snJfzpUoPYNK3CrHoHf0ApffOf9vsjWCuvwOQAvo
NjmXHqoyyQROeksc+1aJShSgehu3Ged2nc20RbZXQKBf3Am8BzouVWu8bxTQ95OD
GoctEO9TxVRjO6bLZ35S58IbHhTJg9J4jXfysq6LbLNzFMgAC2kJPcGH8rDbeaxn
iAGJ6gOJLQICQeT9GuKuux7T7NpCcSj22+pcwXHFcGXn6EdR/ddoUuht8MNJB+qs
I3rOZ2/K2uhQlv5yPLOq8y9w0m1megfSxVKEoEaE+gDbHeqrOZGVM4cc08jHo4Xz
OAkmaQ5m6GeFiYkaO4PWDdzTbfueK3Vj97vlgj3RuH2ykL6gkXUBg1Dft+7laEb5
/JjPjbrajzioUEudQeB9TxK3oqJXUkxtDWnadAPrBtcg3XC3ZBw=
=5EiG
-----END PGP SIGNATURE-----

--nextPart5668474.S8tDUuPlPh--



