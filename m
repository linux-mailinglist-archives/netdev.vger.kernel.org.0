Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8639921A2DB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 16:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgGIO5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 10:57:20 -0400
Received: from mout.gmx.net ([212.227.15.19]:40047 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgGIO5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 10:57:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594306634;
        bh=M5e+/eaY/5UG+2MSsrtR/fR1Rk9bVfJo5kIypTgzTBU=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=ZStSHV4wjIgNbC3dD7hY9Nfx9HArUSGonZQ9gL/0Ls0NDw3n/0I/i+RxPYTet4kBK
         C8zxUjb9AK7HqrbUMqsRu/toD2F16XWExrr6nG0GmwlAhu8zf9BEjyRo7ZfbGK8I3t
         1xXe8f/EKz6AuMjU65Anb/Lb0Rlf8VEQoNywJXUs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.20] ([149.224.144.145]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N2DxE-1ktseK0dUE-013cip; Thu, 09
 Jul 2020 16:57:14 +0200
Reply-To: vtol@gmx.net
Subject: Re: [DSA] L2 Forwarding Offload not working
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
References: <29a9c85b-8f5a-2b85-2c7d-9b7ca0a6cb41@gmx.net>
 <20200709135335.GL928075@lunn.ch>
 <50c35a41-45c2-1f2b-7189-96fe7c0a1740@gmx.net>
 <20200709143533.GN928075@lunn.ch>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <c1030071-2c97-28ef-aaaf-44076a3b805c@gmx.net>
Date:   Thu, 9 Jul 2020 14:57:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <20200709143533.GN928075@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:Salq+prUrk3/E+viVdOGCIemzFVqRllFke5g35pmJrMfvaPHkca
 GOlK8ZK9fzfStLLTOqmnKiagKrqvK3Gccmoh6HvF5ipDUFius+DUcWd57+iBFURoI1WsQHc
 fbbpDP2iKNx0y1KFiyz4iSF51u7nk8N4VlsVbiHUkV4zN3WnRHeGrQVnMwPxyQ8nrZGjCSv
 VG8pKeN9VPxe7Udw6Qhhg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/DIBKFVrpGs=:38NN7cdIo/m/hGyHGZoHAQ
 aIrpmG6HGpkYCh5klMdJ0qSeX0oGaCZFyOJe9Z83cvex7bH2rNiOeIuB8i6BJrV1DCIHqoYt5
 /rHtZ5i6SdtXDhjSyL/hxIQ1ST87JcjuQGvLSn2GFQ9jFzTUSxX/AN+MgADGM3XBhWSyX0+B+
 fP4BYll5UsWO/Z8FimAdAwjGqM4XTDP4Naq2sjNt/f9p7GQ0EGnycquL4D7+IwuO49jTZSs5u
 7XdxN0nIhIkv70j1hnnSpNNFIt59pKcGIPDEPl51djp+9sOaWzyh36LKiwf3IYSbGwHCWVF9i
 gKpCUSkFVkX00oiL+ktdVW+UCbScRL4UfT76FM8K8sLPQGpIJwybHI7kNiQnbu4woBNTspFAq
 WJ1vTbDOPc3dZ7ETDiYY3gwax+rTmMKYdC773xZ86wMDsm5hwOkeVPZK9+ocKOCeK8TGvaiBh
 rmxQ8CNkuFBAI3GPVuGBMirF2QZ4qJVNPVm45b7Cz5mln+9Tjsdva58klZWARTVIUSMoUMWc2
 EDXnIUADUGob7iTX3JDsifWdLpfIfhkqgGD92NgNXWUkuqEoSBTCmLLMCbIOscOS3Or6GZWnw
 PzTtEEgzC0SRbJYuOSGa6PpQF4rWZ7q4G/lHHAAe0yEPJCCNS44a9wfP7OAyuyjGKdxjiZ207
 6DK506guKFCVSvWCgPVB/vfzF+DpcqHKScAgMqAz8JmmSGVmPbrXuMUD0sW5VP0NmxD9ycx+n
 hzRMyF+3txFiaJ9NWL98oeZi0BznvYeEQorpEdFXfZ6FCmji5QBbNKanV1TsLBwq2lPugq5/C
 4ASHclj6GtDHzotku+VA3J3pLw0XwreuOtmuJN5eRIWVKq3LrdXqktb3BloPrQFvmh+vIYILu
 EMFI1nyaFC8N12taphayYGH3ioAPT2y8fxUEgwwlp+51z6OJh9zbv4YAw7J1vG5aze3uuXofE
 /IPBlFWvAc3feND2XCAPlWIsEBQLs1zhrVj7BR6VqTJLsH/ThoKKX/zJHf56wcCvjk17Kd9Y2
 rWmkatReXYFFWPlV//AB1r8OmipL/Rpr9fMCZ6gY24Nz0me/jn64lLSWw2HQ0+3wTnlI2eZPy
 SdLy+uNsPV5qb+dS0tV0XaF1Oeo+OeeRGjxEuTZMFMamjMOBYjSnefosB0a/4HEcuzcAR8xkH
 g2EWeoX+6fjhAbelJSaEgi3W4shVFLuToy5ODfbeoGsGTFngtvffWR1KI9/qmDiaFc8/9Lyqt
 KGvOFi65zdWxVvVhN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/07/2020 14:35, Andrew Lunn wrote:
>> Two questions if you do not mind:
>>
>> 1) does the above apply to all stable kernel releases or only =3D> 5.4?
>> Because with 4.14 there are reports that dynamic addresses of clients
>> roaming from a switch port to an bridge port (upstream of the switch,
>> e.g. WLan AP provided by the router) facing time outs until the switch
>> retires (ages) the client's MAC.
> DSA has always worked like this.
>
> It does however very from switch to switch. When adding a new switch,
> the first version of the driver sometimes does not support offloading.
> All frames are forwarded to the software bridge, and the software
> bridge does all the work. Then the driver gets extended, to support
> the hardware doing the work. And the driver gets extended again to
> allow static FDB entries to be passed to the hardware. DSA drivers are
> not 'big bang'. It is not all or nothing. They gain features with
> time. So you need to look at the driver in your specific version of
> the kernel to see what it supports. And you might need to be careful
> with the OpenWRT kernel, see if they have backported features.
>
>> 2) The document
>> https://www.kernel.org/doc/Documentation/networking/switchdev.txt cites
>> (for static entries)
>>
>> bridge command will label these entries "offload"
>>
>> Is that still up-to-date or rather outdated from the earlier days of DS=
A?
> It should be true. But you need a reasonably recent iproute2 for this
> to be shown.
>
>     Andrew

The distro backported bridge from 5.7 (ip-bridge 5.7.0-1)

but the offload label does not show, which I would reckon does make
sense anyway for the DSA ports (or should it anyway?) but then attempted
to add a MAC to a WLan port (mPCIe to CPUl), e.g.

bridge fdb add MAC dev WLan_5G vlan 1 self

which printed

RTNETLINK answers: Invalid argument

and

bridge fdb add MAC dev WLan_5G self

which worked but does not show the offload label either, instead when
queried with bridge fdb exhibiting:

MAC dev WLan_5G self permanent
