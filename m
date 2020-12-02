Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09CA32CC2C4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgLBQvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:51:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726332AbgLBQvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:51:04 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GcWwK151236;
        Wed, 2 Dec 2020 11:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ph0Nno5q9gyWL84r6/HiHu41Ox5RJpXG079ODYE8+7A=;
 b=hq2J4j8qaIAfDbw6mfLR7sG+yNKHbRzxLaEpsrEfxZ7IJlx1U/VKmhmyU36/vhmsm5Dx
 fs8gYeVCzuJFjSYkR0FTJGim62TPgh3c6I8Z6koAuFdR97q05SEzlgkAP73XABMrc4Do
 sxi0KbKeKXev9R6EBlAll0eKjIKPkhGy4v1Ityf1lLuVHAY9cjW2nHpzfUEYlKwWaPiQ
 fI7M+mabQeCc++pfBJnVHVb+o+Iie6ISYGLH3u+UUOlSzAULKyLBifF6Izey/mcWKYKH
 QeyzIknT7qwOpRJSSof4vhoWVSZ2v4QDbGacVCK3jpXqrgSgDOeW244wFpjzMtJA3q66 KA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 356741gdqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:50:18 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GlcTW019458;
        Wed, 2 Dec 2020 16:50:15 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 353dtha9rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 16:50:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B2GoDBv8454798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Dec 2020 16:50:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39F6942045;
        Wed,  2 Dec 2020 16:50:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADE624203F;
        Wed,  2 Dec 2020 16:50:12 +0000 (GMT)
Received: from [9.145.10.111] (unknown [9.145.10.111])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  2 Dec 2020 16:50:12 +0000 (GMT)
Subject: Re: [PATCH] net: 8021q: use netdev_info() instead of pr_info()
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <20201202124515.24110-1-info@metux.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <8e0a5d86-6293-d4f1-0669-a9077f863da9@linux.ibm.com>
Date:   Wed, 2 Dec 2020 18:50:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201202124515.24110-1-info@metux.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.12.20 14:45, Enrico Weigelt, metux IT consult wrote:
> Use netdev_info() instead of pr_info() for more consistent log output.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  net/8021q/vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index f292e0267bb9..d3a6f4ffdaef 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -132,7 +132,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
>  	const char *name = real_dev->name;
>  
>  	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
> -		pr_info("VLANs not supported on %s\n", name);
> +		netdev_info(real_dev, "VLANs not supported on %s\n", name);

Could you please also remove the real_dev->name string here?
netdev_info() should insert it automatically. Same below.

>  		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
>  		return -EOPNOTSUPP;
>  	}
> @@ -385,7 +385,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>  
>  	if ((event == NETDEV_UP) &&
>  	    (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)) {
> -		pr_info("adding VLAN 0 to HW filter on device %s\n",
> +		netdev_info(dev, "adding VLAN 0 to HW filter on device %s\n",
>  			dev->name);
>  		vlan_vid_add(dev, htons(ETH_P_8021Q), 0);
>  	}
> 

