Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464893C5D9
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 10:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404582AbfFKIVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 04:21:33 -0400
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38103 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403996AbfFKIVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 04:21:32 -0400
Received: from [192.168.2.10] ([46.9.252.75])
        by smtp-cloud8.xs4all.net with ESMTPA
        id ac1qhfdph41bFac1thCupM; Tue, 11 Jun 2019 10:21:30 +0200
Subject: Re: [PATCH 5/8] drivers: media: coda: fix warning same module names
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Matt Redfearn <matt.redfearn@thinci.com>,
        Anders Roxell <anders.roxell@linaro.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>,
        "stefan@agner.ch" <stefan@agner.ch>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20190606094722.23816-1-anders.roxell@linaro.org>
 <d6b79ee0-07c6-ad81-16b0-8cf929cc214d@xs4all.nl>
 <CADYN=9KY5=FzrkC7MKj9QnG-eM1NVuL00w8Xv4yU2r05rhr7WQ@mail.gmail.com>
 <c2ff2c77-5c14-4bc4-f59c-7012d272ec76@thinci.com>
 <1560240943.13886.1.camel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <221c8ef8-7adc-4383-93c9-9031dca590f0@xs4all.nl>
Date:   Tue, 11 Jun 2019 10:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1560240943.13886.1.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfF4l958gFcXbV6p95xz+ivCMsV6s4588moNOs9xu2Iu97gq8E8gpQpJUwHv+LkhfdxwpeLJQXiKUx1AlyFqxgT1gA/7wWLItAOSIJiLQdmwKpWc+fKFG
 vgDVAUCC1cZ5stiYDkUqlh2EcAWqi7Md5RRcCmEXm+8tYSNg7ISwK4efXRTEoVW+I2hyFPVUagqURLbJjEHp7pP3NnPKy/31ZBETWX+oQtaxu1L/JuO7dgPf
 HnNSYxRiWghAhGKyI62h1BpN1w42uc7cQ/oXIBCiaAgS1eJcxOPiu326GTdnuN9Kx92iuMp7/n6vKpnBQPtR/qLOg8JPRgUhpRSa0zqt4djY9V5mQS96lJKz
 f2rH+YlTJL7CmaaSGOeTqdiUiT38QtxmsSL7i8X+kcrLMk/EcGT+tj0AQyDmDRjspjsgFZA1mSsLUsOkNUYiWkr+hdrd1GsXkgOz2PjXGTukYJzJeaQVoSqe
 d60XFTDTbLgStGivDZdX7UNH8PzRRVaOtyLSAG3t3AO+qlhY4dy4sxkZ8G/NhLkDqsMh8B71+/zBo8rSUSrq5M8ZXkCdaii8SMkssCHGQ6+Vv2FAY2I6fbmx
 Xid/liFV0KXCTUzeN7CzTYM4AAa46DnSAQ/0T1QT6pPbCpbK2gX/gZTvJ5cZgmWDrg8JOkBFjD+Pi1oWHQBsSHz6qibIVsZfsI/CgaK9NSRFtvTEp7ifwfAc
 geBvs8P2gZmQHGj8Ju+w+QrHQ+R3mvF8yzEKjhUR9xrQS/1pD8MRZy4EUvBFJgjuxT6so14qzZAOm+JHvhULAxlG6OPFrvg2ZpHhoUY47YPJbEiIBYIsv/IE
 teJbVQgtWRv9SBf2e6uP15ECcp65KaAsnUtq1UySLHJYiTXhfptY9WRsvCwbK5Ft3KwaiNCpmHGOE5Fhr8Y7ZrFIS081K3OeEhfJL6J0GJq9qc4QQKC02EFJ
 KKueZgpH2AuUJhfG/GxasVo2z5POtJFu7M6QSx11WjThU8995eci5lvaMj4+QzckJISsRw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 10:15 AM, Philipp Zabel wrote:
> Hi,
> 
> On Mon, 2019-06-10 at 13:14 +0000, Matt Redfearn wrote:
>>
>> On 10/06/2019 14:03, Anders Roxell wrote:
>>> On Thu, 6 Jun 2019 at 12:13, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>
>>>> On 6/6/19 11:47 AM, Anders Roxell wrote:
>>>>> When building with CONFIG_VIDEO_CODA and CONFIG_CODA_FS enabled as
>>>>> loadable modules, we see the following warning:
>>>>>
>>>>> warning: same module names found:
>>>>>    fs/coda/coda.ko
>>>>>    drivers/media/platform/coda/coda.ko
>>>>>
>>>>> Rework so media coda matches the config fragment. Leaving CODA_FS as is
>>>>> since thats a well known module.
>>>>>
>>>>> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
>>>>> ---
>>>>>   drivers/media/platform/coda/Makefile | 4 ++--
>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
>>>>> index 54e9a73a92ab..588e6bf7c190 100644
>>>>> --- a/drivers/media/platform/coda/Makefile
>>>>> +++ b/drivers/media/platform/coda/Makefile
>>>>> @@ -1,6 +1,6 @@
>>>>>   # SPDX-License-Identifier: GPL-2.0-only
>>>>>
>>>>> -coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
>>>>> +video-coda-objs := coda-common.o coda-bit.o coda-gdi.o coda-h264.o coda-mpeg2.o coda-mpeg4.o coda-jpeg.o
>>>>>
>>>>> -obj-$(CONFIG_VIDEO_CODA) += coda.o
>>>>> +obj-$(CONFIG_VIDEO_CODA) += video-coda.o
>>>>
>>>> How about imx-coda? video-coda suggests it is part of the video subsystem,
>>>> which it isn't.
>>>
>>> I'll resend a v2 shortly with imx-coda instead.
> 
> I'd be in favor of calling it "coda-vpu" instead.

Fine by me!

> 
>> What about other vendor SoCs implementing the Coda IP block which are 
>> not an imx? I'd prefer a more generic name - maybe media-coda.
> 
> Right, this driver can be used on other SoCs [1].

Good point.

Regards,

	Hans

> 
> [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg146498.html
> 
> regards
> Philipp
> 

