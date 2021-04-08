Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5744358F9D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhDHWEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhDHWEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:04:15 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77066C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 15:04:03 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o18so1876965pjs.4
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 15:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qBkzhp10PQKVFQS/O3O0ieo1lqvUO3zeoMh12oUB5D8=;
        b=mA+zFUcy4CSdV/DiepYPpvBwFyA1sZv3tn7KW69pSQslpywy9ikoMj3uzj2DfH9h3P
         iI6h9vw+WEo1d2kwMNK56DjwDwBEWV6lGfMKRHcgY9StWlQ9c7ueyo7ogk3UTHNE9AX4
         JQKuaEQF0+MEbKvx2CRZVtWMoU/toI0pKOtLhV4C9VT+QTdzAZtwWoMSQ6e9nK607MrS
         9tlRQEySFaUYdFWPnxaOFDVMcGDg1qEBA85n1zh6Wlu5nBM1yFWhOuamN2nyGe+Z5vPv
         tYuOvCvY+9lKB1vvnvhPaFhJhNcNR8vUzL232Xj7WjK5P0DPNiBddHKp2ZWGtv5zwHrv
         IsGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=qBkzhp10PQKVFQS/O3O0ieo1lqvUO3zeoMh12oUB5D8=;
        b=l+Azg/2LrconirWZ+z5ZPWikFSUoXFNwcG/XXzwRz9BOcAFlspcFH9lwVBp+YHhPSg
         m27yWJBFpK06015HEXf2xFCpyt8HFJsXa9H4XVi+RjQq2ji5vCu8PtlArQiOwtvFZjgQ
         8hgnUMXn8zdxnjVM3OAHq66JmrY011Pmemd1GpygnQCDF9iWeMpmNdzoO3Iq8lD9ZGKc
         7Jwb6hZn+uet+WNJ/PEchu9Kc0CqdNtQu6XwxvRFc4Uxq1gtTUcCA9yf1vHsppBCqr6g
         RrFoIPAtG2MFDMQXs4kyuWD9SqjpU3JLsGrND3At0OWR1fVIUDdfDICpnkXqx62ZlDot
         +j4w==
X-Gm-Message-State: AOAM533c+dVsdNkzOgYVK6/vhi9lg0UY3ZXWNewpimsWsC0nwWf1ggrD
        qR6lgOic8smfe226I5r5Jyg=
X-Google-Smtp-Source: ABdhPJwRAuDotuWBBvkcar5QR1q2PUEJPduHIhrOk0/e6h7yhA3tNwiqAazxFMgagrPvy4iYLd+h8A==
X-Received: by 2002:a17:902:780c:b029:e6:9193:56e2 with SMTP id p12-20020a170902780cb02900e6919356e2mr9791265pll.39.1617919443000;
        Thu, 08 Apr 2021 15:04:03 -0700 (PDT)
Received: from ?IPv6:2600:8801:130a:ce00:7132:c1aa:59e9:59fe? ([2600:8801:130a:ce00:7132:c1aa:59e9:59fe])
        by smtp.gmail.com with ESMTPSA id c12sm393783pfp.17.2021.04.08.15.04.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 15:04:02 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: Re: rfc5837 and rfc8335
From:   Ishaan Gandhi <ishaangandhi@gmail.com>
In-Reply-To: <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
Date:   Thu, 8 Apr 2021 15:03:57 -0700
Cc:     Ron Bonica <rbonica@juniper.net>, David Ahern <dsahern@gmail.com>,
        Zachary Dodds <zdodds@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1FB38B5E-F952-421D-8FA7-338678E0E8BC@gmail.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
 <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
 <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com>
 <CAJByZJBNMqVDXjcOGCJHGcAv+sT4oEv1FD608TpA_e-J2a3L2w@mail.gmail.com>
 <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
 <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com>
 <BL0PR05MB5316527A1739025552EB8BB6AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
 <BL0PR05MB531617E730233A4913B4C5B3AE7E9@BL0PR05MB5316.namprd05.prod.outlook.com>
 <CA+FuTSdvyknXTj+5d1O4+6SE3Hp+EA4TgRWpqaS6NUy_39vTOQ@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But the patch series under review adds support to generate such =
packets.

Willem, yes, good point. Let me add some more context.

This quote might be misleading:

>> Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions often

Linux _hosts_ won=E2=80=99t send 5837 extensions often, but Linux is =
often
used in routers, which may indeed send those extensions often.

(Ron previously added some great context why routers may want to send =
those
extensions _now_ as opposed to 11 years ago.)

Juniper is adding RFC 5837 support to some of their router line right =
now, and=20
some of their OS=E2=80=99s  are based on Linux.

Contributing these changes to the upstream kernel would be valuable
to Juniper for maintainability. (No re-applying the patch every time =
Juniper
upgrades to a new kernel version.)

Furthermore, Juniper is not the only router vendor based on Linux.

OpenWrt and DD-WRT are two popular router distributions, both based on =
Linux.
There are 16 total Linux based router-distributions mentioned on
https://en.wikipedia.org/wiki/List_of_router_and_firewall_distributions =
alone.

Re, some previous questions

>> What tooling supports it?=20

Currently, Wireshark. There are also open merge requests for traceroute =
in IPUtils,
and TCPDump.

>> With Linux, the ingress interface can lost in the layers (NIC port, =
vlan, bond, bridge, vrf, macvlan), and to properly support either you =
need to return information about the right one.

either return the information, or?

Many thanks!
- Ishaan

