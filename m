Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7C1AD0A9
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbgDPT4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:56:31 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36703 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgDPT43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:56:29 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200416195627euoutp02a76fe520a57da16e4b4fb96fa2a8cc9b~GZQQj_zzg2223922239euoutp02G
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 19:56:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200416195627euoutp02a76fe520a57da16e4b4fb96fa2a8cc9b~GZQQj_zzg2223922239euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587066987;
        bh=BOw44bJHIBFHurxhAMbHDokN2782/36M7XGTmR/A1xA=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=SKhtYDMcROFTsVGo3I71aZMkLzQ0QT8bFX3k3tCtx+KgwJ7NCtRw58YFadE2nbd72
         VJi7dSHC2C5wY5X+E76Kly2tNMPpYMvyEVx5jZAFMNDMAgR6VdxfK8vRmZrDJEaFw3
         WmtI519lIwPQmOtWOTMfCJ2q0SI/OFxD2KUhC9zM=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200416195626eucas1p2f906c0499eeabc32169c93bedfeffb98~GZQQECp_J1396513965eucas1p2f;
        Thu, 16 Apr 2020 19:56:26 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id AD.78.60679.A68B89E5; Thu, 16
        Apr 2020 20:56:26 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200416195625eucas1p18d95d63a8fb2f997d4c2eb63d15726f5~GZQPTXBN01641516415eucas1p1p;
        Thu, 16 Apr 2020 19:56:25 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200416195625eusmtrp1dbd83e97ba803f69dadb91b7cc5e72c5~GZQPSjAJ50640106401eusmtrp1b;
        Thu, 16 Apr 2020 19:56:25 +0000 (GMT)
X-AuditID: cbfec7f4-0e5ff7000001ed07-81-5e98b86a0ece
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 1C.2E.08375.968B89E5; Thu, 16
        Apr 2020 20:56:25 +0100 (BST)
