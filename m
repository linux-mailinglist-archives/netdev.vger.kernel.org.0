Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C156399FD
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 11:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiK0K5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 05:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiK0K5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 05:57:40 -0500
Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A975725ED
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 02:57:35 -0800 (PST)
Received: (wp-smtpd smtp.tlen.pl 7192 invoked from network); 27 Nov 2022 11:57:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1669546652; bh=qS+rKWNvGCE+eobUw/wNc/kwb6l/nshtjygdh0Ja6Pc=;
          h=Subject:To:Cc:From;
          b=qOhJgvEQM2pXF7U1NqFXaRELAcH1yunwvj1QB2Mk32WlXn8rvCHn4nE9flVcPfFOu
           fIE4xF4qXar66d0axeHm2f9tlcRFFQGyaPBkdICagvv+xMTFLUz0cUI5+RKGLo9dPk
           Gu3E+KRJGC+pSEdVMcWZMUBxFTET4m26NA6+SgMM=
Received: from aaeq124.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.120.124])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <luiz.von.dentz@intel.com>; 27 Nov 2022 11:57:32 +0100
Message-ID: <ab910a40-45e8-08c0-dd25-5c9dec0f272a@o2.pl>
Date:   Sun, 27 Nov 2022 11:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] Bluetooth: silence a dmesg error message in hci_request.c
To:     luiz.von.dentz@intel.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brian.gix@intel.com,
        marcel@holtmann.org, johan.hedberg@gmail.com
References: <20221116202856.55847-1-mat.jonczyk@o2.pl>
 <166863481577.13601.1517745268400800639.git-patchwork-notify@kernel.org>
Content-Language: en-GB
From:   =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
In-Reply-To: <166863481577.13601.1517745268400800639.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: c6c3e251eb3a3a0309f581adaadd77eb
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [UbME]                               
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 16.11.2022 o 22:40, patchwork-bot+bluetooth@kernel.org pisze:
> Hello:
>
> This patch was applied to bluetooth/bluetooth-next.git (master)
> by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:
>
> On Wed, 16 Nov 2022 21:28:56 +0100 you wrote:
>> On kernel 6.1-rcX, I have been getting the following dmesg error message
>> on every boot, resume from suspend and rfkill unblock of the Bluetooth
>> device:
>>
>> 	Bluetooth: hci0: HCI_REQ-0xfcf0
>>
>> After some investigation, it turned out to be caused by
>> commit dd50a864ffae ("Bluetooth: Delete unreferenced hci_request code")
>> which modified hci_req_add() in net/bluetooth/hci_request.c to always
>> print an error message when it is executed. In my case, the function was
>> executed by msft_set_filter_enable() in net/bluetooth/msft.c, which
>> provides support for Microsoft vendor opcodes.
>>
>> [...]
> Here is the summary with links:
>   - Bluetooth: silence a dmesg error message in hci_request.c
>     https://git.kernel.org/bluetooth/bluetooth-next/c/c3fd63f7fe5a
>
> You are awesome, thank you!

Hello,

Thank you. I would like to ask: is this patch going to be merged for kernel 6.1?

The error message that this patch silences will no doubt confuse some users
if it will be released in Linux 6.1.0.

Greetings,

Mateusz

