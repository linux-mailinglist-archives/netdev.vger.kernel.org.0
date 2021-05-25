Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6993908B3
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 20:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhEYSUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 14:20:17 -0400
Received: from mout.gmx.net ([212.227.17.21]:55135 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231663AbhEYSUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 14:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621966719;
        bh=/op4fcM9HVqmDEsdC29j710Me60EemTF9DQAeaZWDow=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=UK0hk/VOzky/KbKfWp/ixJOfPIAHbcmyNksZsXNH+6LtZByBr1XUXBN4hGgC90hJ5
         CFzDvk/nUeOlPo8B0WkBBb4mnNgxJS7Ca3ok1Usnv9j55waAGRtDCNf4zU0ehwIwvL
         U0/mXLM5IGBHk0J+2hWYxfIfC/Bx2fFhNWr4DBrw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.224.228] ([157.180.224.228]) by web-mail.gmx.net
 (3c-app-gmx-bs13.server.lan [172.19.170.65]) (via HTTP); Tue, 25 May 2021
 20:18:39 +0200
MIME-Version: 1.0
Message-ID: <trinity-3a2b0fba-68a6-47d1-8ed1-6f3fc0cf8200-1621966719535@3c-app-gmx-bs13>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 25 May 2021 20:18:39 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210525090846.513dddb1@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
 <20210516141745.009403b7@hermes.local>
 <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
 <20210517123628.13624eeb@hermes.local>
 <D24044ED-FAC6-4587-B157-A2082A502476@public-files.de>
 <20210524143620.465dd25d@hermes.local>
 <AACFD746-4047-49D5-81B2-C0CD5D037FAB@public-files.de>
 <20210525090846.513dddb1@hermes.local>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:R21n4AiY2iA8cz2l+0tGKIqpnFIXxIjO65QAL2k8fbDlByuaR4qPj8k9U9vy/cgHqGFwl
 tCR7ZAIMZaxY/7uQGiVwqUKJxl5ok43nfVBmYgiSyWBNuV/UcwpUiUv+yNXpxvOy3Etn8UH5NG5G
 HDMkHQxnhHU6OzGQYgxV1QEjB5Jd5VqEwbeIbTn3u995DOB8pb9dkbpAKXFfg21M3L7HISOI+0fJ
 6CL2HXsbvpwl/9KTfIk2lZXiDfbk1BNyomzWlYD8GZsjXzrrvsv4jetMwzm9Fg7cc8dj1UpRAX/U
 no=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2KLhtAS/R44=:D6QFrVMESya49wwj+NfmHc
 5J9m9VL61PSNN4B+RltyaYO2lzkpWvHHd/L46S0tERyzt2mhPW5a+e1y/08/rKronJw6oNo1q
 Yf2oQh4BRKPXA1fpemgqu3eFlCZoQAxzua9bWx44raJnJdrC5ZSbWp+U48gDtqKc5JZOqG7Lb
 6n4rGMdEQzeLJcBlilTp3rxMTdkr9iyisfrLzb9o5NUwtTv2bWms+pDufOS2L5Cu8S31Hn00D
 2tnx0wAW1FFeh1GcEv+RzyfT64rycl9NOd+fsKWO9zzYTy+Sc0tFawXlUCiaMZJc1t1tu/rqC
 vL8tHTR44Z/0ZKjbbYuIw5faSEbOowMhBRnl9axAoa6LEJKA2i0SSKqBpsQgxonOZNCgV/4xL
 eRNVce2jKWcfJum7wMxrmMaN5InzhO/njubgnZSeKVB+X96wNKx2d+MIVUNUS0IzBCWUyW2dQ
 GQKKTQVtBPj5W2k6JMeDwllPRdRyzEd1jaUcvTwPsA1aBKjEP6LjNWC5He2mx+sw2zQOdP0k4
 lfTEb//zAosKel9leSB7sXUtdtRXn2/7Y6cM9JfnUjrELedM8HxG8lNcJU8N5lGJr1+aMXIlA
 tH4fyKBTCSaiMK7qweLhqqjYvBheB1wLyHRoZaMcrtX9iXTofTjtPmO2JfipBv9mPN2jk65PK
 RaYwVZztYJLu47y0U9G3kPr1X/EX+HnExPWrZpX/6em/2G+nk+dpWSenAxItfggEqF6wGONb3
 sVEHloiMZXpPeYZ90KDVW6praX1Pr2rZCrCNdXcPjprAyvAsxQqTiTTffqlVK5aJxOI0bAdGW
 hyWXLaKJtYdbtj1cwEvClKsz6Ssm/utzzCBU2Vcm5wsySPbhg39tdM1LrOoIE8t+K24wUVJ8T
 WY3mBROdjTWpoAz579QcmJscH9VXW+ZqthM/ML1x03d2kGGkevyj+ORpbxvjRh5OQBZcRHpCV
 6CmTcqt0Y/A==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Dienstag, 25. Mai 2021 um 18:08 Uhr
