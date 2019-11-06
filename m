Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF89F1D12
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfKFSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:02:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42704 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728191AbfKFSCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:02:15 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA6I06fG026193
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 10:02:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=PvqFEXNBoHkmIi1zRu3NcMaSANd1HCAy11FibpsN+EU=;
 b=V9qwnnW8h3I6qI03PiX3sjzIulUgjAsvMAs2O84cfjSuNndXNBLF0ZuZ0/2OtoASfkHv
 ymscPcDCFE+qeNArcoKgoVsS3uygyyneMD15oJm997ZTeDZ1kIdu4ipCNuBqeI4UmcyI
 KUA8EKL3bsj6QbtEJELfdOBNCxC3/yTHTE4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41un0dvx-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 10:02:15 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 6 Nov 2019 10:02:13 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 118A6294200E; Wed,  6 Nov 2019 10:02:12 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/2] bpf: Add array support to btf_struct_access
Date:   Wed, 6 Nov 2019 10:02:12 -0800
Message-ID: <20191106180212.2175046-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_06:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 mlxscore=0 spamscore=0 suspectscore=8 impostorscore=0 mlxlogscore=680
 lowpriorityscore=0 clxscore=1015 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911060175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds array support to btf_struct_access().
Please see individual patch for details.

Martin KaFai Lau (2):
  bpf: Add array support to btf_struct_access
  bpf: Add cb access in kfree_skb test

 kernel/bpf/btf.c                              | 187 +++++++++++++++---
 .../selftests/bpf/prog_tests/kfree_skb.c      |  54 +++--
 tools/testing/selftests/bpf/progs/kfree_skb.c |  25 ++-
 3 files changed, 220 insertions(+), 46 deletions(-)

-- 
2.17.1

