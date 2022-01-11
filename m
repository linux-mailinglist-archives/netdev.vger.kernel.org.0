Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDCE48A9B0
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 09:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbiAKIkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 03:40:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234862AbiAKIkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 03:40:18 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20B7hRHh015671;
        Tue, 11 Jan 2022 08:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F5o21lG1EhU7AfqluRD+lFYgrCMmSIg8645QJeODBo8=;
 b=n9LE5e7cvc4jzIqYAvBAnpUwp7dl+eSne6sPKFzckzZw8vVDksnuvyixp2M4yWaYi/RA
 D1ixOoW+jQIEgaYPXn9D2iht+w7GQmRsDjQOuRloLK9nLeR6cn7lkBRpKxunsZg9NeTa
 mf0n52hjmpXXPd3X9F/izjXhwXIId4EhpeeQYqbveTCgSM4xCnJ4S0k640hHZWB64VqN
 VaiuV0G3pyAFiibivSKN72RLNI/+PsPtBaQYlbHEsi/6OXUU96lNbLJziO50jdexn9Ar
 7mI64p1t4zRuqRuFAh2MBmFjNy8IcD20e8CXuh3lVmBACyjb6JFCK3cuEEqk9/99mUQd EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh5rp94ux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:40:08 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20B7mWUI029985;
        Tue, 11 Jan 2022 08:40:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dh5rp94ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:40:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20B8bwaZ009048;
        Tue, 11 Jan 2022 08:40:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3df289u89n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 08:40:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20B8e3wd41288092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 08:40:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BA9C4C062;
        Tue, 11 Jan 2022 08:40:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 365D54C04A;
        Tue, 11 Jan 2022 08:40:03 +0000 (GMT)
Received: from [9.145.30.70] (unknown [9.145.30.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 08:40:03 +0000 (GMT)
Message-ID: <8f13aa62-6360-8038-3041-86fd51b40a3e@linux.ibm.com>
Date:   Tue, 11 Jan 2022 09:40:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 3/3] net/smc: Resolve the race between SMC-R link
 access and clear
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641806784-93141-4-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NXEx7vB3J0fDkHsJfkpbQ9vQ6QwtIsh8
X-Proofpoint-GUID: txm97WcY5lQDdZP_ZS2oA1DJ7DeY2gqH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_03,2022-01-10_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2022 10:26, Wen Gu wrote:
> @@ -1226,15 +1245,23 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>  	smc_wr_free_link(lnk);
>  	smc_ib_destroy_queue_pair(lnk);
>  	smc_ib_dealloc_protection_domain(lnk);
> -	smc_wr_free_link_mem(lnk);
> -	smc_lgr_put(lnk->lgr); /* lgr_hold in smcr_link_init() */
>  	smc_ibdev_cnt_dec(lnk);
>  	put_device(&lnk->smcibdev->ibdev->dev);
>  	smcibdev = lnk->smcibdev;
> -	memset(lnk, 0, sizeof(struct smc_link));
> -	lnk->state = SMC_LNK_UNUSED;
>  	if (!atomic_dec_return(&smcibdev->lnk_cnt))
>  		wake_up(&smcibdev->lnks_deleted);

Same here, waiter should not be woken up until the link memory is actually freed.

> +	smcr_link_put(lnk); /* theoretically last link_put */
> +}
> +
> +void smcr_link_hold(struct smc_link *lnk)
> +{
> +	refcount_inc(&lnk->refcnt);
> +}
> +
> +void smcr_link_put(struct smc_link *lnk)
> +{
> +	if (refcount_dec_and_test(&lnk->refcnt))
> +		__smcr_link_clear(lnk);
>  }
