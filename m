Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E579F136E31
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 14:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgAJNiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 08:38:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:52457 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgAJNiH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 08:38:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578663485;
        bh=cP/bckO7UTJ49XhTbyKoItt03JnbevjqxSeD+rzowSo=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=RNZ5tSHZMwzV5QmpMhBt1nNQOjth32w2zS1nnnygJOBIhbJwPEJsUEIGSQkN60FTt
         3tpNfOybOjkbGKzTsKx0erIf7gys0taUzNFU6EflDNau8cNPQxtMI6UxyytdAIsDNX
         eFe95EpUJemZOHjOdDdLwqCfr3L4ttYH6BRWKKh8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([149.224.164.215]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwQT9-1ji9EX3ig1-00sMKI; Fri, 10
 Jan 2020 14:38:05 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
References: <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
 <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
 <20200110132206.GB19739@lunn.ch>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <063a1281-b1e9-df5f-1006-41a6d7d1e850@gmx.net>
Date:   Fri, 10 Jan 2020 13:38:01 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110132206.GB19739@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:beMySRM7ZAED9+QR/2c5hqLgu15r8P5o3d+oUglJD8ap9oPpEXW
 kUF+URlqXk1NE9yjXe+A0OwHJKS40RAWE0jHi47qzevQudkS82MP7sJkbSchC+3wBQz7yqm
 s8beYaKRSqt1YDBPKT3BFUJTFkkWm8UiYDT+H53p/OFaIidY8tlInMW9DhnBomeGGPjJKvn
 9RbD5buY7F/9IzJk5MAng==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ofSucEw9GrA=:eNbG3XGkF4LTw1BZRkVbik
 rGRnsbqzlL6wR+B+nPC+u726R3EXFuXqB5p1L2sZ7WIglU6IFrgR1f5xw2ogYHdfag+KA75TC
 C/KGJaT+uDSUOjFWpnPkQp+JLxyggi72fi2/lnf3CK96PMI+CDBJY6lgOJAgzfD5lqvipkQoi
 0/7TNXZrj2hHQnL0Se9waJe388MBYHh5h/GktRlEftd0xUFodvwB+70iiUtClJ2so3y8FpNKC
 t8eCVuDkLwLcINdpYVK+clB9lCAeIl7BdAmJapA+QdqPmutWNwHwYPcXNXh/ZkOzdK55molwN
 AhMJ+V9B//Fg/hklpDbRF4vWoahifEjejZ1cJiffkiWj20pO7bVaQDaOlSxhw6iV29bmUAc8u
 Y39jbh8W54T40UPUfaEEcwAV+3PCb084tLtAc7UogCTMpQpNe9EEM1GATuB4X331C+8polaWC
 TZ0iMh+2StNyMR9HZ4Q1y2O8Mi6bK8ruc3R/rCxL+b+qP9BtvZSLbpRKLAiLf5PKD5XzgwSIJ
 WdMB7kF6LbzNrj0R2Hn5EfC7xmsKOdygaEmdj/XScPycz6cIWWFu2fpSXTq07932XIbYNCMv5
 q3km7TqLz58azyeel/Upb1JK815etrkiq+xmVYDzpHlsN5imwFrnXzBteDk9EiXiORdGzABG2
 j3D8GfGacfYSoHQhTMNxvSZfnLjTGz5qOYAfKmyLbcIbWKIUzFBClBpO9dRGuo0Trzq2HvhiA
 /M9KkDuSEoxhm+kChrGFVo/IyaUTf69JN8clHe0ZD+KBB+FVCBQUJRcaLGRxmieJSjPbaI/Tu
 T1XEhP7PCJ3u/VLvsG3WfXEqHXTSGcA9pQEc9+dxnFyjIhKi/O/i10gaIMH3jaeXtuOTigSty
 6aREmw9fsYvAw/nbNUpSeIxe/Yp+RQ7vuVIAbsA9A9nt3JRfiDZlLC41tuCMSKI4fZOWfLfln
 qOY3eVPOxrSj5cBaY9HxhYyYsks2XwBrECsUXpIqkGiwNKJHXKpo2EhfF+0S6aPsu9s7QsKC9
 CKA7hjxTVn1vABLlRUfD81kHNl4EGqAZfxX898wX81k4LAx31N0Vb19BH1afBErhbnRYpWIoP
 Z3yFVe/XhWAYEgZfEChgv4wg1gEhSU5+JYPdsribJJZNgw7MYEArFhBqYgFgV7BDa1gJ3NoK4
 7wpKZQrS6Lh3SllNBQCPDTbdqGyHUTVr71Mb+8dZ0oXjAB384sjW35VxaGQoBH9qSD0B4lY1s
 97Q8NBkBIZdCUjw+yotbNPkNfTOI3fs9pPyG44A==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 13:22, Andrew Lunn wrote:
> On Fri, Jan 10, 2020 at 10:19:47AM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=
=E2=84=A0 wrote:
>> I just came across this
>> http://edgemax5.rssing.com/chan-66822975/all_p1715.html#item34298
>>
>> and albeit for a SFP g.fast module it indicates/implies that Metanoia
>> provides own Linux drivers (supposedly GPL licensed), plus some bits
>> pertaining to the EBM (Ethernet Boot Management protocol).
>>
>> Has Metanoia submitted any SFP drivers to upstream kernel development?=

> I have also not seen any. You could ask for the sources. It is
> unlikely we would use them, but they could provide documentation about
> the quirks needed to make this device work properly.
>
>      Andrew
>

Wish I could since it would be really helpful.

As far as I can tell some of the ISP in Switzerland, least Swisscom,=20
provide Metanoia designed/manufactured SFP modules as CPE and those=20
drivers and EBM tools for Linux are packaged into the firmware shipped=20
by the ISP.

Too bad that Metanoia has not bothered to take the initiative and submit =

those to upstream development, even it were just for=C2=A0 taking a peek =
at=20
potential quirks.

Regrettably, I do not entertain a (commercial or otherwise) relationship =

at a level that would warrant a response to a request for such drivers=20
from either Metanoia or an ISP providing Metanoia equipment.

