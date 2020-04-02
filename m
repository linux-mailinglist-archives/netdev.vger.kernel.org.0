Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397CB19C13F
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 14:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbgDBMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 08:38:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:32855 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgDBMiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 08:38:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id c14so3079661qtp.0;
        Thu, 02 Apr 2020 05:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=+jH8hdXCd9Ym6DPhy+4AlV5854a6fLVFEkswNBLo8LQ=;
        b=saPIu+O4u8UdbNbArI5VFdJ758YePBDqI1sbTdazpSKWtd32oYAZyEzLuJLwm/s/XX
         Txvz6Dsz9X2j8e62xVLYW8rlFXCf1MF8by5eKit06LisEXIvjG+Y9MEpV8mG7/iJkBSj
         moyb7blhlk2StUF3ORFd0ONBadBL3gxGpU3tLRa8us8Khf7FNLmUnUUhmuIFvNT8JYwb
         vPE52GkFmu+PJ6cJp6H8sdR6udvWxqnJsT8UHO6ws751DO/VecOqP4ZRpdcEJiqJ7gZ/
         hGVHoMUHoWsnLpZrkm/UfRFB11vBd0wjz3NfmiW5oPm+aU8eM9QXE7n6HO6kOsEJmMJH
         No9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=+jH8hdXCd9Ym6DPhy+4AlV5854a6fLVFEkswNBLo8LQ=;
        b=C2uQYz5cWWQredHrfIN38BHsBHhZCftBS3RU4CwctLETcMSD7qbL8YQeiXmQc0CbK/
         JmyYyTgfYdAM5o2QpIelppdAFFt12SQ+MpuHdd0M8o5cKIxePoyjYeh9/7TDoHsfbInq
         Qxu+IO7JFqnZ1AQhZmqaEp0/U5vcTVAgz5ITqnPEPmqRSo7b8q83vQelJnvrErRoDfN3
         YbVTErlqB/SLQBLvAWGl+QZH7yKMl2nYPzAkH2xRNORbBboEUzsZk47mDz43uycwRXPJ
         G6PzPeN/VmhIRdx0JsXJNp2adbrKOeb8W5H7TKdY2B01rlqsnIvo/rGpgF0k8KoUNz2W
         LTcg==
X-Gm-Message-State: AGi0PubdjCi+0iLw78k8DIHCHBShXdDGxsQ/GsM+5QItY5qA1yHjMdSc
        CN+zuAkXkBJApswJ68hubfE=
X-Google-Smtp-Source: APiQypLV+xtgmiUZkI7Xe4MZVYjWaOO0etWdrNQLLA88VPy5vtl58lZ5ieLWEL5o+0XVpHzODoDKjA==
X-Received: by 2002:aed:2535:: with SMTP id v50mr2671290qtc.354.1585831091995;
        Thu, 02 Apr 2020 05:38:11 -0700 (PDT)
Received: from [10.117.94.148] ([2001:470:b16e:20::200])
        by smtp.gmail.com with ESMTPSA id l13sm3141191qke.116.2020.04.02.05.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 05:38:11 -0700 (PDT)
User-Agent: Microsoft-MacOutlook/16.35.20030802
Date:   Thu, 02 Apr 2020 08:38:10 -0400
Subject: Re: [ANNOUNCE] nftables 0.9.4 release
From:   sbezverk <sbezverk@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <lwn@lwn.net>
Message-ID: <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
Thread-Topic: [ANNOUNCE] nftables 0.9.4 release
References: <20200401143114.yfdfej6bldpk5inx@salvia>
In-Reply-To: <20200401143114.yfdfej6bldpk5inx@salvia>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pablo,

Did this commit make into 0.9.4?

https://patchwork.ozlabs.org/patch/1202696/

Thank you
Serguei

