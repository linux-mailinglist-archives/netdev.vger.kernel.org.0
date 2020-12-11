Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0401D2D7C8A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394583AbgLKRMl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Dec 2020 12:12:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61967 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394869AbgLKRMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:12:24 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BBH8bZn003807
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 09:11:43 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35c9reh4yq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 09:11:43 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 09:11:41 -0800
Received: by devvm2494.atn0.facebook.com (Postfix, from userid 172786)
        id B53045283262; Fri, 11 Dec 2020 09:11:38 -0800 (PST)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <yhs@fb.com>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>
Subject: [PATCH 0/1 v3 bpf-next] bpf: increment and use correct thread iterator
Date:   Fri, 11 Dec 2020 09:11:37 -0800
Message-ID: <20201211171138.63819-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_05:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1034 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 mlxscore=0 mlxlogscore=563 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <bsd@fb.com>

Reposting with one of the many splats seen.

v2->v3:
  Add splat to commitlog descriptions

v1->v2
  Use Fixes: shas from correct tree

Jonathan Lemon (1):
  bpf: increment and use correct thread iterator

 kernel/bpf/task_iter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.24.1

