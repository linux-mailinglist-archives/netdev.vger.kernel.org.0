Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB055317B
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbiFUL6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350269AbiFUL6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:58:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A368DFC7;
        Tue, 21 Jun 2022 04:58:11 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25LADi03032637;
        Tue, 21 Jun 2022 11:58:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ld8ONx1WoaWgPX/hqnxfo4AHapYxdwGCb8SdAeAAbkk=;
 b=K79IfWdNAvE7lzBL1Qh4nGlUP/iB5HoAW9VEAvxW064hjSvDZW37ye/YTUpetu1Xes3D
 EcQtRPfKCVd9lwBzQsrGShGP6Xwr+lRxc6dtCi4JMouoLImFNamALxGsLse6ciAROM80
 HcckcrP7It6UHi7DetzTsA4svc8c08GVO5dwX/nnHfnfMM59u8cMIvN8uMq7FjIl/Sg7
 0Bvvf7tR+6Nb2cLIFxsrwGR4KjYLwS5L7yVUcZqvG7ZfNqPdpXJ6nU8OZStjagMuw/+e
 Vm83aayaeVmsDeJUlvvkpuDRNpS2t2awMMqhcgXvTqQCoDyrFbb1KRkaApSv7Mo46Z5C QA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3guc202tjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 11:58:07 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25LBpEpG022601;
        Tue, 21 Jun 2022 11:58:04 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3gs6b933xf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jun 2022 11:58:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25LBw0Xi19923372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jun 2022 11:58:00 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7E78A404D;
        Tue, 21 Jun 2022 11:58:00 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85F02A4040;
        Tue, 21 Jun 2022 11:58:00 +0000 (GMT)
Received: from [9.152.224.195] (unknown [9.152.224.195])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jun 2022 11:58:00 +0000 (GMT)
Message-ID: <09b411b2-0e1f-26d5-c0ea-8ee6504bdcfd@linux.ibm.com>
Date:   Tue, 21 Jun 2022 13:58:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] net: s390: drop unexpected word "the" in the comments
Content-Language: en-US
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220621113740.103317-1-jiangjian@cdjrlc.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220621113740.103317-1-jiangjian@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 65iRLLqjKaKQYaC7OLXIcWFLbFDgQeU1
X-Proofpoint-GUID: 65iRLLqjKaKQYaC7OLXIcWFLbFDgQeU1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_04,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1011 bulkscore=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206210050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21.06.22 13:37, Jiang Jian wrote:
> there is an unexpected word "the" in the comments that need to be dropped
> 
> file: ./drivers/s390/net/qeth_core_main.c
> line: 3568
> 
> * have to request a PCI to be sure the the PCI
> changed to
> * have to request a PCI to be sure the PCI
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/s390/net/qeth_core_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 9e54fe76a9b2..35d4b398c197 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -3565,7 +3565,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
>  			if (!atomic_read(&queue->set_pci_flags_count)) {
>  				/*
>  				 * there's no outstanding PCI any more, so we
> -				 * have to request a PCI to be sure the the PCI
> +				 * have to request a PCI to be sure the PCI
>  				 * will wake at some time in the future then we
>  				 * can flush packed buffers that might still be
>  				 * hanging around, which can happen if no

Acked-by: Alexandra Winter <wintera@linux.ibm.com>
