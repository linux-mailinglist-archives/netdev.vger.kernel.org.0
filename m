Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9121D826
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgGMOSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 10:18:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60876 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 10:18:04 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DEGqCF152423;
        Mon, 13 Jul 2020 14:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=maqCkEZVuXvl4eey3+1aRgdidBQY0DgpE9fs4vTN6Y4=;
 b=BpU9sGhJjdTRXjhJEB3O+6RnniyVKO3cH9t+Zqle76yE1+O+aRQq1ZUAM9In5bUk7J2D
 fFfed3CizWho67yCwvs2y7KgKrK2TvJt7cUPzD1oNSkYDoy+QifRpgJvhCMFjgwNYnSB
 ZS5RcZMc6x3vTD78HPN9wRrWPK6KwaF4BkSNAYyS6Gc0ilBZX68jgpFg7ZLAsSu6+qie
 iZU20wrDLr+vmtsOZrZQZxcXAeV9jwNV3D57I+KT8HihC90118FyB6Avv/gLIHVn+tz2
 N6QEEQe5Mvt1pnh5pJGzUL7OzPsh6WR8g/Uc2HrolfCUupm6sKA8qXV+NYQJrsEi0pwm yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3275cky98b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 14:17:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06DECZxd129058;
        Mon, 13 Jul 2020 14:17:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 327qbvn8hg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jul 2020 14:17:58 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06DEHvxL010867;
        Mon, 13 Jul 2020 14:17:57 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 07:17:56 -0700
Date:   Mon, 13 Jul 2020 17:17:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Suraj Upadhyay <usuraj35@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: qlge: qlge_ethtool: Remove one byte memset.
Message-ID: <20200713141749.GU2549@kadam>
References: <cover.1594642213.git.usuraj35@gmail.com>
 <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5eb87576cef4bf1b968481d6341013e6c7e9650.1594642213.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9680 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007130108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 05:52:22PM +0530, Suraj Upadhyay wrote:
> Use direct assignment instead of using memset with just one byte as an
> argument.
> Issue found by checkpatch.pl.
> 
> Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
> ---
> Hii Maintainers,
> 	Please correct me if I am wrong here.
> ---
> 
>  drivers/staging/qlge/qlge_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_ethtool.c b/drivers/staging/qlge/qlge_ethtool.c
> index 16fcdefa9687..d44b2dae9213 100644
> --- a/drivers/staging/qlge/qlge_ethtool.c
> +++ b/drivers/staging/qlge/qlge_ethtool.c
> @@ -516,8 +516,8 @@ static void ql_create_lb_frame(struct sk_buff *skb,
>  	memset(skb->data, 0xFF, frame_size);
>  	frame_size &= ~1;
>  	memset(&skb->data[frame_size / 2], 0xAA, frame_size / 2 - 1);
> -	memset(&skb->data[frame_size / 2 + 10], 0xBE, 1);
> -	memset(&skb->data[frame_size / 2 + 12], 0xAF, 1);
> +	skb->data[frame_size / 2 + 10] = (unsigned char)0xBE;
> +	skb->data[frame_size / 2 + 12] = (unsigned char)0xAF;

Remove the casting.

I guess this is better than the original because now it looks like
ql_check_lb_frame().  It's still really weird looking though.

regards,
dan carpenter