> On Mar 31, 2021, at 7:04 AM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20
> On Mon, Mar 29, 2021 at 3:40 PM Ron Bonica <rbonica@juniper.net> =
wrote:
>>=20
>> Folks,
>>=20
>> Andreas reminds me that you may have the same questions regarding RFC =
8335.....
>>=20
>> The practice of assigning globally reachable IP addresses to =
infrastructure interfaces cost network operators money. Normally, they =
number an interface from a IPv4  /30. Currently, a /30 costs 80 USD and =
the price is only expected to rise. Furthermore, most IP Address =
Management (IPAM) systems license by the address block. The more =
globally reachable addresses you use, the more you pay.
>>=20
>> They would prefer to use:
>>=20
>> - IPv4 unnumbered interfaces
>> - IPv6 interfaces that have only link-local addresses
>>=20
>>                                                                    =
Ron
>=20
> Thanks for the context, Ron.
>=20
> That sounds reasonable to me. Andreas's patch series has also been
> merged by now.
>=20
>=20
>>=20
>>=20
>>=20
>> Juniper Business Use Only
>>=20
>> -----Original Message-----
>> From: Ron Bonica
>> Sent: Monday, March 29, 2021 10:50 AM
>> To: David Ahern <dsahern@gmail.com>; Zachary Dodds =
<zdodds@gmail.com>; Ishaan Gandhi <ishaangandhi@gmail.com>
>> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller =
<davem@davemloft.net>; Network Development <netdev@vger.kernel.org>; =
Stephen Hemminger <stephen@networkplumber.org>; Willem de Bruijn =
<willemdebruijn.kernel@gmail.com>; junipeross20@cs.hmc.edu
>> Subject: RE: rfc5837 and rfc8335
>>=20
>> David,
>>=20
>> Juniper networks is motivated to promote RFC 5837 now, as opposed to =
eleven years ago, because the deployment of parallel links between =
routers is becoming more common
>>=20
>> Large network operators frequently require more than 400 Gbps =
connectivity between their backbone routers. However, the largest =
interfaces available can only handle 400 Gbps. So, parallel links are =
required. Moreover, it is frequently cheaper to deploy 4 100 Gbps =
interfaces than a single 400 Gbps interface. So, it is not uncommon to =
see two routers connected by many, parallel 100 Gbps links. RFC 5837 =
allows a network operator to trace a packet interface to interface, as =
opposed to node to node.
>>=20
>> I think that you are correct in saying that:
>>=20
>> - LINUX is more likely to be implemented on a host than a router
>> - Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions =
often
>>=20
>> However, LINUX hosts are frequently used in network management =
stations. Therefore, it would be very useful if LINUX hosts could parse =
and display incoming RFC 5837 extensions, just as they display RFC 4950 =
ICMP extensions.
>=20
> But the patch series under review adds support to generate such =
packets.
>=20
>=20
>> Juniper networks plans to support RFC 5837 on one platform in an =
upcoming release and on other platforms soon after that.
>>=20
>>                                                                       =
          Ron
>>=20
>>=20
>>=20
>>=20
>> Juniper Business Use Only
>>=20
>> -----Original Message-----
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, March 24, 2021 11:19 PM
>> To: Ron Bonica <rbonica@juniper.net>; Zachary Dodds =
<zdodds@gmail.com>; Ishaan Gandhi <ishaangandhi@gmail.com>
>> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller =
<davem@davemloft.net>; Network Development <netdev@vger.kernel.org>; =
Stephen Hemminger <stephen@networkplumber.org>; Willem de Bruijn =
<willemdebruijn.kernel@gmail.com>; junipeross20@cs.hmc.edu
>> Subject: Re: rfc5837 and rfc8335
>>=20
>> [External Email. Be cautious of content]
>>=20
>>=20
>> On 3/23/21 10:39 AM, Ron Bonica wrote:
>>> Hi Folks,
>>>=20
>>>=20
>>>=20
>>> The rationale for RFC 8335 can be found in Section 5.0 of that =
document.
>>> Currently, ICMP ECHO and ECHO RESPONSE messages can be used to
>>> determine the liveness of some interfaces. However, they cannot
>>> determine the liveness of:
>>>=20
>>>=20
>>>=20
>>>  * An unnumbered IPv4 interface
>>>  * An IPv6 interface that has only a link-local address
>>>=20
>>>=20
>>>=20
>>> A router can have hundreds, or even thousands of interfaces that =
fall
>>> into these categories.
>>>=20
>>>=20
>>>=20
>>> The rational for RFC 5837 can be found in the Introduction to that
>>> document. When a node sends an ICMP TTL Expired message, the node
>>> reports that a packet has expired on it. However, the source address
>>> of the ICMP TTL Expired message doesn't necessarily identify the
>>> interface upon which the packet arrived. So, TRACEROUTE can be =
relied
>>> upon to identify the nodes that a packet traverses along its =
delivery
>>> path. But it cannot be relied upon to identify the interfaces that a
>>> packet traversed along its deliver path.
>>>=20
>>>=20
>>=20
>> It's not a question of the rationale; the question is why add this =
support to Linux now? RFC 5837 is 11 years old. Why has no one cared to =
add support before now? What tooling supports it? What other NOS'es =
support it to really make the feature meaningful? e.g., Do you know what =
Juniper products support RFC 5837 today?
>>=20
>> More than likely Linux is the end node of the traceroute chain, not =
the transit or path nodes. With Linux, the ingress interface can lost in =
the layers (NIC port, vlan, bond, bridge, vrf, macvlan), and to properly =
support either you need to return information about the right one.
>> Unnumbered interfaces can make that more of a challenge.

