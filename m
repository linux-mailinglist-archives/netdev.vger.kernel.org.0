Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2C33955E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbfFGTPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:15:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44362 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbfFGTPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:15:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 43D6D1504F979;
        Fri,  7 Jun 2019 12:15:41 -0700 (PDT)
Date:   Fri, 07 Jun 2019 12:15:38 -0700 (PDT)
Message-Id: <20190607.121538.2106706546161674940.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        richardcochran@gmail.com, john.stultz@linaro.org,
        tglx@linutronix.de, sboyd@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA
 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190605.114429.1672040440449676386.davem@davemloft.net>
References: <20190604.202258.1443410652869724565.davem@davemloft.net>
        <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
        <20190605.114429.1672040440449676386.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Jun 2019 12:15:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 05 Jun 2019 11:44:29 -0700 (PDT)

> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Wed, 5 Jun 2019 12:13:59 +0300
> 
>> It is conflicting because net-next at the moment lacks this patch that
>> I submitted to net:
>> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=e8d67fa5696e2fcaf956dae36d11e6eff5246101
>> What would you like me to do: resubmit after you merge net into
>> net-next, add the above patch to this series (which you'll have to
>> skip upon the next merge), or you can just cherry-pick it and then the
>> series will apply?
> 
> So let me bring this series back to state "Under Review" and I'll apply it
> after I next merge net into net-next.

So I applied the series but it doesn't even build:

ERROR: "sja1105_unpack" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
ERROR: "sja1105_spi_send_packed_buf" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
ERROR: "sja1105_pack" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
ERROR: "sja1105_spi_send_int" [drivers/net/dsa/sja1105/sja1105_ptp.ko] undefined!
ERROR: "sja1105_get_ts_info" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105pqrs_ptp_cmd" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105_ptp_clock_unregister" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105_ptpegr_ts_poll" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105et_ptp_cmd" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105_ptp_reset" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105_tstamp_reconstruct" [drivers/net/dsa/sja1105/sja1105.ko] undefined!
ERROR: "sja1105_ptp_clock_register" [drivers/net/dsa/sja1105/sja1105.ko] undefined!

You have to test better with the various modular/non-modular combinations.

Thanks.
