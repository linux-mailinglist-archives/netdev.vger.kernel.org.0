Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E41C27759E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgIXPkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:40:47 -0400
Received: from foss.arm.com ([217.140.110.172]:49398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbgIXPkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:40:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A06E51FB;
        Thu, 24 Sep 2020 08:40:46 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.10])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 718B13F718;
        Thu, 24 Sep 2020 08:40:46 -0700 (PDT)
Subject: Re: [PATCH] net/fsl: quieten expected MDIO access failures
To:     Jamie Iles <jamie@nuviainc.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
References: <20200924145645.1789724-1-jamie@nuviainc.com>
 <20200924150453.GA3821492@lunn.ch> <20200924151200.GW418386@poplar>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <eafa77d6-4a00-f40e-a4fe-6b50736f3e03@arm.com>
Date:   Thu, 24 Sep 2020 10:40:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200924151200.GW418386@poplar>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/24/20 10:12 AM, Jamie Iles wrote:
> Hi Andrew,
> 
> On Thu, Sep 24, 2020 at 05:04:53PM +0200, Andrew Lunn wrote:
>> On Thu, Sep 24, 2020 at 03:56:45PM +0100, Jamie Iles wrote:
>>> MDIO reads can happen during PHY probing, and printing an error with
>>> dev_err can result in a large number of error messages during device
>>> probe.  On a platform with a serial console this can result in
>>> excessively long boot times in a way that looks like an infinite loop
>>> when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
>>> extended scanning in xgmac_mdio) we perform more scanning so there are
>>> potentially more failures.
>>>
>>> Reduce the logging level to dev_dbg which is consistent with the
>>> Freescale enetc driver.
>>
>> Hi Jamie
>>
>> Does the system you are using suffer from Errata A011043?
> 
> It's the HoneyComb SolidRun (LX2160A) and I can't find an errata list
> for that chip.  It's booting from ACPI in any case so wouldn't have that
> workaround set.

I don't see those messages, but granted my firmware is a bit out of 
date. Let me upgrade it and see if I can reproduce it too.

(also +CC Calvin)