> Von: "Stephen Hemminger" <stephen@networkplumber.org>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: netdev@vger.kernel.org
> Betreff: Re: Crosscompiling iproute2
>
> On Tue, 25 May 2021 17:56:09 +0200
> Frank Wunderlich <frank-w@public-files.de> wrote:
>
> > Am 24. Mai 2021 23:36:20 MESZ schrieb Stephen Hemminger <stephen@netwo=
rkplumber.org>:
> > >On Mon, 24 May 2021 21:06:02 +0200
> > >Frank Wunderlich <frank-w@public-files.de> wrote:
> > >
> > >> Am 17. Mai 2021 21:36:28 MESZ schrieb Stephen Hemminger
> > ><stephen@networkplumber.org>:
> > >> >On Mon, 17 May 2021 09:44:21 +0200
> > >> >This works for me:
> > >> >
> > >> >make CC=3D"$CC" LD=3D"$LD" HOSTCC=3Dgcc
> > >>
> > >> Hi,
> > >>
> > >> Currently have an issue i guess from install. After compile i insta=
ll
> > >into local directory,pack it and unpack on target system
> > >(/usr/local/sbin).tried
> > >>
> > >> https://github.com/frank-w/iproute2/blob/main/crosscompile.sh#L17
> > >
> > >>
> > >> Basic ip commands work,but if i try e.g. this
> > >>
> > >> ip link add name lanbr0 type bridge vlan_filtering 1
> > >vlan_default_pvid 500
> > >>
> > >> I get this:
> > >>
> > >> Garbage instead of arguments "vlan_filtering ...". Try "ip link
> > >help".
> > >>
> > >> I guess ip tries to call bridge binary from wrong path (tried
> > >$PRFX/usr/local/bin).
> > >>
> > >> regards Frank
> > >
> > >No ip command does not call bridge.
> > >
> > >More likely either your kernel is out of date with the ip command (ie
> > >new ip command is asking for
> > >something kernel doesn't understand);
> > I use 5.13-rc2 and can use the same command with debians ip command
> >
> > >or the iplink_bridge.c was not
> > >compiled as part of your compile;
> > >or simple PATH issue
> > >or your system is not handling dlopen(NULL) correctly.
> >
> > Which lib does ip load when using the vlanfiltering option?
> It is doing dlopen of itself, no other library
>
> >
> > >What happens is that the "type" field in ip link triggers the code
> > >to use dlopen as form of introspection (see get_link_kind)

this seems to be the problem:

openat(AT_FDCWD, "/usr/lib/ip/link_bridge.so", O_RDONLY|O_LARGEFILE|O_CLOE=
XEC) =3D -1 ENOENT (No such file or directory)
write(2, "Garbage instead of arguments \"vl"..., 71Garbage instead of argu=
ments "vlan_filtering ...". Try "ip link help".

i have no /usr/lib/ip directory, my package contains only lib-folder for t=
c (with dist files only because i use static linking). also there is no *.=
so in my building-directory

how should this built?

> > I can use the command without vlan_filtering option (including type br=
idge).
> >
> > Maybe missing libnml while compile can cause this? had disabled in con=
fig.mk and was not reset by make clean,manual delete causes build error,se=
e my last mail
> >
> > You can crosscompile only with CC,LD and HOSTCC set?
>
> libmnl is needed to get the error handling and a few other features.

so not needed for compilation, right? on target-system i have it

/usr/local/lib/aarch64-linux-gnu:
        libmnl.so.0 -> libmnl.so.0.2.0

regards Frank
