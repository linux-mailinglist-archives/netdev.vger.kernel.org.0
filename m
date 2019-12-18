Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B6A124642
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfLRLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:55:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39332 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbfLRLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:55:43 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so1976104wrt.6;
        Wed, 18 Dec 2019 03:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=A9XMDbkjykdasKiXfW/wy1M+ql/+TZC+TS5C3QaqAzE=;
        b=rX7yQteL2z7erMU18+yi9De1vQQspA8IU9js2mEe0dmy5NAXIdr1eij7dNJDnq33YG
         CkVUw4n0A+6SBhs4zWqH5bLSjyruvl/mHXAgCBbzjkstCzRhggC/sbhTf/IX28r0lm3h
         mVxQG/Jmu5nYxI6pAp2EuZ5nkBtvVgqbs5TDOhdpRAeh3Sy02A5lWJZEZXKr3HW0dllR
         AW9N/t4CWHSbUOwz/4GL4fRFt87XQHbkXWukSY7f+hAnPBgS34Lyr7yBCyh+ppb+s0mN
         1pgW/YkS9lnUpi3HQfii15GSgcYHdHZPZx4Q/fDEdlG+hMIr8gH1GrfZHgydGIvDAnRD
         dF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=A9XMDbkjykdasKiXfW/wy1M+ql/+TZC+TS5C3QaqAzE=;
        b=XvEqaW8thVxKqidIQq38Qk+3vivDRmegX6neF11zmpfoxAqDthybhpMxRj+5iDzO31
         Y3btAgv/OK1W62WYB/7t4B+Q8lyfMsRVMV5yFNkJuxtkBVyR19xFG4pLkDo+JWLP1AEM
         SP12bud8FvVFAZZjOty+S2O6A4IOUikRIPYkpDECgXtPkDgV47sq2brF4jaUkGZImJ+C
         FlxmNY/P12M5FeZ2zR+SQo7AOkcBdwPPejgchpjGNgRwKLqwa5RRgiH4vy/X0XxqBKEl
         kiPsHcohoz5nZGvGXAW3O7Jn1+ipuUqUzIUi5UbDuEtOi8NWjukZP5esRBrvF/8XdgJr
         +pUw==
X-Gm-Message-State: APjAAAXy7jGXw35yDevQPENBrwUHTJu0fjyhtJ8Dwgwh07XmQ79cMdTs
        Fh+CMco3jiVNyXvqTRPWb34=
X-Google-Smtp-Source: APXvYqyrhOQ2b4j/qBXySAEDKbQNPNebWrDmGNc0QMMmxtq2kRkw0mHnZSoZDdRcAbyPlCbw+s7XoA==
X-Received: by 2002:a5d:6ac5:: with SMTP id u5mr2390865wrw.271.1576670140813;
        Wed, 18 Dec 2019 03:55:40 -0800 (PST)
Received: from [10.123.42.178] ([194.165.151.227])
        by smtp.gmail.com with ESMTPSA id x11sm2198579wmg.46.2019.12.18.03.55.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 03:55:40 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
From:   Christian Hewitt <christianshewitt@gmail.com>
In-Reply-To: <20191211235253.2539-1-smoch@web.de>
Date:   Wed, 18 Dec 2019 13:55:35 +0200
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Heiko Stuebner <heiko@sntech.de>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D1B53CE9-E87C-4514-A2D7-0FE70A4D1A5D@gmail.com>
References: <20191211235253.2539-1-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 12 Dec 2019, at 1:52 am, Soeren Moch <smoch@web.de> wrote:
>=20
> Add support for the BCM4359 chipset with SDIO interface and RSDB =
support
> to the brcmfmac wireless network driver in patches 1-7.
>=20
> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
>=20
>=20
> Chung-Hsien Hsu (1):
>  brcmfmac: set F2 blocksize and watermark for 4359
>=20
> Soeren Moch (5):
>  brcmfmac: fix rambase for 4359/9
>  brcmfmac: make errors when setting roaming parameters non-fatal
>  brcmfmac: add support for BCM4359 SDIO chipset
>  arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>  arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>=20
> Wright Feng (3):
>  brcmfmac: reset two D11 cores if chip has two D11 cores
>  brcmfmac: add RSDB condition when setting interface combinations
>  brcmfmac: not set mbss in vif if firmware does not support MBSS

Thanks for posting this series, this chip is widely used by a large =
number of current Amlogic devices!

Patches 1-7 have been tested on Amlogic G12B (Khadas VIM3) hardware with =
5.5-rc kernel and a LibreELEC (distro) colleague also tested with a =
Khadas Edge board (RK3399). The Ampak 6398S module on both boards are =
detected and can connect to networks to pass basic functional testing.

On the VIM3 board I do see the following warning splat:

[    7.987351] ------------[ cut here ]------------
[    7.987382] WARNING: CPU: 5 PID: 36 at =
drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c:776 =
brcmf_sdiod_sgtable_alloc+0x130/0x138 [brcmfmac]
[    7.987384] Modules linked in: brcmfmac ecdh_generic brcmutil =
rtc_meson_vrtc videodev ecc cfg80211 gpio_pca953x rfkill ir_nec_decoder =
crct10dif_ce rc_khadas mali_kbase(O) meson_ir ao_cec_g12a mc rtc_hym8563 =
rc_core gpio_keys_polled adc_keys ipv6 nf_defrag_ipv6 crc_ccitt =
sch_fq_codel
[    7.987403] CPU: 5 PID: 36 Comm: kworker/5:0 Tainted: G           O   =
   5.5.0-rc1 #1
