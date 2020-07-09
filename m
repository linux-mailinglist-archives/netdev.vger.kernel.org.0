Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1251219F1A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 13:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgGILcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 07:32:35 -0400
Received: from mout.gmx.net ([212.227.17.21]:46435 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgGILcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 07:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594294353;
        bh=xf3HvEHnxDgbM/Vy22VMW98HUJTkiezhWUckf8FOXBA=;
        h=X-UI-Sender-Class:To:Reply-To:From:Subject:Date;
        b=BrzGzjyhgylVy31DfhUoRtQUpqbk78dlPBrstuW2hhhCzrvUQk7MkSYWh0NuRpL38
         XGmWTiG+ip6nKvFfwBxF0lYfKndSbV5pcoqyQlYbzZZpdCTAofITjTINTFU9lz60A+
         8ENCQ++c4lDjS7G0noT4dm/uDG7dq4WKl/L7dpZQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.20] ([149.224.144.145]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1McH5Q-1kTwbd2zF6-00cdaX for
 <netdev@vger.kernel.org>; Thu, 09 Jul 2020 13:32:33 +0200
To:     netdev@vger.kernel.org
Reply-To: vtol@gmx.net
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Subject: [DSA] L2 Forwarding Offload not working
Message-ID: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
Date:   Thu, 9 Jul 2020 11:32:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:62i4Wz/FhuEPUsYu6ApmOqWlKuKmF0z4p8Ea2EI9Gz29ZTw2K4j
 PuT9onFVcXijXy1yJ/D+JKPaAHxAOeOSl2dzkhqVmjSNonLJt6mF67EZHtoZF1fKtP7gQ9Z
 VzXkOWqIXqluRz3Llea+1AlchStyRUBfBqpkP/vZtKFnTbDRRxQAdVrzFpc50chd/l/ezdL
 Oz9df6bjcrROKWduD62QQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XInn5lNdZhs=:TcBRX1PtZ3RSoI8HbQYP5i
 rF9TB81+G/RmczGhuK44odJCpgblZi+CkzbNyhstBqVIOy9NZMifDIVrKUGOj8azLTVHz93Jm
 njKxAD3QDvU7DhYrIoorOLvGrQ8pc0ediz+FlI3aPWptCNM9S/LoEc5drzEeFl/5IlRfZ9JIL
 vKsFjE3zeRDkwqfh3+K386zElwxk+ptg1C0gMmrtj5GvC+hXQNoAWoeO1NFFm8wi5YJULJ2Q7
 J7bGYL/2yk6HeTVxoKd3wV9MrOVLNS7+V4kHRC4F2KwHniCj9dnQp7H4ztcbHVPrn4x65BGrJ
 DEhSNiltCWJMKVRIFK8RuZNd+m9r5RaCKYz9jTIFC5WUJl51Ue9ZLzpnFvHs7eIrokfqHGOkp
 YVfDM/WlQ0vy/GBGJ27BTloH2jM5WiijBkDa5tXi9tBR0uJ8xk2lP9FcnN50gLBOuYljnD/MM
 eLhRn27tSghw9lQQMnXd2X6FoOXQPK/qtRNTN1rnprflWBT7R8NKMz8qzYXBfukw+oZtfIJpS
 2uN+SMFPJGoZo6kBMLeXLqgH573lkUOYHAPAxJbFuZyU/nLQ+owFzP0ieSBYGseLx/vdL5qGb
 ZXEStmAINzCJT41lWNDb8rH3+UD1DrpdddX+agXB4TnukMezXlZKs4XoFCDloMRVvFqvHYRd7
 w1NpX3V3HzmAr9pq181TwZn26MC8oZ1F1CPHPe4Ed4rxOSg+ebxuPY4g86qdhS1xAMaJL5X2D
 C8BJx7hgCiqoRqxJgfkNOQcsreacH5E1+2fK8OtP02uqLsL2fITq7K77130q9LAXhCDB14Wkz
 kyNHK3BSSbDZXk9f53lZT80d8SyNSvOS4iEvn1xBYW7rZP91xoqG/WSeZg4E4PSm707La81zo
 zLQqaxjOuJnftzdnwpKqtIbr90hLC1w2E2eQj6CaIC8GA+Nv5W+PKqs68cmL+2Scf+kNkOizz
 to7rU9wnfg0hcf7n+KBDP8q6OwOULLoW5Aob/bMQKY27aLFn1MuuXjqQiD1cJxjesxmusVHu6
 0wZv7MwTLAlhS2kOjh9sX0XtU/Mr4kJGaVSprNY414/XkO+2vI9aE21x5QiGBZSgJ9171N7V6
 z9073YEs5nfJj2gGFBCx1j46bjCA8heEtm2z4bjQGNJDfPyRTzaWH775mtlOq6V8QeYBUuDwY
 +BElXnosEbrn/Rri+fXLgWxRbjCuIqNkrfr9DplmCkxVh4MvehLwpLCL3oUCkqAaZNvZiGIYK
 jJcjYb3z2iyiC6ZNW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"kernel":"5.4.50", "system":"ARMv7 Processor rev 1
(v7l)","model":"Turris
Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"OpenWr=
t","version":"SNAPSHOT","revision":"r13719-66e04abbb6","target":"mvebu/cor=
texa9","}

CPU Marvell Armada 385 88F6820 | Switch=C2=A0 Marvell 88E6176

soft bridge br-lan enslaving DSA ports lan0 lan1 lan2

DSA master device eth1 (subsequent ip l exhibits slaves as lanX@eth1)
=2D---------

After perusal of
https://www.kernel.org/doc/Documentation/networking/switchdev.txt it is
my understanding that offloading works only for static FDB entries,
though not clear to me:

* what the logic is behind, and
* why DSA ports are not static FDB entries by default (would only seem
logical)

That said queried bridge fdb for lan2 (as example here), producing:

44:8a:5b:47:0b:c2 dev lan2 master br-lan
44:8a:5b:47:0b:c2 dev lan2 vlan 1 self

then went ahead with

bridge fdb add 44:8a:5b:47:0b:c2 dev lan2 vlan 1 self

resulting in

44:8a:5b:47:0b:c2 dev lan2 master br-lan
44:8a:5b:47:0b:c2 dev lan2 vlan 1 self static

So it is static now but nothing about offload still. Next up

ip l s br-lan ty bridge vlan_filtering 1

checking again bridge fdb and now exhibiting

44:8a:5b:47:0b:c2 dev lan2 vlan 1 master br-lan
44:8a:5b:47:0b:c2 dev lan2 master br-lan
44:8a:5b:47:0b:c2 dev lan2 vlan 1 self static

Do I suffer some sort of misconception of how to get it working, missing
something?
