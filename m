Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5952B55721
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732929AbfFYSXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:23:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36782 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732928AbfFYSXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:23:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5PI53vC032267
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=OA9bvUyhDNX+cwxXkDwPNKdyzV46rSJ7gwusns727DY=;
 b=N4Zf63Q0al/B0gMuVnOVwsbXNWh7kXo13kDukqAAHfwgd4dkG4XjvVNk+fvHDNEbKnfy
 RdoIh5Rhur//Hx+w+FluOjaduUx1Ig/qd1yGjM6GwxC1RkW376WOsFYX+fS3sRcuVxoO
 Mfnz8eayHOgF+QTZwRYaDysjTU54JLg8rUU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tbk3qsgap-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:23:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 11:23:14 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BCFCA62E1DB8; Tue, 25 Jun 2019 11:23:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] bpf: sync tools/include/uapi/linux/bpf.h
Date:   Tue, 25 Jun 2019 11:23:01 -0700
Message-ID: <20190625182303.874270-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625182303.874270-1-songliubraving@fb.com>
References: <20190625182303.874270-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=906 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync changes for bpf_dev_ioctl.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/include/uapi/linux/bpf.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f..ec3ae452cfd7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3541,4 +3541,9 @@ struct bpf_sysctl {
 				 */
 };
 
+#define BPF_IOCTL	0xBF
+
+#define BPF_DEV_IOCTL_GET_PERM	_IO(BPF_IOCTL, 0x01)
+#define BPF_DEV_IOCTL_PUT_PERM	_IO(BPF_IOCTL, 0x02)
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.17.1

