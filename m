Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64334183294
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgCLOOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:14:55 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgCLOOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:14:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CEAeqZ002776;
        Thu, 12 Mar 2020 14:14:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=ukYai0Szp9GbgbGil4JNjUKZcGVTXYPk+TiQREDrQQI=;
 b=ZE2YueL7kEDUoiyOZ7Yp7RhxSxIUXXNkgNPFtW0NnLgrMLhY7bic3Y0u90vHBtuwnRN7
 DA1MW47Q8uC9bl6DeZ/qJlvbm+kmdoFuaDQ1HLH2jdxz+6/x44dUDQ0AFKNYeHLQmUb5
 bnLRgvjECxK/3R6y3nBrFlGDeYao3oGWZ0D3N0iLDm0doZuqOtPOI3BSFNY10xGsz7AK
 nb8bt68BYyNmVbhus+CGDaXCFDKvJvAQA/wlS5NiVNk8EjpOjQUzYUz/U7OdvXrf9MQW
 5qsHTTdUN410j759b/FKy/LZeYRZtGAwYGWGP7G10sADpaLE3NhdWlRNDu6rSpra+/ZL ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31usttq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:14:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02CE85WW090900;
        Thu, 12 Mar 2020 14:14:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yqgvd117b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:14:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02CEEfQO031130;
        Thu, 12 Mar 2020 14:14:41 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Mar 2020 07:14:40 -0700
Date:   Thu, 12 Mar 2020 17:14:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 2/5] staging: wfx: fix lines ending with a comma instead
 of a semicolon
Message-ID: <20200312141435.GM11561@kadam>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
 <20200310101356.182818-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200310101356.182818-3-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9557 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:13:53AM +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Obviously introduced by mistake.
> 

I have a Smatch check for when people use a comma instead of semi-colon,
but I have never published it because it seems totally harmless.  I
can't think of a reason why we should use semi-colons instead of commas.

regards,
dan carpenter

