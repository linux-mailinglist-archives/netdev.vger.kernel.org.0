Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842118C07A
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbfHMSVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:21:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34016 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbfHMSVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:21:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DI8lqC087899;
        Tue, 13 Aug 2019 18:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=RsPoYWfFx7yDcnU5wWZcnHxw2qFhA2LFjkIidqYEbX4=;
 b=qSGichiB1WmFZD3g2tcJDzlFl0o98u+J3t9muSi6WeCPwgKv5FZvFkfQc9CHWVmZ5Lcw
 18v6fipzcQIsZRJYD79vxDYJftg2wNPuOiy9YFEWlE0hmieDwn76FXsevBB5VgtrUC8I
 L8m9EBGMbrZOo7LX7tZyJm0VHZBuBYMBF0qZ+nDjxA7LBiEA3lfpcPDG/PIWyzh6rmdD
 PFOOeHaXD3kkeGBL1DlwcBJn/R2LnwjSObLvsW7WHWZLKoJ7Rwbdn+D6VM5KkEbCFRd5
 xa/6Ekk1pJSJn2QnS1EzWyTtsd7CmQa53+rgG5i3Ns6u3ZLQ99i5X35jmOB4Toa8UXUm YQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjqfx99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7DID8El087629;
        Tue, 13 Aug 2019 18:21:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ubwrga7ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Aug 2019 18:21:42 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7DIGvEx098675;
        Tue, 13 Aug 2019 18:21:42 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2ubwrga7a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 18:21:41 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7DILe1V026370;
        Tue, 13 Aug 2019 18:21:40 GMT
Received: from [10.211.54.53] (/10.211.54.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Aug 2019 11:21:40 -0700
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net-next 4/5] net/rds: Add a few missing rds_stat_names
 entries
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
Message-ID: <9a93fcf5-720c-a771-0329-312a1499eda1@oracle.com>
Date:   Tue, 13 Aug 2019 11:21:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9348 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.22.0


