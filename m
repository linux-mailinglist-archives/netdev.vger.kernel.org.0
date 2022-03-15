Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54C14DA535
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 23:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiCOWVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 18:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352182AbiCOWVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 18:21:33 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443485C64A;
        Tue, 15 Mar 2022 15:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1647382811;
        bh=F7qzi2Jtg8G6t/zA0obNAJDFPFB3OxtU5mvSGJmS+7g=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=TiaDUmgHP/HED/+pQbT/Hn+jBPFJx7cXSVzmpnUgPZWGMG6PmwaPIzlSHlbm/j7GC
         6Oh2R4RYrLwvkk4E4Kng8a/u18uqweWZTx4p5IdanIQoEsHhoZyobVTl8anhUtuGJj
         J8a1BFmNo+hE7eDRKTtYl1XbmfqiVLqGP6ignmTI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.131.186]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M42nS-1nUFWV0LB2-0001tn; Tue, 15
 Mar 2022 23:20:11 +0100
Message-ID: <a66551f3-192a-70dc-4eb9-62090dbfe5fb@gmx.de>
Date:   Tue, 15 Mar 2022 23:18:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: mark tulip obsolete
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org
References: <20220315184342.1064038-1-kuba@kernel.org>
 <29f1daf3-e9f2-bbc5-f5e5-6334c040e3fa@gmx.de>
 <20220315120432.2a72810d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <20220315120432.2a72810d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eajRvEXOB2r7/rbj10wFvcBtdPYoIpPMwkHrIzVSSQW8lkEKLDB
 f7RorEr3aG1wq4vLD9lqq1hl49XS0kBAysmJ7GtaeixVS7ArtWRYJv/walXix16duG0ks4n
 5jwYW+0F4lXx1cppHvMBgBMIIrqX+QtJs+wSHEspFNeoiKpC7pvOEspgpNWIECz0Puxgn7d
 O5B4YzE+YjGGqJrVdYDog==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1ROlVqA4oI8=:8qWtrmXfeuG0LRBetC8fEv
 uwr2fGmYoNVbb10GSWp5NGR0sFx8QhWa1zJzYEgTpSB7c18B+LGfGPA62U1tERWX5V6+DI1dK
 9jugx2ocfZRPchNOzoIg4vgJWTBYwulKgfTQ+fLXOP0Yt5QkmT9+tBIhqMJGctYUNMRoYgQ00
 dUkoXVLFERh+ulx/zvDBaqopSYoqtaxp8ISYfRuEtes8XYWnRbLBpAKdbQtB+HH1b6/ITzRoI
 p1OL5f/+KjkObhKHiv8dAsmEGS77K5ILg1MtyMIfG+GQp/G6YQYGu4JmDqrKJdySMThW6tMtK
 g3PbEvoi8ho/9BJoED/CtzGWc8ZN8PXbs/sN14JT3m2O1zffVWovTKTA5Zf2LrrgzvyBp4lw/
 ndXv2d1r1n5l7KpXWFeNg/wZF4LiR5uRZYz1YiYJGmqCzPaHjB7VUJOmnhyY//5IBlzPaHuc6
 dGMcrTNfxfd/rbQI3yaaPuPcTgniH1G7EXQZ5Hj3BCXJGsY1WrHMDT3Ni6CxuWUWWECMnNoEU
 M6i6Jpp230Jhl2k2rcJ9Vfn7jMV7At8S3VqCDTbCTOVuhE0aVMgVB0FmDoeZSUAAdq+RTHJSN
 gkCno8nc4anZa2GPOBwNdYGQ8aTTZ+mVkW8zIceclHwmH2MZJ99F6njR8qICUimDGc0FQyROK
 iTtLWaT7J0cXmqCeR8mFucBAXohHmMwKW29iqNPmscnWFnXEVyXrcvq0MJ/M3LVrW2iqy8O27
 Uim0vV+21dCiTYb1mj4ZA/Kb/qOCDQi7PBy4oq5zWIfvXWJyPdQTv5R1ocmJd2LvyW6/X+rBl
 O6l9FMsBhZWcChhdePybhs0rsm0heIxrSw+I71KswfAzj/74Fr4Z7H+zu0v8scHV7aCvGA3AT
 eixsSSLV1L6vGhhc9Sw+t2U1ttHLjwtIc695oMUdiOkMu1HeeWfhyknP6L9zwo2ky9umO9/P7
 oV+e3eQfO3UW150MNjHPOmqL+QUeKo1Cgjvc41oVOCjsaHdjvFyOiWPJtme6FWkpbPDD1ldpn
 cHQnd2mNuYDfph5y88h6k+SgXhp2JxEB1kuZbXWKFoBHsQqDRDQIElnSMoaZEo9lsP2JWos4n
 C4R+Oa5TFrj26E=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 20:04, Jakub Kicinski wrote:
> On Tue, 15 Mar 2022 19:44:24 +0100 Helge Deller wrote:
>> On 3/15/22 19:43, Jakub Kicinski wrote:
>>> It's ancient, an likely completely unused at this point.
>>> Let's mark it obsolete to prevent refactoring.
>>
>> NAK.
>>
>> This driver is needed by nearly all PA-RISC machines.
>
> I was just trying to steer newcomers to code that's more relevant today.

That intention is ok, but "obsolete" means it's not used any more,
and that's not true.

Helge
