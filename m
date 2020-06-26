Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9520AE73
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbgFZIev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:34:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48716 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgFZIev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:34:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05Q8S7xw134511;
        Fri, 26 Jun 2020 08:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=fjqGH22vN8tmHJC5Ez+rpYalehtYxTKAP/PTFFOVU+A=;
 b=QPuSTCPUBeUywJ4cdRVBcX4j4qAoWBQytlLuZdN8MuV+SPw1Pi89PDGBSLyyDKjhyR2m
 L82kVyC4OqKWbbN2mH97QSXn6bVN/zrkmZboSY4/2cRKkHljjfKkWr3zq9bDGGAGlURz
 PBokYIZZsnNwwLnsg7DqOOob7KkSmJPknzjAbTLpJivOdT26/sxOL2o+dGxTVxrTdlIe
 M7sxDkAy8hM6c52o5QOeAoPToT1B7eCWVjSg3NxxPukODuVkVCecOGTpBSeieBUuernO
 6ynvVrBtNdIAqal3L2QmAfCAdG1c138nJ28JSt7EL9fhrLWlclDFbbb9Y13wWVQoR4Cs GQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31uusu4ufe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 26 Jun 2020 08:34:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05Q8YKSl009278;
        Fri, 26 Jun 2020 08:34:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uurbp4bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Jun 2020 08:34:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05Q8YhU9017943;
        Fri, 26 Jun 2020 08:34:43 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 26 Jun 2020 08:34:43 +0000
Date:   Fri, 26 Jun 2020 11:34:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        open list <linux-kernel@vger.kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: qlge: fix else after return or break
Message-ID: <20200626083436.GG2549@kadam>
References: <20200625215755.70329-1-coiby.xu@gmail.com>
 <20200625215755.70329-3-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625215755.70329-3-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260062
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 cotscore=-2147483648 malwarescore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260061
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 05:57:55AM +0800, Coiby Xu wrote:
> @@ -1404,11 +1403,10 @@ static void ql_dump_cam_entries(struct ql_adapter *qdev)
>  			pr_err("%s: Failed read of mac index register\n",
>  			       __func__);
>  			return;
                        ^^^^^^
> -		} else {
> -			if (value[0])
> -				pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
> -				       qdev->ndev->name, i, value[1], value[0]);
>  		}
> +		if (value[0])
> +			pr_err("%s: MCAST index %d CAM Lookup Lower = 0x%.08x:%.08x\n",
> +			       qdev->ndev->name, i, value[1], value[0]);
>  	}
>  	ql_sem_unlock(qdev, SEM_MAC_ADDR_MASK);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  }
> @@ -1427,11 +1425,10 @@ void ql_dump_routing_entries(struct ql_adapter *qdev)
>  			pr_err("%s: Failed read of routing index register\n",
>  			       __func__);
>  			return;
                        ^^^^^^


> -		} else {
> -			if (value)
> -				pr_err("%s: Routing Mask %d = 0x%.08x\n",
> -				       qdev->ndev->name, i, value);
>  		}
> +		if (value)
> +			pr_err("%s: Routing Mask %d = 0x%.08x\n",
> +			       qdev->ndev->name, i, value);
>  	}
>  	ql_sem_unlock(qdev, SEM_RT_IDX_MASK);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  }

This is not caused by your patch, but in these two functions we return
without dropping the lock.  There may be other places as well, but these
are the two I can see without leaving my email client.

Do you think you could fix that before we forget?  Just change the
return to a break to fix the bug.

regards,
dan carpenter

