Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564E11C31FC
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 06:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbgEDEzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 00:55:31 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgEDEzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 00:55:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0444t1b6164944;
        Mon, 4 May 2020 04:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eqc1g0RHD8NajFbSbeM3ITNHQefj4Xkc2Q5/lenbumc=;
 b=msEduOPzOZN+xiGenLo/sQweyoIHZ/vpQ6ShR4alfM2EemyXBvuncJfWuz2AlwtUifFO
 8OlYSFDp0fKkVr/+INumuU3kVrvyaTC18yDQF2hT6LoBtmWOS2h953BcBxOkEBOcg/Jh
 0w8eXFmaGuU2URgqGXdADYE7r1jSLKWilWDlCRIA6ahm9zf2xqHQpz/5T7kBhv7ULTXH
 HAaQVoymBjgpa350T4V7UH0zamrU18ABpDh3O46mGbdXKmAyCXaFJaRhbMq6ct5rl1dd
 cAxwYbkWu3i52fzAFdPr6EyxUSYGB+m7Ki9Y4EpOkc8vIfboMGMyCP3kJGzuoDmEf2Ro 9g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30s09qvqer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 04:55:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0444fXic014245;
        Mon, 4 May 2020 04:55:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30t1r17q8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 04:55:23 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0444tMiM015764;
        Mon, 4 May 2020 04:55:22 GMT
Received: from [192.168.0.106] (/49.207.49.247)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 May 2020 21:55:21 -0700
Subject: Re: Net: [DSA]: dsa-loop kernel panic
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
 <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
 <c998f49c-0119-7d8c-7cbc-ab8beadfa82d@oracle.com>
 <1ec3b421-dee5-e291-ac17-5d2f713b9aae@gmail.com>
 <9a4912aa-3129-1774-5f21-2f6fb4afafb2@oracle.com>
 <a15245fb-a9a4-4bcd-8459-fe3cbcc03119@gmail.com>
 <82bc0bdf-e4f6-2b85-d2ad-54632b287a60@gmail.com>
From:   Allen <allen.pais@oracle.com>
Message-ID: <702a2379-b6b2-1ec6-685f-a1861f42e40d@oracle.com>
Date:   Mon, 4 May 2020 10:25:17 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <82bc0bdf-e4f6-2b85-d2ad-54632b287a60@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxlogscore=747 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=793 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040041
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> There is a DSA master reference counting issue, but with dsa-loop, the
> DSA master is already properly reference counted thanks to the
> dev_get_by_name() call, I will keep digging.
> 

Thank you Florain.

I am not dsa expert, am debugging the call chain.

- Allen
