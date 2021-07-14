Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08F13C8723
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239774AbhGNPQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbhGNPQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 11:16:14 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E8AC061762
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:13:22 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 37so2813029pgq.0
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vPovLzh9GDyMDrFt2gJrehQ8zJP9GQ0Up/apqwPjCmc=;
        b=ROIBP/D5cS0m6FNRuCyRdXytGQVJ7FVgXFaWIJdslyh06vEoj9CuWyRjcJg44YkIbP
         nsRyugnEtB2jmaW0kyDqB93DkBNV7r2XVdOigjIlYY6nm7zqkUQtSl2rc9nl17v0ZME/
         iUAOnyxrTaIXQHIqIkhiUWxFYY5b9z0omwWwyBwLO5fzJNp4ZBIOFkdygjTX6yI5+7tj
         EYrv3sYTyUJw8XQr0gJVPoANvJQUA0dl4Jy/XKWwzK18U7ecMtfYlJu1KNQSmJ1CXu2g
         NcIDgUV1Df6M8CX4BTgEXkKNV9xbYpcx/rRvpgePs6oCkKX2JTrPtat4A7eS7E1RbydS
         o5gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=vPovLzh9GDyMDrFt2gJrehQ8zJP9GQ0Up/apqwPjCmc=;
        b=rpOxRv0I6UD7OxDiMn4L2RuGuAFbMQwUTvoijr8ZLPeoFSiRIaFJd7KMRtBvpoXgYT
         JzMAofAlKhUL+58DwOh4MSWdFPCeucyl3IeTLK8qSqox0B392S6D0zeMQfQ6/YSOcblc
         VmiGHOejRGK9YW9xc5hzQxfdh6AJMvOPGFHc23uFR8TEOgDhzK7KnrgnxD3ecqCqaKVF
         d9Z4L+Blthdf8WxhYjjKJcwnZkAj1JIujRQAeRce4I9rdXy77RJdXxqsQz4hRW2bi4rG
         gPRrakuTubrclPfThH/bECviKbSw3L/NVt8+LtNF9S+vVZzhcKcSBjvDFp1Q62M2iktG
         bLIw==
X-Gm-Message-State: AOAM531eIoslg6yDv4mc7Ez7Cyy4sUOvsCgCfTApOYCMZ8qhht0+yU4o
        +IgSxN114RjsyzCxvnfESVWepr47rJ1iew==
X-Google-Smtp-Source: ABdhPJwxfQMAEoQ5/UbQhiRQZcOXl+1nPlKHkPdVzMRr8c8TUWpJmS7IWOWrq1Nq7iF0FnAXSKqSOA==
X-Received: by 2002:a63:3186:: with SMTP id x128mr9938312pgx.379.1626275601870;
        Wed, 14 Jul 2021 08:13:21 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id r15sm3631483pgk.72.2021.07.14.08.13.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 08:13:21 -0700 (PDT)
Date:   Wed, 14 Jul 2021 08:13:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 213729] New: PMTUD failure with ECMP.
Message-ID: <20210714081318.40500a1b@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 14 Jul 2021 13:43:51 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 213729] New: PMTUD failure with ECMP.


https://bugzilla.kernel.org/show_bug.cgi?id=3D213729

            Bug ID: 213729
           Summary: PMTUD failure with ECMP.
           Product: Networking
           Version: 2.5
    Kernel Version: 5.13.0-rc5
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: skappen@mvista.com
        Regression: No

Created attachment 297849
  --> https://bugzilla.kernel.org/attachment.cgi?id=3D297849&action=3Dedit =
=20
Ecmp pmtud test setup

PMTUD failure with ECMP.

We have observed failures when PMTUD and ECMP work together.
Ping fails either through gateway1 or gateway2 when using MTU greater than
1500.
The Issue has been tested and reproduced on CentOS 8 and mainline kernels.=
=20


Kernel versions:=20
[root@localhost ~]# uname -a
Linux localhost.localdomain 4.18.0-305.3.1.el8.x86_64 #1 SMP Tue Jun 1 16:1=
4:33
UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

[root@localhost skappen]# uname -a
Linux localhost.localdomain 5.13.0-rc5 #2 SMP Thu Jun 10 05:06:28 EDT 2021
x86_64 x86_64 x86_64 GNU/Linux


Static routes with ECMP are configured like this:

[root@localhost skappen]#ip route
default proto static=20
        nexthop via 192.168.0.11 dev enp0s3 weight 1=20
        nexthop via 192.168.0.12 dev enp0s3 weight 1=20
