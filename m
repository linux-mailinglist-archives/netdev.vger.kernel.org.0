Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC820B873
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgFZSkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:40:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgFZSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:40:45 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIMAaO015714;
        Fri, 26 Jun 2020 11:40:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=EcCtaCeZbcS38sbyQfe/VVa+t7Ays24uTYttWs34Z/Q=;
 b=xdoRuJBFiMUrODHOxDVyq0Y7PSVNSMJD62Z1qH+d6osUdgfiyk03fu8wqJdXjQxyIn4O
 j1dmbz7s3LiBPZD+rSguX1D5ziRk1RqjefvP9ND9vZbqwy53CG7ATofNtMfn1L8cD5+z
 KguQE5ABkJBmephs0xEw68j+QTVSR1TzLnz5NKH57J+cja+6pr5sO/uyW8R5dEIlnLjX
 aVeKkbB2p0+2DjmKJtvOfhtCkpX/pk5u+JeEnfACMMTQLaKoNAUocpuBhLHVlizOHddR
 fCXI5sGCKHbec2MRqtDqq/LYCJ5LFnPulOxHqQu/RhFZngoMXhWLdQfkph4MaqWxAIK3 Qw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh5u7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jun 2020 11:40:43 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 11:40:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 26 Jun 2020 11:40:43 -0700
Received: from NN-LT0019.marvell.com (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id 6BF453F703F;
        Fri, 26 Jun 2020 11:40:41 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 0/8] net: atlantic: various non-functional changes
Date:   Fri, 26 Jun 2020 21:40:30 +0300
Message-ID: <20200626184038.857-1-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains several non-functional changes, which were made in
out of tree driver over the time.
Mostly typos, checkpatch findings and comment fixes.

Dmitry Bezrukov (1):
  net: atlantic: missing space in a comment in aq_nic.h

Igor Russkikh (1):
  net: atlantic: put ptp code under IS_REACHABLE check

Mark Starovoytov (5):
  net: atlantic: MACSec offload statistics checkpatch fix
  net: atlantic: Replace ENOTSUPP usage to EOPNOTSUPP
  net: atlantic: make aq_pci_func_init static
  net: atlantic: fix typo in aq_ring_tx_clean
  net: atlantic: add alignment checks in hw_atl2_utils_fw.c

Nikita Danilov (1):
  net: atlantic: fix variable type in aq_ethtool_get_pauseparam

 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 11 ++++---
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 20 +++++++++---
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  9 +++---
 .../ethernet/aquantia/atlantic/aq_pci_func.c  |  9 +++---
 .../ethernet/aquantia/atlantic/aq_pci_func.h  |  8 ++---
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  9 ++++--
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 11 ++++---
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c   |  2 +-
 .../atlantic/hw_atl2/hw_atl2_utils_fw.c       | 32 ++++++++++++++++---
 10 files changed, 80 insertions(+), 33 deletions(-)

-- 
2.25.1

