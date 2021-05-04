Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B84372662
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 09:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhEDHQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 03:16:28 -0400
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:30458 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229786AbhEDHQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 03:16:27 -0400
Received: from pps.filterd (m0048493.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1447C4IM015937
        for <netdev@vger.kernel.org>; Tue, 4 May 2021 00:15:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com; h=from : to :
 cc : subject : date : message-id : mime-version :
 content-transfer-encoding; s=PPS12012017;
 bh=WTn1YShjJBUWM6coDhTlnSbh55D8VaJYWmej1N4vH0I=;
 b=luP6qjuTBLX3JtVJ8fipmZvG2qdjMy3fimBmXHL3JawOhqwTtzcm3xyNGeJV0n+ETDRa
 Gs72Y8rc+G958SfIn4EKKkS4boDOem5B1lawLeC5ttyMCzUmmY4lU25D/0X5u6wyVI9T
 8FUcwlGt98tMVQotKvFWFDvFM1KSLLnuLeVzRiUJ/H/hGRrrUVsW3lfahBdsqHOFDvsz
 Or8c5bKm3g9AlnrA7j1+zKZyZd9ZPbg6nKwKWmeCnD4YTB8+TGqv86gvYbr9PkXjKSqK
 +9Bpfis8Qc79FTOipqu0uR/R8gXGZf/i1cBCGHWDkelFYNifBQNn3BKrzDVR3AQ1Et2/ mA== 
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        by mx0a-00169c01.pphosted.com with ESMTP id 38atst22d4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 00:15:33 -0700
Received: by mail-wm1-f72.google.com with SMTP id j3-20020a1c55030000b029012e7c06101aso634280wmb.5
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 00:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTn1YShjJBUWM6coDhTlnSbh55D8VaJYWmej1N4vH0I=;
        b=pzvIi1tJZFAZixnrvLTie6yRy1BbbWeAr2BdpryO275c8Hmx4/4INYIiBcaAOTQv2I
         Oz/PL/tqUoYcmi7dqUJbiEc3qI8777O/R7xd7sUpKhq63SxihDEymaHgVLWodjSLSFu2
         LMyB7kW+2/4THl+CUXrI72/D6iicZuVQD56jIys8vccUGlNbS5/CdFbZp5N7nUA4kBdi
         0nlSHj5DQND04F+Gb4RZIH2+vjZOf0U22DlZq6gFiTqhaWnSxFHU0tUWCkHJTV5A2otw
         ELrkM/uthDzq32hu7CSK8KXfmQODC8YbesEdAQ6xy0m5mZPkljsBTH1YztNlImo1694s
         Lxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WTn1YShjJBUWM6coDhTlnSbh55D8VaJYWmej1N4vH0I=;
        b=S3A6AgPGXcit++Vtdt+2m4fzvbRp5UhWrrb9IGW3ZErQBfh1nB7Vgol3RskvDZgdUH
         PMBNkgu81diISr+ZcFkywMmR8Nfs8hgXZEYdfKYvwOLUMbUrTPt+y/DABlfhBTqVewqT
         9kyz4LL0RfwhYpvTiMtVMdnR+gumVRe0WTjcagfBC7D5FRzHfc4v/WA6i05E9Q//N7fY
         d5DOH94UPUz+LfFbW8k4fRMW1JIKemWaFEHXg51I32NcsHQdE35OyPdnHAIUMQ4NPpuD
         fl3wCjuVy+Y148RP8+IKhSp8Yhf15yWWri2TosWshcJGjCCncq5ud/EHNu2DZ8dsSTHk
         DlOQ==
X-Gm-Message-State: AOAM532IshSnEe1+OD7f8qrKBJowfTfmev1nB5shEjg7Vmo5XwWns2lf
        Nv3zKy87IpMC7CqI2woqRsOENGAO+dacrv/Kei84HZ6AaXEPHhsNX7dNX/2gDzyLUXKPfFkNdkM
        ICzcVjqR8U7ZG9oGsQ5x6Z657Eu2OcYgAG4O3WDVxyCsanbS6c5B1xO+zkiIwOYZQo5P+TGGT+z
        74IBOk
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr30006873wrm.46.1620112531345;
        Tue, 04 May 2021 00:15:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLxmEwu+xjcWsKH7hMm2mmsc+DxmyY9zLGxert6RZh8HE8FaqFUtVJw0IOxtuzCp+jVcRtJA==
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr30006835wrm.46.1620112530944;
        Tue, 04 May 2021 00:15:30 -0700 (PDT)
Received: from localhost.localdomain (bzq-109-64-244-223.red.bezeqint.net. [109.64.244.223])
        by smtp.gmail.com with ESMTPSA id f7sm14830049wrg.34.2021.05.04.00.15.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 May 2021 00:15:30 -0700 (PDT)
From:   Or Cohen <orcohen@paloaltonetworks.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nixiaoming@huawei.com, matthieu.baerts@tessares.net,
        mkl@pengutronix.de, nmarkus@paloaltonetworks.com
Cc:     Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH] net/nfc: fix use-after-free llcp_sock_bind/connect
Date:   Tue,  4 May 2021 10:15:25 +0300
Message-Id: <20210504071525.28342-1-orcohen@paloaltonetworks.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: Yk8zqmFctN4_IDnFZmTsmEq619BXZufQ
X-Proofpoint-GUID: Yk8zqmFctN4_IDnFZmTsmEq619BXZufQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_02:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 phishscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 adultscore=0 mlxlogscore=720 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2105040054
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commits 8a4cd82d ("nfc: fix refcount leak in llcp_sock_connect()")
and c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
fixed a refcount leak bug in bind/connect but introduced a
use-after-free if the same local is assigned to 2 different sockets.

