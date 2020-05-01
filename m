Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810BA1C0CD4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgEADy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:54:29 -0400
Received: from fgont.go6lab.si ([91.239.96.14]:53282 "EHLO fgont.go6lab.si"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgEADy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 23:54:29 -0400
Received: from [192.168.0.10] (unknown [181.45.84.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by fgont.go6lab.si (Postfix) with ESMTPSA id 93E5081B60;
        Fri,  1 May 2020 05:54:26 +0200 (CEST)
Subject: Re: [PATCH v2 net-next] ipv6: Implement draft-ietf-6man-rfc4941bis
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200426154140.GA1065@archlinux-current.localdomain>
 <20200430.202334.573859461451348083.davem@davemloft.net>
From:   Fernando Gont <fgont@si6networks.com>
Message-ID: <1748ebf6-e058-d124-58ea-acde0ebc5d45@si6networks.com>
Date:   Fri, 1 May 2020 00:54:09 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200430.202334.573859461451348083.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/20 00:23, David Miller wrote:
> From: Fernando Gont <fgont@si6networks.com>
> Date: Sun, 26 Apr 2020 12:41:40 -0300
> 
>> Implement the upcoming rev of RFC4941 (IPv6 temporary addresses):
>> https://tools.ietf.org/html/draft-ietf-6man-rfc4941bis-09
>>
>> * Reduces the default Valid Lifetime to 2 days
>>    The number of extra addresses employed when Valid Lifetime was
>>    7 days exacerbated the stress caused on network
>>    elements/devices. Additionally, the motivation for temporary
>>    addresses is indeed privacy and reduced exposure. With a
>>    default Valid Lifetime of 7 days, an address that becomes
>>    revealed by active communication is reachable and exposed for
>>    one whole week. The only use case for a Valid Lifetime of 7
>>    days could be some application that is expecting to have long
>>    lived connections. But if you want to have a long lived
>>    connections, you shouldn't be using a temporary address in the
>>    first place. Additionally, in the era of mobile devices, general
>>    applications should nevertheless be prepared and robust to
>>    address changes (e.g. nodes swap wifi <-> 4G, etc.)
>>
>> * Employs different IIDs for different prefixes
>>    To avoid network activity correlation among addresses configured
>>    for different prefixes
>>
>> * Uses a simpler algorithm for IID generation
>>    No need to store "history" anywhere
>>
>> Signed-off-by: Fernando Gont <fgont@si6networks.com>
> 
> Please respin this patch as it no longer applies cleanly.  It should
> be easy, it's just because of the ReST conversion of ip-sysctl.txt

Just did, as [PATCH v3 net-next]. No code changes. Just rebased the 
patch on origin/master.

Thanks,
-- 
Fernando Gont
SI6 Networks
e-mail: fgont@si6networks.com
PGP Fingerprint: 6666 31C6 D484 63B2 8FB1 E3C4 AE25 0D55 1D4E 7492




