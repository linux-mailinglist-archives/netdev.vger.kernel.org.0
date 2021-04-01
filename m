Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA67F35195D
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhDARxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:53:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35396 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235634AbhDARtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:49:12 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 131DY5pf076011;
        Thu, 1 Apr 2021 09:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mg2lDEAe6gklpkKFAHaPTHh7cIMcXDrfVTsmQ1dH3Ck=;
 b=DgGS7NEGDNxFLRUDeaVKVkZjWdFVD9tvCVSmFBXwT81r8CjJ8mkXvw1gG0dL1VzhQ59X
 SQMCAM54yGMUP7dMiqXmNmQNsfr6skgjWv0Z/SiJ7KOfRhuVNTUD6hK6to363P6lvK29
 29xiOWfB4INW/mdqPRFlLR/Il29dWrzLLdJC5g4ihaMyVhQKTlrEa1B9dGqfkZWdFJ4o
 8Zbp5ihkla2khpba9uVjUUFw76r5M/IEx3XAsObqk7uKf4hM94cdOrV1LO34GzF4n0uj
 ZAHc5FWham0Ln9DIrZIPRlQkMS2jkE7yY6HwI3q1x0pdbUu4mIkhkO3NrxA/pkiFhQup dQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37n8r0cbdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 09:48:03 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 131DgKIC016839;
        Thu, 1 Apr 2021 13:48:00 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 37n28w89gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Apr 2021 13:48:00 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 131DlcGv36504056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Apr 2021 13:47:38 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 389A5A4060;
        Thu,  1 Apr 2021 13:47:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE39A4054;
        Thu,  1 Apr 2021 13:47:57 +0000 (GMT)
Received: from [9.171.31.36] (unknown [9.171.31.36])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Apr 2021 13:47:57 +0000 (GMT)
Subject: Re: [PATCH] net: smc: Remove repeated struct declaration
To:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
References: <20210401084030.1002882-1-wanjiabing@vivo.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <c46c4186-7d48-efa1-ec4f-03bcb1c7188e@linux.ibm.com>
Date:   Thu, 1 Apr 2021 15:47:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210401084030.1002882-1-wanjiabing@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FKexRfPIxGpEh_yaWuXYovGDO14eBo-o
X-Proofpoint-GUID: FKexRfPIxGpEh_yaWuXYovGDO14eBo-o
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-01_05:2021-03-31,2021-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 mlxlogscore=946 clxscore=1011 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103310000 definitions=main-2104010094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2021 10:40, Wan Jiabing wrote:
> struct smc_clc_msg_local is declared twice. One is declared at
> 301st line. The blew one is not needed. Remove the duplicate.
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  net/smc/smc_core.h | 1 -
>  1 file changed, 1 deletion(-)
> 

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
