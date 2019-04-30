Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BBA1003C
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 21:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfD3TUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 15:20:30 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:60482 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbfD3TU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 15:20:29 -0400
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 15:20:28 EDT
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UIn24o014160;
        Tue, 30 Apr 2019 19:55:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : from : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=Okk/l6FTrfl1WUIJ9LxyG2OUMLoHnOjhq8yiP5DWwmw=;
 b=la984SFWeEgvZgbxvXHtW4gQWC3mKDp2v6+kQEqcTpdXhBGDSWHgH/hejnLF/mwo0fg7
 +7ALht8NuXrN46fuZkWBWlaSVRYojcPd5b6PUkEJA04S2xcqo8qnhw9a9qZqWo4UBYWO
 DPsw8tI8JxenITpVbKbrPHmrXMhMIBMAGRytLQsU4KTF6vEtwz+t5DsPM3t8NyXCNNKt
 nPetjDDY5XblgT3VQ9Fiwl+O15nAXwc/waMbMmUUASNBkHXU5ry2tQ2zUyuSpVMCDF/c
 IUujNJgvrXf9hGqMKFtLaxXKMp6chclgp8v70/I7LAicO1Wk6qjXF2+wq1dZ5vFI4/ia tw== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2s6gsbtn81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Apr 2019 19:55:11 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x3UIlQ1t026699;
        Tue, 30 Apr 2019 14:55:10 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2s4jdve6m4-1;
        Tue, 30 Apr 2019 14:55:10 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 8E8241FCDB;
        Tue, 30 Apr 2019 18:55:09 +0000 (GMT)
Subject: Re: [PATCH iproute2-next] ss: add option to print socket information
 on one line
From:   Josh Hunt <johunt@akamai.com>
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556227308-16057-1-git-send-email-johunt@akamai.com>
 <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
 <f1a1cd3b-8b85-3296-edd0-8106b7e28010@akamai.com>
Message-ID: <1f1ca56d-bfd7-7fc4-1fed-cff2cc69c6f7@akamai.com>
Date:   Tue, 30 Apr 2019 11:55:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <f1a1cd3b-8b85-3296-edd0-8106b7e28010@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300111
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300112
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 11:31 AM, Josh Hunt wrote:
> On 4/30/19 11:30 AM, David Ahern wrote:
>> On 4/25/19 3:21 PM, Josh Hunt wrote:
>>> @@ -4877,6 +4903,7 @@ static void _usage(FILE *dest)
>>>   "\n"
>>>   "   -K, --kill          forcibly close sockets, display what was 
>>> closed\n"
>>>   "   -H, --no-header     Suppress header line\n"
>>> +"   -O, --one-line      socket's data printed on a single line\n"
>>>   "\n"
>>>   "   -A, --query=QUERY, --socket=QUERY\n"
>>>   "       QUERY := 
>>> {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n" 
>>>
>>> @@ -5003,6 +5030,7 @@ static const struct option long_opts[] = {
>>>       { "kill", 0, 0, 'K' },
>>>       { "no-header", 0, 0, 'H' },
>>>       { "xdp", 0, 0, OPT_XDPSOCK},
>>> +    { "one-line", 0, 0, 'O' },
>>
>> shame 'o' can not be used for consistency with ip, but we can have both
>> use 'oneline' as the long option without the '-'.
>>
> 
> Yeah, thanks David. I saw that the other tools use --oneline, so I'll 
> send an update with that changed.
> 

Actually, David can you clarify what you meant by "use 'oneline' as the 
long option without the '-'."?

Thanks
Josh
