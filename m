Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019201C7B4A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgEFUbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbgEFUbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:31:33 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEF6C061A0F;
        Wed,  6 May 2020 13:31:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49HSt76qF7z9sRY;
        Thu,  7 May 2020 06:31:27 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1588797091;
        bh=KqKCx/ji5Q8MNDlPdmAtbxR6gXS0SDdrL49oxUt0fjs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eQzEg2vLKY+eRIOixhgFyx61PBJFGcBv3S0WESeDWLlavZhLPkkK3Fb8D6yi9d69Z
         Rlyia0v0r9PvEk5ndpNM+bV+pm2Czb4azbBQ7wf8je6t5IcSbfpKtZKmLSeDw9O/Hv
         nB7ktELofJEzkewK/jACFZCpfaWYL7WQ5NXCyI+yEu2QoNSoyblu3LX5x1xku5ehxK
         HcftZ/JxlOjuOmODXfTRO7P2/aluVZL1jNnqBJaoBYv/aVG/DgT+X+rH+JLnD4xOJg
         RSelZQPNiYOylUoqBTHLeqQ4hhtHzCiLL/Pw/QpsT809M3Y8ozZdX3khl9/sFciwSC
         gZ/Gj1IWHPvHg==
Date:   Thu, 7 May 2020 06:31:25 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Amol Grover <frextrite@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Dmitry Vyukov <dvyukov@google.com>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        syzbot <syzbot+1519f497f2f9f08183c6@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "paul E. McKenney" <paulmck@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Subject: Re: linux-next boot error: WARNING: suspicious RCU usage in
 ipmr_get_table
Message-ID: <20200507063125.79827a7f@canb.auug.org.au>
In-Reply-To: <20200506153941.GA16135@kernel-dev-lenovo>
References: <000000000000df9a9805a455e07b@google.com>
        <CACT4Y+YnjK+kq0pfb5fe-q1bqe2T1jq_mvKHf--Z80Z3wkyK1Q@mail.gmail.com>
        <34558B83-103E-4205-8D3D-534978D5A498@lca.pw>
        <20200506153941.GA16135@kernel-dev-lenovo>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aJ3qZd9Qbn.Jw1EcTQ/PqS4";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aJ3qZd9Qbn.Jw1EcTQ/PqS4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 6 May 2020 21:09:41 +0530 Amol Grover <frextrite@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 09:56:59AM -0400, Qian Cai wrote:
> >=20
> > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > >> WARNING: suspicious RCU usage
> > >> 5.7.0-rc3-next-20200428-syzkaller #0 Not tainted
> > >> -----------------------------
> > >> security/integrity/evm/evm_main.c:231 RCU-list traversed in non-read=
er section!! =20
> >=20
> > Ditto.
> >  =20
> > >>=20
> > >> other info that might help us debug this:
> > >>=20
> > >>=20
> > >> rcu_scheduler_active =3D 2, debug_locks =3D 1
> > >> 2 locks held by systemd/1:
> > >> #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: sb_start_write =
include/linux/fs.h:1659 [inline]
> > >> #0: ffff888098dfa450 (sb_writers#8){.+.+}-{0:0}, at: mnt_want_write+=
0x3a/0xb0 fs/namespace.c:354
> > >> #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: ino=
de_lock include/linux/fs.h:799 [inline]
> > >> #1: ffff8880988e8310 (&type->i_mutex_dir_key#6){++++}-{3:3}, at: vfs=
_setxattr+0x92/0xf0 fs/xattr.c:219
> > >>=20
> > >> stack backtrace:
> > >> CPU: 0 PID: 1 Comm: systemd Not tainted 5.7.0-rc3-next-20200428-syzk=
aller #0
> > >> Hardware name: Google Google Compute Engine/Google Compute Engine, B=
IOS Google 01/01/2011
> > >> Call Trace:
> > >> __dump_stack lib/dump_stack.c:77 [inline]
> > >> dump_stack+0x18f/0x20d lib/dump_stack.c:118
> > >> evm_protected_xattr+0x1c2/0x210 security/integrity/evm/evm_main.c:231
> > >> evm_protect_xattr.isra.0+0xb6/0x3d0 security/integrity/evm/evm_main.=
c:318
> > >> evm_inode_setxattr+0xc4/0xf0 security/integrity/evm/evm_main.c:387
> > >> security_inode_setxattr+0x18f/0x200 security/security.c:1297
> > >> vfs_setxattr+0xa7/0xf0 fs/xattr.c:220
> > >> setxattr+0x23d/0x330 fs/xattr.c:451
> > >> path_setxattr+0x170/0x190 fs/xattr.c:470
> > >> __do_sys_setxattr fs/xattr.c:485 [inline]
> > >> __se_sys_setxattr fs/xattr.c:481 [inline]
> > >> __x64_sys_setxattr+0xc0/0x160 fs/xattr.c:481
> > >> do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> > >> entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > >> RIP: 0033:0x7fe46005e67a
> > >> Code: 48 8b 0d 21 18 2b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 bc 00 00 00 0f 05 <48> 3d 01 =
f0 ff ff 73 01 c3 48 8b 0d ee 17 2b 00 f7 d8 64 89 01 48
> > >> RSP: 002b:00007fffef423568 EFLAGS: 00000246 ORIG_RAX: 00000000000000=
bc
> > >> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fe46005e67a
> > >> RDX: 00007fffef4235e0 RSI: 0000556ea53ddf9b RDI: 0000556ea6766760
> > >> RBP: 0000556ea53ddf9b R08: 0000000000000000 R09: 0000000000000030
> > >> R10: 0000000000000020 R11: 0000000000000246 R12: 00007fffef4235e0
> > >> R13: 0000000000000020 R14: 0000000000000000 R15: 0000556ea6751700
> > >>=20
> > >> security/device_cgroup.c:357 RCU-list traversed in non-reader sectio=
n!! =20
> >=20
> > https://lore.kernel.org/lkml/20200406105950.GA2285@workstation-kernel-d=
ev/
> >=20
> > The same story. The patch had been ignored for a while.
> >  =20
>=20
> Thank you for reminding! I will resend the patches and try to get them
> merged ASAP.

I have also applied the above patch to by fixes tree from today and
will remove it when a solution is applied to some other tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/aJ3qZd9Qbn.Jw1EcTQ/PqS4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6zHp0ACgkQAVBC80lX
0Gwm1Qf/VrIceBzwt3yjxiUvEZgAwnP+zwIgFwvbW3CMzAf0QOjPM/Qx68+WaSjP
N+OxxgKbLUZa5ccequc9doY0bjsUHtKeev5Z4rCptR7TYzlWltn+PmeJkDJ8qIEt
I0WYrIrBzMO4Xf7LvC19OJbQdrQoRvIl+c6HExzXPlFFYdV9km0QRKxBtoEjW9S/
WkTHDUm7Z3Zm9yqDquQnqhgaHiESplYc+L516d6EmDXkDIJfGqZk0HjhZOjQkLQA
2wQUOrD+8E8dS7u/niRm63NlQeaq+DyHdVGqkmWZxaxzARspx89x5YPI7hKcG7rv
SOBnOvswUIgoK1ZBHb0cWnPgFPPQCg==
=+XnA
-----END PGP SIGNATURE-----

--Sig_/aJ3qZd9Qbn.Jw1EcTQ/PqS4--
