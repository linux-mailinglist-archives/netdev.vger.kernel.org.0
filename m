Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CCE269AAD
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgIOAuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:50:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5150 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgIOAuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 20:50:39 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F0jgrC001947
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:50:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ZjBm9IiGUNB9N/sWWyOh5V0UmNeIgaRarYo06RJj2SE=;
 b=WBbvn4aWh60pMtILLItvoiuL+OMTsAXp4QjDzW5RnTrHzDmEuwNKvNSRroLscWpRTUSI
 l9+9890BnLb722BeKtr1Y0HuTs7a0dvfSVH8a/TQ4WjN2OtRXp/a8MW3kuTAb9dmEUdx
 dtf3IpWninHT7OcM14Q3+acAE0mMGNWnDYU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33hdttsd4t-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 17:50:39 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 17:50:38 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8D3B52EC6ED4; Mon, 14 Sep 2020 17:50:36 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH bpf] docs/bpf: remove source code links
Date:   Mon, 14 Sep 2020 17:50:31 -0700
Message-ID: <20200915005031.2748397-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 suspectscore=8 bulkscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make path to bench_ringbufs.c just a text, not a special link.

Reported-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Fixes: 97abb2b39682 ("docs/bpf: Add BPF ring buffer design notes")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 Documentation/bpf/ringbuf.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/ringbuf.rst b/Documentation/bpf/ringbuf.rs=
t
index 4d4f3bcb1477..6a615cd62bda 100644
--- a/Documentation/bpf/ringbuf.rst
+++ b/Documentation/bpf/ringbuf.rst
@@ -197,7 +197,7 @@ a self-pacing notifications of new data being availab=
ility.
 being available after commit only if consumer has already caught up righ=
t up to
 the record being committed. If not, consumer still has to catch up and t=
hus
 will see new data anyways without needing an extra poll notification.
-Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c_) sh=
ow that
+Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbufs.c) sho=
w that
 this allows to achieve a very high throughput without having to resort t=
o
 tricks like "notify only every Nth sample", which are necessary with per=
f
 buffer. For extreme cases, when BPF program wants more manual control of
--=20
2.24.1