[    7.987404] Hardware name: Khadas VIM3 (DT)
[    7.987417] Workqueue: events brcmf_driver_register [brcmfmac]
[    7.987420] pstate: 80000005 (Nzcv daif -PAN -UAO)
[    7.987432] pc : brcmf_sdiod_sgtable_alloc+0x130/0x138 [brcmfmac]
[    7.987443] lr : brcmf_sdio_probe+0x28c/0x890 [brcmfmac]
[    7.987444] sp : ffff80001017ba90
[    7.987445] x29: ffff80001017ba90 x28: 0000000000000000=20
[    7.987447] x27: 0000000000000000 x26: ffff0000a8c09400=20
[    7.987449] x25: ffff80000a24cb08 x24: ffff0000a3800400=20
[    7.987451] x23: ffff800012c618c8 x22: ffff0000a675e000=20
[    7.987453] x21: ffff0000a675e000 x20: 0000000000000023=20
[    7.987454] x19: ffff0000a3800000 x18: ffff800013b25908=20
[    7.987456] x17: ffff800013b25d0c x16: ffff800013b25104=20
[    7.987457] x15: 00000000f0000000 x14: 000000000000000a=20
[    7.987459] x13: 0000000000000000 x12: 0000000000000001=20
[    7.987460] x11: 0000000000000005 x10: 0101010101010101=20
[    7.987461] x9 : ffffffffffffffff x8 : 7f7f7f7f7f7f7f7f=20
[    7.987463] x7 : 00000000000001ff x6 : 0000000000000080=20
[    7.987464] x5 : 0000000000000600 x4 : 0000000000000003=20
[    7.987466] x3 : ffff0000a5a3d880 x2 : 0000000000000021=20
[    7.987467] x1 : 0000000000000003 x0 : ffff0000a675e000=20
[    7.987469] Call trace:
[    7.987481]  brcmf_sdiod_sgtable_alloc+0x130/0x138 [brcmfmac]
[    7.987493]  brcmf_sdio_probe+0x28c/0x890 [brcmfmac]
[    7.987504]  brcmf_sdiod_probe+0xe0/0x1c0 [brcmfmac]
[    7.987516]  brcmf_ops_sdio_probe+0x16c/0x208 [brcmfmac]
[    7.987522]  sdio_bus_probe+0xe0/0x1c8
[    7.987526]  really_probe+0xd8/0x428
[    7.987529]  driver_probe_device+0xdc/0x130
[    7.987531]  device_driver_attach+0x6c/0x78
[    7.987533]  __driver_attach+0x9c/0x168
[    7.987535]  bus_for_each_dev+0x70/0xc0
[    7.987536]  driver_attach+0x20/0x28
[    7.987538]  bus_add_driver+0x190/0x220
[    7.987539]  driver_register+0x60/0x110
[    7.987541]  sdio_register_driver+0x24/0x30
[    7.987552]  brcmf_sdio_register+0x14/0x48 [brcmfmac]
[    7.987563]  brcmf_driver_register+0xc/0x20 [brcmfmac]
[    7.987567]  process_one_work+0x1e0/0x358
[    7.987569]  worker_thread+0x40/0x488
[    7.987571]  kthread+0x118/0x120
[    7.987573]  ret_from_fork+0x10/0x18
[    7.987575] ---[ end trace 808ac7e159d1fc33 ]---

I don=E2=80=99t see this on older Amlogic SoCs (GXL/GXM devices with =
various other BCM chips) or another Amlogic G12B device (same SoC with a =
different Ampak module) or some RK3399 devices, so it may be something =
board (Khadas VIM3) specific.

I also see some errors like:

[   71.046597] brcmfmac: brcmf_sdio_readframes: RXHEADER FAILED: -5
[   71.046652] brcmfmac: brcmf_sdio_rxfail: abort command, terminate =
frame, send NAK
[  123.844863] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus =
sleep state -5
[  124.678329] brcmfmac: brcmf_sdio_txfail: sdio error, abort command =
and terminate frame
[  124.680226] mmc0: tuning execution failed: -5
[  124.708843] brcmfmac: brcmf_sdio_bus_sleep: error while changing bus =
sleep state -5
[  125.700765] brcmfmac: brcmf_sdio_txfail: sdio error, abort command =
and terminate frame
[  125.880372] brcmfmac: mmc_submit_one: CMD53 sg block read failed -22
[  125.880393] brcmfmac: brcmf_sdio_rxglom: glom read of 512 bytes =
failed: -5
[  125.880401] brcmfmac: brcmf_sdio_rxfail: abort command, terminate =
frame
[  125.881262] brcmfmac: brcmf_sdio_readframes: brcmf_sdio_readframes: =
glom superframe w/o descriptor!
[  125.881318] brcmfmac: brcmf_sdio_rxfail: terminate frame
[  131.844289] brcmfmac: mmc_submit_one: CMD53 sg block write failed -22
[  131.844302] brcmfmac: brcmf_sdio_txfail: sdio error, abort command =
and terminate frame
[  131.844488] brcmfmac: mmc_submit_one: CMD53 sg block write failed -22
[  131.844494] brcmfmac: brcmf_sdio_txfail: sdio error, abort command =
and terminate frame

I=E2=80=99m not sure if that=E2=80=99s of any concern, but if yes, I=E2=80=
=99d be happy to apply any debugging patches you provide to generate =
output.

Thanks again for working on this chipset!

Christian


