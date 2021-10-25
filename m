Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D471439519
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 13:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhJYLpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 07:45:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:33680 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbhJYLpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 07:45:42 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1meyNq-000BAA-Iz; Mon, 25 Oct 2021 13:43:18 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1meyNq-0003OW-E8; Mon, 25 Oct 2021 13:43:18 +0200
Subject: Re: [PATCH iproute2 -next 3/4] ip, neigh: Add missing NTF_USE support
To:     David Ahern <dsahern@gmail.com>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org
References: <20211015225319.2284-1-daniel@iogearbox.net>
 <20211015225319.2284-4-daniel@iogearbox.net>
 <4e842bc5-116b-66c6-b8dc-487b4b5d15ed@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8f029272-466a-3231-9f75-664496ae1dfd@iogearbox.net>
Date:   Mon, 25 Oct 2021 13:43:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <4e842bc5-116b-66c6-b8dc-487b4b5d15ed@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26333/Mon Oct 25 10:29:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/21 2:18 AM, David Ahern wrote:
> On 10/15/21 4:53 PM, Daniel Borkmann wrote:
>> diff --git a/ip/ipneigh.c b/ip/ipneigh.c
>> index 564e787c..9510e03e 100644
>> --- a/ip/ipneigh.c
>> +++ b/ip/ipneigh.c
>> @@ -51,7 +51,7 @@ static void usage(void)
>>   	fprintf(stderr,
>>   		"Usage: ip neigh { add | del | change | replace }\n"
>>   		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] proxy ADDR }\n"
>> -		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
>> +		"		[ dev DEV ] [ router ] [ use ] [ extern_learn ] [ protocol PROTO ]\n"
>>   		"\n"
>>   		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
>>   		"				  [ vrf NAME ]\n"
> 
> 
> does not apply to iproute2-next; looks like you made the change against
> main branch.

Sorry for the delay, was on PTO whole last week. Looks like it, will rebase and send a v2.

Thanks!
Daniel
