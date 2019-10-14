Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40D8CD6C2A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfJNXp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:45:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfJNXp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 19:45:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1D4F14B8E234;
        Mon, 14 Oct 2019 16:45:55 -0700 (PDT)
Date:   Mon, 14 Oct 2019 16:45:53 -0700 (PDT)
Message-Id: <20191014.164553.1587745125486142398.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] PTP driver refactoring for SJA1105 DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191012191454.GM3165@localhost>
References: <20191011231816.7888-1-olteanv@gmail.com>
        <20191012191454.GM3165@localhost>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Oct 2019 16:45:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>
Date: Sat, 12 Oct 2019 12:14:54 -0700

> On Sat, Oct 12, 2019 at 02:18:12AM +0300, Vladimir Oltean wrote:
>> This series creates a better separation between the driver core and the
>> PTP portion. Therefore, users who are not interested in PTP can get a
>> simpler and smaller driver by compiling it out.
>> 
>> This is in preparation for further patches: SPI transfer timestamping,
>> synchronizing the hardware clock (as opposed to keeping it
>> free-running), PPS input/output, etc.
>> 
>> Vladimir Oltean (4):
>>   net: dsa: sja1105: Get rid of global declaration of struct
>>     ptp_clock_info
>>   net: dsa: sja1105: Make all public PTP functions take dsa_switch as
>>     argument
>>   net: dsa: sja1105: Move PTP data to its own private structure
>>   net: dsa: sja1105: Change the PTP command access pattern
>> 
>>  drivers/net/dsa/sja1105/sja1105.h      |  16 +-
>>  drivers/net/dsa/sja1105/sja1105_main.c | 234 +--------------
>>  drivers/net/dsa/sja1105/sja1105_ptp.c  | 391 ++++++++++++++++++++-----
>>  drivers/net/dsa/sja1105/sja1105_ptp.h  |  84 ++++--
>>  drivers/net/dsa/sja1105/sja1105_spi.c  |   2 +-
>>  5 files changed, 386 insertions(+), 341 deletions(-)
> 
> Acked-by: Richard Cochran <richardcochran@gmail.com>

Series applied, thanks everyone.
