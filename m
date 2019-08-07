Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F10A856AC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 01:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbfHGXzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 19:55:19 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:51340 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729624AbfHGXzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 19:55:17 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x77NkX8v003741;
        Thu, 8 Aug 2019 00:55:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=reTqOkQ8+7rl89NKxNGGNgLQjINSna9Qvy0QGGbOReM=;
 b=HyAaV1cdWaRL6xvwDvb5nKp5jxbno4t95KEz8h1FfLgzc8gaM1cEaIQlAl3EY8xqbRs7
 zKJ+Xr9mpS9o0nDn5IcJ0m848tod4nvPGw9tHYnqxnzZ1SnxXUjPycwPuthFBs4g2SkT
 S91IaUeknauuZeJsi/kZoKz47x4zK2lfrF/xbk3/obtDOWreMiAO+fF3xLyg60iKfHXR
 F1FQ3gPR0IFbvNoygoVKZGYilFZQ8Xn/qfYPZv78CSfR4kgGmAPtNVsbrfcmmpdiXBU0
 QIFQ/z0bWsXyvtzeOB/3LZvYIhV08tKxmzVgIVBJnXlZxFhxNacDnq6VbIu7vZf59HJ9 xQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2u52p8kwse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 00:55:14 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x77NldnS002520;
        Wed, 7 Aug 2019 19:55:13 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2u55kwdxr8-1;
        Wed, 07 Aug 2019 19:55:12 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id C334A26BE2;
        Wed,  7 Aug 2019 23:55:09 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1hvVm7-0000NC-Tj; Wed, 07 Aug 2019 19:55:23 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH v2 2/2] tcp: Update TCP_BASE_MSS comment
Date:   Wed,  7 Aug 2019 19:52:30 -0400
Message-Id: <1565221950-1376-2-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565221950-1376-1-git-send-email-johunt@akamai.com>
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=769
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908070211
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-07_07:2019-08-07,2019-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 mlxlogscore=768
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1908070211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP_BASE_MSS is used as the default initial MSS value when MTU probing is
enabled. Update the comment to reflect this.

Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 include/net/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 81e8ade1e6e4..9e9fbfaf052b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -64,7 +64,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 /* Minimal accepted MSS. It is (60+60+8) - (20+20). */
 #define TCP_MIN_MSS		88U
 
-/* The least MTU to use for probing */
+/* The initial MTU to use for probing */
 #define TCP_BASE_MSS		1024
 
 /* probing interval, default to 10 minutes as per RFC4821 */
-- 
2.7.4