192.168.0.0/24 dev enp0s3 proto kernel scope link src 192.168.0.4 metric 100

So the host would pick the first or the second nexthop depending on ECMP's
hashing algorithm.

When pinging the destination with MTU greater than 1500 it works through the
first gateway.

[root@localhost skappen]# ping -s1700 10.0.3.17
PING 10.0.3.17 (10.0.3.17) 1700(1728) bytes of data.
=46rom 192.168.0.11 icmp_seq=3D1 Frag needed and DF set (mtu =3D 1500)
1708 bytes from 10.0.3.17: icmp_seq=3D2 ttl=3D63 time=3D0.880 ms
1708 bytes from 10.0.3.17: icmp_seq=3D3 ttl=3D63 time=3D1.26 ms
^C
--- 10.0.3.17 ping statistics ---
3 packets transmitted, 2 received, +1 errors, 33.3333% packet loss, time 20=
03ms
rtt min/avg/max/mdev =3D 0.880/1.067/1.255/0.190 ms

The MTU also gets cached for this route as per rfc6754:

[root@localhost skappen]# ip route get 10.0.3.17
10.0.3.17 via 192.168.0.11 dev enp0s3 src 192.168.0.4 uid 0=20
=C2=A0 =C2=A0 cache expires 540sec mtu 1500=20

[root@localhost skappen]# tracepath -n 10.0.3.17
=C2=A01?: [LOCALHOST] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0pmtu 1500
=C2=A01: =C2=A0192.168.0.11 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01.475ms=20
=C2=A01: =C2=A0192.168.0.11 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.995ms=20
=C2=A02: =C2=A0192.168.0.11 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A01.075ms !H
=C2=A0 =C2=A0 =C2=A0Resume: pmtu 1500 =C2=A0 =C2=A0 =C2=A0 =C2=A0=20

However when the second nexthop is picked PMTUD breaks. In this example I p=
ing
a second interface configured on the same destination
from the same host, using the same routes and gateways. Based on ECMP's has=
hing
algorithm this host would pick the second nexthop (.2):

[root@localhost skappen]# ping -s1700 10.0.3.18
PING 10.0.3.18 (10.0.3.18) 1700(1728) bytes of data.
=46rom 192.168.0.12 icmp_seq=3D1 Frag needed and DF set (mtu =3D 1500)
=46rom 192.168.0.12 icmp_seq=3D2 Frag needed and DF set (mtu =3D 1500)
=46rom 192.168.0.12 icmp_seq=3D3 Frag needed and DF set (mtu =3D 1500)
^C
--- 10.0.3.18 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2062ms
[root@localhost skappen]# ip route get 10.0.3.18
10.0.3.18 via 192.168.0.12 dev enp0s3 src 192.168.0.4 uid 0=20
=C2=A0 =C2=A0 cache=20

[root@localhost skappen]# tracepath -n 10.0.3.18
=C2=A01?: [LOCALHOST] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0pmtu 9000
=C2=A01: =C2=A0192.168.0.12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A03.147ms=20
=C2=A01: =C2=A0192.168.0.12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.696ms=20
=C2=A02: =C2=A0192.168.0.12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.648ms pmtu 1500
=C2=A02: =C2=A0192.168.0.12 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A00.761ms !H
=C2=A0 =C2=A0 =C2=A0Resume: pmtu 1500 =C2=A0 =C2=A0=20

The ICMP frag needed reaches the host, but in this case it is ignored.
The MTU for this route does not get cached either.


It looks like mtu value from the next hop is not properly updated for some
reason.=20


Test Case:
Create 2 networks: Internal, External
Create 4 virtual machines: Client, GW-1, GW-2, Destination

Client
configure 1 NIC to internal with MTU 9000
configure static route with ECMP to GW-1 and GW-2 internal address

GW-1, GW-2
configure 2 NICs
- to internal with MTU 9000
- to external MTU 1500
- enable ip_forward
- enable packet forward

Target
configure 1 NIC to external MTU with 1500
configure multiple IP address(say IP1, IP2, IP3, IP4) on the same interface=
, so
ECMP's hashing algorithm would pick different routes

Test
ping from client to target with larger than 1500 bytes
ping the other addresses of the target so ECMP would use the other route too

Results observed:
Through GW-1 PMTUD works, after the first frag needed message the MTU is
lowered on the client side for this target. Through the GW-2 PMTUD does not,
all responses to ping are ICMP frag needed, which are not obeyed by the ker=
nel.
In all failure cases mtu is not cashed on "ip route get".

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
