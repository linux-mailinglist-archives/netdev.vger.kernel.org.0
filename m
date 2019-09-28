Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A1C10AF
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 13:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfI1LVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 07:21:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfI1LVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 07:21:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8SBJGZO106410;
        Sat, 28 Sep 2019 11:20:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=JvfgdC2hgYiOD08GKxZBdYNRMJRQteJ88B9j1u0YadE=;
 b=b+THG9ZTlAfZHCK9JYcFohpfL5Ai7zgX2r5bcIJ3yIb6I/bo3cOvKEZxwRUjPdbQdJx1
 jW0qvgEIC1GAci4qw268FFusyBrsq1t514YeiKsC230w1gYngw7erbo+F7oVP2hMyOQ5
 1bneZw9C7h/ER7eZYoFpGM8+foCxo6soz+OwzDdcMMLp2/xUBcwKz95l63iRWljjtQkO
 t9/Ivc+Adcz6Td2P3JamJvU6SbqDKcmc0LXyMSjWpcxzzTMfetnCA7PPUHw6Yp2OlBXP
 XGmuNeEOQO7yxiJUtw56A8i2lquL8YvPUntJ5e9euypcEDK4i1Aow0Co1dfvpBvVLeWk qQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2va05r8nhe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Sep 2019 11:20:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8SBJDmG145002;
        Sat, 28 Sep 2019 11:20:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2v9vnjagjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Sep 2019 11:20:47 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8SBKi1T012863;
        Sat, 28 Sep 2019 11:20:44 GMT
Received: from dhcp-10-175-218-65.vpn.oracle.com (/10.175.218.65)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 28 Sep 2019 04:20:44 -0700
Date:   Sat, 28 Sep 2019 12:20:36 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-218-65.vpn.oracle.com
To:     Andrii Nakryiko <andriin@fb.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf] libbpf: count present CPUs, not theoretically
 possible
In-Reply-To: <20190928063033.1674094-1-andriin@fb.com>
Message-ID: <alpine.LRH.2.20.1909281202530.5332@dhcp-10-175-218-65.vpn.oracle.com>
References: <20190928063033.1674094-1-andriin@fb.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909280119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9393 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909280119
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Sep 2019, Andrii Nakryiko wrote:

> This patch switches libbpf_num_possible_cpus() from using possible CPU
> set to present CPU set. This fixes issues with incorrect auto-sizing of
> PERF_EVENT_ARRAY map on HOTPLUG-enabled systems.
> 
> On HOTPLUG enabled systems, /sys/devices/system/cpu/possible is going to
> be a set of any representable (i.e., potentially possible) CPU, which is
> normally way higher than real amount of CPUs (e.g., 0-127 on VM I've
> tested on, while there were just two CPU cores actually present).
> /sys/devices/system/cpu/present, on the other hand, will only contain
> CPUs that are physically present in the system (even if not online yet),
> which is what we really want, especially when creating per-CPU maps or
> perf events.
> 
> On systems with HOTPLUG disabled, present and possible are identical, so
> there is no change of behavior there.
> 

Just curious - is there a reason for not adding a new libbpf_num_present_cpus() 
function to cover this  case, and switching to using that in various places?

Looking at the places libbpf_num_possible_cpus() is called in libbpf 

- __perf_buffer__new(): this could just change to use the number of  
  present CPUs, since perf_buffer__new_raw() with a cpu_cnt in struct 
  perf_buffer_raw_ops

- bpf_object__create_maps(), which is called via bpf_oject__load_xattr().
  In this case it seems like switching to num present makes sense, though
  it might make sense to add a field to struct bpf_object_load_attr * to
  allow users to explicitly set another max value.

This would give the desired default behaviour, while still giving users 
a way of specifying the possible number. What do you think? Thanks!

Alan

> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index e0276520171b..45351c074e45 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -5899,7 +5899,7 @@ void bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear)
>  
>  int libbpf_num_possible_cpus(void)
>  {
> -	static const char *fcpu = "/sys/devices/system/cpu/possible";
> +	static const char *fcpu = "/sys/devices/system/cpu/present";
>  	int len = 0, n = 0, il = 0, ir = 0;
>  	unsigned int start = 0, end = 0;
>  	int tmp_cpus = 0;
> -- 
> 2.17.1
> 
> 
