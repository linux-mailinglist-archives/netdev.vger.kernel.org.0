Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF227125759
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLRXFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:05:00 -0500
Received: from mout.web.de ([212.227.17.12]:57491 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfLRXFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 18:05:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576710285;
        bh=JeD9UjBEBsG+7esEHJ1K+i5iEZyYkip7/p7WAEBn4m0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=lz/xHXj8iLzofQiqSW8gCM7dhAzjwfcOjYJwCbD9YGM0meIg659qfOi0ApBWC7pt1
         EKynZ9Mqvt9RKnPZS1Q8JjG8GGHdBjD0DPBaEMzF2mI789g6eI32ni0kic8IK8NwPb
         4Zu+wrZ/lH8msiXon2QzNzHjzQGifb1/xqVSB/bY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.43.108] ([89.204.137.218]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MIN6p-1igM7f48Cd-004DeO; Thu, 19
 Dec 2019 00:04:45 +0100
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
To:     Christian Hewitt <christianshewitt@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
References: <20191211235253.2539-1-smoch@web.de>
 <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
From:   Soeren Moch <smoch@web.de>
Autocrypt: addr=smoch@web.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <cb3ac55f-4c8f-b0a0-41ee-f16b3232c87e@web.de>
Date:   Thu, 19 Dec 2019 00:04:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:OngXJGyXWd1j3PLPDFNMGDzyRaQ9Xj4izf7RsJvC9NTlpKJKj/L
 kJYOzD0XSpE6CMJyA+0bn4AzreDqSCbqpV1cTzU6kvF4y3uc4TnAcRzEJed/+6b33j13qAg
 deQKVr1RriP0/UMI9mYbDRTfVppkk1tHsYjzSLaSveAIXmyfTzBviFVxJQNhJHNIbapkuxR
 G9NVqRrf0FHG8KXUJwA2A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MqJ2ltsPEvc=:H76FQv81RvAxfuYdoPdz3p
 GeYD5H7jRJnP9SvuMAjMhAGKmh7HZH0j+JkmoibUfrBY9fEZPH87DnUvv+GL+JSkNNlGAOB2p
 RpYfD8dRjetMt+9bwfCRLVyvdPXUE0clmHQWhTJ6s5XerS+FvsiMwe8qPsJHpx4TgQBwrz673
 fGeVOvFYT8pHBtfqM9QVP2j9biz+JzhabsfJpQ2I8+Oyp9E21UqgzJ8AG31Zky7oGjej7V8mP
 XTSIyWR3vOLsxcS1GMm5oC2Zgy6THGxa7DCxLfdc2DekRDOT/5drjNsqn/3CNJjdGj3L+JapP
 Cssh6d3m1Uu6B3mJQlkXja55uLlLqZN1nB9EdRZxtMSy8kFEnd2mk8nU3mzKseH0Dgzh7O8lg
 aV6Sq8q8UHzYeN4tpEw5Im+ltxcEQLjRjbTDu5H++8pA5rmhc0xk6lszoh0dggXmd1LnFGrFH
 pnzgc0Mc9xQF3VGZRQHks1A1OZns0xPRBxQun7xsJ2brswZGTW/TywxLVdz8MUjUAcMEv4ova
 X4tKLTzmoTAxeXG3qRMt3atKfq6yRibN4hDW0nvHULVCWpRqybg951JHliebuejvf9pn3QNEx
 njKj+j/kog8tF9taOQsml0maB3c6u30YeEGCGa4TbE1lNRz67osKBgZRLf4PQB3u4opxMTKbh
 DniNdkIx2fsAuwJsD3n4+WUTTAZHWKqVF336+EtFdjhnPGj8MQro7QWGCPX1eEFEW3qi7h0Rd
 CiS0Mni6d+2eldg3t3tSKsrPzWSBgnaDwWvDP0CinvWwbd0cX+95RAMRp20BD1S6f7JIPeTE7
 yIKTYtVUftTyTAO/zVyAD9kmUOnyMo/5IKWVc4Udhy0g/dZLOkoinOl0TnoZ8bW0evXcxquXw
 VEZMKJ5AOmS5OgHiN+SRYRCxDT/KjXJuzRNcnAtnmhTaeVZto8ENu4D1sBp2iLBhQw+daKbXy
 h7qEreFxYYH5PUJMk4+37CaE2a/RCpYwm3lu19C8kSnhF9CTi/6ljdQvJpoxNe+Dril4BimrF
 OTX6+HuOkWYoR/35hMl2Xj7ElNjcx/OrsGHZBF7laRXXTjJ9gCjt4/b+fIvw/FgzddDrKtrNx
 9iFr1k75dVE+RAYRvWfmeo0C0BAwPZbBG0LsgAySZBFqrn9TqHitdoxrOFjVxmEQfPny9jF9G
 gfc44OTPEYH3Ryz9MgMnSX0pdyaAiKK/6k043xqKo2g4yY7IaVghL3IovDoFLxmSu2lEFnXGZ
 hjLOKO/Ix/TN3kudTMAkLxGqlj9WSMG4xdsaPOA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.12.19 12:55, Christian Hewitt wrote:
>> On 12 Dec 2019, at 1:52 am, Soeren Moch <smoch@web.de> wrote:
>>
>> Add support for the BCM4359 chipset with SDIO interface and RSDB suppo=
rt
>> to the brcmfmac wireless network driver in patches 1-7.
>>
>> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
>> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
>>
>>
>> Chung-Hsien Hsu (1):
>>  brcmfmac: set F2 blocksize and watermark for 4359
>>
>> Soeren Moch (5):
>>  brcmfmac: fix rambase for 4359/9
>>  brcmfmac: make errors when setting roaming parameters non-fatal
>>  brcmfmac: add support for BCM4359 SDIO chipset
>>  arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>>  arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>>
>> Wright Feng (3):
>>  brcmfmac: reset two D11 cores if chip has two D11 cores
>>  brcmfmac: add RSDB condition when setting interface combinations
>>  brcmfmac: not set mbss in vif if firmware does not support MBSS
> Thanks for posting this series, this chip is widely used by a large num=
ber of current Amlogic devices!
>
> Patches 1-7 have been tested on Amlogic G12B (Khadas VIM3) hardware wit=
h 5.5-rc kernel and a LibreELEC (distro) colleague also tested with a Kha=
das Edge board (RK3399). The Ampak 6398S module on both boards are detect=
ed and can connect to networks to pass basic functional testing.
Thanks for confirming that this series to add support for the BCM4359
SDIO chipset works on different boards.
>
> On the VIM3 board I do see the following warning splat:
>
> [    7.987351] ------------[ cut here ]------------
> [    7.987382] WARNING: CPU: 5 PID: 36 at drivers/net/wireless/broadcom=
/brcm80211/brcmfmac/bcmsdh.c:776 brcmf_sdiod_sgtable_alloc+0x130/0x138 [b=
rcmfmac]
> [    7.987384] Modules linked in: brcmfmac ecdh_generic brcmutil rtc_me=
son_vrtc videodev ecc cfg80211 gpio_pca953x rfkill ir_nec_decoder crct10d=
if_ce rc_khadas mali_kbase(O) meson_ir ao_cec_g12a mc rtc_hym8563 rc_core=
 gpio_keys_polled adc_keys ipv6 nf_defrag_ipv6 crc_ccitt sch_fq_codel
> [    7.987403] CPU: 5 PID: 36 Comm: kworker/5:0 Tainted: G           O =
     5.5.0-rc1 #1
> [    7.987404] Hardware name: Khadas VIM3 (DT)
> [    7.987417] Workqueue: events brcmf_driver_register [brcmfmac]
> [    7.987420] pstate: 80000005 (Nzcv daif -PAN -UAO)
> [    7.987432] pc : brcmf_sdiod_sgtable_alloc+0x130/0x138 [brcmfmac]
> [    7.987443] lr : brcmf_sdio_probe+0x28c/0x890 [brcmfmac]
> [    7.987444] sp : ffff80001017ba90
> [    7.987445] x29: ffff80001017ba90 x28: 0000000000000000=20
> [    7.987447] x27: 0000000000000000 x26: ffff0000a8c09400=20
> [    7.987449] x25: ffff80000a24cb08 x24: ffff0000a3800400=20
> [    7.987451] x23: ffff800012c618c8 x22: ffff0000a675e000=20
> [    7.987453] x21: ffff0000a675e000 x20: 0000000000000023=20
> [    7.987454] x19: ffff0000a3800000 x18: ffff800013b25908=20
> [    7.987456] x17: ffff800013b25d0c x16: ffff800013b25104=20
> [    7.987457] x15: 00000000f0000000 x14: 000000000000000a=20
> [    7.987459] x13: 0000000000000000 x12: 0000000000000001=20
> [    7.987460] x11: 0000000000000005 x10: 0101010101010101=20
> [    7.987461] x9 : ffffffffffffffff x8 : 7f7f7f7f7f7f7f7f=20
> [    7.987463] x7 : 00000000000001ff x6 : 0000000000000080=20
> [    7.987464] x5 : 0000000000000600 x4 : 0000000000000003=20
> [    7.987466] x3 : ffff0000a5a3d880 x2 : 0000000000000021=20
> [    7.987467] x1 : 0000000000000003 x0 : ffff0000a675e000=20
> [    7.987469] Call trace:
> [    7.987481]  brcmf_sdiod_sgtable_alloc+0x130/0x138 [brcmfmac]
> [    7.987493]  brcmf_sdio_probe+0x28c/0x890 [brcmfmac]
> [    7.987504]  brcmf_sdiod_probe+0xe0/0x1c0 [brcmfmac]
> [    7.987516]  brcmf_ops_sdio_probe+0x16c/0x208 [brcmfmac]
> [    7.987522]  sdio_bus_probe+0xe0/0x1c8
> [    7.987526]  really_probe+0xd8/0x428
> [    7.987529]  driver_probe_device+0xdc/0x130
> [    7.987531]  device_driver_attach+0x6c/0x78
> [    7.987533]  __driver_attach+0x9c/0x168
> [    7.987535]  bus_for_each_dev+0x70/0xc0
> [    7.987536]  driver_attach+0x20/0x28
> [    7.987538]  bus_add_driver+0x190/0x220
> [    7.987539]  driver_register+0x60/0x110
> [    7.987541]  sdio_register_driver+0x24/0x30
> [    7.987552]  brcmf_sdio_register+0x14/0x48 [brcmfmac]
> [    7.987563]  brcmf_driver_register+0xc/0x20 [brcmfmac]
> [    7.987567]  process_one_work+0x1e0/0x358
> [    7.987569]  worker_thread+0x40/0x488
> [    7.987571]  kthread+0x118/0x120
> [    7.987573]  ret_from_fork+0x10/0x18
> [    7.987575] ---[ end trace 808ac7e159d1fc33 ]---
>
> I don=E2=80=99t see this on older Amlogic SoCs (GXL/GXM devices with va=
rious other BCM chips) or another Amlogic G12B device (same SoC with a di=
fferent Ampak module) or some RK3399 devices, so it may be something boar=
d (Khadas VIM3) specific.
Unfortunately I don't know this Khadas VIM3 board and special problems
to support brcmfmac on it.

On RockPro64 there are 2 board specific tweaks needed to get this
running (also see patch 8 in this series, and rk3399.dtsi):
- limit clock of the sdio0 port of rk3399
- enable sdio in-band irq, do not use out-of-band irq that the wifi
module supports.

I guess you need similar enhancements of the board device tree as in
patch 8 of this series for your VIM3 board.

Regards,
Soeren
>
> I also see some errors like:
>
> [   71.046597] brcmfmac: brcmf_sdio_readframes: RXHEADER FAILED: -5
> [   71.046652] brcmfmac: brcmf_sdio_rxfail: abort command, terminate fr=
ame, send NAK
> [  123.844863] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus=
 sleep state -5
> [  124.678329] brcmfmac: brcmf_sdio_txfail: sdio error, abort command a=
nd terminate frame
> [  124.680226] mmc0: tuning execution failed: -5
> [  124.708843] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus=
 sleep state -5
> [  125.700765] brcmfmac: brcmf_sdio_txfail: sdio error, abort command a=
nd terminate frame
> [  125.880372] brcmfmac: mmc_submit_one: CMD53 sg block read failed -22=

> [  125.880393] brcmfmac: brcmf_sdio_rxglom: glom read of 512 bytes fail=
ed: -5
> [  125.880401] brcmfmac: brcmf_sdio_rxfail: abort command, terminate fr=
ame
> [  125.881262] brcmfmac: brcmf_sdio_readframes: brcmf_sdio_readframes: =
glom superframe w/o descriptor!
> [  125.881318] brcmfmac: brcmf_sdio_rxfail: terminate frame
> [  131.844289] brcmfmac: mmc_submit_one: CMD53 sg block write failed -2=
2
> [  131.844302] brcmfmac: brcmf_sdio_txfail: sdio error, abort command a=
nd terminate frame
> [  131.844488] brcmfmac: mmc_submit_one: CMD53 sg block write failed -2=
2
> [  131.844494] brcmfmac: brcmf_sdio_txfail: sdio error, abort command a=
nd terminate frame
>
> I=E2=80=99m not sure if that=E2=80=99s of any concern, but if yes, I=E2=
=80=99d be happy to apply any debugging patches you provide to generate o=
utput.
>
> Thanks again for working on this chipset!
>
> Christian
>
>


