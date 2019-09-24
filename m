Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA080BBF51
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 02:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391527AbfIXATF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 20:19:05 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbfIXATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 20:19:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O047WW193144;
        Tue, 24 Sep 2019 00:18:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=CYnernZqxWUzUsnsA+ryrZNCCZdIPViU9+VB3OeyCag=;
 b=egZhZal+XCur2Gx8ugLu5eQkb80AVHe/EFGCeaH3n5L4JUoBpU8u2+VXNPdDmu1c7d2n
 ZHvoo2G46k20tXpJSVbgbZ6pLeEzATdKYjZU5ZKfgqPS91dByk2kHkPeGl17wEAPRmjO
 8/klkfIV7JS33yTO5CT0zqwogc6CDoMdKW56Vh7RQfzCAGg8rdT7KJyebgdzDxXHSeD+
 uhBLH/UO12TqldyR7QitubAnT7tRJHmQxg1i9p6SK1+Gk+2+Zf/1FLP+CF/Vfh7n40Ms
 wzlHYHRrqBq/KrqlpgfVEESREhHKtEScPfMLz2VyAhADYsGV6fW72CzxUSJ7DKrkhQ+k cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2v5cgqt5qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 00:18:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8O093nm152425;
        Tue, 24 Sep 2019 00:18:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2v6yvhvg0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Sep 2019 00:18:53 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8O0IniH023008;
        Tue, 24 Sep 2019 00:18:49 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Sep 2019 17:18:48 -0700
Subject: Re: [PATCH 1/1] MAINTAINERS: add Yanjun to FORCEDETH maintainers list
To:     rain.1986.08.12@gmail.com, mchehab+samsung@kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org, robh@kernel.org,
        linus.walleij@linaro.org, nicolas.ferre@microchip.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20190923143746.4310-1-rain.1986.08.12@gmail.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <b227d9ea-d393-23f3-51c2-9de28678943f@oracle.com>
Date:   Tue, 24 Sep 2019 08:23:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190923143746.4310-1-rain.1986.08.12@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909230207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9389 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909230207
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/9/23 22:37, rain.1986.08.12@gmail.com wrote:
> From: Rain River <rain.1986.08.12@gmail.com>
>
> Yanjun has been spending quite a lot of time fixing bugs
> in FORCEDETH source code. I'd like to add Yanjun to maintainers
> list.
>
> Signed-off-by: Rain River <rain.1986.08.12@gmail.com>

Acked-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Thanks a lot.

Zhu Yanjun

> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a400af0501c9..336ad8fe8b60 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -643,6 +643,7 @@ F:	drivers/net/ethernet/alacritech/*
>   
>   FORCEDETH GIGABIT ETHERNET DRIVER
>   M:	Rain River <rain.1986.08.12@gmail.com>
> +M:	Zhu Yanjun <yanjun.zhu@oracle.com>
>   L:	netdev@vger.kernel.org
>   S:	Maintained
>   F:	drivers/net/ethernet/nvidia/*
