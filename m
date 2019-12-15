Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B0A11FB79
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 22:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfLOVYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 16:24:24 -0500
Received: from mout.web.de ([212.227.15.3]:37913 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbfLOVYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 16:24:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576445052;
        bh=eCUdcI2nCUe6hq6eD8muOW7l4NxkUtCc/Udi30XHMRo=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=KVMa0kkKNkRJdqlY/Cm54b7hjY4HbGyeEaDR2sNFVzd7BMXL42ansFVj2i3N3rr+f
         UpGiYHHwaVVuOO4Cbhfd9RNn5G61O9tuw+2nHxmKcZZT0YUpZ56T38bMyeWJjUFX52
         NOQk7eh4sUL0NehBqpznjPauaGnt1nifBeji+LPo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.138.206]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Mck7d-1iPLbR1RvF-00HveM; Sun, 15
 Dec 2019 22:24:12 +0100
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
From:   Soeren Moch <smoch@web.de>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org
References: <20191211235253.2539-1-smoch@web.de>
 <0101016ef97cf6b5-2552a5e4-12de-4616-94d6-b63d9c795ed6-000000@us-west-2.amazonses.com>
 <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de>
Message-ID: <22526722-1ae8-a018-0e24-81d7ad7512dd@web.de>
Date:   Sun, 15 Dec 2019 22:24:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <1daadfe0-5964-db9b-818c-6e4c75ac6a69@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Provags-ID: V03:K1:QhKcYNNQrZd6thN4hQsC9O7Yf91beeDEgTC+ZesnncMwRYbdp6k
 PcVfxxisANZf5uninSbdb8XlFs43Q8aukGZfSECbUxgh+NFVXxC5/CV/0zyqxmrCf9Ujs2x
 b6v7dWT2uNmz5OfaMlimF17bQj8CWalZC/cdhlAPJb5da0W9x7AA244YyuuXUwiusfGxafl
 Xgo4bupLX2lw+JKtOKStw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1ISRg0nEFow=:wc+RMp78TqOTVz7simHpvW
 bK3VSfSBE/9kizexywirb7ZXzVZhs7mriDltIXa16CJdeKX7HfFuTZsc0ZdAYKJSmQORgwQy5
 Zpft+rWolrPyRPfVXjHmP9vwwTjNvjz2cYYy0/1Xf7q7MyUsRpLsxn6oj3yHmsPhZGmopCnwQ
 AqkxbmpU3AiZlhPCqV0vhS+xIXturcE4pLnYlOYZHy6AaWYYxz1K9pIO3wHeBtDEtAfF8qRNR
 msgqmOY3iZ02hrHfdv0AVqNBy3n8Ex+rwL0POG1Cm2z9P0KEm2GO2W9EEZ4xh37/u1lxunK6k
 FnkDUUZpMcnkexMWz12CqOpdlF3uDqQc8J65EZWebAJc25joOd2oJUT/fRn/4LPsP4r5FEJA1
 kYJzAzZrL0bVdwX38Gt9LeAwBhjxB2uySxuaZPcrWI7tMafC3Med8W44nkyyFrhPAhYMNoeJ4
 OSoSKYx63fF885aT0zScBovb1bZZzm3Ja4XHPYaCagNOvG6fzEwM6d2+kGBj9l86sidgml9if
 K1pmjqN1Wf2Mgndz0odCyTXfOSMgVveWhhqfGDe45P2f2KzH0PBg9iPq3BK2V2Tbnd8WwW+De
 KSVZe/W2ommLUL6zBYATH+WTElYuwxbCk+76dh5jJx8Z0gxR1mz40cZw0qvgQvHgx/fqXE8Y0
 7GRZaeQeueNcKzKD/HRUBK7R6yCTgLJS2YlRI6GI6UHDpBGXLbeJcCaWL3Dk38OrsAWYr67fH
 ybBNxY1YB9qd5hA1lHYje/RUMW0zY1JSV5z4WU4SLxYK6UivFrpgq6GOEphRgOVFgxFNqKyoN
 NdyNh8qZCOvPvYmy4OPQ62KfCO7QsM/SgaujMZIencM/T4KJbJsRHKIkJf3GyDZymvpZiG6cH
 TylB2KnNPD8QCdLRz2dwk7f4Z2dBZueBvS38sgT9RnyY/zZNNClNPEMBARzfYJXhmHNT4oPoA
 yzo85V9fzHKgwrsCUfA+CIKdkJqAX/fqp9Zdr+P3klh4dXV1PWmuZldE7SkbBfcGm5hadkOGx
 HLKBN0+GkWt/Cyyz54nhmUITMrlvFY8rRiPca0TXRBktv+1gVsYkYtO2HhxFtggfufsO2Sfrd
 R860lSzrhp7RL8Intuse99bV+424/kScZMvP94VEJ3Bou++y4akIDbP7Y7W1Ix7vlhnh7+MpU
 mxUOcEEQdTi9AVGZxa7JshX8jDsfUiFpFBqyzdhbpzLLO+6xddhCJj02ABW2WUg10SAfYbtQd
 rULgwVJAOeh+Gg5uHa+vTI91QRC1m08sLTyWrgA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.12.19 11:59, Soeren Moch wrote:
> On 12.12.19 10:42, Kalle Valo wrote:
>> Soeren Moch <smoch@web.de> writes:
>>
>>> Add support for the BCM4359 chipset with SDIO interface and RSDB support
>>> to the brcmfmac wireless network driver in patches 1-7.
>>>
>>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
>>> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
>>>
>>>
>>> Chung-Hsien Hsu (1):
>>>   brcmfmac: set F2 blocksize and watermark for 4359
>>>
>>> Soeren Moch (5):
>>>   brcmfmac: fix rambase for 4359/9
>>>   brcmfmac: make errors when setting roaming parameters non-fatal
>>>   brcmfmac: add support for BCM4359 SDIO chipset
>>>   arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>>>   arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>>>
>>> Wright Feng (3):
>>>   brcmfmac: reset two D11 cores if chip has two D11 cores
>>>   brcmfmac: add RSDB condition when setting interface combinations
>>>   brcmfmac: not set mbss in vif if firmware does not support MBSS
>>>
>>>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 50 +++++++++++---
>>>  .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 ++-
>>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 68 +++++++++++++++----
>>>  .../broadcom/brcm80211/brcmfmac/chip.c        | 54 ++++++++++++++-
>>>  .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
>>>  .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
>>>  .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++++
>>>  include/linux/mmc/sdio_ids.h                  |  2 +
>>>  8 files changed, 176 insertions(+), 26 deletions(-)
>> Just to make sure we are on the same page, I will apply patches 1-7 to
>> wireless-drivers-next and patches 8-9 go to some other tree? And there
>> are no dependencies between the brcmfmac patches and dts patches?
>>
> Yes, this also is my understanding. I'm glad if you are fine with
> patches 1-7.
> Heiko will pick up patches 8-9 later for linux-rockchip independently.
> And if we need another round of review for patches 8-9, I think we don't
> need to bother linux-wireless with this.

Heiko,

is this OK for you when patches 1-7 are merged now in wireless-drivers,
and then I send a v3 for patches 8-9 only for you to merge in
linux-rockchip later? Or do you prefer a full v3 for the whole series
with only this pending clock name update in patch 9?

Thanks,
Soeren