Received: from [106.210.85.205] (unknown [106.210.85.205]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200416195624eusmtip264d584c752fba6ab3caac4a381259466~GZQOPKqrq1596415964eusmtip2p;
        Thu, 16 Apr 2020 19:56:24 +0000 (GMT)
Subject: Re: [RFC 0/6] Regressions for "imply" behavior change
To:     Jason Gunthorpe <jgg@ziepe.ca>, Nicolas Pitre <nico@fluxnic.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>
From:   Andrzej Hajda <a.hajda@samsung.com>
Message-ID: <01f964ae-9c32-7531-1f07-2687616b6a71@samsung.com>
Date:   Thu, 16 Apr 2020 21:56:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416182106.GX5100@ziepe.ca>
Content-Transfer-Encoding: 7bit
Content-Language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA01SaUwTQRjN7C7bhVhcSpEJKsaiiZpwKBon0aASoht/IZoYRYGqG+5CWrn0
        h4jIIZRTOQo0xIgg0UDQApIQpECBcIhS5JAEahSBUIhUUDnUbhcj/9733vdm3psMhYuUpBMV
        KrvJymXSCAlpQ9Trfr11DWssCvAoqHBByv5uDK3n6QSo9G0ygfRLCySqHKwBaOjHDI6Ki7oA
        6p4bItDihwyA0nOfCNDDlQocDTaVkmhKqySQZmYeQ4bJESukzfJHuvJtSD09TaJCpRE/ac+s
        ruQBZmHkvoB59WwUY6a6UkmmJK3YiqmrTieZrpz3GNOwPGnFqLvPMRMZneaNwjaMeaPMJxhT
        nTOjMX0kfG0v2xy/wUaExrJyd68gm5DB8RJBdJM4fmVMTyaCfPoBsKYgfRiuvczCHgAbSkRX
        AbiQqwL88B1AVV72xmACcLY+yTxQFsu7SV/OLaIrAfyZLeZ3FgA03KvCOMGe9oKTBUqCw2La
        Bz5KMZHcEk6rBVBfVmkRSHo/XH85SnKHCs2GniRvjibovTA1566FdqCvwsIPFzhaSNvB7uLP
        BEdb066wYN6No3F6F2wwluI8FsORT8mWyJBup+Dz4RLAt/SBhlWTgMf2cLbz1QbeAXvyMwke
        34ETVck4b04DUFP7GueFY3C8f8WSBzdHrmly5+lTMHMxG+OfxBaOGO34DLYwr74Q52khTEsR
        8du74USfZuNAR1gxsETmAIlqUzHVpjaqTW1U/+8tB0Q1cGRjFJHBrOKQjI1zU0gjFTGyYLfr
        UZF1wPxJe353fm8ETWvXtICmgGSLMOhEUYDIShqrSIjUAkjhErHQ9oiZEt6QJtxi5VGB8pgI
        VqEF2ylC4ij0fDxzVUQHS2+y4Swbzcr/qRhl7ZQIntY8netVO18cOPutlik7sy98q0Gz/Mut
        1ujt37LWMvtVllvZ2/dH2nHpSvPFcrZgIEkX6KkPbN3TCgwzc+tG8ZdAWVxbw/x+/ahsy9Di
        79uOKdVhwztT/cmh9tOZvTvjw16EuQaI/Y6eN4qzlS6hXh7z0w5TDqt2frqOsVjQHC8hFCHS
        gwdwuUL6F1b/5nugAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec9tmzQ5zVkvhiWjoovOzmz6KmYSBudDhdW3ysvQg5puq50t
        MgjM1HK50Kypy8woCYVuzltKUCumw0ukJes+o4aGc+HoZiptWrBvf378f8/DA48Ql9wgI4QF
        Gj2n06iKZFQIMbjY/yGmoKc+c9vw7RhkGnFgaOGSXYAan5cR6OV3L4Vuj90D6NXPKRw11A8A
        5Jh+RaDZ8QsAVdbcEqDLcy04GuttpJDbZiJQ59QMhiZcThLZLh5G9uZVqGlykkJ1Jg+eGsb+
        mbsEWK+zXMB2tL7GWPfAOYq9er6BZNvbKil2oHoUY7t/uEi2ybGf/Xih39+oe4qxj021BOtr
        X8t2+t4S6aGH5Mk6rUHPReVref0O2WEGKeRMIpIrtifKmbiEjCSFUhabkpzLFRWc4HSxKdny
        /LF3VwXHeqUn5968pEpALW0EQiGkt8MXrnQjCBFK6BYA33rnMSMQ+flq2Hfdgy/nMDg/bqSW
        Sx4Af7luLpXC6BToMpuIQJbSafBKhW+phNPNAnhn4Ay2bIyT0OybWBpF0ZvhgvU1FVgt9tuD
        pbsCmKA3wHPVZ5ZwOJ0By15sDmAxvRI6Gj4TASyiY6B5Rh7AOB0Pm6zLA3F6Hez2NP7LUuj8
        VAaqgcQSZFuCFEuQYglSmgHRBqScgVfnqXlGzqvUvEGTJ8/RqtuB/z267L+tPWD0wUEboIVA
        tkKcvbM+U0KqTvDFahuAQlwmFYcq/Uicqyo+xem0WTpDEcfbgNJ/Wg0eEZ6j9T+bRp/FKJkE
        lMgkxCXExSPZavF5+skRCZ2n0nOFHHeM0/33MKEoogSUL7TutV1xR41cO7DH+ZCITE8OmU3d
        F3M/XdH35fQaPGdkqAk/e7y5ospmTzNPrvpT2bXb7V5bWphZjllFsUNweP2eo4sdyNxS6GlN
        Nj6LLCmd7rPerXNVkeRExvukmuhiNvprm3frqMO3qVPtpB4d/GZYMz1r3JtT0Z4xtRHJCD5f
        xWzBdbzqL6xp3kE0AwAA
X-CMS-MailID: 20200416195625eucas1p18d95d63a8fb2f997d4c2eb63d15726f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200416182112eucas1p1030595f63fe250ff02dbab2707df11e9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200416182112eucas1p1030595f63fe250ff02dbab2707df11e9
References: <CAK8P3a0aFQ7h4zRDW=QLogXWc88JkJJXEOK0_CpWwsRjq6+T+w@mail.gmail.com>
        <20200414152312.GF5100@ziepe.ca>
        <CAK8P3a1PjP9_b5NdmqTLeGN4y+3JXx_yyTE8YAf1u5rYHWPA9g@mail.gmail.com>
        <f6d83b08fc0bc171b5ba5b2a0bc138727d92e2c0.camel@mellanox.com>
        <CAK8P3a1-J=4EAxh7TtQxugxwXk239u8ffgxZNRdw_WWy8ExFoQ@mail.gmail.com>
        <834c7606743424c64951dd2193ca15e29799bf18.camel@mellanox.com>
        <CAK8P3a3Wx5_bUOKnN3_hG5nLOqv3WCUtMSq6vOkJzWZgsmAz+A@mail.gmail.com>
        <874ktj4tvn.fsf@intel.com>
        <CAK8P3a1S2x1jnx9Q5B22vX8gBHs0Ztu-znA9hqZ5xp5tRAykGg@mail.gmail.com>
        <nycvar.YSQ.7.76.2004161106140.2671@knanqh.ubzr>
        <CGME20200416182112eucas1p1030595f63fe250ff02dbab2707df11e9@eucas1p1.samsung.com>
        <20200416182106.GX5100@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16.04.2020 20:21, Jason Gunthorpe wrote:
> On Thu, Apr 16, 2020 at 11:12:56AM -0400, Nicolas Pitre wrote:
>> On Thu, 16 Apr 2020, Arnd Bergmann wrote:
>>
>>> On Thu, Apr 16, 2020 at 12:17 PM Jani Nikula
>>> <jani.nikula@linux.intel.com> wrote:
>>>> On Thu, 16 Apr 2020, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> On Thu, Apr 16, 2020 at 5:25 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
>>>>>> BTW how about adding a new Kconfig option to hide the details of
>>>>>> ( BAR || !BAR) ? as Jason already explained and suggested, this will
>>>>>> make it easier for the users and developers to understand the actual
>>>>>> meaning behind this tristate weird condition.
>>>>>>
>>>>>> e.g have a new keyword:
>>>>>>       reach VXLAN
>>>>>> which will be equivalent to:
>>>>>>       depends on VXLAN && !VXLAN
>>>>> I'd love to see that, but I'm not sure what keyword is best. For your
>>>>> suggestion of "reach", that would probably do the job, but I'm not
>>>>> sure if this ends up being more or less confusing than what we have
>>>>> today.
>>>> Ah, perfect bikeshedding topic!
>>>>
>>>> Perhaps "uses"? If the dependency is enabled it gets used as a
>>>> dependency.
>>> That seems to be the best naming suggestion so far
>> What I don't like about "uses" is that it doesn't convey the conditional
>> dependency. It could be mistaken as being synonymous to "select".
>>
>> What about "depends_if" ? The rationale is that this is actually a
>> dependency, but only if the related symbol is set (i.e. not n or empty).
> I think that stretches the common understanding of 'depends' a bit too
> far.. A depends where the target can be N is just too strange.
>
> Somthing incorporating 'optional' seems like a better choice
> 'optionally uses' seems particularly clear and doesn't overload
> existing works like depends or select


I think the whole misunderstanding with imply is that ppl try to use it 
as weak 'depend on' but it is weak 'select' - ie it enforces value of 
implied symbol in contrast to 'depends' which enforces value of current 
symbol.

So if we want to add new symbol 'weak depend' it would be good to stress 
out that difference.

Moreover name imply is already cryptic, adding another keyword which for 
sure will be cryptic (as there are no natural candidates) will 
complicate things more.

Maybe adding some decorator would be better, like optionally or weak, 
for example:

optionally depends on X

optionally select Y

Even more readable:

depends on X if on

depends on Y if enabled


Regards

Andrzej


>
> Jason
>
