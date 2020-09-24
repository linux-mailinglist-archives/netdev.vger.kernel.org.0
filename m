Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7D1277B9F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgIXW1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:27:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:52998 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgIXW1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:27:06 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZhf-0006EC-W0; Fri, 25 Sep 2020 00:27:04 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kLZhf-000E62-PI; Fri, 25 Sep 2020 00:27:03 +0200
Subject: Re: [PATCH bpf-next v5] bpf: Add bpf_ktime_get_real_ns
To:     David Ahern <dsahern@gmail.com>, bimmy.pujari@intel.com,
        bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        kafai@fb.com, maze@google.com, ashkan.nikravesh@intel.com
References: <20200924220736.23002-1-bimmy.pujari@intel.com>
 <42da4525-d09e-4be9-7d3c-a4662276b721@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5a4c7ac0-254b-bd25-8eeb-1bef86cd374f@iogearbox.net>
Date:   Fri, 25 Sep 2020 00:27:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <42da4525-d09e-4be9-7d3c-a4662276b721@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25937/Thu Sep 24 15:53:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 12:15 AM, David Ahern wrote:
> On 9/24/20 4:07 PM, bimmy.pujari@intel.com wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index a22812561064..198e69a6508d 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3586,6 +3586,13 @@ union bpf_attr {
>>    * 		the data in *dst*. This is a wrapper of **copy_from_user**\ ().
>>    * 	Return
>>    * 		0 on success, or a negative error in case of failure.
>> + *
>> + * u64 bpf_ktime_get_real_ns(void)
>> + *	Description
>> + *		Return the real time in nanoseconds.
>> + *		See: **clock_gettime**\ (**CLOCK_REALTIME**)
> 
> This should be a little more explicit -- something like "See the caveats
> regarding use of CLOCK_REALTIME in clock_gettime man page."

+1, and also other feedback got ignored along the way [0]; please don't just resend
several new revisions in the meantime when there were things that still need to be
addressed. Thanks!

   [0] https://lore.kernel.org/bpf/d232b77c-da79-da1c-e564-e2a5cb64acb6@iogearbox.net/T/#ma2997c90e80329c457eb92e9592e185f27ce222f
