Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8290C6E45C4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjDQKwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjDQKwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:52:06 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9318699;
        Mon, 17 Apr 2023 03:51:06 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1poLUs-0000V0-CC; Mon, 17 Apr 2023 11:50:06 +0200
Message-ID: <afa92c35-b17a-49de-ac4c-6d60237a2dca@leemhuis.info>
Date:   Mon, 17 Apr 2023 11:50:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [regression] Bug 217286 - ath11k:deny assoc request, Invalid
 supported ch width and ext nss combination
Content-Language: en-US, de-DE
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
To:     P Praneesh <quic_ppranees@quicinc.com>
Cc:     ath11k <ath11k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        Kalle Valo <kvalo@kernel.org>,
        Jouni Malinen <jouni@codeaurora.org>, Jouni Malinen <j@w1.fi>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>,
          Linux regressions mailing list 
          <regressions@lists.linux.dev>
References: <ed31b6fe-e73d-34af-445b-81c5c644d615@leemhuis.info>
 <f84c39ed-b8d8-7d0c-0eff-c90feaf5ab4f@leemhuis.info>
In-Reply-To: <f84c39ed-b8d8-7d0c-0eff-c90feaf5ab4f@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1681728666;9bab99fe;
X-HE-SMSGID: 1poLUs-0000V0-CC
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resending with the current email addresses for P Praneesh and Jouni
Malinen; didn't find one on lore for Ganesh Sesetti, and Sathishkumar
Muruganandam]

Please see quoted text below, as there is a kernel regression that is
caused by a patch you authored or passed on.

On 17.04.23 11:33, Thorsten Leemhuis wrote:
> On 08.04.23 13:52, Linux regression tracking (Thorsten Leemhuis) wrote:
>> Hi, Thorsten here, the Linux kernel's regression tracker.
>>
>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>> kernel developers don't keep an eye on it, I decided to forward it by mail.
>>
>> Note, you have to use bugzilla to reach the reporter, as I sadly[1] can
>> not CCed them in mails like this.
>>
>> Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=217286 :
>>
>>> Built and installed v6.2 kernel (with ath11k_pci) on arm64 hardware
>>> running Ubuntu22.04. Hardware has both Atheros QCN9074 module and Intel
>>> AX210 module. Running each (separately) in station mode and try to
>>> connect to Synology router with WiFi Access Point based on QCN9074.
>>> AX210 has no problem connecting to AP but Atheros is successfully
>>> authenticating but association is rejected by AP with this error message:
>>>
>>>
>>> wlan: [0:I:ANY] [UNSPECIFIED] vap-0(wlan100): [04:f0:21:a1:7c:3e]deny assoc request, Invalid supported ch width and ext nss combination
>>>
>>> Please note that when running v5.15.5 kernel (with ath11k_pci), I am
>>> able to connect to the same AP without problems.
>>>
>>> Detailed logs follow:
>>> [...]
>>
>> See the ticket for more details.
> 
> FWIW, the reporter bisected the regression down to
> 
> 552d6fd2f2 ("ath11k: add support for 80P80 and 160 MHz bandwidth")
> 
> Authored by P Praneesh, Ganesh Sesetti, and Sathishkumar Muruganandam,.
> all of which I added to the list of recipients (just like Jouni Malinen,
> who handled the patch). Could one of you please look into this?
> 
> While at it, let me update the tracking status:
> 
> #regzbot introduced: 552d6fd2f2
> #regzbot ignore-activity
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
> 
> 
