Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD90CFED0
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfJHQVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:21:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726253AbfJHQVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:21:16 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x98GD3xC017082
        for <netdev@vger.kernel.org>; Tue, 8 Oct 2019 12:21:15 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vgvsjtrh9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:21:14 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 8 Oct 2019 17:21:13 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 8 Oct 2019 17:21:11 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x98GL91b33554510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Oct 2019 16:21:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DE244203F;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D0DB42047;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Oct 2019 16:21:09 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net 0/2] s390/qeth: fixes 2019-10-08
Date:   Tue,  8 Oct 2019 18:21:05 +0200
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 19100816-0008-0000-0000-0000032021C7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19100816-0009-0000-0000-00004A3F2394
Message-Id: <20191008162107.95259-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-08_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=836 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910080138
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

please apply the following two patches to your net tree.

Alexandra fixes two issues in the initialization code for vnicc cmds.
One is an uninitialized variable when a cmd fails, the other that we
wouldn't recover correctly if the device's supported features changed.

Thanks,
Julian


Alexandra Winter (2):
  s390/qeth: Fix error handling during VNICC initialization
  s390/qeth: Fix initialization of vnicc cmd masks during set online

 drivers/s390/net/qeth_l2_main.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

-- 
2.17.1

