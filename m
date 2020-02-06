Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657AB153DE4
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 05:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgBFEfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 23:35:19 -0500
Received: from ozlabs.org ([203.11.71.1]:36391 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgBFEfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 23:35:19 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48ClwM2XjNz9s29;
        Thu,  6 Feb 2020 15:35:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1580963716;
        bh=59zFNalJmp/WvnEScCF3ArwVDsj2RfvIy0ivPyUHgHA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Whkwu/LRfqatjhKrdPr0f6xAsscgI2GAcwnucCINarqZf1GbbRhy7k46Mc95LWSxm
         qrw0UUlfp3K2Y5GLbLZ5L6O2QFWD7qzytCKVyZlR99x5BsGuSsWxCI9EU07mIe+fQb
         bpSF1e9l2lrORXLJK8P2vkZRljA3gDojwjw/eKNOTAuvcg6gBadUo2Tj+HPeTgRAob
         FvYXHJbaAlsaWTzMt2Bo8615d2IFgJ8jDochbh0K3L2rvqFAY6nExHRirdN9p2hfiK
         s7nrhSFtwublQSzPKXjUpdIVC2rn+cSC8CoTDJ4i41+Ptpg2R3Em4zZ6IoRxHwp7bN
         rB/awUKLetxHQ==
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
In-Reply-To: <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de>
References: <20200203095325.24c3ab1c@cakuba.hsd1.ca.comcast.net> <C11859E1-BE71-494F-81E2-9B27E27E60EE@xenosoft.de>
Date:   Thu, 06 Feb 2020 15:35:10 +1100
Message-ID: <87tv441gg1.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Zigotzky <chzigotzky@xenosoft.de> writes:
> Kernel 5.5 PowerPC is also affected.

I don't know what you mean by that. What sha are you talking about?

I have a system with avahi running and everything's fine.

  # grep use- /etc/avahi/avahi-daemon.conf=20
  use-ipv4=3Dyes
  use-ipv6=3Dyes
=20=20
  # systemctl status -l --no-pager avahi-daemon
  =E2=97=8F avahi-daemon.service - Avahi mDNS/DNS-SD Stack
     Loaded: loaded (/lib/systemd/system/avahi-daemon.service; enabled; ven=
dor preset: enabled)
     Active: active (running) since Thu 2020-02-06 14:55:34 AEDT; 38min ago
   Main PID: 1884 (avahi-daemon)
     Status: "avahi-daemon 0.7 starting up."
     CGroup: /system.slice/avahi-daemon.service
             =E2=94=9C=E2=94=801884 avahi-daemon: running [mpe-ubuntu-le.lo=
cal]
             =E2=94=94=E2=94=801888 avahi-daemon: chroot helper
=20=20
  Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address=
 record for fe80::5054:ff:fe66:2a19 on eth0.*.
  Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address=
 record for 10.61.141.81 on eth0.IPv4.
  Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address=
 record for ::1 on lo.*.
  Feb 06 14:55:34 mpe-ubuntu-le avahi-daemon[1884]: Registering new address=
 record for 127.0.0.1 on lo.IPv4.
  Feb 06 14:55:34 mpe-ubuntu-le systemd[1]: Started Avahi mDNS/DNS-SD Stack.
  Feb 06 14:55:35 mpe-ubuntu-le avahi-daemon[1884]: Server startup complete=
. Host name is mpe-ubuntu-le.local. Local service cookie is 3972418141.
  Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Leaving mDNS multicast =
group on interface eth0.IPv6 with address fe80::5054:ff:fe66:2a19.
  Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Joining mDNS multicast =
group on interface eth0.IPv6 with address fd69:d75f:b8b5:61:5054:ff:fe66:2a=
19.
  Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Registering new address=
 record for fd69:d75f:b8b5:61:5054:ff:fe66:2a19 on eth0.*.
  Feb 06 14:55:38 mpe-ubuntu-le avahi-daemon[1884]: Withdrawing address rec=
ord for fe80::5054:ff:fe66:2a19 on eth0.
=20=20
  # uname -r
  5.5.0-gcc-8.2.0


The key question is what ioctl is it complaining about. You should be
able to find that via strace.

cheers

> Christian Zigotzky wrote:
>
> Hi All,
>
> The issue with the avahi-daemon still exist in the latest Git kernel. It'=
s a PowerPC issue. I compiled the latest Git kernel on a PC today and there=
 aren't any issues with the avahi daemon. Another Power Mac user reported t=
he same issue on his G5. I tested with the AmigaOne X1000 and X5000 in the =
last days.
>
> I bisected today but I think the result isn't correct because it found th=
e other problem with ordering of PCSCSI definition in esp_rev enum. I don't=
 know how to bisect if there is another issue at the same time. Maybe "git =
bisect skip"?
>
> 2086faae3c55a652cfbd369e18ecdb703aacc493 is the first bad commit
> commit 2086faae3c55a652cfbd369e18ecdb703aacc493
> Author: Kars de Jong <jongk@linux-m68k.org>
> Date:   Tue Nov 19 21:20:20 2019 +0100
>
>     scsi: esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum
>
>     The order of the definitions in the esp_rev enum is important. The va=
lues
>     are used in comparisons for chip features.
>
>     Add a comment to the enum explaining this.
>
>     Also, the actual values for the enum fields are irrelevant, so remove=
 the
>     explicit values (suggested by Geert Uytterhoeven). This makes adding =
a new
>     field in the middle of the enum easier.
>
>     Finally, move the PCSCSI definition to the right place in the enum. I=
n its
>     previous location, at the end of the enum, the wrong values are writt=
en to
>     the CONFIG3 register when used with FAST-SCSI targets.
>
>     Link: https://lore.kernel.org/r/20191119202021.28720-2-jongk@linux-m6=
8k.org
>     Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> :040000 040000 cdc128596e33fb60406b5de9b17b79623c187c1a 48ceab06439f95285=
e8b30181e75f9a68c25fcb5 M    drivers
