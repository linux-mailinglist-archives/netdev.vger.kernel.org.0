Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6579D21A1CB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgGIOHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:07:00 -0400
Received: from mout.gmx.net ([212.227.15.19]:40339 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgGIOHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594303618;
        bh=X1A9f1U9k0P0efJPzez9VGexRHZjZOiwfgktfCqvlZk=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=RVM5MMdX2QoARhxPc8mQBt4X7y9u0W7bda3BLV3vVuPWSLEbrICl33A5v/GuE8i5L
         3VD8Q3sVZ13DaCfLJfCOlA9YIGQsLqel2OrKwvtihUJqF+fvV0k0aYyh3I0utRgRsu
         dGsuBYejdb/dEx+d3qVIdjDWbJccRf6Rb+BQrw7w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.20] ([149.224.144.145]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MCbEf-1k1ThB1DKV-009fIN; Thu, 09
 Jul 2020 16:06:58 +0200
Reply-To: vtol@gmx.net
Subject: Re: [DSA] L2 Forwarding Offload not working
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
 <20200709135335.GL928075@lunn.ch>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <50c35a41-45c2-1f2b-7189-96fe7c0a1740@gmx.net>
Date:   Thu, 9 Jul 2020 14:06:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <20200709135335.GL928075@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:J089gYuFzdFfhIQkMSqpzrnqBsxoIB/1NyApFm6bgw7JgimWfva
 uGXIB7ko52iXZy1iHk53VFqqDn8cw+23zghb4AgBXOlXo/Q5ZPQEg3JrvyVcWEbP5zt0bDP
 DLBz7WWQLP6nccbw5NegieeFboSzPOJRz7ZoVlLUWx1CMh6nSGeU1js5bFt9KRqmHf0+2XO
 kPjz3iCNODJiHDFOxjOwg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aeA0J4rdMRI=:N9OLkimiaHL/nPlEDCrQrA
 hodMvACIQoRKa/qYlAK5VGbCvRsOpmI8LxoxHRMm7Y4/XRCYmtUkBM++7biP1hDZx4zN8b89y
 HesbtW+y6xsFbDNRT1IYdbDjyC+PXkKW7AeELzvk+DV20ftrthJ0AvtfmH9UddUwMFrd+EwTs
 jXiHNmJipXdwcahk27iAN5+TiITPD7uu+C9icxq4GnSAwFa98rzKhoL8O1WvruEQ0+LacoyK/
 IfLzNBaktgPfAC8+WAnE1DFaxv9YIdeVeg/nAENNV7u5tFVmFEyQ+B4WGQVHnpG6D/16oMLug
 oRGCxZjkdqmweUaR+RJhe2NCx7SF107jwbllQ16ABNVLzh8AXSMv+zudRdHC75acITTSCNTKA
 gcYqtmPJupBtqNhE2AjYcKfpMGmJ8eTxiQ32EVOXPxg+C0mod/JBzIlWmeQnK2yaZhXvSWycY
 LAs6vk2OV+YXeL0OJww80oR+GeIGr3WdZtgjRCmuiMqvcMQhc5L7Oz5Hkk0ibANF//CaTj0nu
 QVMDhyo4IEhr23v7kayIpkGp0l3yyYeyLBCwOSkvMqDNXnS3zS2TuK7iuu7gHJ3Jrj93jCfX0
 MaHaU0BhjchtSjcu5dL8Rc8cua+aI3pjfSHKud/2WFoY8o72iyqv8GqZciK9nQXLnOOzNf7kH
 w7lvYcwDfibWAue5n3SSsBFFsGaSNCMK3OrYwJWrj3Dya367H70ePt6r3Z6QHfP71oleqlTfl
 YG8Xqe+kUIv5m4Ru4+EykK+Vayqz4bn01sh1G4l1aCXejlTBroAj5VR31xruZTvhZ0iDDLEl5
 I/H6+bx3bYrap6LbNscO40sv25OTj06MA7oH5AmfZ2q5iGExjObdrMuTdguov00XfzxQkNzj8
 XpzntyenvEKqfRVlc46loiW2x9BYTnG0V0IltNLJwfvF4JJMydS6d+stkwLXEeN+3A2YGqTzP
 iswaxIYUewaZ0yDS5LGmsq5Tp8r98revssdCY3rL5NynWMnrqSqZ+nVHDMrmvBXXIUV5r9/GK
 0C1N8HaKMtcYNDDO28Yv04z7f9JCq9Nw45z+ZIPGYIIv9ZBk6utwGw753UarNm5XyiXA8Fypn
 rCD6zq+Ri25aY2iA5qJeQqZctnG4NXWcCp82BjiwbMlXwKyPoVizrr+eYWVmh4CdsTzd3KEs1
 xJ9eqcyrTY6cZiXaTIIkcMlQw3empimZOzoPQPbZqo/uEqk4qEj8LWcmsErkGHqk8NRN/s4gk
 CyyY+oQhoDGQfAs2T
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/07/2020 13:53, Andrew Lunn wrote:
> On Thu, Jul 09, 2020 at 11:32:00AM +0000, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=
=E2=84=A0 wrote:
>> "kernel":"5.4.50", "system":"ARMv7 Processor rev 1
>> (v7l)","model":"Turris
>> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"Ope=
nWrt","version":"SNAPSHOT","revision":"r13719-66e04abbb6","target":"mvebu/=
cortexa9","}
>>
>> CPU Marvell Armada 385 88F6820 | Switch=C2=A0 Marvell 88E6176
>>
>> soft bridge br-lan enslaving DSA ports lan0 lan1 lan2
>>
>> DSA master device eth1 (subsequent ip l exhibits slaves as lanX@eth1)
>> ----------
>>
>> After perusal of
>> https://www.kernel.org/doc/Documentation/networking/switchdev.txt it is
>> my understanding that offloading works only for static FDB entries,
>> though not clear to me:
>>
>> * what the logic is behind, and
>> * why DSA ports are not static FDB entries by default (would only seem
>> logical)
> Hello
>
> With DSA, we have two sets of tables. The switch performs address
> learning, and the software bridge performs address learning. No
> attempt is made to keep these dynamic FDB entries in sync. There is
> not enough bandwidth over the MDIO link to keep the two tables in
> sync. However, when you dump the FDB using the bridge command, you get
> to see the combination of both tables. The hardware will perform
> forwarding based on its table, and the software bridge based on its
> table.. However, if there is no entry in the hardware table for a
> given destination MAC address, it will forward the frame to the
> software bridge, so it can decide what to do with it.
>
> For static FDB entries which the user adds, they are first added to
> the software bridge, and then pushed down to the switch.
>
>      Andrew

Thank you for the instantaneous feedback and insight!

Two questions if you do not mind:

1) does the above apply to all stable kernel releases or only =3D> 5.4?
Because with 4.14 there are reports that dynamic addresses of clients
roaming from a switch port to an bridge port (upstream of the switch,
e.g. WLan AP provided by the router) facing time outs until the switch
retires (ages) the client's MAC.

2) The document
https://www.kernel.org/doc/Documentation/networking/switchdev.txt cites
(for static entries)

bridge command will label these entries "offload"

Is that still up-to-date or rather outdated from the earlier days of DSA?
