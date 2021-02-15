Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4048131B5DD
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 09:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBOIXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 03:23:47 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229597AbhBOIXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 03:23:46 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11F8IBNp091661;
        Mon, 15 Feb 2021 03:22:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ftWBf4xrcZXmLgkk1OigxHJKK8FpKulJG/DWEMa0+nQ=;
 b=SKmD4wvc964hEuXP0aVJQ/ywPbE9vXBYOuhRUpsel4crwoFIA5367ZBT773kucqtXoZf
 SjXJT5YEdesBOqh2EwX9/TS5mRqOrSH4SYO7Nr+59HvOll1/0Q06F91daMXSCBT1TTXL
 vPOZPRANwW1EtNKHYYgEaPdRwpijcD3fmqfgIpMXMgjvwyN/vHT6RCONJljLcFDPElx/
 va0gISEAZTSfLJQVgB17F/n4wIXrIVgzNSrSdZnNrfWT4q5/NC1sJBL6CDC2DMo1PyfJ
 o8y6bDy9MRe9ppzAn4Hj9jCNwKkdj2UwWSTjo6KHovkB8YZdnXDFzIkg6kRkYxqSaqxO 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qnaxg2v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 03:22:52 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11F8Jmxl098832;
        Mon, 15 Feb 2021 03:22:52 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36qnaxg2up-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 03:22:52 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11F8LMn5000828;
        Mon, 15 Feb 2021 08:22:50 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 36p6d89ma0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 08:22:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11F8Mmtc19398958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 08:22:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 408F54204B;
        Mon, 15 Feb 2021 08:22:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B39C942054;
        Mon, 15 Feb 2021 08:22:47 +0000 (GMT)
Received: from Alexandras-MBP.fritz.box (unknown [9.145.21.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Feb 2021 08:22:47 +0000 (GMT)
Subject: Re: [PATCH iproute2 5/6] man8/bridge.8: explain self vs master for
 "bridge fdb add"
To:     Vladimir Oltean <olteanv@gmail.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210211104502.2081443-1-olteanv@gmail.com>
 <20210211104502.2081443-6-olteanv@gmail.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
Message-ID: <65b9d8b6-0b04-9ddc-1719-b3417cd6fb89@linux.ibm.com>
Date:   Mon, 15 Feb 2021 09:22:47 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210211104502.2081443-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-15_02:2021-02-12,2021-02-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 adultscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150064
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you very much Vladimir for improving this man page. I am still struggling with the meaning of the bridge attributes and sometimes
the man page has caused more confusion.

In the section about 'bridge link set' Self vs master mention physical device vs software bridge. Would it make sense to use the same
terminology here?

The attributes are listed under 'bridge fdb add' not under 'bridge fdb show'. Is it correct that the attributes displayed by 'show'
are a 1-to-1 representation of the ones set by 'add'? What about the entries that are not manually set, like bridge learned adresses?
Is it possible to add some explanation about those as well?

On 11.02.21 11:45, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The "usually hardware" and "usually software" distinctions make no
> sense, try to clarify what these do based on the actual kernel behavior.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  man/man8/bridge.8 | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
> index 1dc0aec83f09..d0bcd708bb61 100644
> --- a/man/man8/bridge.8
> +++ b/man/man8/bridge.8
> @@ -533,12 +533,21 @@ specified.
>  .sp
>  
>  .B self
> -- the address is associated with the port drivers fdb. Usually hardware
> -  (default).
> +- the operation is fulfilled directly by the driver for the specified network
> +device. If the network device belongs to a master like a bridge, then the
> +bridge is bypassed and not notified of this operation (and if the device does
> +notify the bridge, it is driver-specific behavior and not mandated by this
> +flag, check the driver for more details). The "bridge fdb add" command can also
> +be used on the bridge device itself, and in this case, the added fdb entries
> +will be locally terminated (not forwarded). In the latter case, the "self" flag
> +is mandatory. 
Maybe I misunderstand this sentence, but I can do a 'bridge fdb add' without 'self'
on the bridge device. And the address shows up under 'bridge fdb show'.
So what does mandatory mean here?
The flag is set by default if "master" is not specified.
>  .sp
>  
>  .B master
> -- the address is associated with master devices fdb. Usually software.
> +- if the specified network device is a port that belongs to a master device
> +such as a bridge, the operation is fulfilled by the master device's driver,
> +which may in turn notify the port driver too of the address. If the specified
> +device is a master itself, such as a bridge, this flag is invalid.
>  .sp
>  
>  .B router
> 
