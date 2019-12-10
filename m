Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30A11184B0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 11:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLJKQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 05:16:15 -0500
Received: from mout.web.de ([212.227.15.4]:45433 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbfLJKQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 05:16:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1575972961;
        bh=3lu1/bDzlHQWncDoTWVRGXTFeZBsALALSvK0V4xQUsY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=KFb25BYRz38RT7bBf9g68vibTN2tb4JGx9opUc1mZNJ4Not8GUBMr7buSnrGJUqQx
         7axuRPjrS5qBaXUm59c8a/RaxEmtkkRg7iTR1WqRYdIGTgMCcre1VaK47DMHJqGnNI
         f0BU9UDZvOg/etK6APcDSsREplsuuJu18HeoRsQs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.137.56]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LZvfZ-1htANw25Az-00lm0J; Tue, 10
 Dec 2019 11:16:01 +0100
Subject: Re: [PATCH 8/8] arm64: dts: rockchip: RockPro64: enable wifi module
 at sdio0
To:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Heiko_St=c3=bcbner?= <heiko@sntech.de>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191209223822.27236-1-smoch@web.de> <2668270.pdtvSLGib8@diego>
 <2cf70216-8d98-4122-4f4e-b8254089a017@web.de> <6162240.GiEx4hqPFh@diego>
 <0101016eef171394-2c71e1b8-45b9-4e38-96f9-2841dd0607ba-000000@us-west-2.amazonses.com>
From:   Soeren Moch <smoch@web.de>
Message-ID: <e8742d18-9dd9-bd97-1d4a-0c5312501b24@web.de>
Date:   Tue, 10 Dec 2019 11:15:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <0101016eef171394-2c71e1b8-45b9-4e38-96f9-2841dd0607ba-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:BmouxPORzFnUtMfMs9rkSg06N45biyMWFv+dkxM532l+MBmsCq9
 NKrsNRGYig8S6iERHaN1OEDubM+pu6B4PQehaKPwuJUFbld0HZvWXcyJ1iCZKgK+h1b76D6
 OwuGqbC6k/i4YNYXPy1kRnaSgy69AyTCLqMbYxtDKTTvk8OoS2CaXCk90NFm9+Y6kvbd5Y2
 0ekhcoci7MjDZSaZonzrg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JdUVEkMY6j4=:YPPupy08imKC1CuXy723Fb
 oojqA1+dEiyvgS6ZUBJAZ5A65eTviEtBJV4o4OCd9ZA0kmqfrU80oq0mQclUw/wMuiqNbxiCR
 y3Da5meb5biCNAXVnAmQdeYt3q/eFc2EPwS3yjNRHv1nfPso7gsgJz7qXwGCRNvtMiKifD0Nb
 ma8Hl8QLWIb4RYsLeGebnCYbfNUx+9uxFhYtM3unf340sOM0G4jBgHmJQa7k3pV0dP/WByyFR
 3KD3zRjPgaOaS2P8Hos9QmYpyzRkb7ibRvaAzLfiDmqDqD4M+z5/oP6gZ5+6N/zurIPDpEgNc
 7Dkum/I2cTVCcVwNCJSmuRR+KW6hgNJbCneE4NBvWpHMbjOtAO/86+inVWXFOVLEN+jtOU9qZ
 be7EN7NjWMk7OBd5jHdWtj62PoGnd3/SZaF8tHEjWOrEnsGROV6ElDlSQpM8muQlkuqzH++H6
 /F9+ghMAT/MTY+U162haEdsMeN3DSYtZuNWhs9Pp6CVre4pB3eisliYdbTAzIunnA7iKFNf0c
 q6/Dyf2qv0hWHMqQBamdigB/TMxAgzmlPP/4BbFeYHgEAcbQvuMC6q1Y+qGeWtMBr+pUSMgCD
 pRgSgyJtjBQzR92BWJG8jV4viPa/pHr9iQCcVowjH8n8GvHAh+2WXMn4LXCQiMrfXpp7IJG1E
 qRhinRvo+RsPHe5n3//NEkdSVJiqi8j9cc3mu9nDbm7svfuTupNsQNrmbL+qxs36z0Eunprxm
 djgO6OSSSrhJUbglhLouU3/dNMWySsEpF+UDGOoTb37xsgE4t3uK+gCGNK2lsm7a5EMLPJ6gh
 IjfH2+CYhAPEs36M+7OykUU8DD3p5fQ7PDsYvJ60leWKTChqOSAlmZ8kBYftkBmGy6f/kA0SW
 z0qnFc4vt16ogKGe9d+Psh2aB4cZup83qt7ybXBfqe42hDs6vlYAZakOIbBiOHYq9Pmbbfhmi
 OBTDn4mXyonqoD6LY5e06xvv779fPeFeIvIejlH+9Owo50mtK17RDqY1Ug0uRb3CrsJi/5DGt
 Sk7WpDtlOam9IzBt9otYxh7d+pVc+1hEiZxZlTTZAvr9ORNWwaYrVh4VdBisOI5LMVoCbUq63
 dbXBbt7JW2CX/pqtLvdti16g+lFrtaL1m7J4fYosqSG9ICUMKQhoxdbqXXlJD00XM66nK/Zu7
 /Tr4MHJlY7TFY4F3JsCPRei2XP0PUQ9BBeFZwM80D9dA21UTof7jWkvPnZHcRiU3JOV7mEaXB
 rnyk7ZdfPzyWIuqkjyOqA9ffuicoDRxB6qKykZA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.12.19 10:14, Kalle Valo wrote:
