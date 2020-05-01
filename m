Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD081C1C74
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgEASAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:00:23 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729599AbgEASAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 14:00:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041HlTf4035489;
        Fri, 1 May 2020 18:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=bvmy93u1P5ebiNBpEpIAfT14o9YjECSOvlejTEFsTrw=;
 b=S/M7ltWxI6Ipy+VVWZ1dHLCWvMNRu3CNoJOuDjNdKwN/WjteMcLzxjrMQaGzQPoUCm0X
 KTO74J7VnavTPCl+2ryYIaxdus5cJF7S5569sv0Df2pD5o51CAukrtNyavCUn8KkH88q
 BeFSX2S5vR9fGxeP6FNMunSos/b3kAXetHLyrIW2yym4FixYobWp5RIYQHFjCthSH3/Z
 l02/FqVTD6/TveIe9xE4zhgn8v/BAWhRT8DT5gW/UVqf6+5JlRxgMOG1WKK3ssaCQmNo
 0XWsp++lbz9gNVrjDxrym883gyNku60C8xUs9hta1ILHEBXX+eu2NlcS7P/L1pYtsnft Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30r7f83dpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 18:00:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041Hl0wk059279;
        Fri, 1 May 2020 17:58:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30r7fbe7yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 17:58:15 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 041HwC9G017207;
        Fri, 1 May 2020 17:58:12 GMT
Received: from [10.76.44.121] (/10.76.44.121)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 10:58:12 -0700
Subject: Re: Net: [DSA]: dsa-loop kernel panic
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
 <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
 <c998f49c-0119-7d8c-7cbc-ab8beadfa82d@oracle.com>
 <1ec3b421-dee5-e291-ac17-5d2f713b9aae@gmail.com>
From:   Allen <allen.pais@oracle.com>
Message-ID: <9a4912aa-3129-1774-5f21-2f6fb4afafb2@oracle.com>
Date:   Fri, 1 May 2020 23:28:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1ec3b421-dee5-e291-ac17-5d2f713b9aae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=801
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=866
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005010137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>
>>   It maps to "eth0". Please let me know if you need further details.
> 
> I suppose I should have been clearer, what network device driver created
> eth0?
> 

  This was seen on a VM.
eth0 [52:54:00:c1:cd:65]: virtio_net (up)

Thanks.
