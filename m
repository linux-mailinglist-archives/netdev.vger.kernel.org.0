Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D06450596
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhKONiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:38:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231995AbhKONgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:36:12 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFC0Veg000441;
        Mon, 15 Nov 2021 13:33:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Gz0c/FL/c6RRh3IZXFdLAN601aKHbe5dHn0gMf/X5xk=;
 b=YeAH5Tv8ixswkGuxc4i3ZMe/49PsXniMYnTGtetvHlsFISnKxUNaLm6pz3fI6AF7ItEl
 Q6mJklKYRgrt6Y9Ow9t/4pjkrivos+00zCnEETsp4BF8enb5RMU0mhhzrYpYBCCA83bh
 JFyA9eZN29h9Bf3LNQqF9efMJIEN6gzvcRLvUb0ZcNTIWmHkmCvJeLDYUlCmJDdRoVh6
 fUreztjtJefp6jmxJGj/Hz8v3waT9diIg5N7g5rVKb+O07eyliJnNTFTqOiRCezcMU1t
 FFn+fmlyf6YQcKcQ04Dq6OGtrR+84DKaPqrK1TWfCwPHUWya8Z/L7Jkxjv10H+ynkIZb eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbq671ry7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 13:33:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AFD0vim005966;
        Mon, 15 Nov 2021 13:33:15 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cbq671rxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 13:33:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AFDDgfd017670;
        Mon, 15 Nov 2021 13:33:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3ca50bw7r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Nov 2021 13:33:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AFDX91Z131804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 13:33:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7945B52069;
        Mon, 15 Nov 2021 13:33:09 +0000 (GMT)
Received: from [9.145.1.201] (unknown [9.145.1.201])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2463D52065;
        Mon, 15 Nov 2021 13:33:09 +0000 (GMT)
Message-ID: <58bb8ddf-f5d7-8797-e950-6f5674069953@linux.ibm.com>
Date:   Mon, 15 Nov 2021 14:33:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] net/smc: Make sure the link_id is unique
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
        tonylu@linux.alibaba.com, dust.li@linux.alibaba.com
References: <1636969507-39355-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1636969507-39355-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x5V7E5CluX1FHF5bKFekhgyu2yPCUvdS
X-Proofpoint-GUID: 2xnWB0VxUROmvav2VjrUV2YmnpeaR8kV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-15_10,2021-11-15_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111150073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/11/2021 10:45, Wen Gu wrote:
> The link_id is supposed to be unique, but smcr_next_link_id() doesn't
> skip the used link_id as expected. So the patch fixes this.
> 
> Fixes: 026c381fb477 ("net/smc: introduce link_idx for link group array")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> ---

Thank you.

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
