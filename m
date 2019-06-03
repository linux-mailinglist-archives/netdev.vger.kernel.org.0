Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5FB33520
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbfFCQjC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 12:39:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35448 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729389AbfFCQjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 12:39:01 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53GXo80006380
        for <netdev@vger.kernel.org>; Mon, 3 Jun 2019 09:39:00 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sw5y08a77-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 09:39:00 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 3 Jun 2019 09:38:53 -0700
Received: by devvm34215.prn1.facebook.com (Postfix, from userid 172786)
        id BB600230C88D1; Mon,  3 Jun 2019 09:38:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm34215.prn1.facebook.com
To:     <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <bjorn.topel@intel.com>,
        <magnus.karlsson@intel.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>
Smtp-Origin-Cluster: prn1c35
Subject: [PATCH v4 bpf-next 0/2] Better handling of xskmap entries
Date:   Mon, 3 Jun 2019 09:38:50 -0700
Message-ID: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=330 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030115
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3->v4:
 - Clarify error handling path.

v2->v3:
 - Use correct map type.

Jonathan Lemon (2):
  bpf: Allow bpf_map_lookup_elem() on an xskmap
  libbpf: remove qidconf and better support external bpf programs.

 include/net/xdp_sock.h                        |   6 +-
 kernel/bpf/verifier.c                         |   6 +-
 kernel/bpf/xskmap.c                           |   4 +-
 tools/lib/bpf/xsk.c                           | 103 +++++-------------
 .../bpf/verifier/prevent_map_lookup.c         |  15 ---
 5 files changed, 39 insertions(+), 95 deletions(-)

-- 
2.17.1

