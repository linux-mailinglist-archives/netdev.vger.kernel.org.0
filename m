Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CBD1377E9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgAJU1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 15:27:43 -0500
Received: from mout.gmx.net ([212.227.17.22]:46693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbgAJU1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 15:27:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578688060;
        bh=I/JAISfHvRPnhmv0O5h8ysJ6wAr7MUQk58JpAjt5yLI=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=IoPtDoNptMfSdZTS4tURCuJkEHlg9wz2hm+SxZG3D3Xx/vgKsHnujfZvUu9eoixrU
         gL0dYz8cPKtlAUJ7nGkvFEFhrrc/fbrSpQORyv/JnGyape2CgN1HbqsNzafrawcVV/
         zIlXOgubVXEaH3L7gTZrQekQRFQzJvKWf5ScchWM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([46.59.197.184]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N1fii-1jnEIN3Dia-011zjg; Fri, 10
 Jan 2020 21:27:40 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20200110150955.GE25745@shell.armlinux.org.uk>
 <e9a99276-c09d-fa8d-a280-fca2abac6602@gmx.net>
 <20200110163235.GG25745@shell.armlinux.org.uk>
 <717229a4-f7f6-837d-3d58-756b516a8605@gmx.net>
 <20200110170836.GI25745@shell.armlinux.org.uk>
 <12956566-4aa3-2c5d-be1a-8612edab3b3d@gmx.net>
 <20200110173851.GJ25745@shell.armlinux.org.uk>
 <e18b0fb9-0c6d-ed5e-3a20-dc29e9cc048e@gmx.net>
 <20200110190134.GL25745@shell.armlinux.org.uk>
 <a2a22d92-11ec-5f80-f010-d8da838b7cbf@gmx.net>
 <20200110195533.GM25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <b8b9a61c-d361-e6dd-1cd9-db4cea624fd7@gmx.net>
Date:   Fri, 10 Jan 2020 20:27:39 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200110195533.GM25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:EY7gtmb+2ctrOb12beycTORJtm594IlOf7s9ezxf+9phbb2BhGs
 fho9gz15F4BvM9wx6QIaaOhYj48836G2f+XqahJueiaD1x/cMCXKnQM4JMwveNRm5pHenLp
 sjfnqFYG8W7vH5JNYADBEBsiSeiQW7JM5pUzpevMiYJyptPz3gKJTXdNc2t3N67kq/3VAKe
 aAD8LG+7mmNydOls/ja1Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q9T6JtYdxII=:+X+7XSlG0L/dbnemVr+4d+
 mXlckSjpDRwYzco6dtDXawN2V8czBhHuToIkXb7nWgjQDN1lSBxwNTCo1BJAPxkhSCq9WcETW
 ozN4H+8iavWRiEB7wFJkygOXb++FFIW8agY+J+r8FZiHw6fvS7qvT4oGuNRJA4srJSQIw0hCa
 HUkMmqEjPxryBPVnxj+W5lZUHNzveTvk+ZAYIJdo6oV5VU2v3e1L6MtB6JxnVy37zMTDB42xj
 9QlZov8SnMdB87OgMPJ9JnpPsYk6sSZyoYI86RbITAXIiutv7KtLkIK0e0rsC6vLoReOktP0s
 +zf7sLmWQ2C3BBIaF2YE4yIiPWjJOngU1GWOlnzMcmMUt5cdwS440fxRsqaeWSmRQZpvHWwf6
 qClez6McBx1Yk6nXhy0BhOADeSUfCy8M4wcVb3ndHteihpVH8JTmDb75ffxeIoCPo6dQbg0oM
 ac5ttZsLW9hYKqNFJUHI7TcoVW1X7DWPurCJRTPos1WWKRbXYAlWaGnomhsMjkdizYGwj4rAs
 uhTdRJeXGYuBCudEo50l4zx704fA1SuAcJRBOVtkQYv4Y10exhqKV+jRYIWn6La9p+8wxNR7r
 2t+73k8vgIpeFdknu8G9023yimfhQAPmjwRhG3Mw0qPO5PKJtCyE0+wcU/uulH28QEZwlGoUe
 oJ6qmI0cpItKontrTcWahWqd0Qt7E/JCE73JRIJr8GojFNECyRfpqgGTB3e3o9ULEWeXYkzOJ
 VUsWCFW7ztTiEyPWxly34QAtIc4euacGy71EHdUYYILyGBe+gxjhurF3jnrEvpZ6T7uChhY6r
 C4QwDrghaIFpzSiS+HpcUiT2AGTy+M7SMVa/AfZ14qSkbtg0w32xArwsLnfcL4DVEL/Snps0W
 3DTkn1CyWjybqV1S41i7ZW882YzufEsnMy5370a3cStP1hGywZnr3uEUt/4FIFIMZHYG1fanz
 LliO1vSaFgKVUVXkj3KR2Hm8sDL+YnyN5vFcrBiV+FvCor9aRDQ1MNQJiakac4Cve7je/BqGE
 S2xeAWebr8tP6xvBc46s3oxaGMvSTFF9PwtlGD570/hqTWEWLESnLBQog1d3utf/UuQaUn45x
 E+UgH8tBX+mq/RzF3pCJEF4IRbjp+jMWDn2ujPvUf7RBcQsggyID1p+hKXN0NgVAR0uy3dVQv
 66+fsI9TWVyYc+5lgMM8pIwZhkSGj1N8spedhXmJY0/S8GeN1BTgVLXOYL1DFfOHl2OTBNPtn
 GlPPLLYpoOjx2UaSTUMubwcqg5xa8oZYQWXFqfA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/01/2020 19:55, Russell King - ARM Linux admin wrote:
>
> Define "stable once the interface is up".  Is that stable after ten
> seconds?  Or stable in under the 300ms initialisation delay allowed
> by the SFP MSA?

The router boots, SFP.C is called and performs its functions and the=20
module gets online and stays that way.
At some point the modules thus apparently passes the checks, incl. the=20
under the 300ms initialisation, or else it would never get online and I=20
could trash it.
Once up it is rock-solid - the IRQ values are staying constant.

If at later stage the iif is being brought down and up again the issue=20
starts to exhibit.

>
>> The 5 toggles are resulting from manually invoking ifupdown action.
>>
>>> Therefore, I'd say that the SFP state machines are operating as
>>> designed, and as per the SFP MSA, and what we have is a module that
>>> likes to assert TX_FAULT for unknown reasons, and this confirms the
>>> hypothesis I've been putting forward.
>>>
>> This is based on the 5 IRQ toggles or the previous reading on the GPIO=

>> output?
> On _both_.
>
>
> Okay, I give up trying to help you.  Sorry, but I've spent a lot of
> time over the last two days trying to help and explain stuff, and
> you seem to want to constantly tell me I'm wrong, or misreading what
> you're saying, or that there's some problem with the "sm check"
> when I've already pointed out is a figment of your imagination.

Not sure really why took such offence from that bit of summary.

I am not saying/implying that you are wrong, just beg to differ - there=20
is no explanation why the module is passing the test on initial up (at=20
boot time) but failing intermittently with ifupdown action later on,=20
that is all I am saying.
That the module is failing checks is hardly a figment of my imagination=20
or else I would not have bothered in seeking support in various places,=20
and prior reaching out all the way upstream having tried first in this=20
order:

- TOS
- OpenWrt
- vendor

> Sorry, but I'm not prepared to help any further.

It would be just sad to leave on such note and thus just let me=20
emphasize that I have thoroughly enjoyed and appreciated the exchange.
Unless you object me posting to this mailing list I would just remove=20
your email address then.