=EF=BB=BFOn 2020-04-01, 10:34 AM, "Pablo Neira Ayuso" <netfilter-owner@vger.kerne=
l.org on behalf of pablo@netfilter.org> wrote:

    Hi!
   =20
    The Netfilter project proudly presents:
   =20
            nftables 0.9.4
   =20
    This release contains fixes and new features available up to the Linux
    kernel 5.6 release.
   =20
    * Support for ranges in concatenations (requires Linux kernel >=3D 5.6),
      e.g.
   =20
        table ip foo {
               set whitelist {
                       type ipv4_addr . ipv4_addr . inet_service
                       flags interval
                       elements =3D { 192.168.10.35-192.168.10.40 . 192.68.11=
.123-192.168.11.125 . 80 }
               }
   =20
               chain bar {
                       type filter hook prerouting priority filter; policy =
drop;
                       ip saddr . ip daddr . tcp dport @whitelist accept
               }
        }
   =20
      This creates a `whitelist' set whose elements are a concatenation.
      The interval flag specifies that this set might include ranges in
      concatenations. The example above is accepting all traffic coming
      from 192.168.10.35 to 192.168.10.40 (both addresses in the range
      are included), destination to 192.68.10.123 and TCP destination
      port 80.
   =20
    * typeof support for sets. You can use typeof to specify the datatype
      of the selector in sets, e.g.
   =20
         table ip foo {
                set whitelist {
                        typeof ip saddr
                        elements =3D { 192.168.10.35, 192.168.10.101, 192.168=
.10.135 }
                }
   =20
                chain bar {
                        type filter hook prerouting priority filter; policy=
 drop;
                        ip daddr @whitelist accept
                }
         }
   =20
      You can also use typeof in maps:
   =20
         table ip foo {
                map addr2mark {
                    typeof ip saddr : meta mark
                    elements =3D { 192.168.10.35 : 0x00000001, 192.168.10.135=
 : 0x00000002 }
                }
         }
   =20
    * NAT mappings with concatenations. This allows you to specify the addr=
ess
      and port to be used in the NAT mangling from maps, eg.
   =20
          nft add rule ip nat pre dnat ip addr . port to ip saddr map { 1.1=
.1.1 : 2.2.2.2 . 30 }
   =20
      You can also use this new feature with named sets:
   =20
          nft add map ip nat destinations { type ipv4_addr . inet_service :=
 ipv4_addr . inet_service \; }
          nft add rule ip nat pre dnat ip addr . port to ip saddr . tcp dpo=
rt map @destinations
   =20
    * Hardware offload support: Your nic driver must include support for th=
is
      infrastructure. You have to enable offload via ethtool:
   =20
         # ethtool -K eth0 hw-tc-offload on
   =20
      Then, in nftables, you have to turn on the offload flag in the basech=
ain
      definition.
   =20
         # cat file.nft
         table netdev x {
                chain y {
                    type filter hook ingress device eth0 priority 10; flags=
 offload;
                    ip saddr 192.168.30.20 drop
                }
         }
         # nft -f file.nft
   =20
      Just a simple example to drop all traffic coming from 192.168.30.20
      from the hardware. The Linux host see no packets at all from
      192.168.30.20 after this since the nic filters out the packets.
   =20
      As of kernel 5.6, supported features are:
   =20
      - Matching on:
        -- packet header fields.
        -- input interface.
   =20
      - Actions available are:
        -- accept / drop action.
        -- Duplicate packet to port through `dup'.
        -- Mirror packet to port through `fwd'.
   =20
    * Enhancements to improve location-based error reporting, e.g.
   =20
         # nft delete rule ip y z handle 7
         Error: Could not process rule: No such file or directory
         delete rule ip y z handle 7
                        ^
   =20
      In this example above, the table `y' does not exist in your system.
   =20
         # nft delete rule ip x x handle 7
         Error: Could not process rule: No such file or directory
         delete rule ip x x handle 7
                                   ^
   =20
      This means that rule handle 7 does not exist.
   =20
         # nft delete table twst
         Error: No such file or directory; did you mean table =E2=80=98test=E2=80=99 in=
 family ip?
         delete table twst
                      ^^^^
   =20
      If you delete a table whose name has been mistyped, error reporting
      includes a suggestion.
   =20
    * Match on the slave interface through `meta sdif' and `meta
      sdifname', e.g.
   =20
            ... meta sdifname vrf1 ...
   =20
    * Support for right and left shifts:
   =20
            ... meta mark set meta mark lshift 1 or 0x1 ...
   =20
      This example shows how to shift one bit left the existing packet
      mark and set the less significant bit to 1.
   =20
    * New -V option to display extended version information, including
      compile time options:
   =20
         # nft -V
           nftables v0.9.4 (Jive at Five)
              cli:          readline
              json:         yes
              minigmp:      no
              libxtables:   yes
   =20
    * manpage documentation updates.
   =20
    * ... and bugfixes.
   =20
    See ChangeLog that comes attached to this email for more details.
   =20
    =3D Caveat =3D
   =20
    This new version enforces options before commands, ie.
   =20
         # nft list ruleset -a
         Error: syntax error, options must be specified before commands
         nft list ruleset -a
            ^             ~~
   =20
    Just place the option before the command:
   =20
         # nft -a list ruleset
         ... [ ruleset listing here ] ...
   =20
    Make sure to update your scripts.
   =20
    You can download this new release from:
   =20
    http://www.netfilter.org/projects/nftables/downloads.html#nftables-0.9.=
4
    ftp://ftp.netfilter.org/pub/nftables/
   =20
    To build the code, libnftnl 1.1.6 and libmnl >=3D 1.0.3 are required:
   =20
    * http://netfilter.org/projects/libnftnl/index.html
    * http://netfilter.org/projects/libmnl/index.html
   =20
    Visit our wikipage for user documentation at:
   =20
    * http://wiki.nftables.org
   =20
    For the manpage reference, check man(8) nft.
   =20
    In case of bugs and feature request, file them via:
   =20
    * https://bugzilla.netfilter.org
   =20
    Happy firewalling!
   =20