> Heiko St=C3=BCbner <heiko@sntech.de> writes:
>
>> Hi Soeren,
>>
>> Am Dienstag, 10. Dezember 2019, 00:29:21 CET schrieb Soeren Moch:
>>> On 10.12.19 00:08, Heiko St=C3=BCbner wrote:
>>>> Am Montag, 9. Dezember 2019, 23:38:22 CET schrieb Soeren Moch:
>>>>> RockPro64 supports an Ampak AP6359SA based wifi/bt combo module.
>>>>> The BCM4359/9 wifi controller in this module is connected to sdio0,
>>>>> enable this interface.
>>>>>
>>>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>>>> ---
>>>>> Not sure where to place exactly the sdio0 node in the dts because
>>>>> existing sd nodes are not sorted alphabetically.
>>>>>
>>>>> This last patch in this brcmfmac patch series probably should be pic=
ked
>>>>> up by Heiko independently of the rest of this series. It was sent to=
gether
>>>>> to show how this brcmfmac extension for 4359-sdio support with RSDB =
is
>>>>> used and tested.
>>>> node placement looks good so I can apply it, just a general questions
>>>> I only got patch 8/8 are patches 1-7 relevant for this one and what a=
re they?
>>> Patches 1-7 are the patches to support the BCM4359 chipset with SDIO
>>> interface in the linux brcmfmac net-wireless driver, see [1].
>>>
>>> So this patch series has 2 parts:
>>> patches 1-7: add support for the wifi chipset in the wireless driver,
>>> this has to go through net-wireless
>>> patch 8: enable the wifi module with this chipset on RockPro64, this p=
atch
>> Thanks for the clarification :-) .
>>
>> As patch 8 "only" does the core sdio node, it doesn't really depend on =
the
>> earlier ones and you can submit any uart-hooks for bluetooth once the
>> other patches land I guess.
>>
>>
>>> If this was confusing, what would be the ideal way to post such series=
?
>> I think every maintainer has some slightly different perspective on thi=
s,
>> but personally I like getting the whole series to follow the discussion=
 but
>> also to just see when the driver-side changes get merged, as the dts-pa=
rts
>> need to wait for that in a lot of cases.
> FWIW I prefer the same as Heiko. If I don't see all the patches in the
> patchset I start worrying if patchwork lost them, or something, and then
> it takes more time from me to investigate what happened. So I strongly
> recommend sending the whole series to everyone as it saves time.
>
Thanks for your explanation.
I will keep this in mind for future submissions.

Soeren
