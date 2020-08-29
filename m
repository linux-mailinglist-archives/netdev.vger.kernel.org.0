Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AE7256574
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgH2GvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 02:51:18 -0400
Received: from mout.gmx.net ([212.227.17.22]:52791 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgH2GvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 02:51:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598683847;
        bh=SxoEwaiAQ0pJTOazsRSLYff3KdUYfb+1JkvU/7If30E=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=A5fmh2PITVMXeSYNvPuuwkWDp7GkxjNvGB6gEc3n/RbQOaZh2uVJKClC0imX09B/k
         JeKheRVUqjKARDUiQM/72PhDPLPtCktDcc2bDV9LXFjNlbx0936tm1J/8wmNc90GQY
         3fGXdFX+HKRzcuM2pd7N/AgFG32wgRE+exsZP/Yo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.54.124]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MjjCF-1krnu02N9n-00lBJ5; Sat, 29 Aug 2020 08:50:47 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id DBE9C800D6; Sat, 29 Aug 2020 08:50:42 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Brian Vazquez <brianvv@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20200729212721.1ee4eef8@canb.auug.org.au>
        <87ft8lwxes.fsf@turtle.gmx.de>
        <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
        <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
        <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
        <878sdyn6xz.fsf@turtle.gmx.de>
        <49315f94-1ae6-8280-1050-5fc0d1ead984@infradead.org>
        <CAMzD94QKnE+1Cmm0RNFUVAYArBRB0S2VUUC5c4jTY9Z4xdZH0w@mail.gmail.com>
        <4dce5976-d4a1-1fbf-8824-a92adfc542b5@infradead.org>
Date:   Sat, 29 Aug 2020 08:50:42 +0200
In-Reply-To: <4dce5976-d4a1-1fbf-8824-a92adfc542b5@infradead.org> (Randy
        Dunlap's message of "Fri, 28 Aug 2020 16:42:00 -0700")
Message-ID: <87zh6ekksd.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:n1ZcUPQX5+IE7GHuwgGajCAtU+2FWz2hPlDbkDiHo3V7R9/8ab8
 7oUHQsbYE7q+5uPahylw4DRkyzx0lU23FAhBStGYijeTf1eI99GlFrz5/ZOL/nAcfW3U7qy
 CPxMVDI3U+IvWgE6Ia2aZ7wfSYB4+4KyxYR2Sr+b/kcHQ2r3wRXARVkedHiKAAM8oXQfYIA
 JDACfv3sHCtjcUcPhPVPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:tJwpPjJjNsc=:Fz46G4GVnyJ+rkPInIPcVT
 YYjLu3JbsAgKSG7PVZUbIlVr4v7MsPQChCbik2hryZWNr58hQwanru2cvZxOKlzNDMVuLwsRX
 PKtDge/v0VGsYqIW0VDplO3RywN5RGyIsuUyfA+jIoqrOR7W+sh/kbh3SkZg6tqDyr7Kax2MG
 jK+ZYhdqhaT+U+4UGt3DSWF0FcXEB0oU9wdYTk75feJQ87olQTnR7x+1bQcufst59xWQI7n6K
 a2SYY3W4fxEycjTHwZROWzlLBjeWwjizaAtAFhxOr6ZPgkgaR6JwynfxcpIQR7RcSea8iHLOV
 QGVVQi2A+Ye8o+ccKvWnHSrjHxSMRrNdp4v1TdujldCrQLSG60DchOYHj6KWmu81dXiCUY/2s
 5TBDyecE+PlFESlkvVatmf/iXfVYyb7Jl17gSwlo0Izj0K04G3zIjrjPecNZXYqgwTahEWSCD
 LZCqJ26UQCDjtKcueKrcurIIJIIPmcGgnKxC0QVM4AT7/Pkeob08mIKDsBdCljbW9ZyfOzM3b
 QDdoynLE2ExIcR79bH3Kw5YVJDLT/WW8t3MMijiDLj8JXFfflP+oGVOqkS2TxpcLHAFHQEsuB
 +OkVdIrI+PcOzcFWG4llQTN1rqG6lQYHc02ymhLLrc3wsbRvQJKMKpBJPQmquhZFdzfRunJWR
 m6rO7sCPsA8UPzLktharVcd8QIL9sVOujK3KT3G2AW67gN6YDuoo1OwFwO0gUOCHOCqWkMo6k
 06iX2mwBl8MUVBB9Ue0rGTEeWun8BwDaFtgOAxR8pOzolxdiLexSIuLT+/Wmy/gTIX/oZDGdW
 UwdoYC4epRojb5jmrh6Tf40VW1/mcSVAwEsHxdcu8V+RpfeEDi6XMhdBBNYEOycA88MO8sq12
 ujQbFd8wY/xi3h8sTfnNR2UICHLFrwplPpDdy/HsuLvzhl8qmAFo83fFe4znn3WEiVdbmQU2K
 730sJ/mDQ7Gz0Wm7/u/ADnNNctQ2DYintvo9st1LELG8W25Fed+dkX3XFMO9nN9JTcaYnJujJ
 rcueyucRBAcG775Z867PTmvr5ccp8Irwf7f6LhsZoe8VSeWRAUcS/JANlKlwJakrkUZZ29qo8
 q0V4+b12mn9BXfJc6uZbcVD5wUIhUy6SDaZaCBr7HCs9iZsjpmPKwsy3xTITQpqQlKIULcgzl
 1F6qo6rUU0Jf5uHXaJ3r252U8U4yRRITAy0Q3sI7/a30UPdqb1BsnWlQtiog2AmKij5NLhgCj
 v3uFyFMpouLYCap85
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-28 16:42 -0700, Randy Dunlap wrote:

> On 8/28/20 4:16 PM, Brian Vazquez wrote:
>> On Fri, Aug 28, 2020 at 8:12 AM Randy Dunlap <rdunlap@infradead.org> wr=
ote:
>>>
>>> On 8/28/20 8:09 AM, Sven Joachim wrote:
>>>> On 2020-08-27 11:12 -0700, Brian Vazquez wrote:
>>>>
>>>>> I've been trying to reproduce it with your config but I didn't
>>>>> succeed. I also looked at the file after the preprocessor and it
>>>>> looked good:
>>>>>
>>>>> ret =3D ({ __builtin_expect(!!(ops->match =3D=3D fib6_rule_match), 1=
) ?
>>>>> fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })
>>>>
>>>> However, in my configuration I have CONFIG_IPV6=3Dm, and so
>>>> fib6_rule_match is not available as a builtin.  I think that's why ld=
 is
>>>> complaining about the undefined reference.
>>>
>>> Same here FWIW. CONFIG_IPV6=3Dm.
>>
>> Oh I see,
>> I tried this and it seems to work fine for me, does this also fix your
>> problem? if so, I'll prepare the patch, and thanks for helping!
>> diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
>> index 51678a528f85..40dfd1f55899 100644
>> --- a/net/core/fib_rules.c
>> +++ b/net/core/fib_rules.c
>> @@ -16,7 +16,7 @@
>>  #include <net/ip_tunnels.h>
>>  #include <linux/indirect_call_wrapper.h>
>>
>> -#ifdef CONFIG_IPV6_MULTIPLE_TABLES
>> +#if defined(CONFIG_IPV6_MULTIPLE_TABLES) && defined(CONFIG_IPV6)
>
>
> Yes, that works for me.
> You can add this to your patch:
>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Works for me as well.

Cheers,
       Sven
