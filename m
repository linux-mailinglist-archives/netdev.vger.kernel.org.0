Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D982B3A3D78
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 09:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFKHrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 03:47:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhFKHrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 03:47:14 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15B7WvLP015671;
        Fri, 11 Jun 2021 03:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=rDCeGq499BM6LOKFgZCJNQl19LYZoC38jZTDudV+ur8=;
 b=rX1YD9p16Ht2sckhp35+ssUCzLky+idKJKxhayWQApC2XpxXsmFB3+EUpzbDfd5/UsnF
 rcBj1mV8ovSIReIbY/LxB2nQOPVhGdx967TC0xb2lKb1Z7Gjw/DwM9o+LrKmNsQtbu2Y
 5EnsusNNNFxKtE6eNv1BDxit1HnRMsaBpgc1aCTg2O9QVBOhKowzfx5+e9kKVZx/9PeZ
 llW/NdxDx3gFroKY7B+Mn7T8CjI2ea6umL1Eydx3a/QZVnhNBjE9Xt5hWR1Aeu4HVRDp
 nzm4GlcUCRSU+CPCjZhAg+d7DDppy7B7Oqaw6jZYU4atq0F/C+9rFZxmFR4QFd3pOew+ 1w== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39439wgm2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 03:45:16 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15B7gHk5031816;
        Fri, 11 Jun 2021 07:45:13 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3900hhu9j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 07:45:13 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15B7j9DB29688166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Jun 2021 07:45:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE5A11C05B;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04F3511C054;
        Fri, 11 Jun 2021 07:45:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Jun 2021 07:45:08 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/2] s390/iucv: updates 2021-06-11
Date:   Fri, 11 Jun 2021 09:45:00 +0200
Message-Id: <20210611074502.1719233-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M9frRIQXSFshw4jBgd1SAAr0xsVdET7P
X-Proofpoint-ORIG-GUID: M9frRIQXSFshw4jBgd1SAAr0xsVdET7P
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_01:2021-06-11,2021-06-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=850 mlxscore=0
 bulkscore=0 malwarescore=0 phishscore=0 priorityscore=1501 adultscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106110048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following iucv patches to netdev's net-next tree.

This cleans up a pattern of forward declarations in two iucv drivers,
so that they stop causing compile warnings with gcc11.

Thanks,
Julian

Heiko Carstens (1):
  s390/netiuvc: get rid of forward declarations

Julian Wiedmann (1):
  net/af_iucv: clean up some forward declarations

 drivers/s390/net/netiucv.c | 28 ++++++++++------------------
 net/iucv/af_iucv.c         | 27 ++++++++++-----------------
 2 files changed, 20 insertions(+), 35 deletions(-)

-- 
2.25.1

