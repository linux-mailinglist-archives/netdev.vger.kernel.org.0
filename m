Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7546509B2
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiLSJ7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiLSJ7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:59:54 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD4A26D0;
        Mon, 19 Dec 2022 01:59:53 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p7Cw4-00070z-7R; Mon, 19 Dec 2022 10:59:52 +0100
Message-ID: <90bf9797-a949-b75b-285a-9056b9ba7f56@leemhuis.info>
Date:   Mon, 19 Dec 2022 10:59:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
 #forregzbot
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     bpf <bpf@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <96ee7141-f09c-4df9-015b-6ae8f3588091@leemhuis.info>
In-Reply-To: <96ee7141-f09c-4df9-015b-6ae8f3588091@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1671443993;3dc84f23;
X-HE-SMSGID: 1p7Cw4-00070z-7R
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.12.22 09:44, Thorsten Leemhuis wrote:
> [Note: this mail contains only information for Linux kernel regression
> tracking. Mails like these contain '#forregzbot' in the subject to make
> then easy to spot and filter out. The author also tried to remove most
> or all individuals from the list of recipients to spare them the hassle.]
> 
> On 06.12.22 04:28, Hao Sun wrote:
>>
>> The following crash can be triggered with the BPF prog provided.
>> It seems the verifier passed some invalid progs. I will try to simplify
>> the C reproducer, for now, the following can reproduce this:
> 
> Thanks for the report. To be sure below issue doesn't fall through the
> cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
> tracking bot:
> 
> #regzbot ^introduced c86df29d11df
> #regzbot title net/bpf: BUG: unable to handle kernel paging request in
> bpf_dispatcher_xdp
> #regzbot ignore-activity

#regzbot fix: bpf: Synchronize dispatcher update with
bpf_dispatcher_xdp_func
