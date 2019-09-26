Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A81FBEBDE
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 08:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389052AbfIZGM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 02:12:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35779 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388609AbfIZGM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 02:12:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so1226519wrt.2
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 23:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s+Cit9M33AcnlbPRN5qBv8hyxsawOAWumKdMwIGDx4M=;
        b=kHT08BYU2WfpTT9vpEdf/+evyOndQ/9pdy74PCwIjolasLuMJo5VE/Vr3nuo3gbChU
         HqD046i5KRWOtYFFhRCcFABMIKA/qQJeG6N1XzurddZ5QVgXoo3CBMOi8epyBmnjW0aa
         +VfF4HJyMhIjC2Qei1trcsQClo5CWONkspBvDTYfJzktkHmZFNT0ssf1VVk8aGX5ekyD
         wsF6fPnX5iaX8ZOf5BgE7jfMKOgi/etCp4Nku/zcpFrjuLAaOH9PkkU7F5BYtV2O6m0I
         QbHslFbJnnomRiaGM3nTEx5z+XEPl4eg5lrbo9+Q00IrBKR9/3urmy/KcgUOYZb/xvIo
         E42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+Cit9M33AcnlbPRN5qBv8hyxsawOAWumKdMwIGDx4M=;
        b=T4eTNetC1CRWm5Omr+B8lRdYZ1ArPq7ELzDu6xRSJZ81vdUsTt6MWDpqYyCQvk+F4k
         W60OTm1qx+lkGhQmZVv1Ad8/0cUHLuVs+z5X4CEAJjoJ8/F9bHdt9HD2IIgmIwj6Mhc5
         gczQ14CSEcGhTfVyp+7/UiPEP+PiSDvLgDotD18DbZsEuArL588agwOLFdcekMWW/l+i
         elnme6+Mr84ipywyGkuIdE6+jmFx5Nu0XjiYJ7h8lPyH1qZBWqgq0DzsGz1Z0+PtP+WK
         zwhQbSRakY1C1a/sVwf4PtU6wNc7MFWlJIdzCrTA+q7DQpbPLaPhhpF7PQuYKiIVcWeQ
         XXoQ==
X-Gm-Message-State: APjAAAWr5bYcNtw+ethua02Wy7pkL0SEdJ/5/3An4mRT2Gt3WjqxNyMb
        iiS5o4dNaibr4iroPUAB7Es=
X-Google-Smtp-Source: APXvYqy1fiES3qlpkeyMQ5J47iD/bCs0h8TvxVgNXJ+j38ULyhRdHBpd+oqIRz3kiQY0wVVAFRQadw==
X-Received: by 2002:a5d:42cf:: with SMTP id t15mr1544995wrr.64.1569478375166;
        Wed, 25 Sep 2019 23:12:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:b050:9567:4cd5:5914? (p200300EA8F266400B05095674CD55914.dip0.t-ipconnect.de. [2003:ea:8f26:6400:b050:9567:4cd5:5914])
        by smtp.googlemail.com with ESMTPSA id j26sm3951318wrd.2.2019.09.25.23.12.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 23:12:54 -0700 (PDT)
Subject: Re: [BUG] Unable to handle kernel NULL pointer dereference in
 phy_support_asym_pause
To:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>
References: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <13cca19e-25b1-b5b0-cf29-51a4ed90fc6b@gmail.com>
Date:   Thu, 26 Sep 2019 08:12:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <573ffa6a-f29a-84d9-5895-b3d6cc389619@ysoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.09.2019 13:27, Michal Vokáč wrote:
> Hi,
> 
> just tried booting latest next-20190920 on our imx6dl-yapp4-hydra platform
> with QCA8334 switch and got this:
> 
> [    6.957822] 8<--- cut here ---
> [    6.963550] Unable to handle kernel NULL pointer dereference at virtual address 00000264
> [    6.974342] pgd = (ptrval)
> [    6.979751] [00000264] *pgd=00000000
> [    6.986005] Internal error: Oops: 5 [#1] SMP ARM
> [    6.993318] CPU: 0 PID: 21 Comm: kworker/0:1 Not tainted 5.3.0-rc5-00985-g0394a63acfe2 #7
> [    7.004196] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [    7.013467] Workqueue: events deferred_probe_work_func
> [    7.021339] PC is at phy_support_asym_pause+0x14/0x44
> [    7.029149] LR is at qca8k_port_enable+0x40/0x48
> [    7.036485] pc : [<806840f4>]    lr : [<80686724>]    psr: 60000013
> [    7.045489] sp : e821bca0  ip : e821bcb0  fp : e821bcac
> [    7.053456] r10: 00000000  r9 : e8241f00  r8 : e812d040
> [    7.061431] r7 : 00000000  r6 : 00000000  r5 : e8931640  r4 : 00000002
> [    7.070702] r3 : 00000001  r2 : 00000000  r1 : 00000000  r0 : 00000000
> [    7.079947] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> [    7.089825] Control: 10c5387d  Table: 1000404a  DAC: 00000051
> [    7.098382] Process kworker/0:1 (pid: 21, stack limit = 0x(ptrval))
> [    7.107431] Stack: (0xe821bca0 to 0xe821c000)
> [    7.114607] bca0: e821bccc e821bcb0 80686724 806840ec e812d090 e812d090 e88a02cc 00000000
> [    7.125637] bcc0: e821bce4 e821bcd0 80a74134 806866f0 e812d090 e812d0cc e821bd7c e821bce8
> [    7.136666] bce0: 80a730bc 80a74104 00000000 e88a02cc 00000004 e821bd00 e88a02e0 80cc95f8
> [    7.147725] bd00: e88a02e0 e88a02c0 e812d090 e812d090 81006548 e88a02e4 e812d040 e88a02c0
> [    7.158791] bd20: 00000003 e812d040 e8830c00 00000000 e821bd5c e821bd40 806243b8 80623abc
> [    7.169887] bd40: e8931640 00000000 00000000 5303fd08 e821bd7c e8931640 e8830c00 e8931680
> [    7.181000] bd60: 00000000 81077adc 00000004 00000000 e821bd9c e821bd80 806864f8 80a72930
> [    7.192107] bd80: 81077adc e8830c00 81123b24 00000000 e821bdb4 e821bda0 806856c8 80686354
> [    7.203216] bda0: 81123a18 e8830c00 e821bde4 e821bdb8 8061f944 80685694 00000000 e8830c00
> [    7.214318] bdc0: 81077adc e8830c00 81006548 00000001 810c07f0 00000000 e821be1c e821bde8
> [    7.225434] bde0: 8061ff68 8061f850 e821be04 e821bdf8 81077adc e821be74 81077adc e821be74
> [    7.236589] be00: e8830c00 81006548 00000001 810c07f0 e821be3c e821be20 80620178 8061ff04
> [    7.247788] be20: 00000000 e821be74 806200dc 81006548 e821be6c e821be40 8061e160 806200e8
> [    7.258982] be40: e821be6c e836d96c e86acdb8 5303fd08 e8830c00 81006548 e8830c44 81071194
> [    7.270217] be60: e821bea4 e821be70 8061fd80 8061e104 8061b58c e8830c00 00000001 5303fd08
> [    7.281470] be80: 00000000 e8830c00 81077998 e8830c00 81071194 00000000 e821beb4 e821bea8
> [    7.292770] bea0: 80620220 8061fcac e821bed4 e821beb8 8061e360 80620210 e8830c00 81071180
> [    7.304105] bec0: 81071180 81071194 e821bef4 e821bed8 8061f144 8061e2d8 810711b8 e81f5080
> [    7.315494] bee0: eada5f40 eada7100 e821bf34 e821bef8 80142e2c 8061f0dc e8200d00 ffffe000
> [    7.326890] bf00: e821bf1c e821bf10 8014234c e81f5080 eada5f40 e81f5094 eada5f58 ffffe000
> [    7.338312] bf20: 00000008 81003d00 e821bf74 e821bf38 801433f4 80142c14 ffffe000 80e1264c
> [    7.349778] bf40: 810c00c7 eada5f40 80148afc e81f76c0 e81f7680 00000000 e821a000 e81f5080
> [    7.361246] bf60: 80143130 e8143e74 e821bfac e821bf78 80148e2c 8014313c e81f76dc e81f76dc
> [    7.372758] bf80: e821bfac e81f7680 80148cc4 00000000 00000000 00000000 00000000 00000000
> [    7.384313] bfa0: 00000000 e821bfb0 801010e8 80148cd0 00000000 00000000 00000000 00000000
> [    7.395858] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    7.407363] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
> [    7.418856] Backtrace:
> [    7.424620] [<806840e0>] (phy_support_asym_pause) from [<80686724>] (qca8k_port_enable+0x40/0x48)
> [    7.436911] [<806866e4>] (qca8k_port_enable) from [<80a74134>] (dsa_port_enable+0x3c/0x6c)
> [    7.448629]  r7:00000000 r6:e88a02cc r5:e812d090 r4:e812d090
> [    7.457708] [<80a740f8>] (dsa_port_enable) from [<80a730bc>] (dsa_register_switch+0x798/0xacc)
> [    7.469833]  r5:e812d0cc r4:e812d090
> [    7.476909] [<80a72924>] (dsa_register_switch) from [<806864f8>] (qca8k_sw_probe+0x1b0/0x1c4)
> [    7.489008]  r10:00000000 r9:00000004 r8:81077adc r7:00000000 r6:e8931680 r5:e8830c00
> [    7.500419]  r4:e8931640
> [    7.506528] [<80686348>] (qca8k_sw_probe) from [<806856c8>] (mdio_probe+0x40/0x64)
> [    7.517774]  r7:00000000 r6:81123b24 r5:e8830c00 r4:81077adc
> [    7.527048] [<80685688>] (mdio_probe) from [<8061f944>] (really_probe+0x100/0x2d8)
> [    7.538284]  r5:e8830c00 r4:81123a18
> [    7.545528] [<8061f844>] (really_probe) from [<8061ff68>] (driver_probe_device+0x70/0x180)
> [    7.557539]  r10:00000000 r9:810c07f0 r8:00000001 r7:81006548 r6:e8830c00 r5:81077adc
> [    7.569129]  r4:e8830c00 r3:00000000
> [    7.576439] [<8061fef8>] (driver_probe_device) from [<80620178>] (__device_attach_driver+0x9c/0xc8)
> [    7.589338]  r9:810c07f0 r8:00000001 r7:81006548 r6:e8830c00 r5:e821be74 r4:81077adc
> [    7.600949] [<806200dc>] (__device_attach_driver) from [<8061e160>] (bus_for_each_drv+0x68/0xc8)
> [    7.613617]  r7:81006548 r6:806200dc r5:e821be74 r4:00000000
> [    7.623099] [<8061e0f8>] (bus_for_each_drv) from [<8061fd80>] (__device_attach+0xe0/0x14c)
> [    7.635235]  r7:81071194 r6:e8830c44 r5:81006548 r4:e8830c00
> [    7.644681] [<8061fca0>] (__device_attach) from [<80620220>] (device_initial_probe+0x1c/0x20)
> [    7.657036]  r8:00000000 r7:81071194 r6:e8830c00 r5:81077998 r4:e8830c00
> [    7.667551] [<80620204>] (device_initial_probe) from [<8061e360>] (bus_probe_device+0x94/0x9c)
> [    7.680054] [<8061e2cc>] (bus_probe_device) from [<8061f144>] (deferred_probe_work_func+0x74/0xa0)
> [    7.692914]  r7:81071194 r6:81071180 r5:81071180 r4:e8830c00
> [    7.702440] [<8061f0d0>] (deferred_probe_work_func) from [<80142e2c>] (process_one_work+0x224/0x528)
> [    7.715483]  r7:eada7100 r6:eada5f40 r5:e81f5080 r4:810711b8
> [    7.725046] [<80142c08>] (process_one_work) from [<801433f4>] (worker_thread+0x2c4/0x5e4)
> [    7.737175]  r10:81003d00 r9:00000008 r8:ffffe000 r7:eada5f58 r6:e81f5094 r5:eada5f40
> [    7.748949]  r4:e81f5080
> [    7.755402] [<80143130>] (worker_thread) from [<80148e2c>] (kthread+0x168/0x170)
> [    7.766823]  r10:e8143e74 r9:80143130 r8:e81f5080 r7:e821a000 r6:00000000 r5:e81f7680
> [    7.778636]  r4:e81f76c0
> [    7.785159] [<80148cc4>] (kthread) from [<801010e8>] (ret_from_fork+0x14/0x2c)
> [    7.796457] Exception stack(0xe821bfb0 to 0xe821bff8)
> [    7.805543] bfa0:                                     00000000 00000000 00000000 00000000
> [    7.817805] bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    7.830047] bfe0: 00000000 00000000 00000000 00000000 00000013 00000000
> [    7.840688]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:80148cc4
> [    7.852535]  r4:e81f7680
> [    7.859061] Code: e92dd800 e24cb004 e52de004 e8bd4000 (e5902264)
> [    7.869239] ---[ end trace 1b5559d3dc3f80a4 ]---
> 
> Bisecting the dsa code changes since v5.3 brought me to this commit:
> 
> 0394a63acfe2a6e1c08af0eb1a9133ee8650d7bd is the first bad commit
> commit 0394a63acfe2a6e1c08af0eb1a9133ee8650d7bd
> Author: Vivien Didelot <vivien.didelot@gmail.com>
> Date:   Mon Aug 19 16:00:50 2019 -0400
> 
>     net: dsa: enable and disable all ports
>         Call the .port_enable and .port_disable functions for all ports,
>     not only the user ports, so that drivers may optimize the power
>     consumption of all ports after a successful setup.
>         Unused ports are now disabled on setup. CPU and DSA ports are now
>     enabled on setup and disabled on teardown. User ports were already
>     enabled at slave creation and disabled at slave destruction.
>         Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
>     Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> :040000 040000 0462b53f03ece23b4af955c3b8a48dce05d90970 34e5df083585e6cce35600698a757508b539e508 M    net
> 
> Any ideas what might be wrong?
> Thank you!
> 
This commit added a call to dsa_port_enable() with the phy_device parameter
being NULL what causes the NPE. Other port_enable callback implementations
may also not check this parameter and face a similar issue.
What I can't answer at a first glance is whether passing NULL is the bug,
or whether port_enable implementations not checking the parameter is the
bug.

> Michal
> 
> 
Heiner
