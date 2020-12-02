Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8A2CC44D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgLBRxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:53:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34226 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgLBRxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 12:53:16 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2HixDn050115;
        Wed, 2 Dec 2020 17:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=voOUknOp6aqLcPOVdIicUc+o1iE0LKeGH6bbRJzIC6U=;
 b=ncZRCNpZ2qPwjztBzqQqJ3k9uOfI+DehNRb+eUF1w0z79GkUbpX7rsKeZ8+nZ4f+cqUx
 Iz6R86LRjZ+j+fW8z2z33HiyNEmUKfh0DvHh+8DFeur/XKp+HGcmg2RVpePdmkJpLY56
 Zwb6Ve9E1CxiSLm0xtO9rpK11b5m5rzUJoWzSVeqqqR9XPCmewvU4K4UV3/3EcJNp4EJ
 HGaotp35QkAL9/1kfFzU6ueYclddAxL50/OB4Le44aFXe5+SI8xtOZngm2z3Gnpk7dPW
 eojwk4UKCQNlYc2ogn/8+DVa98JHsn35FfqZI4XMRuWjQ3N7qF6r/d2Ma6rq48csFFMS Xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egksses-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 17:52:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2HoR3I182466;
        Wed, 2 Dec 2020 17:52:23 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404pne93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 17:52:23 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B2HqNDp029329;
        Wed, 2 Dec 2020 17:52:23 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 09:52:22 -0800
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [net:master 1/3] ERROR: modpost: "__uio_register_device"
 undefined!
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11rg8cczn.fsf@ca-mkp.ca.oracle.com>
References: <202012021229.9PwxJvFJ-lkp@intel.com>
        <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
        <20201202094624.32a959fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Wed, 02 Dec 2020 12:52:20 -0500
In-Reply-To: <20201202094624.32a959fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 2 Dec 2020 09:46:24 -0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub,

> Martin is it an option to drop the patch from scsi-staging and put it
> in the queue for 5.10 (yours or ours)?

I'll shuffle it over to my fixes branch.

-- 
Martin K. Petersen	Oracle Linux Engineering
