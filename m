Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6301847D5
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 14:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCMNRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 09:17:53 -0400
Received: from mout.web.de ([212.227.17.12]:43835 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgCMNRx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 09:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1584105458;
        bh=s17YN6zBvUkf8m+IR4qkLbONDJ8Rl5iogNahwfY04L0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EkroZexSqNRhgu/n7QEI7Qb3xRC9C1nnKzEUwMq4CASb5XasHgRZK3O16owX+G86E
         qaRKlkFwMQvGkX/tl/pYkfCztvOFqhK4kVhGOIXlouy05da2BLzOwnskQAklX6CbxH
         NyxkRZ2T+ZZdxZfXAYrUjjYq57zwriTChnC6uCNs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.23] ([77.191.109.216]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MRUBA-1ikG0g1dv6-00SjQl; Fri, 13
 Mar 2020 14:17:38 +0100
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     chi-hsien.lin@cypress.com,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
References: <20191211235253.2539-1-smoch@web.de>
 <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de>
 <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de> <2685733.IzV8dBlDb2@diego>
 <d7b05a6c-dfba-c8e0-b5fb-f6f7f5a6c1b7@cypress.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <09d6c2d7-b632-3dd1-2c9d-736ccc18d4a9@web.de>
Date:   Fri, 13 Mar 2020 14:17:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d7b05a6c-dfba-c8e0-b5fb-f6f7f5a6c1b7@cypress.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:BnRPO9/yoBVzD9397yrzsC8frrT9NO6N1rg6fxEL1s/TpY8gBJs
 T9I7UAKzTjLELxaKIyjGe4GEWi8ZkMmTnESd2jeac7rlL2ZyPKZ02neSX55SjVbwuo6WZYg
 uue+4wWpOcKLpRTUf1vrqytHX5qZ7ikSaSBkHWE8K0Dn1QdvlCt/InOde3CWsVhw0ll2H4Q
 0punPCQeAhK0y2UZ5p8ow==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cF3WspyrK0M=:BijzAxOqvZo5FBsY8cbBzu
 a9X5D3QrhmpNrUWUmjpCUCyFBXDwC+zY/LMJtVlbMaqzBphnWmw8WQvOJ3GzwtnSPB7xOnQLg
 Nr6LZhF4y+o4mryN5gJiYkLLlRQYCgF6IUMRlufYfT6NZCjTlEmpR0e07oiH3NCYViB+HLj/W
 qeSaMlsVIFLwAumQrWH5ZjLX3+Bo2nzT+GiplMlyXd21Z9AzW1A7q5aMJLjPpwI/zNloCCD2C
 c+I7khkLyH8lAoYYG16MfMpmkzgEvVqnHOnccExVO43dsSNAxPuMCypRZxjUfhV2F5I3q5nEV
 Yqoq8tbxzXWKDHglQeZs26m/UVHzUn2Yunnzzy3LlHXKA5KnlB9dkiYlQfa6DTbFfGqPTjTW0
 /LNfPfslrrKgp/EI3kupTNu/qlc1tlMmqXXkJOYDRn3sewSQy95UefK5S8s65xM5qqa1gf79C
 MegkN5FQy1Xnuv2KIX8jrxErcBYzJjBicevZxyMtZE+IAhm+sxijzQahlBl8SD3rgKwoJZCzk
 OAMN1N5xyRQ7QOmlMlfn06UMS5s4wHFSDvDbcXpZE0b1nqIxC+CQHvdAVLfAZABsi1JItZdx6
 gZIxoVmJKMul/nzAE3vIodRcVlAX92BvW5k591I6juSFQGW/SDnHndPK0Svp6jc4eJOfcJo4D
 3Wy3GC9oh5UUXG0dRz4U6SToxK6eksE1F8YH4//Qav6ikGVrK1XbENms0c5biat/xL32hmAMq
 hUg3/fLQpp+dwU9mdtsPfrVGjQrd3RPoKDA8mKpHQZJFgnauU81px2MHSEP+bQwr7Bp4nOp7M
 wY5Wytbfga3y/p66R0ypwIsQB56u7AyJ6mpjI7BrKQ4dR9CdpfhuQmB+mavsn+8eukBhXf2E9
 GH48TUquQya1jShqcWnIhwhBNEl8WXo0mTjeFNZvECDBN3NYb138fScLh6lV9n3CK0aM6NSkY
 qwsp8jzWe35yVdZOYJWjCYrpg3vTpyba0o0tYVevRyUB2OBRBAFL+MTBzs1zpLJn0FZVgBsZg
 WLl06i7fmBD24hFbJVGLeiU00OD78uS3Wq3B+V0Gj4eFEOJlREoPCwTDiGnhwv9iEn8D1fMsG
 XmM8fG1qeZfGh3edCLl8RofIkFvhvRAFVCxNO7NJD/6iBYXmSSq3Rb/PYsXbEBW/LwXhtyYDB
 B0labZIm6rEcYDGPl5Ijx3JZqLQGwaJvc/J+AqCnkX5RRoESOR08F/Wi8T9+X+zYoAFc3k/LH
 uybn9eMmp2+5GIPBU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.03.20 12:03, Chi-Hsien Lin wrote:
> On 12/16/2019 7:43, Heiko St=C3=BCbner wrote:
>> Hi Soeren,
>>
>> Am Sonntag, 15. Dezember 2019, 22:24:10 CET schrieb Soeren Moch:
>>> On 12.12.19 11:59, Soeren Moch wrote:
>>>> On 12.12.19 10:42, Kalle Valo wrote:
>>>>> Soeren Moch <smoch@web.de> writes:
>>>>>
>>>>>> Add support for the BCM4359 chipset with SDIO interface and RSDB
>>>>>> support
>>>>>> to the brcmfmac wireless network driver in patches 1-7.
>>>>>>
>>>>>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
>>>>>> AP6359SA based wifi/bt combo module with this chipset in patches
>>>>>> 8-9.
>>>>>>
>>>>>>
>>>>>> Chung-Hsien Hsu (1):
>>>>>> =C2=A0=C2=A0 brcmfmac: set F2 blocksize and watermark for 4359
>>>>>>
>>>>>> Soeren Moch (5):
>>>>>> =C2=A0=C2=A0 brcmfmac: fix rambase for 4359/9
>>>>>> =C2=A0=C2=A0 brcmfmac: make errors when setting roaming parameters =
non-fatal
>>>>>> =C2=A0=C2=A0 brcmfmac: add support for BCM4359 SDIO chipset
>>>>>> =C2=A0=C2=A0 arm64: dts: rockchip: RockPro64: enable wifi module at=
 sdio0
>>>>>> =C2=A0=C2=A0 arm64: dts: rockchip: RockPro64: hook up bluetooth at =
uart0
>>>>>>
>>>>>> Wright Feng (3):
>>>>>> =C2=A0=C2=A0 brcmfmac: reset two D11 cores if chip has two D11 core=
s
>>>>>> =C2=A0=C2=A0 brcmfmac: add RSDB condition when setting interface co=
mbinations
>>>>>> =C2=A0=C2=A0 brcmfmac: not set mbss in vif if firmware does not sup=
port MBSS
>>>>>>
>>>>>> =C2=A0 .../boot/dts/rockchip/rk3399-rockpro64.dts=C2=A0=C2=A0=C2=A0=
 | 50 +++++++++++---
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/bcmsdh.c=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 8 ++-
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/cfg80211.c=C2=A0=C2=A0=C2=A0=
 | 68
>>>>>> +++++++++++++++----
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/chip.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 54 ++++++++++++++-
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/chip.h=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1 +
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/pcie.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
>>>>>> =C2=A0 .../broadcom/brcm80211/brcmfmac/sdio.c=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 17 +++++
>>>>>> =C2=A0 include/linux/mmc/sdio_ids.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 +
>>>>>> =C2=A0 8 files changed, 176 insertions(+), 26 deletions(-)
>>>>> Just to make sure we are on the same page, I will apply patches
>>>>> 1-7 to
>>>>> wireless-drivers-next and patches 8-9 go to some other tree? And
>>>>> there
>>>>> are no dependencies between the brcmfmac patches and dts patches?
>>>>>
>>>> Yes, this also is my understanding. I'm glad if you are fine with
>>>> patches 1-7.
>>>> Heiko will pick up patches 8-9 later for linux-rockchip independently=
.
>>>> And if we need another round of review for patches 8-9, I think we
>>>> don't
>>>> need to bother linux-wireless with this.
>>>
>>> Heiko,
>>>
>>> is this OK for you when patches 1-7 are merged now in wireless-drivers=
,
>>> and then I send a v3 for patches 8-9 only for you to merge in
>>> linux-rockchip later? Or do you prefer a full v3 for the whole series
>>> with only this pending clock name update in patch 9?
>>
>> Nope, merging 1-7 from this v2 and then getting a v3 with only the dts
>> stuff is perfectly fine :-)
>
> Soeren,
>
> I suppose patch 1-7 from this serious are all good for merging. Is
> that right? If so, could you please create a rebased V3?
Chi-hsien,

Thanks for asking, but these patches are already merged in
torvalds/v5.6-rc1 as commits
1b8d2e0a9e42..2635853ce4ab

So everything already fine with this.

Thanks,
Soeren

>
>
> Regards,
> Chi-hsien Lin
>
>>
>> Heiko
>>
>>
>> .
>>

