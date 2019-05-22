Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958E7270F0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbfEVUmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:42:13 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:60798 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbfEVUmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:42:13 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x4MKb3Sk004269;
        Wed, 22 May 2019 21:42:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=/mLXx6iwCW5XOYkc/piGc+DI17jP3DsArxx8sw+T1GM=;
 b=BuRunKIGPrR59r/nHAvWNA0F+NNPS/SuI9rP67qgE+PnGoEZEd41zIxD71ZgYKVbGW5J
 ny4nxbYqJVoKbCVD6JbSnkTG8J+skQcu5Ya9luWfmjViVPCd12C4AhWMYYAmsHAwlyiy
 3tx2yS8ytSd2aUtwcLJD8C8q/hyMd9rk+kDaqGQ2up43V4sxL6/VA9eddDetmFWBFaeq
 jRwjeXJOV0J0ryrZaO58U2JQ020//dWnYrLWNHoeKMjQn+JJt7fV0WpxPAp0ZH8oDBD0
 irpijEcDqF4LcWAGzHmaP9BjVFxQOMRcKxexb/ORKLyfaNXN4jJGNUjrJf+0DI/OTRuV dA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2smxegwvju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:42:07 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKXCg5011409;
        Wed, 22 May 2019 16:42:06 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsk0m-1;
        Wed, 22 May 2019 16:42:06 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id DC04032A88;
        Wed, 22 May 2019 20:40:30 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 5/6] Documentation: ip-sysctl.txt: Document tcp_fastopen_key
Date:   Wed, 22 May 2019 16:39:37 -0400
Message-Id: <aa4defa5f0f75908b140855e4495388468a94c01.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add docs for /proc/sys/net/ipv4/tcp_fastopen_key

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 Documentation/networking/ip-sysctl.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 14fe930..e8d848e 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -648,6 +648,26 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
 	0 to disable the blackhole detection.
 	By default, it is set to 1hr.
 
+tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
+	The list consists of a primary key and an optional backup key. The
+	primary key is used for both creating and validating cookies, while the
+	optional backup key is only used for validating cookies. The purpose of
+	the backup key is to maximize TFO validation when keys are rotated.
+
+	A randomly chosen primary key may be configured by the kernel if
+	the tcp_fastopen sysctl is set to 0x400 (see above), or if the
+	TCP_FASTOPEN setsockopt() optname is set and a key has not been
+	previously configured via sysctl. If keys are configured via
+	setsockopt() by using the TCP_FASTOPEN_KEY optname, then those
+	per-socket keys will be used instead of any keys that are specified via
+	sysctl.
+
+	A key is specified as 4 8-digit hexadecimal integers which are separted
+	by a '-' as: xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx. Leading zeros may be
+	omitted. A primary and a backup key may be specified by separting them
+	by a comma. If only one key is specified, it becomes the primary key and
+	any previous backup keys are removed.
+
 tcp_syn_retries - INTEGER
 	Number of times initial SYNs for an active TCP connection attempt
 	will be retransmitted. Should not be higher than 127. Default value
-- 
2.7.4

