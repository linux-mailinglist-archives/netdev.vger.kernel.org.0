Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E8C280507
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732569AbgJARVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:21:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26680 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732213AbgJARVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:21:36 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091H3tlA056289;
        Thu, 1 Oct 2020 13:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=BWwV+d99QDMYcSZeoIZ/A61Cv9EKQG3wuEi0CfUD6QA=;
 b=eeRSsSST6nwqZUugmNpyb2qjR3T+vkOaCSD6oTSCFCMUSY4CAYeTNXITCpRMZ5sb6Nl/
 krNP5HG6bJ7AvzZBYpzlRDMfr17ArG5fFg+O3laQ2JS+a+c47E/cucP7N5tWdMK38Yxc
 U6ilLq7eF4qMJqi1yjgsLmgfzr+qwN0lO4gdfT8KJ4ud0O1+AczZmK/VV1WTlgglct6Y
 N4Bf6FdcrqpO80N5fsktjbtvBtzmdfU1eeTwHPOUD9g8XhSH7tILOlIbf3dtkrP9X78O
 wIe4tmSIGtinMQjb/6deobS3VP7ZwV1zavrriB+U5l/f6wcyZkcu45lQEs9OXF4FcEaG Tw== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33wg81g4qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 13:21:34 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 091HKUqv022204;
        Thu, 1 Oct 2020 17:21:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 33wgcu030j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 17:21:31 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 091HLSW734472242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Oct 2020 17:21:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A462A4065;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25358A4062;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Oct 2020 17:21:28 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/2] net/iucv: updates 2020-10-01
Date:   Thu,  1 Oct 2020 19:21:25 +0200
Message-Id: <20201001172127.98541-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_05:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxlogscore=759 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for iucv to netdev's net-next
tree.

Just two (rare) patches, and both deal with smatch warnings.

Thanks,
Julian

Julian Wiedmann (2):
  net/af_iucv: right-size the uid variable in iucv_sock_bind()
  net/iucv: fix indentation in __iucv_message_receive()

 net/iucv/af_iucv.c | 2 +-
 net/iucv/iucv.c    | 8 +++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

-- 
2.17.1

