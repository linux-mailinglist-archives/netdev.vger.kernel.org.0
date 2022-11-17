Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3868062E6E8
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 22:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbiKQV1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 16:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiKQV1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:27:46 -0500
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E363B1
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:27:42 -0800 (PST)
Received: (wp-smtpd smtp.tlen.pl 7271 invoked from network); 17 Nov 2022 22:27:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1668720458; bh=QAm84S5ZlKWSWkXCuY0F+3m8n9T5YQX4aAHzSgpv6l4=;
          h=Subject:To:Cc:From;
          b=fHRt1v32Oxs2Hu64P5AJEMrSTgjLDRW79rInA1zxuTJftVZ1fJQbOXzV+sVPvbJs5
           4oERJFR9y81zJWlGBUwfabl0a8mb9+7kdS3ARTOB3cJuHyvXFer5NdC+lskz/TsUQ5
           xVSMz/AppWVFx6cZtcxVqw3XEBfNzUQLWpupzQmc=
Received: from aafn183.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.143.183])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <brian.gix@intel.com>; 17 Nov 2022 22:27:38 +0100
Message-ID: <232fd0ae-0002-53cb-9400-f0347e434d42@o2.pl>
Date:   Thu, 17 Nov 2022 22:27:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
Content-Language: en-GB
To:     "Gix, Brian" <brian.gix@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Von Dentz, Luiz" <luiz.von.dentz@intel.com>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "marcel@holtmann.org" <marcel@holtmann.org>
References: <20221116202856.55847-1-mat.jonczyk@o2.pl>
 <499a1278bcf1b2028f6984d61733717a849d9787.camel@intel.com>
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <499a1278bcf1b2028f6984d61733717a849d9787.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 7fccb677ad4e849ba835e87700170acb
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [IROE]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 17.11.2022 o 21:34, Gix, Brian pisze:
> Hi Mateusz,
>
> On Wed, 2022-11-16 at 21:28 +0100, Mateusz Jończyk wrote:
>> On kernel 6.1-rcX, I have been getting the following dmesg error
>> message
>> on every boot, resume from suspend and rfkill unblock of the
>> Bluetooth
>> device:
>>
>>         Bluetooth: hci0: HCI_REQ-0xfcf0
>>
> This has a patch that fixes the usage of the deprecated HCI_REQ
> mechanism rather than hiding the fact it is being called, as in this
> case.
>
> I am still waiting for someone to give me a "Tested-By:" tag to patch:
>
> [PATCH 1/1] Bluetooth: Convert MSFT filter HCI cmd to hci_sync
>
> Which will also stop the dmesg error. If you could try that patch, and
> resend it to the list with a Tested-By tag, it can be applied.

Hello,

I did not receive this patch, as I was not on the CC list; I was not
aware of it. I will test it shortly.

Any guidelines how I should test this functionality? I have a Sony Xperia 10 i4113
mobile phone with LineageOS 19.1 / Android 12L, which according to the spec supports
Bluetooth 5.0. Quick Google search tells me that I should do things like 

        hcitool lescan

to discover the phone, then use gatttool to list the services, etc.

Greetings,

Mateusz

