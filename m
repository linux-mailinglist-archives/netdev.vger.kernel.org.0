Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB11AE7F0
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 23:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgDQV7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 17:59:49 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDQV7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 17:59:48 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLrisZ040871;
        Fri, 17 Apr 2020 21:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=UEqsCE5hsmdiKZ41U1wwjJk89H1YXXF0VEMN/gJve/M=;
 b=hNsBFvv5O0QuSCvXggMY6d6nba2dQXqsgtTykJecS9kw3i/HikWw1GQ2Jjw+tNlCr+QH
 QfqRYh3oBoFrIBtAVvFw+JXRP23sXinb+7us45DyVM0jKSVoh5PWNADtC/AlNf01h9Di
 nIx8CL+tfCktx9R8+dVvqGnuCBUQQVsBNu709h5o4UT7QeihBH5Ta0oN8QBfWqjlPtA/
 YEzq6NM6Yx0l1KI5dL7rxaDPgvs/5X3REx7pu26L5dxgoMGaMImdJpjDtNevuDLx0VLl
 goXg39IF/6GfSwHyrUD+yw9tLRiBSBsBAKiMHXAXOA6qEilUOR2+At2kVJX30UdJY/wp bA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30e0aaexms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:59:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03HLqEno020563;
        Fri, 17 Apr 2020 21:57:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30dn9m71k7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 21:57:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03HLvj1B014950;
        Fri, 17 Apr 2020 21:57:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Apr 2020 14:57:45 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>, <jhasan@marvell.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 0/9] qed/qedf: Firmware recovery, bw update and misc fixes.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200416084314.18851-1-skashyap@marvell.com>
Date:   Fri, 17 Apr 2020 17:57:42 -0400
In-Reply-To: <20200416084314.18851-1-skashyap@marvell.com> (Saurav Kashyap's
        message of "Thu, 16 Apr 2020 01:43:05 -0700")
Message-ID: <yq1eesln5bd.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=860 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004170159
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9594 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=934 mlxscore=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170159
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Saurav,

> Kindly apply this series to scsi tree at your earliest convenience.

Fixed a few things, including a sparse warning and the error message
pointed out by Sergei. Applied to 5.8/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
