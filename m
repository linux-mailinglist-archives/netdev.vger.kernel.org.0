Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11660211C17
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 08:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGBGnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 02:43:42 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48824 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgGBGnl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 02:43:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1593672220; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=6f1hBImubSguouxbGX6vkeK05F05hauxyhVr5E0zwrU=; b=d54wuOMzlTfovjjkXCOUaLHake5/Zn7ySDTwLbwiBn0fuoJiwkm9FDmyyfwD9ZlqaE13l/wg
 JJoYdZS0x1zPzHHtiWif8X5QZzhPnNpbgeo4UkNxSLK/gNVKRsIsaavWG+kYffzb6nvUArEd
 5RqULHnw4KbZ+l2qMwipto0NsN4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5efd8205c76a4e7a2a8c81a5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Jul 2020 06:43:17
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B350FC4339C; Thu,  2 Jul 2020 06:43:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6580EC433CA;
        Thu,  2 Jul 2020 06:43:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6580EC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Viktor =?utf-8?B?SsOkZ2Vyc2vDvHBwZXI=?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     Roman Mamedov <rm@romanrm.net>, Qiujun Huang <hqjagain@gmail.com>,
        ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
References: <20200404041838.10426-1-hqjagain@gmail.com>
        <20200404041838.10426-6-hqjagain@gmail.com>
        <20200621020428.6417d6fb@natsu> <87lfkff9qe.fsf@codeaurora.org>
        <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de>
Date:   Thu, 02 Jul 2020 09:43:11 +0300
In-Reply-To: <53940af0-d156-3117-ac86-2f3ccaee9513@freenet.de> ("Viktor
        \=\?utf-8\?Q\?J\=C3\=A4gersk\=C3\=BCpper\=22's\?\= message of "Wed, 1 Jul 2020
 17:53:27 +0200")
Message-ID: <87imf6beo0.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.de> writes:

> Kalle Valo writes:
>> Roman Mamedov <rm@romanrm.net> writes:
>>=20
>>> On Sat,  4 Apr 2020 12:18:38 +0800
>>> Qiujun Huang <hqjagain@gmail.com> wrote:
>>>
>>>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
>>>> usb_ifnum_to_if(urb->dev, 0)
>>>> But it isn't always true.
>>>>
>>>> The case reported by syzbot:
>>>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@google.=
com
>>>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
>>>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
>>>> usb 2-1: config 1 has no interface number 0
>>>> usb 2-1: New USB device found, idVendor=3D0cf3, idProduct=3D9271, bcdD=
evice=3D
>>>> 1.08
>>>> usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
>>>> general protection fault, probably for non-canonical address
>>>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
>>>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000af]
>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
>>>>
>>>> Call Trace
>>>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>>>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>>>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>>>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>>>> expire_timers kernel/time/timer.c:1449 [inline]
>>>> __run_timers kernel/time/timer.c:1773 [inline]
>>>> __run_timers kernel/time/timer.c:1740 [inline]
>>>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>>>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
>>>> invoke_softirq kernel/softirq.c:373 [inline]
>>>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
>>>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>>>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>>>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>>>
>>>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspotm=
ail.com
>>>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
>>>
>>> This causes complete breakage of ath9k operation across all the stable =
kernel
>>> series it got backported to, and I guess the mainline as well. Please s=
ee:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D208251
>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1848631
>>=20
>> So there's no fix for this? I was under impression that someone fixed
>> this, but maybe I'm mixing with something else.
>>=20
>> If this is not fixed can someone please submit a patch to revert the
>> offending commit (or commits) so that we get ath9k working again?
>>=20
>
> This reverts commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05 ("ath9k: Fix=
 general protection fault
> in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:
>
>   [    5.778803] usb 1-5: Manufacturer: ATHEROS
>   [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.fw=
 requested
>   [   21.701377] usbcore: registered new interface driver ath9k_htc
>   [   22.053705] usb 1-5: ath9k_htc: Transferred FW: ath9k_htc/htc_9271-1=
.4.0.fw, size: 51008
>   [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 cr=
edits
>   [  115.708513] ath9k_htc: Failed to initialize the device
>   [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized
>
> Reported-by: Roman Mamedov <rm@romanrm.net>
> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=3D208251
> Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_us=
b_rx_cb")
> Tested-by: Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.d=
e>
> Signed-off-by: Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freen=
et.de>
> ---
>
> I couldn't find any fix for this, so here is the patch which reverts the
> offending commit. I have tested it with 5.8.0-rc3 and with 5.7.4.
>
> Feel free to change the commit message if it is necessary or appropriate,=
 I am
> just a user affected by this bug.

This was badly formatted:

https://patchwork.kernel.org/patch/11636783/

But v2 looks correct:

https://patchwork.kernel.org/patch/11637341/

Thanks, I'll take a closer look at this as soon as I can.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
