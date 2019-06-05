Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44ED836381
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 20:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfFESob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 14:44:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFESob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 14:44:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2147215104E6D;
        Wed,  5 Jun 2019 11:44:30 -0700 (PDT)
Date:   Wed, 05 Jun 2019 11:44:29 -0700 (PDT)
Message-Id: <20190605.114429.1672040440449676386.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        richardcochran@gmail.com, john.stultz@linaro.org,
        tglx@linutronix.de, sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
        <20190604.202258.1443410652869724565.davem@davemloft.net>
        <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Jun 2019 11:44:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 5 Jun 2019 12:13:59 +0300

> On Wed, 5 Jun 2019 at 06:23, David Miller <davem@davemloft.net> wrote:
>>
>> From: Vladimir Oltean <olteanv@gmail.com>
>> Date: Tue,  4 Jun 2019 20:07:39 +0300
>>
>> > This patchset adds the following:
>> >
>> >  - A timecounter/cyclecounter based PHC for the free-running
>> >    timestamping clock of this switch.
>> >
>> >  - A state machine implemented in the DSA tagger for SJA1105, which
>> >    keeps track of metadata follow-up Ethernet frames (the switch's way
>> >    of transmitting RX timestamps).
>>
>> This series doesn't apply cleanly to net-next, please respin.
>>
>> Thank you.
> 
> Hi Dave,
> 
> It is conflicting because net-next at the moment lacks this patch that
> I submitted to net:
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=e8d67fa5696e2fcaf956dae36d11e6eff5246101
> What would you like me to do: resubmit after you merge net into
> net-next, add the above patch to this series (which you'll have to
> skip upon the next merge), or you can just cherry-pick it and then the
> series will apply?

So let me bring this series back to state "Under Review" and I'll apply it
after I next merge net into net-next.

Thanks for letting me know.
