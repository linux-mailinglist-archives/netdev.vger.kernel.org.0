Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8D35E573
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 15:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfGCN1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 09:27:25 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbfGCN1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 09:27:24 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63DJDA9108639
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 09:27:24 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tgukg4ea5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 09:27:23 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 14:27:21 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 14:27:19 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63DRIGY32571628
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 13:27:18 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB34B4C044;
        Wed,  3 Jul 2019 13:27:18 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 816254C052;
        Wed,  3 Jul 2019 13:27:18 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 13:27:18 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        daniel@iogearbox.net
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 bpf-next 0/4] selftests/bpf: fix compiling loop{1,2,3}.c on s390
Date:   Wed,  3 Jul 2019 15:27:07 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070313-0012-0000-0000-0000032ED659
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070313-0013-0000-0000-00002168296C
Message-Id: <20190703132711.57169-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=388 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use PT_REGS_RC(ctx) instead of ctx->rax, which is not present on s390.

This patch series consists of preparatory commits, which make it
possible to use PT_REGS_RC in BPF selftests, followed by the actual fix.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>


