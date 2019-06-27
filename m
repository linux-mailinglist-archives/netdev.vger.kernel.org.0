Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C90DC58B82
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfF0UTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:19:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60290 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbfF0UTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:19:44 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RKJAxB007286
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jcdQikQ1BslPYp7VcyCuIMUzo7PpGj9BdMXQnszzUwg=;
 b=SP0fGYP+c2U+kXU1EryY8Hue6fdFzsIWggG8yM65gNR0PmhSaGzgZzulcwcVm0mKwGLT
 w8HKf+9HbDacQNCORSr7X2sN0LmfeNsVq9vQUNWyYG7Lx6hn0ZpO2QPKEZBfhVK/kFkh
 9yHeeqHKOZh5TDJRrbvga5zHQ7h14+5zomA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2td37drby0-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 13:19:43 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 27 Jun 2019 13:19:38 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 19BC462E2BE1; Thu, 27 Jun 2019 13:19:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <lmb@cloudflare.com>, <jannh@google.com>,
        <gregkh@linuxfoundation.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/4] bpf: sync tools/include/uapi/linux/bpf.h
Date:   Thu, 27 Jun 2019 13:19:21 -0700
Message-ID: <20190627201923.2589391-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627201923.2589391-1-songliubraving@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=752 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270233
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync changes for bpf_dev_ioctl.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/include/uapi/linux/bpf.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f..13e148bd6c7c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3541,4 +3541,10 @@ struct bpf_sysctl {
 				 */
 };
 
+#define BPF_IOCTL	0xBF
+
+/* enable/disable sys_bpf() for current */
+#define BPF_DEV_IOCTL_ENABLE_SYS_BPF	_IO(BPF_IOCTL, 0x01)
+#define BPF_DEV_IOCTL_DISABLE_SYS_BPF	_IO(BPF_IOCTL, 0x02)
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.17.1

