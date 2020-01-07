Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFD5132B25
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 17:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgAGQcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 11:32:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgAGQcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 11:32:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007GTOjE080833;
        Tue, 7 Jan 2020 16:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=N9upsMAlLmvUTlzkavWx89kJXD4D8Kh3lf2UkOHuARQ=;
 b=jghIoYUKa4Tcd1/4KIHmlyRe4FKxZri6W8Bw5FCHWW2VAFwfpDlhHZ7tYfmxGmemKirS
 Jg7bo8ytoScK//fvs+27q1bV9xb9LVZxzPC1uTceWZuZj2dwavs/RMXyCGqTPpj6HWhL
 ORvN9Pl19WqGkgkcoxvbH8F5hN1WaZme6gKQTDSUIiOWXefzjhlwsAHLyKnm63r0mDIB
 RvYY5Pt5vpoMiGNe5B01P3YZBrlOdVhx3+YrW6iA5OmoAK5GjLnF3q9oXUJqmocBJF4N
 4mI8+FxdDdGdd15C5MNIFg7MiYRSoaPFePyos0nYtdIrZVK2VcrFRYT0SrQIL/auKxFH Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xajnpxncb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 16:32:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 007GTYRF081834;
        Tue, 7 Jan 2020 16:32:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xcjvdgt15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 16:32:17 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 007GWC8e031346;
        Tue, 7 Jan 2020 16:32:15 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jan 2020 08:32:11 -0800
Date:   Tue, 7 Jan 2020 19:32:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rose: remove redundant assignment to variable failed
Message-ID: <20200107163202.GD27042@kadam>
References: <20200107152415.106353-1-colin.king@canonical.com>
 <20200107161827.GO3911@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107161827.GO3911@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=963
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Never mind.  I misread what the code is doing.  Your patch is correct.
My patch would have been harmless but made the code even more confusing.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
