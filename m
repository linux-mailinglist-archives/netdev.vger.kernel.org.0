Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF331F506
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 07:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBSGLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 01:11:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229577AbhBSGLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 01:11:02 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11J6210u137912;
        Fri, 19 Feb 2021 01:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zd/kgD0MonS9u+uh68ExuVJUSUYohIMQzO1ngQ4FTeE=;
 b=cZ1MKjC+jlrsUjkaHWqjJf/orhJXUIlPL9Xk7dG2cdEFj5fxE2BcrplygujE8UYUE4qP
 fO1GqSi5x7abLHDrFnpj5vXytgh1gnOXzN9NkHAVL7RzF4KmvIeacVxkDixdmkvrJw+o
 IiOGuxNNI7e1WLoN55P2kBdum+nya9kPZSPvUp/TQQzQclhlmEAe4NIxxnD+JWsUL4XM
 mZ74kpXw2E4xVoRkoIw2b9rdr+qyR3jfGhIhhFI9O1siJlLkC3BTWiHiujzoTlfHeU+v
 9LRgv5cSqPP4+KvkjXN5bdYrjv0mZQn4E2ikL1TatpwV0HkaL1KU/RGGGBsW8GHBOfoT eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36t7g98erh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 01:08:58 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11J62Thl139912;
        Fri, 19 Feb 2021 01:08:58 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36t7g98er6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 01:08:58 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11J679JD010793;
        Fri, 19 Feb 2021 06:08:57 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 36p6da69qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Feb 2021 06:08:57 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11J68tYc25952678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Feb 2021 06:08:55 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBA6E6A04F;
        Fri, 19 Feb 2021 06:08:55 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 868E46A047;
        Fri, 19 Feb 2021 06:08:49 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.102.3.199])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Feb 2021 06:08:49 +0000 (GMT)
Subject: Re: [PATCH] perf machine: Use true and false for bool variable
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        peterz@infradead.org
Cc:     mingo@redhat.com, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <1613640279-56480-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   kajoljain <kjain@linux.ibm.com>
Message-ID: <eaa5c985-f808-7215-266d-a43f9104b147@linux.ibm.com>
Date:   Fri, 19 Feb 2021 11:38:47 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1613640279-56480-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-19_01:2021-02-18,2021-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102190042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/18/21 2:54 PM, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./tools/perf/util/machine.c:2000:9-10: WARNING: return of 0/1 in
> function 'symbol__match_regex' with return type bool.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  tools/perf/util/machine.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 1e9d3f9..f7ee29b 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1997,8 +1997,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
>  static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
>  {
>  	if (!regexec(regex, sym->name, 0, NULL, 0))
> -		return 1;
> -	return 0;
> +		return true;
> +	return false;
>  }
>  

Hi Jiapeng,
   Just a suggestion, Can we make this check in single line like this:

static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
{
	return regexec(regex, sym->name, 0, NULL, 0) == 0;
}

Thanks,
Kajol Jain

>  static void ip__resolve_ams(struct thread *thread,
> 
