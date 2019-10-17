Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AE0DB4DC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436939AbfJQRwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:52:49 -0400
Received: from mout.gmx.net ([212.227.15.15]:53191 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436896AbfJQRwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 13:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1571334755;
        bh=JFTzIpl2vUzTaahVY6jDAfJ94neB1yDBl6CpIuujvEs=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ki9RNvFZHRiS7BNyYH+p5jdMtCDRjjuPiYgffoyx8LO0s2mzsw8cGKG1ms87Z8lAd
         C4E5v2BMnIGuYFmLbN8ts6MRwQeuXrJNk+I1eeA8W53N7hWhQwxB8kbsQQCUuWQezd
         1PMAd+BlaUqHlvxsJ4LCtI+azN4SjVb7NFqs4P/M=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MYeQr-1iZEYL3Dt5-00VeyV; Thu, 17
 Oct 2019 19:52:34 +0200
Subject: Re: lan78xx and phy_state_machine
To:     Daniel Wagner <dwagner@suse.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
References: <20191014140604.iddhmg5ckqhzlbkw@beryllium.lan>
 <20191015005327.GJ19861@lunn.ch>
 <20191015171653.ejgfegw3hkef3mbo@beryllium.lan>
 <20191016142501.2c76q7kkfmfcnqns@beryllium.lan>
 <20191016155107.GH17013@lunn.ch>
 <20191017065230.krcrrlmedzi6tj3r@beryllium.lan>
 <6f445327-a2bc-fa75-a70a-c117f2205ecd@gmx.net>
 <20191017174133.e4uhsp77zod5vbef@beryllium.lan>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <388beb72-c7e6-745a-ad39-cfbde201f373@gmx.net>
Date:   Thu, 17 Oct 2019 19:52:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191017174133.e4uhsp77zod5vbef@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:5KbIL5XYuSEW5O/V1kBxP+XAM1gCYsnxDhYduIq3rA8Oy0uC7Ky
 WrWhr1FY/JM0zHjBeePfPlWHTVR10MPMTmF9uFKUUdRVEseGcLSr2Oo3SAjfxpJhSN8WPK8
 4MJugThd1Byoa3/24fYA5U6g+IsbO3cVN3Yh+VuQzJ9l1i1jOTNp8i5pNe/EdOdOroCrrOC
 7vo62KvZ1da1yiVHWe4xg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:91lIPmGiGx8=:C0L48Aq/oiCC6QXlTJopFw
 D3XKnrjHPd6US+fO1YEIVJMuoS1rwMbA9pieS5az4QHMkaM/thncsnNHESYIPgLq406E2r4L5
 vVgpf+eBpR7LnxvVo3nNvRjZmnJmCSIkk0kRHdB2LclLeWQ4NxHE79+ZKdshAYBcpNEwMhy98
 3yA/6+xiKd8cQtC57ljLcWFfJOk/912XNUcDM76yJMFdemYf9jQVrH30UaQSIbPwXlBaEfWym
 HYEqmfBJl6ceVQ1QrlJJYbixI8hR9bMw0vVpNJDFU9MfVsnqspVYIfpohC1T6txz83ylda2YM
 Hso1XPRTekGFUkLyaiqRC623amzKB6z1pF3sMbgOGJodxaM8ti5jk6zMSgGQb2vqdBzxnx50f
 swu7K7D/64xFynb0GurPsj+P1MZKIA9nltiUeAMhqtCs8616fgLUlJ/wpxhL2N3TYV62fQ8a8
 vPwoZSnue4wyhmpOXOx9P1KOzpspyumYBAseoJJa0bZM/CzINH4rmKGN2QbrnbMvfrK9TkV4R
 ODjmeytWRIU7JI12o+BLmu1MITDOe7QTT0IP9WQaOe73n3aE9V1DPsas8lo2Py1QpYpRoCSgK
 EPT3kKARA9s1Q7onKSEYcUs6wvDdufopTM/OkpvVXOL8HlDXzWM2uuj50/YEeePixURv6MeMD
 aBZBjZYSY8G1SV0kma+u1smAt3fE5Tgt+D8+RHgFDj50pT1aUq+o8k6Zq9z2+yWm9nq/syfft
 itwxmOa/b8Fcq1FuXk1iaYc98RQ2VQl6OmbLZh1btnYzTO/Ba3E7FSvA6dBod0trH/AwhSuBR
 nAYVkpoLoucQnmyctDSWzTGTHUHuUQHh6swkHsDlHl7jUsSuParVu4OMWDs2hak0YJYwjtzx4
 mCEfSGmhBbXGM4/W5hQ03AnvakxIWuqFY3yxKdtQQAKixLd1ajFSLiXgvRnoR/Fa6dr9E1Qf2
 5vW9If6pBB/QF9J04nk5VklHeNd9xBYB10uyYYyEPQv5ofxFZv3Sojj5iPsxg0pdkPcADKoXA
 nwrPsi+08P7QytakrjcLS+9d50lVQKdfUgOPS+AIJbg6r2IMX5+a9Sg6TkwRUseXQ8NCsrco9
 hQ+bb3DAFwPGTvVUGt5xSt8ZZH1WufnC4d8QjA48xTtI0s4QIZvZgXvkTxo5a4VxacvS9jjI8
 xT7ksTCoLuEGWw2rIth+sQQ+W7DsdYXKDq2YJs9XOhAznYRFdO5xVCehYvK/+0OfZlJHd98MH
 EIDOLbVDO0u0Tnpi37RD1hY6+mGWYHFdykooqdJA17oFxEeptVIp0EIPMUPc=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Am 17.10.19 um 19:41 schrieb Daniel Wagner:
> Hi Stefan,
>
> On Thu, Oct 17, 2019 at 07:05:32PM +0200, Stefan Wahren wrote:
>> Am 17.10.19 um 08:52 schrieb Daniel Wagner:
>>> On Wed, Oct 16, 2019 at 05:51:07PM +0200, Andrew Lunn wrote:
>>>> Please could you give this a go. It is totally untested, not even
>>>> compile tested...
>>> Sure. The system boots but ther is one splat:
>>>
>> this is a known issues since 4.20 [1], [2]. So not related to the crash.
> Oh, I see.
>
>> Unfortunately, you didn't wrote which kernel version works for you
>> (except of this splat). Only 5.3 or 5.4-rc3 too?
> With v5.2.20 I was able to boot the system. But after this discussion
> I would say that was just luck. The race seems to exist for longer and
> only with my 'special' config I am able to reproduce it.
okay, let me rephrase my question. You said that 5.4-rc3 didn't even
boot in your setup. After applying Andrew's patch, does it boot or is it
a different issue?
>
>> [1] - https://marc.info/?l=linux-netdev&m=154604180927252&w=2
>> [2] - https://patchwork.kernel.org/patch/10888797/
> Indeed, the irq domain code looks suspicious and Marc pointed out that
> is dead wrong. Could we just go with [2] and fix this up?

Sorry, i cannot answer this question.

Stefan

>
> Thanks,
> Daniel
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
