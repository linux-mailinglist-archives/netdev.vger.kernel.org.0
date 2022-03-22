Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C484E3AB5
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiCVIfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiCVIft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:35:49 -0400
Received: from mo4-p02-ob.smtp.rzone.de (mo4-p02-ob.smtp.rzone.de [81.169.146.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4A545510;
        Tue, 22 Mar 2022 01:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647938013;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=ntrq2GDLVZrYGtItjUXPdagiGGLGKRv1C9uWWopglQU=;
    b=jlYDY1xt9eqCm8cyhDwadLpuygIPvUnrPSRWlrZKufoT9rGv8zvlmdRr11VjewO+mz
    czpM096lvUC1eBwFWTne5ueeqCprl4lJoXydJdArqbSlkmMa0X8OvLsCbAke7JCp1/aV
    W1OlanywjKPJVzlQOqgWf0zPYdNnVm66BoMtBO3KdFdFwBCXB4abcTmN/+clZo+NV7/l
    jtaccaY979cr/zm5CtKV7fXBLGckN8aaDDeK0KDQZSsfGZL0jr7bug2EPBP2AJu4Xm+h
    4j7UZR6fJZHZeesEFAjkmFl0sUqnfJrPxfO35KugV/cq5Q9677ZXZwpFi+PvEhpqWFYq
    JXwQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2M8XWDnA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 22 Mar 2022 09:33:32 +0100 (CET)
Message-ID: <17c8dc7b-7768-09cb-b48f-a923514f02db@hartkopp.net>
Date:   Tue, 22 Mar 2022 09:33:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
Content-Language: en-US
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
 <20220322074622.5gkjhs25epurecvx@pengutronix.de>
 <202203220918.33033.pisa@cmp.felk.cvut.cz>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <202203220918.33033.pisa@cmp.felk.cvut.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22.03.22 09:18, Pavel Pisa wrote:
> Hello Marc,
> 
> thanks for positive reply for our years effort.
> 
> On Tuesday 22 of March 2022 08:46:22 Marc Kleine-Budde wrote:
>> On 22.03.2022 00:32:27, Pavel Pisa wrote:
>>> This driver adds support for the CTU CAN FD open-source IP core.
>>
>> The driver looks much better now. Good work. Please have a look at the
>> TX path of the mcp251xfd driver, especially the tx_stop_queue and
>> tx_wake_queue in mcp251xfd_start_xmit() and mcp251xfd_handle_tefif(). A
>> lockless implementation should work in your hardware, too.
> 
> Is this blocker for now? I would like to start with years tested base.
> 
> We have HW timestamping implemented for actual stable CTU CAN FD IP core
> version, support for variable number of TX buffers which count can be
> parameterized up to 8 in the prepared version and long term desire to
> configurable-SW defined multi-queue which our HW interface allows to
> dynamically server by á TX buffers. But plan is to keep combinations
> of the design and driver compatible from the actual revision.
> 
> I would be happy if we can agree on some base/minimal support and get
> it into mainline and use it as base for the followup patch series.

IMHO I would vote for this approach too.

There are many users of that open source IP CAN core right now and the 
out-of-tree maintenance is no fun for all of them.

When the driver status is fine from the technical and programming style 
standpoint we should move the improvements for the lockless 
transmissions to a later date.

Best regards,
Oliver

> 
> I understand that I have sent code late for actual merge window,
> but I am really loaded by teaching, related RISC-V simulator
> https://github.com/cvut/qtrvsim , ESA and robotic projects
> at company. So I would prefer to go step by step and cooperate
> on updates and testing with my diploma students.
> 
>> BTW: The PROP_SEG/PHASE_SEG1 issue is known:
>>> +A curious reader will notice that the durations of the segments PROP_SEG
>>> +and PHASE_SEG1 are not determined separately but rather combined and
>>> +then, by default, the resulting TSEG1 is evenly divided between PROP_SEG
>>> +and PHASE_SEG1.
>>
>> and the flexcan IP core in CAN-FD mode has the same problem. When
>> working on the bit timing parameter, I'll plan to have separate
>> PROP_SEG/PHASE_SEG1 min/max in the kernel, so that the bit timing
>> algorithm can take care of this.
> 
> Hmm, when I have thought about that years ago I have not noticed real
> difference when time quanta is move between PROP_SEG and PHASE_SEG1.
> So for me it had no influence on the algorithm computation and
> could be done on the chip level when minimal and maximal sum is
> respected. But may it be I have overlooked something and there is
> difference for CAN FD.  May it be my colleagues Jiri Novak and
> Ondrej Ille are more knowable.
> 
> As for the optimal timequantas per bit value, I agree that it
> is not so simple. In the fact SJW and even tipple-sampling
> should be defined in percentage of bit time and then all should
> be optimized together and even combination with slight bitrate
> error should be preferred against other exact matching when
> there is significant difference in the other parameters values.
> 
> But I am not ready to dive into it till our ESA space NanoXplore
> FPGA project passes final stage...
> 
> By the way we have received report from Andrew Dennison about
> successful integration of CTU CAN FD into Litex based RISC-V
> system. Tested with the Linux our Linux kernel driver.
> 
> The first iteration there, but he reported that some corrections
> from his actual development needs to be added to the public
> repo still to be usable out of the box
> 
>    https://github.com/AndrewD/litecan
> 
> Best wishes,
> 
>                  Pavel Pisa
>      phone:      +420 603531357
>      e-mail:     pisa@cmp.felk.cvut.cz
>      Department of Control Engineering FEE CVUT
>      Karlovo namesti 13, 121 35, Prague 2
>      university: http://dce.fel.cvut.cz/
>      personal:   http://cmp.felk.cvut.cz/~pisa
>      projects:   https://www.openhub.net/accounts/ppisa
>      CAN related:http://canbus.pages.fel.cvut.cz/
>      Open Technologies Research Education and Exchange Services
>      https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home
> 
