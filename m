Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9984515643D
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 13:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBHMgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 07:36:47 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:38003 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbgBHMgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Feb 2020 07:36:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48FBVx05h8z9sPJ;
        Sat,  8 Feb 2020 23:36:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1581165403;
        bh=TIsBMikK22tP+iVnpNdBWnTezaZnCH4QX2IsCZvPKH0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RJe6RTnIjucqdrkV1R47EoAVUruFQ21tuPJZRji3dj8PHMoMeJiDFBH0WcpE8OUbv
         wpxfqHmP9Qs1/IiKuxPCsx1YBPpZqRbXqhf6QRPj+YAkH9ema/+g9Er8KctHpzCEyY
         f6Md2+myTJ+qW6Z1mSKpjdBC0zGiAwTmcznmdNbMYECjAsN046hiVhJqXQ/WF24sgQ
         LSZX0tqiMWziqXP2NqBYLSDWl1iLv2W9qhHcynY7KxySG9dRjatXwJvBLJ/m8dg5Dg
         khxlrwC15v3zsNVTHLkC2MFi7tkjVcEkUM4y5V5GR/7bzpA5BvdqRvcEc85KgRLZif
         mZk9CrM9j07sA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christian Zigotzky <chzigotzky@xenosoft.de>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        DTML <devicetree@vger.kernel.org>,
        Darren Stevens <darren@stevens-zone.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@ozlabs.org, "contact\@a-eon.com" <contact@a-eon.com>,
        "R.T.Dickinson" <rtd2@xtra.co.nz>, Christoph Hellwig <hch@lst.de>,
        mad skateman <madskateman@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Latest Git kernel: avahi-daemon[2410]: ioctl(): Inappropriate ioctl for device
In-Reply-To: <f438e4ed-7746-1d80-6d72-455281884a1e@xenosoft.de>
References: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net> <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de> <87tv441gg1.fsf@mpe.ellerman.id.au> <f438e4ed-7746-1d80-6d72-455281884a1e@xenosoft.de>
Date:   Sat, 08 Feb 2020 23:36:34 +1100
Message-ID: <87imkh1cj1.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Zigotzky <chzigotzky@xenosoft.de> writes:
> On 06 February 2020 at 05:35 am, Michael Ellerman wrote:
>> Christian Zigotzky <chzigotzky@xenosoft.de> writes:
>>> Kernel 5.5 PowerPC is also affected.
>> I don't know what you mean by that. What sha are you talking about?
>>
>> I have a system with avahi running and everything's fine.
>>
>>    # grep use- /etc/avahi/avahi-daemon.conf
>>    use-ipv4=3Dyes
>>    use-ipv6=3Dyes
>>=20=20=20=20
>>    # systemctl status -l --no-pager avahi-daemon
>>    =E2=97=8F avahi-daemon.service - Avahi mDNS/DNS-SD Stack
>>       Loaded: loaded (/lib/systemd/system/avahi-daemon.service; enabled;=
 vendor preset: enabled)
>>       Active: active (running) since Thu 2020-02-06 14:55:34 AEDT; 38min=
 ago
>>     Main PID: 1884 (avahi-daemon)
>>       Status: "avahi-daemon 0.7 starting up."
>>       CGroup: /system.slice/avahi-daemon.service
>>               =E2=94=9C=E2=94=801884 avahi-daemon: running [mpe-ubuntu-l=
e.local]
>>               =E2=94=94=E2=94=801888 avahi-daemon: chroot helper
>>=20=20=20=20
>>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new add=
ress record for fe80::5054:ff:fe66:2a19 on eth0.*.
>>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new add=
ress record for 10.61.141.81 on eth0.IPv4.
>>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new add=
ress record for ::1 on lo.*.
>>    Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new add=
ress record for 127.0.0.1 on lo.IPv4.
>>    Feb 06 14:55:34 mpe-ubuntu-le systemd[1]: Started Avahi mDNS/DNS-SD S=
tack.
>>    Feb 06 14:55:35 mpe-ubuntu-le avahi-daemon[1884]: Server startup comp=
lete. Host name is mpe-ubuntu-le.local. Local service cookie is 3972418141.
>>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Leaving mDNS multic=
ast group on interface eth0.IPv6 with address fe80::5054:ff:fe66:2a19.
>>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Joining mDNS multic=
ast group on interface eth0.IPv6 with address fd69:d75f:b8b5:61:5054:ff:fe6=
6:2a19.
>>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Registering new add=
ress record for fd69:d75f:b8b5:61:5054:ff:fe66:2a19 on eth0.*.
>>    Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Withdrawing address=
 record for fe80::5054:ff:fe66:2a19 on eth0.
>>=20=20=20=20
>>    # uname -r
>>    5.5.0-gcc-8.2.0
>>
>>
>> The key question is what ioctl is it complaining about. You should be
>> able to find that via strace.
>>
>> cheers
>>
> Hello Michael,
>
> Sorry it isn't true that the kernel 5.5 is also affected. A Power Mac G5=
=20
> user told me that but this isn't correct. I compiled and tested the=20
> stable kernel 5.5.1 and 5.5.2 today and both kernels don't have the=20
> issue with the avahi daemon.

OK good to know.

> Could you please also test the latest Git kernel?

That's literally all I ever do.

The problem here is you didn't tell me you were running a big endian
distro, which uses compat mode.

In hindsight I should have thought of that.

Now that I know that, I can reproduce the bug:

  Feb 08 23:31:12 mpe-ubuntu-be avahi-daemon[24819]: ioctl(): Inappropriate=
 ioctl for device
  Feb 08 23:31:12 mpe-ubuntu-be avahi-daemon[24819]: ioctl(): Inappropriate=
 ioctl for device
  Feb 08 23:31:12 mpe-ubuntu-be avahi-daemon[24819]: ioctl(): Inappropriate=
 ioctl for device
  Feb 08 23:31:12 mpe-ubuntu-be avahi-daemon[24819]: ioctl(): Inappropriate=
 ioctl for device


But it seems you've already identified the problem commit, thanks for
bisecting.

I'm sure Arnd will be able to fix it now that you've identified the
problematic commit.

cheers


> strace /usr/sbin/avahi-daemon
>
> ...
> poll([{fd=3D4, events=3DPOLLIN}, {fd=3D16, events=3DPOLLIN}, {fd=3D15,=20
> events=3DPOLLIN}, {fd=3D14, events=3DPOLLIN}, {fd=3D13, events=3DPOLLIN},=
 {fd=3D12,=20
> events=3DPOLLIN}, {fd=3D11, events=3DPOLLIN}, {fd=3D10, events=3DPOLLIN},=
 {fd=3D9,=20
> events=3DPOLLIN}, {fd=3D8, events=3DPOLLIN}, {fd=3D6, events=3DPOLLIN}], =
11, 65) =3D=20
> 2 ([{fd=3D12, revents=3DPOLLIN}, {fd=3D9, revents=3DPOLLIN}])
> ioctl(12, FIONREAD, 0xffba6f24)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 =3D -1 ENOTTY (Inappropriate ioctl=20
> for device)
> write(2, "ioctl(): Inappropriate ioctl for"..., 39ioctl(): Inappropriate=
=20
> ioctl for device) =3D 39
> write(2, "\n", 1
> )=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D 1
> ...
>
> Thanks,
> Christian
