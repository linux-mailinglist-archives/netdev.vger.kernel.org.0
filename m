Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225CB336DA3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 09:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhCKITV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 03:19:21 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230526AbhCKITD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 03:19:03 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12B85AIM181152;
        Thu, 11 Mar 2021 03:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Svjjfu6/Asgt3ngfd3jksUIX6H62v7zQz9Fj3zBsRTs=;
 b=oe1doOtj8tBau6DGp/fFO3kynQp0x8ZuezTPEl3sy6vPwsBYlwiWr/G87n/IqiRMj765
 Lxa1bRhuxFyX5xdjSTK4iEX0xJIpFbqPGzvNuSEvrLD6wColNUgrowkRubGSRMfQIacI
 WiXeOYxjcbtPkQCSdQ5mlweQZvlnR3LxfOUmdK4o2PF1zbxPpra+Wbe3b+rst56wL27Q
 cSVptzjuHlWw2OYEhsDCdILt2hysEYkWH+I95pted9FHOHcyEkzWdCVoCf22S29omb7f
 nDKQ9Lma37XZekXqLq4PWaqvE1DqsrruwNKnB7bojBSkO13yE4RjuR4Abohyger6wJmA mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m3fcs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:18:38 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12B85JRs182196;
        Thu, 11 Mar 2021 03:18:37 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774m3fcrb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 03:18:37 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12B8CTbM016108;
        Thu, 11 Mar 2021 08:18:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3768kx6bes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Mar 2021 08:18:36 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12B8IYAM12386706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Mar 2021 08:18:35 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB0E13604F;
        Thu, 11 Mar 2021 08:18:34 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 632F8136051;
        Thu, 11 Mar 2021 08:18:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.199.44.141])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 11 Mar 2021 08:18:27 +0000 (GMT)
Subject: Re: [PATCH] perf tools: Remove redundant code
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <1615346305-16428-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <36853ff4-70f0-a28b-7114-2423d7c11fad@linux.ibm.com>
Date:   Thu, 11 Mar 2021 13:48:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1615346305-16428-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-11_02:2021-03-10,2021-03-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103110044
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/21 8:48 AM, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/perf/util/evlist.c:1315:5-8: Unneeded variable: "err". Return "-
> ENOMEM" on line 1340.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/perf/util/evlist.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 882cd1f..6c2a271 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1313,7 +1313,6 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
>  {
>  	struct perf_cpu_map *cpus;
>  	struct perf_thread_map *threads;
> -	int err = -ENOMEM;
>  
>  	/*
>  	 * Try reading /sys/devices/system/cpu/online to get
> @@ -1338,7 +1337,7 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
>  out_put:
>  	perf_cpu_map__put(cpus);
>  out:
> -	return err;
> +	return -ENOMEM;
>  }

Seems fine to me.

Reviewed-By: Kajol Jain<kjain@linux.ibm.com>
Thanks,
Kajol Jain
>  
>  int evlist__open(struct evlist *evlist)
> 
