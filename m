Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AD621AF43
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 08:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGJGRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 02:17:42 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:40182 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgGJGRl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 02:17:41 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id CC78DBC117;
        Fri, 10 Jul 2020 06:17:36 +0000 (UTC)
Subject: Re: [PATCH] MAINTAINERS: XDP: restrict N: and K:
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, mchehab+huawei@kernel.org,
        robh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200709194257.26904-1-grandmaster@al2klimov.de>
 <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net>
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
Message-ID: <19a4a48b-3b83-47b9-ac48-e0a95a50fc5e@al2klimov.de>
Date:   Fri, 10 Jul 2020 08:17:34 +0200
MIME-Version: 1.0
In-Reply-To: <d7689340-55fc-5f3f-60ee-b9c952839cab@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
X-Spamd-Bar: /
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 09.07.20 um 22:37 schrieb Daniel Borkmann:
> On 7/9/20 9:42 PM, Alexander A. Klimov wrote:
>> Rationale:
>> Documentation/arm/ixp4xx.rst contains "xdp" as part of "ixdp465"
>> which has nothing to do with XDP.
>>
>> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
>> ---
>>   See also: https://lore.kernel.org/lkml/20200709132607.7fb42415@carbon/
>>
>>   MAINTAINERS | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1d4aa7f942de..2bb7feb838af 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -18708,8 +18708,8 @@ F:    include/trace/events/xdp.h
>>   F:    kernel/bpf/cpumap.c
>>   F:    kernel/bpf/devmap.c
>>   F:    net/core/xdp.c
>> -N:    xdp
>> -K:    xdp
>> +N:    (?:\b|_)xdp(?:\b|_)
>> +K:    (?:\b|_)xdp(?:\b|_)
> 
> Please also include \W to generally match on non-alphanumeric char given 
> you
> explicitly want to avoid [a-z0-9] around the term xdp.
Aren't \W, ^ and $ already covered by \b?

> 
>>   XDP SOCKETS (AF_XDP)
>>   M:    Björn Töpel <bjorn.topel@intel.com>
>>
> 
