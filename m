Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91CE1C0E5A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 08:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728244AbgEAGtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 02:49:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45002 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgEAGtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 02:49:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0416mx22069403;
        Fri, 1 May 2020 06:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s5Q4LqmixkGLflc6S9ZSrKzt1vOUJ4v+X0mIG0m54jU=;
 b=V+PTkkrWjZUu75bJgR0u38dzu4Jtobq+huU3MM94DsW515X5567RdXDDkMNAqU3hChZx
 t0UKPb9sEPHpsh4r+oIZY5ZrwwxVXte+BgkRzsXvaqzX4lrg61bLv9MhjeIAUwdEG8PG
 Ry7F3cVupwvVdGZu352ffork9yzE4gsbBEWxOqyQtGjH3zq/ePtf9y+tYHN6LNn2bMtY
 b7VI+FEkHjozw/G6RnOQfMwRvyNBOD450ecdvV5Xq8osnmjYWMKib79rRDtzLi5eWedD
 63oJ6WEaxm1sJyqFU5Cw4HG2/041WoUhc4bkcYmiLFZbBAyeHKOOunw45qIE0e9d2Tg5 WA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3h1y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 06:49:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0416mJT6078750;
        Fri, 1 May 2020 06:49:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30rbr4hhru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 06:49:07 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0416n6u7017953;
        Fri, 1 May 2020 06:49:06 GMT
Received: from [10.191.212.135] (/10.191.212.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 23:49:06 -0700
Subject: Re: Net: [DSA]: dsa-loop kernel panic
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <9d7ac811-f3c9-ff13-5b81-259daa8c424f@oracle.com>
 <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
From:   Allen <allen.pais@oracle.com>
Message-ID: <c998f49c-0119-7d8c-7cbc-ab8beadfa82d@oracle.com>
Date:   Fri, 1 May 2020 12:18:57 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <dd42f431-d555-fcd2-b25e-50aeecbb513b@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=787 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=854 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010049
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> 
> you have missed an important detail here which is the master device that
> was used for DSA. The current code defaults to whatever "eth0" is, what
> does this map to for your configuration?
> 

  It maps to "eth0". Please let me know if you need further details.

- Allen
