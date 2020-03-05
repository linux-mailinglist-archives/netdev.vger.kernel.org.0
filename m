Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2C179D62
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 02:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgCEBen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 20:34:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18094 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbgCEBem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 20:34:42 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0251Y6tw009270
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 17:34:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=rMqHvAVvVCxmhWbyIbItg4rlY6eKi1SaBYJeBRGvhFM=;
 b=OmAVEeuROtkcww2mw65KwGRdCfnvmp5T7kPwS/WIXG9GPWYV/Wd0MlUPHao1FeVWUp+I
 AVKEj0Sc9HPxSUWf0Sw2miVoBlPQLTkrY3uc7CGu41/z/Wde7zqchvldISon0d1gxFsa
 absiOa+SLWYQvMe1l+VNAM2WgbhQ0xtt+DA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yht6495f7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 17:34:41 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 4 Mar 2020 17:34:40 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CE79429425EB; Wed,  4 Mar 2020 17:34:37 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/2] bpf: A few struct_ops fixes
Date:   Wed, 4 Mar 2020 17:34:37 -0800
Message-ID: <20200305013437.534961-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_10:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=432 spamscore=0
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set addresses a few struct_ops issues.
Please see individual patch for details.

Martin KaFai Lau (2):
  bpf: Return better error value in delete_elem for struct_ops map
  bpf: Do not allow map_freeze in struct_ops map

 kernel/bpf/bpf_struct_ops.c | 14 +++++++++++---
 kernel/bpf/syscall.c        |  5 +++++
 2 files changed, 16 insertions(+), 3 deletions(-)

-- 
2.17.1

