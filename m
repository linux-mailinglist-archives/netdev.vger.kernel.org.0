Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD388EE84
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733094AbfHOOnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 10:43:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35034 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729838AbfHOOnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 10:43:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEWXqZ095123;
        Thu, 15 Aug 2019 14:42:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OlD0Owu/ipcULTceI2p3YPW2WFawqpcVMk9qa5ng7wY=;
 b=lzdAQgwOROUGZWPyI5B2Lf+vsDRGCpCRufwLy7TEY/kkQ6nniV8JB0DZWXGlUXd7bBe6
 wFb+jSggnIcJpmlb82nFi8UgQFae++WP9wLbXLxLglJgnLgwhScIwSzBZKTUUZmk+s39
 nJ5Xk2Kbr5KugklCNohkRGSXnS30YWjtfsx9Pmv3z2GlGcDqZBUr8yH+sJP27KYE7wz+
 0krwwhAPj6hlbhDZ57C6/nIhdgsMAlLVu+z4dEBWEWIvMsVtuIJ2vmSD+NXtrmEUjdub
 X5cJ540QoywpwqoyFCfb6E+V5yLOaRbRsAaOaJQfBxd8rUApGN+P93Op8ZeQ7lx4/MQs og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2u9pjqu06s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7FEXZqS172188;
        Thu, 15 Aug 2019 14:42:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ucgf131rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 14:42:58 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7FEgv5Q001575;
        Thu, 15 Aug 2019 14:42:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ucgf131qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Aug 2019 14:42:57 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7FEgviv007593;
        Thu, 15 Aug 2019 14:42:57 GMT
Received: from [10.159.252.166] (/10.159.252.166)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 15 Aug 2019 07:42:56 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next v2 3/4] net/rds: Add a few missing rds_stat_names
 entries
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <20190814.212525.326606319186601317.davem@davemloft.net>
 <cover.1565879451.git.gerd.rausch@oracle.com>
Message-ID: <2d604055-a49e-637f-a1e6-afefa8482316@oracle.com>
Date:   Thu, 15 Aug 2019 07:42:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1565879451.git.gerd.rausch@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9350 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908150148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gerd Rausch <gerd.rausch@oracle.com>
Date: Thu, 11 Jul 2019 12:15:50 -0700

In a previous commit, fields were added to "struct rds_statistics"
but array "rds_stat_names" was not updated accordingly.

Please note the inconsistent naming of the string representations
that is done in the name of compatibility
with the Oracle internal code-base.

s_recv_bytes_added_to_socket     -> "recv_bytes_added_to_sock"
s_recv_bytes_removed_from_socket -> "recv_bytes_freed_fromsock"

Fixes: 192a798f5299 ("RDS: add stat for socket recv memory usage")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/stats.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/stats.c b/net/rds/stats.c
index 73be187d389e..6bbab4d74c4f 100644
--- a/net/rds/stats.c
+++ b/net/rds/stats.c
@@ -76,6 +76,8 @@ static const char *const rds_stat_names[] = {
 	"cong_update_received",
 	"cong_send_error",
 	"cong_send_blocked",
+	"recv_bytes_added_to_sock",
+	"recv_bytes_freed_fromsock",
 };
 
 void rds_stats_info_copy(struct rds_info_iterator *iter,
-- 
2.22.1


