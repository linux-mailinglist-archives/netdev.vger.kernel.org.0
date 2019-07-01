Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0F45C431
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfGAUQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:16:02 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55250 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfGAUQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:16:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KDdV0058236;
        Mon, 1 Jul 2019 20:16:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rfZIDI+U981e5eJLnXp1HUInqDVSkDrU3lN+03kDQx8=;
 b=BWLtBpgUc11TmxCVklHJxiUtfOjZMSvNH776dXXsjUhKebMyoIAP+Fd3HSP/VgJ919D0
 6J8zMKjlzhGGQeXz5H66Y1IJZhItboo6oGSpQp/oEjpR5z1r2KuYHBrDjcZ3L8aVZIMD
 rQBatKxBg+0++ihm8y8dX8tv5PRcLpHFG5sEDQiTHxKCV/2i3LMJizgn8ZkL7oLaKXd2
 qIvdDfwutITDreww2qCp0bIKlSS3218uW17SvnOC45KKSjjlUnlCBNPcvOqgHGfYsmn+
 S12PXNWbC0L7Vtlq8kpP57Ps5WqLkQ0WdimKKrbT4hGxH2G3XPurmnom7Yjyk06iNUoD Vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2te5tbfrjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:15:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KD2oQ056586;
        Mon, 1 Jul 2019 20:15:59 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tebqg4fxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:15:59 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x61KFwP8026348;
        Mon, 1 Jul 2019 20:15:58 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:15:58 -0700
Subject: Re: [PATCH net-next 7/7] net/rds: Initialize ic->i_fastreg_wrs upon
 allocation
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <a97a92d4-c443-12e1-6d82-1646f9584828@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <f8cc7d1c-467e-01a7-8765-58093933b67b@oracle.com>
Date:   Mon, 1 Jul 2019 13:15:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <a97a92d4-c443-12e1-6d82-1646f9584828@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=923
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=979 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010234
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:40 AM, Gerd Rausch wrote:
> Otherwise, if an IB connection is torn down before "rds_ib_setup_qp"
> is called, the value of "ic->i_fastreg_wrs" is still at zero
> (as it wasn't initialized by "rds_ib_setup_qp").
> Consequently "rds_ib_conn_path_shutdown" will spin forever,
> waiting for it to go back to "RDS_IB_DEFAULT_FR_WR",
> which of course will never happen as there are no
> outstanding work requests.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
Looks good to me. Will add this to other fixes.

