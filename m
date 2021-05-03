Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8E5371064
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 03:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhECBl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 21:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhECBl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 21:41:56 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3EFC06174A
        for <netdev@vger.kernel.org>; Sun,  2 May 2021 18:41:04 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id a2so3717158qkh.11
        for <netdev@vger.kernel.org>; Sun, 02 May 2021 18:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=r70O78sR4a7EzU4HXSGQsxcS3Dhpi2qeQGaHpzD/5RQ=;
        b=TEfOw25MFTNjtlyF+JO4v0W1mQ31Bml+ACrshwZQkrU4wQOLTAWjw8P8rvmYaOeV9L
         OzpQnFICyaSe9vhgv0wSIL9DuoEVG73DjEtoBBWwq/Bjl9od37+uQr3a6fWUAGd3nHk4
         K1ezS40gXHJMGdacdH1j13CiGKlFpz2zprr1raAPptc4r3QZT7Q0tQER6PGhL2DNT4ec
         JXo6u7q4nkV5GRdGSr0vrvQCvGmxmYw5qt1mAj9+xCFiDnWqJEVWwBqWlOCfLGdfmm+A
         Na7279U265xG2bLE4pcSG9+cQ3vBC387exc9hNLX3ytVWWipa+CjxoyjDIKIzsO4FkF9
         w+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=r70O78sR4a7EzU4HXSGQsxcS3Dhpi2qeQGaHpzD/5RQ=;
        b=hGN4Kw/fgyH6a+qV45RLw2hJffSqyHQuhuBdNa3Sf7yaw414v0brYoyx7nQRx0pYVC
         LJEeK0NrDrMvgSG3VvmpU+gC7X1CMJwfOkgDmRh7tdCMFejkLYCxZ9Kzxtdb5PShsTPF
         JX07uNIYr7sDqfUMGAuSpX9rT5b74Rqj+ZGzvK7jlpA1aeyl8WltNNJ/mQtKPp2iILeD
         vm1f9RKFAtL78By26x2CWH3omSqOXGqv0AoYECSRyF0rY80PvhmoGz4LWoVCpVtcb577
         jdQP1ttamWs/lh+2uZVn+BKlxaINx6WoE8oalfwu0mu0nhouEz52lcTsT1pOgIzb6aii
         B+QA==
X-Gm-Message-State: AOAM5305/xaKY7WCmXtsyOYfJHVaeVvbYl6E7AoNT3TmbcpAy5NIWjAS
        imRAWusuYXjCcLuIhHadD53iX8W03JJH6iZN
X-Google-Smtp-Source: ABdhPJzy70BBLYVoONJl4N+w4qPXsNMpsaK45CULO+APM0F5IKVwjKFcuX97YnAFCdQHsNDD4hvdmQ==
X-Received: by 2002:a37:a051:: with SMTP id j78mr496049qke.216.1620006063409;
        Sun, 02 May 2021 18:41:03 -0700 (PDT)
Received: from ?IPv6:2601:5cc:c800:9640:180a:ff53:2657:b1d9? ([2601:5cc:c800:9640:180a:ff53:2657:b1d9])
        by smtp.gmail.com with ESMTPSA id o2sm7249561qki.73.2021.05.02.18.41.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 May 2021 18:41:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.40.0.2.32\))
Subject: RESEND Re: rfc5837 and rfc8335
From:   Ishaan Gandhi <ishaangandhi@gmail.com>
In-Reply-To: <1FB38B5E-F952-421D-8FA7-338678E0E8BC@gmail.com>
Date:   Sun, 2 May 2021 21:41:00 -0400
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ron Bonica <rbonica@juniper.net>,
        David Ahern <dsahern@gmail.com>,
        Zachary Dodds <zdodds@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B61A0978-A7BB-4E8A-B042-3057225A7D8E@gmail.com>
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
 <1FB38B5E-F952-421D-8FA7-338678E0E8BC@gmail.com>
