Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1B6402E2D
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345718AbhIGSLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 14:11:39 -0400
Received: from mail.zeus.flokli.de ([88.198.15.28]:35206 "EHLO zeus.flokli.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345652AbhIGSLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 14:11:38 -0400
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2021 14:11:38 EDT
Received: from localhost (unknown [95.179.247.40])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: flokli@flokli.de)
        by zeus.flokli.de (Postfix) with ESMTPSA id 5E7771191266;
        Tue,  7 Sep 2021 18:01:45 +0000 (UTC)
Date:   Tue, 7 Sep 2021 20:01:44 +0200
From:   Florian Klink <flokli@flokli.de>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linuxwwan@intel.com
Subject: Re: wwan/iosm vs. xmm7360
Message-ID: <20210907180144.c2jakttbigc5x7dm@tp>
References: <0545a78f-63f0-f8dd-abdb-1887c65e1c79@siemens.com>
 <eb8fa6ad-10c8-e035-9bd8-1caf470e739e@linux.intel.com>
 <bafc04de-fb2c-03b4-69c1-ac91e9e8c7ae@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bafc04de-fb2c-03b4-69c1-ac91e9e8c7ae@siemens.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21-08-06 11:41:27, Jan Kiszka wrote:
>On 06.08.21 11:29, Kumar, M Chetan wrote:
>> Hi Jan,
>>
>> What is the context of this request ?
>
>The context is that there are many folks out there (me included - Lenovo
>P52) with devices that have the xmm-7360 built-in, can't switch it to
>USB mode (prevented by OEM), and currently require [1]. That kind of
>works but is not really the final solution. So I also kicked off [2] there.

It also seems the 7560 card doesn't show up in my X13 AMD (Gen 1) at all
- so even if I'd "upgrade" that card, I couldn't use it.

>I know. I'm not an expert on the details, but reading the overall
>architectures of the IOSM and what has been reverse-engineered for the
>7360, there seem to be some similarities. So, maybe you can explain to
>the community if that is a reasonable path to upstream 7360 support, or
>if at least the pattern of the 7560 could/should be transferred to the
>7360 driver.

Very curious about this as well - they might share some code at lest, if
not even the driver?

Regards,
Florian

>
>Thanks,
>Jan
>
>[2] https://github.com/xmm7360/xmm7360-pci/issues/104
>
>>
>> Regards,
>> Chetan
>>
>> On 8/6/2021 2:09 AM, Jan Kiszka wrote:
>>> Hi Chetan,
>>>
>>> at the risk of having missed this being answered already:
>>>
>>> How close is the older xmm7360 to the now supported xmm7560 in mainline?
>>>
>>> There is that reverse engineered PCI driver [1] with non-standard
>>> userland interface, and it would obviously be great to benefit from
>>> common infrastructure and specifically the modem-manager compatible
>>> interface. Is this realistic to achieve for the 7360, or is that
>>> hardware or its firmware too different?
>>>
>>> Thanks,
>>> Jan
>>>
>>> [1] https://github.com/xmm7360/xmm7360-pci
>>>
>
>-- 
>Siemens AG, T RDA IOT
>Corporate Competence Center Embedded Linux

-- 
Florian Klink
