Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB60E21D867
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgGMO1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:27:21 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:34268 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729784AbgGMO1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 10:27:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594650440; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=49GatlMmRBeX4TYUjyWJvtJZH9uZkExUvhxMzl1/Ch8=; b=G+CGJcpBLzXgRRa/rMdgGi8bcSQ+XKj0bVnHt0/tzKhRZOgdyhJHkVjKqK2EAV6paDm4GH6X
 8HYUio63fY9jXyJIvvc1MpcGX7u7f9dB4MQ3mjijJbjwy/N20r2RGzvrOCg6auCtXYIOi57i
 Q6Lb6wlGtZg9AIE2h0dzqHR+dFQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f0c6f351e603dbb44a915b4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 13 Jul 2020 14:27:01
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 00436C43387; Mon, 13 Jul 2020 14:26:59 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 385D7C433C8;
        Mon, 13 Jul 2020 14:26:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 385D7C433C8
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
        <87imf6beo0.fsf@codeaurora.org>
        <abb99acd-e001-6e80-4d46-fae5ad3887f6@freenet.de>
Date:   Mon, 13 Jul 2020 17:26:54 +0300
In-Reply-To: <abb99acd-e001-6e80-4d46-fae5ad3887f6@freenet.de> ("Viktor
        \=\?utf-8\?Q\?J\=C3\=A4gersk\=C3\=BCpper\=22's\?\= message of "Thu, 9 Jul 2020
 16:36:24 +0200")
Message-ID: <87sgdva3td.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.de> writes:

> Kalle Valo wrote:
>> Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet.de> writes:
>>=20
>>> Kalle Valo writes:
>>>> Roman Mamedov <rm@romanrm.net> writes:
>>>>
>>>>> On Sat,  4 Apr 2020 12:18:38 +0800
>>>>> Qiujun Huang <hqjagain@gmail.com> wrote:
>>>>>
>>>>>> In ath9k_hif_usb_rx_cb interface number is assumed to be 0.
>>>>>> usb_ifnum_to_if(urb->dev, 0)
>>>>>> But it isn't always true.
>>>>>>
>>>>>> The case reported by syzbot:
>>>>>> https://lore.kernel.org/linux-usb/000000000000666c9c05a1c05d12@googl=
e.com
>>>>>> usb 2-1: new high-speed USB device number 2 using dummy_hcd
>>>>>> usb 2-1: config 1 has an invalid interface number: 2 but max is 0
>>>>>> usb 2-1: config 1 has no interface number 0
>>>>>> usb 2-1: New USB device found, idVendor=3D0cf3, idProduct=3D9271, bc=
dDevice=3D
>>>>>> 1.08
>>>>>> usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=
=3D3
>>>>>> general protection fault, probably for non-canonical address
>>>>>> 0xdffffc0000000015: 0000 [#1] SMP KASAN
>>>>>> KASAN: null-ptr-deref in range [0x00000000000000a8-0x00000000000000a=
f]
>>>>>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc5-syzkaller #0
>>>>>>
>>>>>> Call Trace
>>>>>> __usb_hcd_giveback_urb+0x29a/0x550 drivers/usb/core/hcd.c:1650
>>>>>> usb_hcd_giveback_urb+0x368/0x420 drivers/usb/core/hcd.c:1716
>>>>>> dummy_timer+0x1258/0x32ae drivers/usb/gadget/udc/dummy_hcd.c:1966
>>>>>> call_timer_fn+0x195/0x6f0 kernel/time/timer.c:1404
>>>>>> expire_timers kernel/time/timer.c:1449 [inline]
>>>>>> __run_timers kernel/time/timer.c:1773 [inline]
>>>>>> __run_timers kernel/time/timer.c:1740 [inline]
>>>>>> run_timer_softirq+0x5f9/0x1500 kernel/time/timer.c:1786
>>>>>> __do_softirq+0x21e/0x950 kernel/softirq.c:292
>>>>>> invoke_softirq kernel/softirq.c:373 [inline]
>>>>>> irq_exit+0x178/0x1a0 kernel/softirq.c:413
>>>>>> exiting_irq arch/x86/include/asm/apic.h:546 [inline]
>>>>>> smp_apic_timer_interrupt+0x141/0x540 arch/x86/kernel/apic/apic.c:1146
>>>>>> apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
>>>>>>
>>>>>> Reported-and-tested-by: syzbot+40d5d2e8a4680952f042@syzkaller.appspo=
tmail.com
>>>>>> Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
>>>>>
>>>>> This causes complete breakage of ath9k operation across all the stabl=
e kernel
>>>>> series it got backported to, and I guess the mainline as well. Please=
 see:
>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D208251
>>>>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1848631
>>>>
>>>> So there's no fix for this? I was under impression that someone fixed
>>>> this, but maybe I'm mixing with something else.
>>>>
>>>> If this is not fixed can someone please submit a patch to revert the
>>>> offending commit (or commits) so that we get ath9k working again?
>>>>
>>>
>>> This reverts commit 2bbcaaee1fcbd83272e29f31e2bb7e70d8c49e05
>>> ("ath9k: Fix general protection fault
>>> in ath9k_hif_usb_rx_cb") because the driver gets stuck like this:
>>>
>>>   [    5.778803] usb 1-5: Manufacturer: ATHEROS
>>>   [   21.697488] usb 1-5: ath9k_htc: Firmware ath9k_htc/htc_9271-1.4.0.=
fw requested
>>>   [   21.701377] usbcore: registered new interface driver ath9k_htc
>>>   [ 22.053705] usb 1-5: ath9k_htc: Transferred FW:
>>> ath9k_htc/htc_9271-1.4.0.fw, size: 51008
>>>   [   22.306182] ath9k_htc 1-5:1.0: ath9k_htc: HTC initialized with 33 =
credits
>>>   [  115.708513] ath9k_htc: Failed to initialize the device
>>>   [  115.708683] usb 1-5: ath9k_htc: USB layer deinitialized
>>>
>>> Reported-by: Roman Mamedov <rm@romanrm.net>
>>> Ref: https://bugzilla.kernel.org/show_bug.cgi?id=3D208251
>>> Fixes: 2bbcaaee1fcb ("ath9k: Fix general protection fault in ath9k_hif_=
usb_rx_cb")
>>> Tested-by: Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@freenet=
.de>
>>> Signed-off-by: Viktor J=C3=A4gersk=C3=BCpper <viktor_jaegerskuepper@fre=
enet.de>
>>> ---
>>>
>>> I couldn't find any fix for this, so here is the patch which reverts the
>>> offending commit. I have tested it with 5.8.0-rc3 and with 5.7.4.
>>>
>>> Feel free to change the commit message if it is necessary or appropriat=
e, I am
>>> just a user affected by this bug.
>>=20
>> This was badly formatted:
>>=20
>> https://patchwork.kernel.org/patch/11636783/
>>=20
>> But v2 looks correct:
>>=20
>> https://patchwork.kernel.org/patch/11637341/
>>=20
>> Thanks, I'll take a closer look at this as soon as I can.
>>=20
>
> Hi Kalle,
>
> it seems you didn't have time for this so far. If you don't have time at =
the
> moment, is there someone else who can fix this? Reverting the commit is j=
ust the
> first and easy option and fixing this properly can be done after that.

I was on vacation, I will get to your patch in the next few days.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
