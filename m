Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 863D8FFC6
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfD3ScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:32:15 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:50240 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726006AbfD3ScP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 14:32:15 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UINYOF023041;
        Tue, 30 Apr 2019 19:32:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=qBCkeVqWktgre4RiuTK4eIH+L7nVU+c/r8laBBUon4E=;
 b=RTRZ0y6M7sc9xMkkTRdJ++Hop9d04lqVEfuTFC6qiktcagHSaijzetJu7qt/UGwng/Sd
 qBJOtJtzPGvGSYXEMNIgqkgcRoS/k0UId80rFG827xYMXsVlZX2bx7AbwN0vuDCkDpix
 lsWL2dU3xUhi7SuW8Q5/T6X7gDkFUtCEkfNDn0agjC/ispafd5arNM0ExXhVq1rIpWzw
 7VbXDuiQXVDQDBzAh9dE2aQbyrqdCKrEkfQB4qdEYJJXFEqOgoG2cEwagqVBWsjXlCoy
 mHluwPgWWWuh6/iurh+ujJgjvViycJhE3ajaIDyqGeZOaYEpayZWAd/jU6rh1N2mOo89 lQ== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2s6n789rc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Apr 2019 19:32:13 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x3UI2Y36031390;
        Tue, 30 Apr 2019 14:32:12 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2s4jdxgh0k-1;
        Tue, 30 Apr 2019 14:32:06 -0400
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id BEE69817F2;
        Tue, 30 Apr 2019 18:31:54 +0000 (GMT)
Subject: Re: [PATCH iproute2-next] ss: add option to print socket information
 on one line
To:     David Ahern <dsahern@gmail.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <1556227308-16057-1-git-send-email-johunt@akamai.com>
 <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <f1a1cd3b-8b85-3296-edd0-8106b7e28010@akamai.com>
Date:   Tue, 30 Apr 2019 11:31:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7f3e7f62-200c-fba3-96b1-f0682e763560@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300109
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/19 11:30 AM, David Ahern wrote:
> On 4/25/19 3:21 PM, Josh Hunt wrote:
>> @@ -4877,6 +4903,7 @@ static void _usage(FILE *dest)
>>   "\n"
>>   "   -K, --kill          forcibly close sockets, display what was closed\n"
>>   "   -H, --no-header     Suppress header line\n"
>> +"   -O, --one-line      socket's data printed on a single line\n"
>>   "\n"
>>   "   -A, --query=QUERY, --socket=QUERY\n"
>>   "       QUERY := {all|inet|tcp|udp|raw|unix|unix_dgram|unix_stream|unix_seqpacket|packet|netlink|vsock_stream|vsock_dgram|tipc}[,QUERY]\n"
>> @@ -5003,6 +5030,7 @@ static const struct option long_opts[] = {
>>   	{ "kill", 0, 0, 'K' },
>>   	{ "no-header", 0, 0, 'H' },
>>   	{ "xdp", 0, 0, OPT_XDPSOCK},
>> +	{ "one-line", 0, 0, 'O' },
> 
> shame 'o' can not be used for consistency with ip, but we can have both
> use 'oneline' as the long option without the '-'.
> 

Yeah, thanks David. I saw that the other tools use --oneline, so I'll 
send an update with that changed.

Josh
