Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A2151021
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgBCTId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:08:33 -0500
Received: from mout.gmx.net ([212.227.15.19]:36439 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgBCTId (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 14:08:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1580756903;
        bh=UiLh6zCU54yGQdKVeY2F6wDqheZNbI42Zc+c4tnRj5M=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FmlFHEBjV7Z2W5z4NallI2T/fD4GvCL/kINueyv0YFrOwn4DjpufJh0dQoMBSSiS/
         VuIsWETmXpQfjU7ABj5WeU0P/jzcrj6d8axBslSFzfW4f1l9wBopSQd2qnsYJclkvK
         rWtQFpF1GL3iDky/j40ODFANNru641MTdlOuIncs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.183] ([37.4.249.154]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MZCb5-1j3HWw0wld-00VAIL; Mon, 03
 Feb 2020 20:08:23 +0100
Subject: Re: [PATCH 6/6] net: bcmgenet: reduce severity of missing clock
 warnings
To:     Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-7-jeremy.linton@arm.com>
 <2dfd6cd2-1dd0-c8ff-8d83-aed3b4ea7a79@gmx.net>
 <34aba1d9-5cad-0fee-038d-c5f3bfc9ed30@arm.com>
 <45e138de5ddd70e8033bdef6484703eed60a9cb7.camel@suse.de>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <70a6ad63-dccc-e595-789d-800484197bbe@gmx.net>
Date:   Mon, 3 Feb 2020 20:08:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <45e138de5ddd70e8033bdef6484703eed60a9cb7.camel@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:TBRHeLDxiNBFFpQ4pCaCTgSeHWK7TsJyeB7TTFezp9D419SmIlq
 zZPzruXph+pvbZaTscETUsOJm0GN/kfTZmmCREWFiy2XNYy3nnOxZ2C9XVjR4cI5s2GdGsj
 bcbBBodG6xEwk3aEBs3B5w25YHc0tiJjRVZR6MMGPPudH0f9+rFGZtx5pMNl0ugT9M4RHbR
 BxJicg9zEcuuhwuf5nqRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1/UOg63QKOo=:/p+H4eydL7dNaSH5Oi0Mqr
 rspvXVROsJta0SSqNukMBRAiYjxQdDHRJlfIg4kZq16vpIGwjjwf+nyBpS1FKruM1QsLwH8O9
 E4gFYXjUF9PCmt8fEpb8XWl7oa+aTQK9eCtcxjft/0laUy5tG79IkHdxybE/02LA60XjQC3hn
 w+QrPk2p11IMVV6P4X4FTlOtHVT2olFeNsUzY6XX4tgQLh8YoqTCHKaSYTvS/XvbX2b0DbRfg
 o8uZ+sq2rPF+9yfbqg7FbTKwFKYlU6AOt1c3TAKs9B6y+OKQqgU7bKORkN2PbvngSlkCvXvWP
 3OtudMt8CbLQbWvcVbXlbY0xpPPx7hCQfdANmrwFLcDz87KPyPCcaQmokJb4IxihCUsbqfALD
 4FOAfChKb3PRvt1h7ZYABIqjTZiKhPNAFuRVNTxCimsCkEaY2Y0bsrA8HahfHwOrKH7D8hVCd
 IkGFlj7Oz3av6cGNaBGOSqUMUXLfz1ljPRW6SXWl66DfjXO8BnrXjZzAwethDOn3zkqWOJdUj
 guYS9ND9OYYMXC8T/91QDgTFDDacio97/tVQRNirsDhMRw/F4CySHuvQIj6X+5yO30Xatt3Lf
 0bxRAbgZg2oZ9AIG7gQAKlFYBdz6wE7pDwk9PvP9/bz6oygcxiBi0lFyU2MzF2Se1RwDOYyuW
 yic05Vz/NaK8GI9VBIOtxRQ6LaPVsuB10KZ5BYKIFEr+58my8QFIcn0VGd4pphwhUIzrS/EIZ
 /9T+dobtiPcXk5D7u/sPUIiomALFrZPiRdvxpv/dMXoCC8j9gozwIaz4uoA69Od010jvtK2Qi
 x3juIV+hFzTKbDm1wuw8JgTKIelJgLeQWF/H7K8T186tElvg56UJU55E4t2TiYNZRzymejT77
 rpxh/u9g7FwQdT5twSlouDLFlGgwWePiWGskyUxxwbFFgzdLi3jOV8w1xvbFcz75lD6NH2ZF6
 6ePwhy1DTsG6GZ3lLen2tOS7L8yEFzO9Fzxd0f/J6GVCd9TDLvmkWNiDjl81WY9OaS/QUKtl8
 Vzo244XedGrqz2iQdxPxpAY6CeCyKZ4OIrZdkCrMLxPXfYUYPrY/Qr+wPnbSQtjv4AV9Rc1ZN
 uZIOMRUHjFOTeJNSf5G/Lt1llm3bo/ZUmDejcCN1cnYfisj/yBeXhRENxtpAqJTJViz8s3MEf
 IAjpDtUlJG5ay00yuzFbi9qUIQ+zRM2Uzqh+IPXVyIAxHDOXECOzc5CZiIVx6jPwls5d8TJX7
 BSfWixktD3jKGFx80
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 03.02.20 um 19:36 schrieb Nicolas Saenz Julienne:
> Hi,
> BTW the patch looks good to me too:
>
> Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
>
> On Sat, 2020-02-01 at 13:27 -0600, Jeremy Linton wrote:
>> Hi,
>>
>> First, thanks for looking at this!
>>
>> On 2/1/20 10:44 AM, Stefan Wahren wrote:
>>> Hi Jeremy,
>>>
>>> [add Nicolas as BCM2835 maintainer]
>>>
>>> Am 01.02.20 um 08:46 schrieb Jeremy Linton:
>>>> If one types "failed to get enet clock" or similar into google
>>>> there are ~370k hits. The vast majority are people debugging
>>>> problems unrelated to this adapter, or bragging about their
>>>> rpi's. Given that its not a fatal situation with common DT based
>>>> systems, lets reduce the severity so people aren't seeing failure
>>>> messages in everyday operation.
>>>>
>>> i'm fine with your patch, since the clocks are optional according to t=
he
>>> binding. But instead of hiding of those warning, it would be better to
>>> fix the root cause (missing clocks). Unfortunately i don't have the
>>> necessary documentation, just some answers from the RPi guys.
>> The DT case just added to my ammunition here :)
>>
>> But really, I'm fixing an ACPI problem because the ACPI power managemen=
t
>> methods are also responsible for managing the clocks. Which means if I
>> don't lower the severity (or otherwise tweak the code path) these error=
s
>> are going to happen on every ACPI boot.
>>
>>> This is what i got so far:
> Stefan, Apart from the lack of documentation (and maybe also time), is t=
here
> any specific reason you didn't sent the genet clock patch yet? It should=
 be OK
> functionally isn't it?

last time i tried to specify the both clocks as suggest by the binding
document (took genet125 for wol, not sure this is correct), but this
caused an abort on the BCM2711. In the lack of documentation i stopped
further investigations. As i saw that Jeremy send this patch, i wanted
to share my current results and retestet it with this version which
doesn't crash. I don't know the reason why both clocks should be
specified, but this patch should be acceptable since the RPi 4 doesn't
support wake on LAN.

Best regards
Stefan

