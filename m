Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035FD57A02D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiGSNzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237731AbiGSNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 09:55:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC1BA267;
        Tue, 19 Jul 2022 06:07:54 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JD6FPO032251;
        Tue, 19 Jul 2022 13:06:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1FnMB6ilUH8Q+XSiPaa6890QFe1JFfyJ6Mi4/MydGgQ=;
 b=Pg+xXRXvw7YxachkPjS7rOUIDudBevwYLBZkUZiDvKAlEPzOJiWrPk7ZU2z2k8U/V7Op
 a++n9gDy9GcO3x7q+7qdPm2T9CpoxDG17hoRe2+8nMVKd1M3lEBbS8W/tmVkgIInWCBv
 +bQeJg+T59B+dNzhBPuo0iSPdpI6P8TZ4R7Bt1uwTUgc/Hg2vG6dwuPUtblLgdrZkeXR
 4SiFU1Q/TIwl6mzN/5HEt4RPK6zJCVb8C+5vlDRiLy5lgDFWTSj9Gk28zUUWdNheOOyN
 Z73gUg19Yv0bS9xtwfEvJek01XVuwcYKuTEI6RViJLUFh/JG/s72D77XbCti1WJV8naZ yQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdw6u0180-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:06:38 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JD66Ep019218;
        Tue, 19 Jul 2022 13:06:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3hbmy8u5d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 13:06:33 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JD4kMu22282534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 13:04:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41AAD5204F;
        Tue, 19 Jul 2022 13:06:30 +0000 (GMT)
Received: from [9.152.224.219] (unknown [9.152.224.219])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E0BC35204E;
        Tue, 19 Jul 2022 13:06:29 +0000 (GMT)
Message-ID: <3dff8443-410b-60ce-033d-0a04c4628c7b@linux.ibm.com>
Date:   Tue, 19 Jul 2022 15:06:29 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] s390/net: Fix comment typo
Content-Language: en-US
To:     Jason Wang <wangborong@cdjrlc.com>, svens@linux.ibm.com
Cc:     wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
References: <20220716042700.39915-1-wangborong@cdjrlc.com>
From:   Alexandra Winter <wintera@linux.ibm.com>
In-Reply-To: <20220716042700.39915-1-wangborong@cdjrlc.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XqQ4vFzCuJUuuhxNhEjRwXaK2feckP7H
X-Proofpoint-ORIG-GUID: XqQ4vFzCuJUuuhxNhEjRwXaK2feckP7H
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 priorityscore=1501 clxscore=1011 phishscore=0 adultscore=0 spamscore=0
 impostorscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 16.07.22 06:27, Jason Wang wrote:
> The double `the' is duplicated in the comment, remove one.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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

The same patch was sent earlier by Jiang Jian <jiangjian@cdjrlc.com>:
https://lore.kernel.org/netdev/7a935730-f3a5-0b1f-2bdc-a629711a3a01@linux.ibm.com/t/

Same patch, but crisper description now by Jason Wang <wangborong@cdjrlc.com>
