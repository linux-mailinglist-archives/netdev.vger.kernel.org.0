Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D703D37C1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfJKDN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:13:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726096AbfJKDN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:13:28 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9B394Wd017777
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=o5jXrns6VTJWaBcu1yecNeLa9l0YnAePg04L5mFjbRU=;
 b=QNbZCUG8sFs3vygW/gw/CNyUfpfdpLd/iR57uORTVwcfQqNeUQBRAOjCOr5CLzZMaCKD
 Pe3Yf0VWwFgVminnjTyA0wzLjzI9RnYckFpnOaGmbzFDwXLKWbXVkPzU+UbfG70dzuif
 E6oEAnMX15oXXqbLz/+ymTKfWiyz0yANLgI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vjekprr5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:13:26 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 10 Oct 2019 20:13:26 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 97AD7861907; Thu, 10 Oct 2019 20:13:24 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/2] selftests/bpf Makefile cleanup and fixes
Date:   Thu, 10 Oct 2019 20:13:16 -0700
Message-ID: <20191011031318.388493-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_01:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 spamscore=0 adultscore=0 mlxscore=0 mlxlogscore=511 clxscore=1015
 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910110028
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 enforces libbpf build to have bpf_helper_defs.h ready before test BPF
programs are built.
Patch #2 drops obsolete BTF/pahole detection logic from Makefile.

Andrii Nakryiko (2):
  selftests/bpf: enforce libbpf build before BPF programs are built
  selftests/bpf: remove obsolete pahole/BTF support detection

 tools/testing/selftests/bpf/Makefile | 47 +++++-----------------------
 1 file changed, 8 insertions(+), 39 deletions(-)

-- 
2.17.1

