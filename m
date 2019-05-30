Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9022EA5A
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 03:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfE3Bsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 21:48:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfE3Bsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 21:48:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4U1mXDx176100;
        Thu, 30 May 2019 01:48:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=6Ot5XwHr/WRbcR2FigO50oXiEg8U3sm898wX+53L4kE=;
 b=RF95p61dl0ev6qKu2zPPOovnDu56XL+K2QsZx01IIQnLfJ9o+kEaxWMA1BX9rT/2RrxL
 KgGsVXEvvTNCStSWt2gnrm570Mda+z6KU3ELtcy0v7nO5awb+F3cXtEz55cqhD8QNc1T
 lJFmdoaZVVG3U/udMzo1eVFWfwP9iSdufqfIWqdFqjs/C7frV2ZEUdJiQqcBJGuZT3hJ
 fE5uPafq4F1U+7ipbj8R8PASyVN0OjJiWh2WLv7G0xi7W+1zYtn8I6yGjie60b3S8SCj
 OnYbfPVSUmx4wbYV9fmf+uLVonAKEPptb8qe5hAY0ANqyFXV/RzsUdLXE8Bb4B/AbYjN jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2spxbqd5em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 01:48:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4U1ld5a095478;
        Thu, 30 May 2019 01:48:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2ss1fnsu3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 01:48:33 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4U1mUpE023531;
        Thu, 30 May 2019 01:48:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 May 2019 18:48:30 -0700
To:     Varun Prakash <varun@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        dt@chelsio.com, indranil@chelsio.com, ganji.aravind@chelsio.com
Subject: Re: [PATCH net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM page pods for iSCSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1559061660-4963-1-git-send-email-varun@chelsio.com>
Date:   Wed, 29 May 2019 21:48:27 -0400
In-Reply-To: <1559061660-4963-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 28 May 2019 22:11:00 +0530")
Message-ID: <yq1lfyozp90.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905300012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905300012
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Varun,

> Page pods are used for direct data placement, this patch enables eDRAM
> page pods if firmware supports this feature.

No objections to the SCSI bits.

> @@ -394,6 +398,26 @@ int cxgbi_ppm_init(void **ppm_pp, struct net_device *ndev,
>  	unsigned int pool_index_max = 0;
>  	unsigned int alloc_sz;
>  	unsigned int ppod_bmap_size;
> +	unsigned int ppmax;
> +
> +	if (!iscsi_edram_start)
> +		iscsi_edram_size = 0;
> +
> +	if (iscsi_edram_size &&
> +	    ((iscsi_edram_start + iscsi_edram_size) != start)) {
> +		pr_err("iscsi ppod region not contigious: EDRAM start 0x%x "

contiguous

-- 
Martin K. Petersen	Oracle Linux Engineering