This can be triggered by the following simple program:
    int sock1 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    int sock2 = socket( AF_NFC, SOCK_STREAM, NFC_SOCKPROTO_LLCP );
    memset( &addr, 0, sizeof(struct sockaddr_nfc_llcp) );
    addr.sa_family = AF_NFC;
    addr.nfc_protocol = NFC_PROTO_NFC_DEP;
    bind( sock1, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    bind( sock2, (struct sockaddr*) &addr, sizeof(struct sockaddr_nfc_llcp) )
    close(sock1);
    close(sock2);

Fix this by assigning NULL to llcp_sock->local after calling
nfc_llcp_local_put.

This addresses CVE-2021-23134.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Reported-by: Nadav Markus <nmarkus@paloaltonetworks.com>
Fixes: c33b1cc62 ("nfc: fix refcount leak in llcp_sock_bind()")
Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
---

 net/nfc/llcp_sock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index a3b46f888803..53dbe733f998 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -109,12 +109,14 @@ static int llcp_sock_bind(struct socket *sock, struct sockaddr *addr, int alen)
 					  GFP_KERNEL);
 	if (!llcp_sock->service_name) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
 	llcp_sock->ssap = nfc_llcp_get_sdp_ssap(local, llcp_sock);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		kfree(llcp_sock->service_name);
 		llcp_sock->service_name = NULL;
 		ret = -EADDRINUSE;
@@ -709,6 +711,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->ssap = nfc_llcp_get_local_ssap(local);
 	if (llcp_sock->ssap == LLCP_SAP_MAX) {
 		nfc_llcp_local_put(llcp_sock->local);
+		llcp_sock->local = NULL;
 		ret = -ENOMEM;
 		goto put_dev;
 	}
@@ -756,6 +759,7 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 sock_llcp_release:
 	nfc_llcp_put_ssap(local, llcp_sock->ssap);
 	nfc_llcp_local_put(llcp_sock->local);
+	llcp_sock->local = NULL;
 
 put_dev:
 	nfc_put_device(dev);
-- 
2.7.4

