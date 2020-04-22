Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4251B3B73
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 11:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgDVJeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 05:34:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVJeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 05:34:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M9IX1p021651;
        Wed, 22 Apr 2020 09:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=VrW0SlucwGVpYtW5sBjiy8D6cWqoWtrecyVysdPVPfc=;
 b=Qiniz0pQM5d+f+eZyV8ra2XvsnEmEFwSnsxMQJIh46V64XuHy5JSMXQKzsP2yxK4l5TY
 gaZeC18nBJDc28EkbzzumHE0M3BtYEqlolnTFSiTH06M7txVqsN7RhgXQzwNuu6Nh68f
 TPbO+jcWK4i57lnreoEHPG22+Mjw2PnWV9f7hOjqSTE85SDTa6MXQH1kO4BsMpO1KZ6B
 1bsd8R+9nMOYGEXEoapjVJEzgK3ONwh0HRM2ZxTz2l2vF9XlvkN66aY0MG90wxaTLsVb
 87fbRyKb9XwwHd+LusSInDIJA000Za0NUQebrQAhk5bC67JsWS21J+NWk2CaY7wUwgRL Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30fsgm1q8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:33:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M9XT8F167083;
        Wed, 22 Apr 2020 09:33:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30gb9275m8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:33:40 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M9Xcc1012562;
        Wed, 22 Apr 2020 09:33:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 02:33:38 -0700
Date:   Wed, 22 Apr 2020 12:33:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] bpf: Change error code when ops is NULL
Message-ID: <20200422093329.GI2659@kadam>
References: <20200422083010.28000-1-maowenan@huawei.com>
 <20200422083010.28000-2-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083010.28000-2-maowenan@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 04:30:09PM +0800, Mao Wenan wrote:
> There is one error printed when use type
> BPF_MAP_TYPE_SOCKMAP to create map:
> libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)
> 
> This is because CONFIG_BPF_STREAM_PARSER is not set, and
> bpf_map_types[type] return invalid ops. It is not clear
> to show the cause of config missing with return code -EINVAL,
> so add pr_warn() and change error code to describe the reason.

Since you're going to have to redo the commit any way, maybe you should
put the line breaks at 72 characters.  I think you're using 65 character
line breaks, but that's only for the Subject.

> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  kernel/bpf/syscall.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d85f37239540..f67bc063bf75 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -112,9 +112,11 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>  		return ERR_PTR(-EINVAL);
>  	type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
>  	ops = bpf_map_types[type];
> -	if (!ops)
> -		return ERR_PTR(-EINVAL);
> -
> +	if (!ops) {
> +		pr_warn("map type %d not supported or
> +			 kernel config not opened\n", type);

This pr_warn() will be badly formatted in dmesg because of the new line
and the tabs.  I tried to add a checkpatch.pl warning for this but maybe
it only works with -f?...

regards,
dan carpenter

