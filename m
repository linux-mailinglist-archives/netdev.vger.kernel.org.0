Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703595EA9B2
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 17:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235353AbiIZPIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 11:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235775AbiIZPIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 11:08:36 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B0B79A62;
        Mon, 26 Sep 2022 06:40:55 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1ocoLu-0006yL-49; Mon, 26 Sep 2022 15:40:54 +0200
Message-ID: <d1ba88bf-ae0e-72e2-d5c8-133cd4323e9f@leemhuis.info>
Date:   Mon, 26 Sep 2022 15:40:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [regression] Bug 216397 - Kernel 5.19 with NetworkManager and
 iwd: Wifi reconnect on resume is broken #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <31cceaa5-2684-1aa8-61c6-c1be2d563bb0@leemhuis.info>
In-Reply-To: <31cceaa5-2684-1aa8-61c6-c1be2d563bb0@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664199655;7c1d48f2;
X-HE-SMSGID: 1ocoLu-0006yL-49
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWIMC: this mail is primarily send for documentation purposes and for
regzbot, my Linux kernel regression tracking bot. These mails usually
contain '#forregzbot' in the subject, to make them easy to spot and filter.

On 26.08.22 13:14, Thorsten Leemhuis wrote:
> 
> To quote from https://bugzilla.kernel.org/show_bug.cgi?id=216397 :
> 
>>  Vorpal 2022-08-22 16:35:21 UTC
>>
>> Created attachment 301630 [details]
>> Relevant journalctl.txt
>>
>> After upgrading to kernel 5.19 (Arch Linux kernel, which is minimally modified, but I tested a few alternative kernels too, such as zen), wifi reconnect on resume is broken when using NetworkManager + iwd.

#regzbot fixed-by: 8997f5c8a62

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
