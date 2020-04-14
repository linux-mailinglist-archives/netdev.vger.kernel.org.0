Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1867A1A708C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 03:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390768AbgDNB1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 21:27:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgDNB1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 21:27:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1I4DZ084466;
        Tue, 14 Apr 2020 01:27:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=yX3jcuaiZwqJS3Px+uYkkVcuyYUZhVfhOgT5XLM8UP0=;
 b=ILqL76B7jN7nZK24M0TUPsCiCB+RI1t29Hs1yFSd5eo5m3OB0kgdwlL410IVDwTgwXdl
 BGUylfEjegSKMfLJmquhbE0YyhzW43rjs4heGz0nY18/KiebbxAZzAhEzyhy/PZf3ujL
 5Z4DHEHFbm6bBiZGh/dGJ3H88FZny9G60VA9pKLmsxGiOdkgwkAiWV0zIxQ4vpjSpVf9
 e7p2CpzwOq0/9EPcDahMn1sgAYzsT3p7C2kgxEcBDVyP2ZHTnW0SdGSyX3OFjPFWJN7x
 w2wZ7JHtYj/HTHBQrl7xnzOsjCjJOH0ChLLDxGnPELdV/gwQe2umimm16HGgx4KkQXbC GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30b5um1mrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:27:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1Qt6b055882;
        Tue, 14 Apr 2020 01:27:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30bqm01tnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:27:08 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03E1R7Ps020966;
        Tue, 14 Apr 2020 01:27:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:27:06 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 7/7] qedf: Get dev info after updating the params.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200403120957.2431-1-skashyap@marvell.com>
        <20200403120957.2431-8-skashyap@marvell.com>
Date:   Mon, 13 Apr 2020 21:27:05 -0400
In-Reply-To: <20200403120957.2431-8-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 3 Apr 2020 05:09:57 -0700")
Message-ID: <yq1mu7euaae.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=850
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 bulkscore=0 mlxscore=0
 mlxlogscore=925 lowpriorityscore=0 impostorscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004140008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

> - Get the dev info after updating the params.

This could also benefit from being elaborated a bit.

-- 
Martin K. Petersen	Oracle Linux Engineering
