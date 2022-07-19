Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C0E57A65E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiGSSVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiGSSU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:20:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1882528A;
        Tue, 19 Jul 2022 11:20:58 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JHlmxg029443;
        Tue, 19 Jul 2022 18:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=s1JPuA/YLMDabKTF1a2XheDVwFqVMwe5u3bKX+eeqpM=;
 b=sfF5wnj/5BXN2gbMTLi5cKEQJ2kykt81eX4Huwv4lJIgRxNxTo4zc15XqXStGs0PiQhu
 F7Eimnqu3KbP3crDvsmEOgXlkB3vUFNb04xf7OA7aclYh9+bHaw1ruITfePcTTkjJnb4
 N2QFZJ/Uy0zsfPWxeS/dcRj+bNBZ2Z+xi+V8zI5ajrb2guNvz+hP6hPkx1RSiX5/QnQQ
 pv01yekVfCAIRjVH8K56kHwIfG0Aod7RGCigI30XUb9xbZq3ZFS3ap2AQbWQBdi15efQ
 BY99WdOTk92UsxjdlEfUF8R76uZDowlrgjg5HacR864A3K+2PoeBKqvISafeX+DStOeZ vg== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3he1auhf3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 18:20:53 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26JIKp7v003747;
        Tue, 19 Jul 2022 18:20:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3hbmy8vksu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 18:20:51 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26JIKmJJ8913240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 18:20:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27B33A4060;
        Tue, 19 Jul 2022 18:20:48 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9068EA4054;
        Tue, 19 Jul 2022 18:20:47 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.145.22.197])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 19 Jul 2022 18:20:47 +0000 (GMT)
Date:   Tue, 19 Jul 2022 20:20:46 +0200
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     svens@linux.ibm.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/net: Fix comment typo
Message-ID: <Ytb1/uU+jlcI4jXw@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20220716042700.39915-1-wangborong@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716042700.39915-1-wangborong@cdjrlc.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HQ7BCeZRGyF4N8Cfb9uMYtvJvHRQHzRN
X-Proofpoint-ORIG-GUID: HQ7BCeZRGyF4N8Cfb9uMYtvJvHRQHzRN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_06,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 adultscore=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 12:27:00PM +0800, Jason Wang wrote:
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

Applied, thanks!
