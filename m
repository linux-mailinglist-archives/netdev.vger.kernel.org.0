Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2DD2CC47D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbgLBSDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:03:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52506 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgLBSDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:03:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2I0Lmr032038;
        Wed, 2 Dec 2020 18:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=ZSYCoRMZKK+SMtwVPNobXtmHqh3ACjUuU854hfBtkRo=;
 b=MqBHr8lD84fcXta3crvVtVyXuqMaYoJiRZDetKQ/qshEWH6I1qaq9HBfDRzL9aNg375o
 mVpyf70Hk6jNwCsx+Hglv6cf0b+rDQ+IajHB0EOQCav4XHNm6IfZnoh/JSdzLaYGSAGl
 jBef0CQwTs/GoycG/IKyMBNOWdRApyWQI79RyLhnRxsMCOjk6tJzvPGVHBYE4J/d7JNv
 ekqkokXBA6SZzBhElFS4Jk0HQ3JjHKQ/dwaM5fkCDlQ6hgqW2iTHwJXPXYj/LOL52fyx
 suQFQoXWs2og50FFsEUE9B7Atr+ZG/ILjqlJLtGTPUd4RU8CE2aLk6HbVn9I0H3sAYC9 0Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyqswfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 18:02:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B2I0BXS108308;
        Wed, 2 Dec 2020 18:02:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3540f0qx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 18:02:52 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B2I2pop018156;
        Wed, 2 Dec 2020 18:02:51 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Dec 2020 10:02:51 -0800
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [net:master 1/3] ERROR: modpost: "__uio_register_device"
 undefined!
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9dkaxxg.fsf@ca-mkp.ca.oracle.com>
References: <202012021229.9PwxJvFJ-lkp@intel.com>
        <8875896f-81a7-cbda-3b6e-97b5b22383c3@infradead.org>
        <20201202094624.32a959fb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <yq11rg8cczn.fsf@ca-mkp.ca.oracle.com>
        <20201202095633.25a29431@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Wed, 02 Dec 2020 13:02:49 -0500
In-Reply-To: <20201202095633.25a29431@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        (Jakub Kicinski's message of "Wed, 2 Dec 2020 17:56:33 +0000 (UTC)")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9823 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=1 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub,

>> I'll shuffle it over to my fixes branch.
>
> Great, thank you!

Should be there now.

-- 
Martin K. Petersen	Oracle Linux Engineering