To:     Ishaan Gandhi <ishaangandhi@gmail.com>
X-Mailer: Apple Mail (2.3654.40.0.2.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gently bumping this. Any thoughts?

> On Apr 8, 2021, at 6:03 PM, Ishaan Gandhi <ishaangandhi@gmail.com> =
wrote:
>=20
>> But the patch series under review adds support to generate such =
packets.
>=20
> Willem, yes, good point. Let me add some more context.
>=20
> This quote might be misleading:
>=20
>>> Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions often
>=20
> Linux _hosts_ won=E2=80=99t send 5837 extensions often, but Linux is =
often
> used in routers, which may indeed send those extensions often.
>=20
> (Ron previously added some great context why routers may want to send =
those
> extensions _now_ as opposed to 11 years ago.)
>=20
> Juniper is adding RFC 5837 support to some of their router line right =
now, and=20
> some of their OS=E2=80=99s  are based on Linux.
>=20
> Contributing these changes to the upstream kernel would be valuable
> to Juniper for maintainability. (No re-applying the patch every time =
Juniper
> upgrades to a new kernel version.)
>=20
> Furthermore, Juniper is not the only router vendor based on Linux.
>=20
> OpenWrt and DD-WRT are two popular router distributions, both based on =
Linux.
> There are 16 total Linux based router-distributions mentioned on
> =
https://en.wikipedia.org/wiki/List_of_router_and_firewall_distributions =
alone.
>=20
> Re, some previous questions
>=20
>>> What tooling supports it?=20
>=20
> Currently, Wireshark. There are also open merge requests for =
traceroute in IPUtils,
> and TCPDump.
>=20
>>> With Linux, the ingress interface can lost in the layers (NIC port, =
vlan, bond, bridge, vrf, macvlan), and to properly support either you =
need to return information about the right one.
>=20
> either return the information, or?
>=20
> Many thanks!
> - Ishaan
>=20
>> On Mar 31, 2021, at 7:04 AM, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>>=20
>> On Mon, Mar 29, 2021 at 3:40 PM Ron Bonica <rbonica@juniper.net> =
wrote:
>>>=20
>>> Folks,
>>>=20
>>> Andreas reminds me that you may have the same questions regarding =
RFC 8335.....
>>>=20
>>> The practice of assigning globally reachable IP addresses to =
infrastructure interfaces cost network operators money. Normally, they =
number an interface from a IPv4  /30. Currently, a /30 costs 80 USD and =
the price is only expected to rise. Furthermore, most IP Address =
Management (IPAM) systems license by the address block. The more =
globally reachable addresses you use, the more you pay.
>>>=20
>>> They would prefer to use:
>>>=20
>>> - IPv4 unnumbered interfaces
>>> - IPv6 interfaces that have only link-local addresses
>>>=20
>>>                                                                   =
Ron
>>=20
>> Thanks for the context, Ron.
>>=20
>> That sounds reasonable to me. Andreas's patch series has also been
>> merged by now.
>>=20
>>=20
>>>=20
>>>=20
>>>=20
>>> Juniper Business Use Only
>>>=20
>>> -----Original Message-----
>>> From: Ron Bonica
>>> Sent: Monday, March 29, 2021 10:50 AM
>>> To: David Ahern <dsahern@gmail.com>; Zachary Dodds =
<zdodds@gmail.com>; Ishaan Gandhi <ishaangandhi@gmail.com>
>>> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller =
<davem@davemloft.net>; Network Development <netdev@vger.kernel.org>; =
Stephen Hemminger <stephen@networkplumber.org>; Willem de Bruijn =
<willemdebruijn.kernel@gmail.com>; junipeross20@cs.hmc.edu
>>> Subject: RE: rfc5837 and rfc8335
>>>=20
>>> David,
>>>=20
>>> Juniper networks is motivated to promote RFC 5837 now, as opposed to =
eleven years ago, because the deployment of parallel links between =
routers is becoming more common
>>>=20
>>> Large network operators frequently require more than 400 Gbps =
connectivity between their backbone routers. However, the largest =
interfaces available can only handle 400 Gbps. So, parallel links are =
required. Moreover, it is frequently cheaper to deploy 4 100 Gbps =
interfaces than a single 400 Gbps interface. So, it is not uncommon to =
see two routers connected by many, parallel 100 Gbps links. RFC 5837 =
allows a network operator to trace a packet interface to interface, as =
opposed to node to node.
>>>=20
>>> I think that you are correct in saying that:
>>>=20
>>> - LINUX is more likely to be implemented on a host than a router
>>> - Therefore, LINUX hosts will  not send RFC 5837 ICMP extensions =
often
>>>=20
>>> However, LINUX hosts are frequently used in network management =
stations. Therefore, it would be very useful if LINUX hosts could parse =
and display incoming RFC 5837 extensions, just as they display RFC 4950 =
ICMP extensions.
>>=20
>> But the patch series under review adds support to generate such =
packets.
>>=20
>>=20
>>> Juniper networks plans to support RFC 5837 on one platform in an =
upcoming release and on other platforms soon after that.
>>>=20
>>>                                                                      =
          Ron
>>>=20
>>>=20
>>>=20
>>>=20
>>> Juniper Business Use Only
>>>=20
>>> -----Original Message-----
>>> From: David Ahern <dsahern@gmail.com>
>>> Sent: Wednesday, March 24, 2021 11:19 PM
>>> To: Ron Bonica <rbonica@juniper.net>; Zachary Dodds =
<zdodds@gmail.com>; Ishaan Gandhi <ishaangandhi@gmail.com>
>>> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>; David Miller =
<davem@davemloft.net>; Network Development <netdev@vger.kernel.org>; =
Stephen Hemminger <stephen@networkplumber.org>; Willem de Bruijn =
<willemdebruijn.kernel@gmail.com>; junipeross20@cs.hmc.edu
>>> Subject: Re: rfc5837 and rfc8335
>>>=20
>>> [External Email. Be cautious of content]
>>>=20
>>>=20
>>> On 3/23/21 10:39 AM, Ron Bonica wrote:
>>>> Hi Folks,
>>>>=20
>>>>=20
>>>>=20
>>>> The rationale for RFC 8335 can be found in Section 5.0 of that =
document.
>>>> Currently, ICMP ECHO and ECHO RESPONSE messages can be used to
>>>> determine the liveness of some interfaces. However, they cannot
>>>> determine the liveness of:
>>>>=20
>>>>=20
>>>>=20
>>>> * An unnumbered IPv4 interface
>>>> * An IPv6 interface that has only a link-local address
>>>>=20
>>>>=20
>>>>=20
>>>> A router can have hundreds, or even thousands of interfaces that =
fall
>>>> into these categories.
>>>>=20
>>>>=20
>>>>=20
>>>> The rational for RFC 5837 can be found in the Introduction to that
>>>> document. When a node sends an ICMP TTL Expired message, the node
>>>> reports that a packet has expired on it. However, the source =
address
>>>> of the ICMP TTL Expired message doesn't necessarily identify the
>>>> interface upon which the packet arrived. So, TRACEROUTE can be =
relied
>>>> upon to identify the nodes that a packet traverses along its =
delivery
>>>> path. But it cannot be relied upon to identify the interfaces that =
a
>>>> packet traversed along its deliver path.
>>>>=20
>>>>=20
>>>=20
>>> It's not a question of the rationale; the question is why add this =
support to Linux now? RFC 5837 is 11 years old. Why has no one cared to =
add support before now? What tooling supports it? What other NOS'es =
support it to really make the feature meaningful? e.g., Do you know what =
Juniper products support RFC 5837 today?
>>>=20
>>> More than likely Linux is the end node of the traceroute chain, not =
the transit or path nodes. With Linux, the ingress interface can lost in =
the layers (NIC port, vlan, bond, bridge, vrf, macvlan), and to properly =
support either you need to return information about the right one.
>>> Unnumbered interfaces can make that more of a challenge.
>=20

