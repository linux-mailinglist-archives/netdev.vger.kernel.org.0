Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4255E60EE33
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 04:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbiJ0C7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 22:59:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbiJ0C7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 22:59:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639F314408E;
        Wed, 26 Oct 2022 19:59:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R2Qwhx031725;
        Thu, 27 Oct 2022 02:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2022-7-12;
 bh=wqcx1+8VWsJOnnHYeG8IhzNmZtiafUlfeIafTBDhrfI=;
 b=UwPuAbVXh9iSUEni1OO6Y0uvdeotcBBYOSU1y/jMqCUyh4WMEkbI21a/XzHaNi/G4PCc
 XUtf9d2W4zT6zOGMJzqZ50rleoKXHjVpgWf85R4GLdcZ0EsZP8gzSM58/9ekmH8KiXML
 V4kE9GPiuOXsxlJEaq8TpNCAtRgDq4ALJJlGTZm8EniDO1RA22F4s73cbaMzpda2j0Qn
 xlOi53C5oQB3v4VT+5xQINyE6bGymVuKczJUU2mY1z26LPCgi7iAl7wVzR3daeK1NaVm
 dXr9il062VbQ/zo1cTgeU/qXVp+TP5KSqQOz8+t+s6WoNXy9KTZX3ggS6fm/AOjMiGo1 Tg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv0uft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM5Qp9006734;
        Thu, 27 Oct 2022 02:58:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfaggh3gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:58:36 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29R2wWsb007945;
        Thu, 27 Oct 2022 02:58:35 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kfaggh3fk-3;
        Thu, 27 Oct 2022 02:58:35 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     skashyap@marvell.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Abaci Robot <abaci@linux.alibaba.com>, jejb@linux.ibm.com,
        netdev@vger.kernel.org, jhasan@marvell.com,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: Remove set but unused variable 'page'
Date:   Wed, 26 Oct 2022 22:58:28 -0400
Message-Id: <166683942542.3791741.7583566281563979533.b4-ty@oracle.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221009060249.40178-1-jiapeng.chong@linux.alibaba.com>
References: <20221009060249.40178-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270015
X-Proofpoint-ORIG-GUID: pLhWZD3a03_sYL0FT3eOvq2IC7HlVzjJ
X-Proofpoint-GUID: pLhWZD3a03_sYL0FT3eOvq2IC7HlVzjJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 9 Oct 2022 14:02:49 +0800, Jiapeng Chong wrote:

> The variable page is not effectively used in the function, so delete
> it.
> 
> 

Applied to 6.2/scsi-queue, thanks!

[1/1] scsi: qedf: Remove set but unused variable 'page'
      https://git.kernel.org/mkp/scsi/c/e6f8a22ff4a1

-- 
Martin K. Petersen	Oracle Linux Engineering
