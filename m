Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21909439321
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 11:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhJYJ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 05:59:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17974 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232705AbhJYJ7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 05:59:34 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19P9URtb009992;
        Mon, 25 Oct 2021 09:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=Elww7Cw+jdr5IGFBzOH85pmoH2wMN/kOhHewY85j3zw=;
 b=sTX6SjRA6GWLSdwNdPn8Jd5YvwVIgp6FTL7s7a/kgbviEalhBJwvan65L4vDyN4L6bEg
 NtPE7e5j/1iyON7woFNoJfnPBifWratoDEvkHlRHLvfzhgP9SzGcfAKY11bE4hzfQlKK
 S1orzMoOyIxc53pG5WMKDRTGxXYsJBvpIlxrD94NCu2fLdBtyHwPt7GkISJGfQo1ZbiG
 NG96AD+UrHSzN50UPvSQC5dBQ5G98U6hCrHRgSFbc8+hmwpP0t3XZ8+IwquZOZHJ7LMe
 fyKWmcW9dZ1KKV1w7epY/nzMcpGZnltQeyqid6s/h+9yeHqLfr2IK/7AZrtQao+GTU51 sw== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bwt0trhek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19P9h31C017206;
        Mon, 25 Oct 2021 09:57:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bwqst9pxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 09:57:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19P9v4dE56623548
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Oct 2021 09:57:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31D7611C04A;
        Mon, 25 Oct 2021 09:57:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E341111C069;
        Mon, 25 Oct 2021 09:57:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Oct 2021 09:57:03 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next 0/9] s390/qeth: updates 2021-10-25
Date:   Mon, 25 Oct 2021 11:56:49 +0200
Message-Id: <20211025095658.3527635-1-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: A6Z0Sg0ciwUI8wLYXwqR-UNmO3UZCPXJ
X-Proofpoint-GUID: A6Z0Sg0ciwUI8wLYXwqR-UNmO3UZCPXJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_03,2021-10-25_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=993 lowpriorityscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110250058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jakub,

please apply the following patch series for qeth to netdev's net-next tree.

This brings some minor maintenance improvements, and a bunch of cleanups
so that the W=1 build passes without warning.

Thanks,
Julian

Heiko Carstens (3):
  s390/qeth: fix various format strings
  s390/qeth: add __printf format attribute to qeth_dbf_longtext
  s390/qeth: fix kernel doc comments

Julian Wiedmann (6):
  s390/qeth: improve trace entries for MAC address (un)registration
  s390/qeth: remove .do_ioctl() callback from driver discipline
  s390/qeth: move qdio's QAOB cache into qeth
  s390/qeth: clarify remaining dev_kfree_skb_any() users
  s390/qeth: don't keep track of Input Queue count
  s390/qeth: update kerneldoc for qeth_add_hw_header()

 arch/s390/include/asm/qdio.h      |  2 --
 drivers/s390/cio/qdio_setup.c     | 34 ++----------------
 drivers/s390/net/qeth_core.h      |  4 +--
 drivers/s390/net/qeth_core_main.c | 59 ++++++++++++++++++-------------
 drivers/s390/net/qeth_l2_main.c   | 27 +++++++-------
 drivers/s390/net/qeth_l3_main.c   | 12 +++----
 6 files changed, 57 insertions(+), 81 deletions(-)

-- 
2.25.1

