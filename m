Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63762AFB2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 10:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfE0IEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 04:04:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:53052 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725940AbfE0IEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 04:04:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AE0EAED0;
        Mon, 27 May 2019 08:04:38 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Yash Shah <yash.shah@sifive.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, nicolas.ferre@microchip.com,
        Palmer Dabbelt <palmer@sifive.com>, aou@eecs.berkeley.edu,
        ynezz@true.cz, Paul Walmsley <paul.walmsley@sifive.com>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Subject: Re: [PATCH 0/2] net: macb: Add support for SiFive FU540-C000
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
        <mvmwoihfi9f.fsf@suse.de>
        <CAJ2_jOEr5J7_-81MjUE63OSFKL-p9whEZ_FDBihojXP2wvadVg@mail.gmail.com>
X-Yow:  ..  the MYSTERIANS are in here with my CORDUROY SOAP DISH!!
Date:   Mon, 27 May 2019 10:04:36 +0200
In-Reply-To: <CAJ2_jOEr5J7_-81MjUE63OSFKL-p9whEZ_FDBihojXP2wvadVg@mail.gmail.com>
        (Yash Shah's message of "Fri, 24 May 2019 10:09:58 +0530")
Message-ID: <mvm36l0fhm3.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mai 24 2019, Yash Shah <yash.shah@sifive.com> wrote:

> Hi Andreas,
>
> On Thu, May 23, 2019 at 6:19 PM Andreas Schwab <schwab@suse.de> wrote:
>>
>> On Mai 23 2019, Yash Shah <yash.shah@sifive.com> wrote:
>>
>> > On FU540, the management IP block is tightly coupled with the Cadence
>> > MACB IP block. It manages many of the boundary signals from the MACB IP
>> > This patchset controls the tx_clk input signal to the MACB IP. It
>> > switches between the local TX clock (125MHz) and PHY TX clocks. This
>> > is necessary to toggle between 1Gb and 100/10Mb speeds.
>>
>> Doesn't work for me:
>>
>> [  365.842801] macb: probe of 10090000.ethernet failed with error -17
>>
>
> Make sure you have applied all the patches needed for testing found at
> dev/yashs/ethernet branch of:

Nope, try reloading the module.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
