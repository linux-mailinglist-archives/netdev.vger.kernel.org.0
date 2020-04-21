Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3561B274F
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgDUNO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:14:59 -0400
Received: from foss.arm.com ([217.140.110.172]:34798 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgDUNO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 09:14:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBB2531B;
        Tue, 21 Apr 2020 06:14:58 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 84A1F3F68F;
        Tue, 21 Apr 2020 06:14:58 -0700 (PDT)
Subject: Re: [PATCH v2 0/5] net: bcmgenet: Clean up after ACPI enablement
To:     David Miller <davem@davemloft.net>,
        andriy.shevchenko@linux.intel.com
Cc:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
 <20200420.162509.1724784326946148100.davem@davemloft.net>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <c8504b66-04d7-e843-67d7-70f50a6aa546@arm.com>
Date:   Tue, 21 Apr 2020 08:14:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200420.162509.1724784326946148100.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/20 6:25 PM, David Miller wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Date: Tue, 21 Apr 2020 00:51:16 +0300
> 
>> ACPI enablement series had missed some clean ups that would have been done
>> at the same time. Here are these bits.
>>
>> In v2:
>> - return dev_dbg() calls to avoid spamming logs when probe is deferred (Florian)
>> - added Ack (Florian)
>> - combined two, earlier sent, series together
>> - added couple more patches
> 
> Series applied to net-next, thanks.
> 

Well, you guys are two fast for me.. <chuckle> Or rather the couple 
hours it took to build the kernel on the rpi4.

Anyway, the changes looks like fine, and boots fine in ACPI mode.

Its probably to late for this but anyway:

Tested-by: Jeremy Linton <jeremy.linton@arm.com>

Thanks,



