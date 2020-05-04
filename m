Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE9B1C399E
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgEDMmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:42:33 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgEDMmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:42:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044CXH8i187631;
        Mon, 4 May 2020 12:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=r49/CSfCJ88tOsE6nZzHYlKvSe3JWgqAyvk/JEZMKps=;
 b=mqBM97zHqFv2/QOultVW/XCx6A3v1kxQocwZ+qY0F2yFwW6WfUfyrOFA2RcdmcvX8Naf
 Fxm5kRk91OkV7H6BX8O3F4ig1kxQKi25Kaex4sCSiSZpgDFzTGc35Ausbmnvol1pkrRC
 RCR9QjCn+UNgz+kniroD3onWPVXbJTiRdKaQQRyl8eT/d54i2oxjDCCwns1ECiS5hqdf
 Y+usnwdTcAJcUGOi6Ih+8/DfGlcKAcQ2XHO6QxStQF6T8VqPyvu4+i3LMgsZutW8yCBf
 DfIXu6y2efAKR525WNySzlGJy1A0WlaBWjlbt70k0P2ISMeopI+OUyc5e1Wfzmic1/8u mA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 30s0tm6k3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 12:42:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044Canpj167723;
        Mon, 4 May 2020 12:40:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30sjdqfju1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 12:40:27 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044CeQfj007266;
        Mon, 4 May 2020 12:40:26 GMT
Received: from [10.191.203.202] (/10.191.203.202)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 05:40:26 -0700
Subject: Re: Net: [DSA]: dsa-loop kernel panic
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
 <20200501131035.GA128166@lunn.ch>
From:   Allen <allen.pais@oracle.com>
Message-ID: <dfc690c3-9bf3-cb55-fa4f-779934e24f46@oracle.com>
Date:   Mon, 4 May 2020 18:10:17 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20200501131035.GA128166@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 mlxlogscore=562 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9610 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=623 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040107
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,
> 
> Which suggests ops is NULL. The #64 also matches with
> 
>> [   50.688935] Unable to handle kernel read from unreadable memory at
>> virtual address 0000000000000040
> 
> How did dev->netdev_ops become NULL?
> 

Thanks. Yes, my debugging also led to this point but not further.
I am tracing the pointer in the call chain. Hoping to find
something.

- Allen
