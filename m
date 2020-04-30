Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A541BF442
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 11:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3Jiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 05:38:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgD3Jiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 05:38:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U9bRQo146223;
        Thu, 30 Apr 2020 09:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RUSYverzYQ9JpE4an/COyndDToRPSkdFo0Kb7DfKK5M=;
 b=VTfpLk/ImRHchhbFMQwxmtAvIW/DZ/csS2xqohj26xM6vGbUlbwdqyFRXe8DQ63xjRd2
 /sW/rIa4TSh5K8jgvObfjzCQiaOavVzYblqO0oVnY/NaIyAcIJ3269mMWADsTPJ1l2CQ
 ldPypm0+KzL1muqllpdjo8fglOZJWyHaauKaw2h5Pn8Xnf/OBjzew72VP7M5IQSJAyGV
 rxO5mRfF4bkRf0xRi66Qa4rUcC684K05OQfrxzECiEgUtDoBXXNd8qGyzfOAasXTbmmF
 sbhkjE8glkonCVC07G+8zgR26yPZZnHJbmdBlntwFQcTnUc3hog8kBcpsL/VgnZWPYKz yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p0fv67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 09:38:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U9bPJQ039878;
        Thu, 30 Apr 2020 09:38:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30qtjwptvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 09:38:46 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03U9chKc024033;
        Thu, 30 Apr 2020 09:38:43 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 02:38:42 -0700
Date:   Thu, 30 Apr 2020 12:38:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Rylan Dmello <mail@rylan.coffee>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 2/7] staging: qlge: Remove gotos from
 ql_set_mac_addr_reg
Message-ID: <20200430093835.GT2014@kadam>
References: <cover.1588209862.git.mail@rylan.coffee>
 <a6f485e43eb55e8fdc64a7a346cb0419b55c3cb6.1588209862.git.mail@rylan.coffee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6f485e43eb55e8fdc64a7a346cb0419b55c3cb6.1588209862.git.mail@rylan.coffee>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300078
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 09:33:04PM -0400, Rylan Dmello wrote:
> As suggested by Joe Perches, this patch removes the 'exit' label
> from the ql_set_mac_addr_reg function and replaces the goto
> statements with break statements.
> 
> Signed-off-by: Rylan Dmello <mail@rylan.coffee>
> ---
>  drivers/staging/qlge/qlge_main.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 29610618c7c0..f2b4a54fc4c0 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -336,22 +336,20 @@ static int ql_set_mac_addr_reg(struct ql_adapter *qdev, u8 *addr, u32 type,
>  
>  		status = ql_wait_reg_rdy(qdev, MAC_ADDR_IDX, MAC_ADDR_MW, 0);
>  		if (status)
> -			goto exit;
> +			break;

Just "return status".  A direct return is immediately clear but with a
break statement then you have to look down a bit and then scroll back.

regards,
dan carpenter

