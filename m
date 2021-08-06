Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5589C3E27EA
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244764AbhHFJ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:58:49 -0400
Received: from goliath.siemens.de ([192.35.17.28]:35501 "EHLO
        goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244733AbhHFJ6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:58:48 -0400
X-Greylist: delayed 1017 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Aug 2021 05:58:48 EDT
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by goliath.siemens.de (8.15.2/8.15.2) with ESMTPS id 1769fSDa026920
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Aug 2021 11:41:28 +0200
Received: from [167.87.32.106] ([167.87.32.106])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 1769fRiq032085;
        Fri, 6 Aug 2021 11:41:28 +0200
Subject: Re: wwan/iosm vs. xmm7360
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linuxwwan@intel.com
References: <0545a78f-63f0-f8dd-abdb-1887c65e1c79@siemens.com>
 <eb8fa6ad-10c8-e035-9bd8-1caf470e739e@linux.intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <bafc04de-fb2c-03b4-69c1-ac91e9e8c7ae@siemens.com>
Date:   Fri, 6 Aug 2021 11:41:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <eb8fa6ad-10c8-e035-9bd8-1caf470e739e@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.08.21 11:29, Kumar, M Chetan wrote:
> Hi Jan,
> 
> What is the context of this request ?

The context is that there are many folks out there (me included - Lenovo
P52) with devices that have the xmm-7360 built-in, can't switch it to
USB mode (prevented by OEM), and currently require [1]. That kind of
works but is not really the final solution. So I also kicked off [2] there.

> 
> FYI, the driver upstreamed is for M.2 7560.

I know. I'm not an expert on the details, but reading the overall
architectures of the IOSM and what has been reverse-engineered for the
7360, there seem to be some similarities. So, maybe you can explain to
the community if that is a reasonable path to upstream 7360 support, or
if at least the pattern of the 7560 could/should be transferred to the
7360 driver.

Thanks,
Jan

[2] https://github.com/xmm7360/xmm7360-pci/issues/104

> 
> Regards,
> Chetan
> 
> On 8/6/2021 2:09 AM, Jan Kiszka wrote:
>> Hi Chetan,
>>
>> at the risk of having missed this being answered already:
>>
>> How close is the older xmm7360 to the now supported xmm7560 in mainline?
>>
>> There is that reverse engineered PCI driver [1] with non-standard
>> userland interface, and it would obviously be great to benefit from
>> common infrastructure and specifically the modem-manager compatible
>> interface. Is this realistic to achieve for the 7360, or is that
>> hardware or its firmware too different?
>>
>> Thanks,
>> Jan
>>
>> [1] https://github.com/xmm7360/xmm7360-pci
>>

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
