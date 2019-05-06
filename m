Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2730D15109
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfEFQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:18:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57324 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEFQSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:18:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIZvC177022
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=A7MyrNTjeTi8j6bFsujcy28dnzcN0l0huvXsqxMpRBM=;
 b=RZXk1A2vbZ5UMxL8rqQ3Bp/EwgnRVqdkFQ1QL4YhxBwRHi0uGuczOFZBazF9W/B4I3+a
 7ID4bSK9XFB7MmGlnWd4u2cig8gr/ZrqfaliapXjxbIoBVXhW/sZChcfFefGr+TxhLj+
 bzGAFwrJBqH6CwMpj99yQnx95h4VHKyLmwHNZolN1G+4lNpRFkKtm63C5T+8nEhvx2c8
 mXNe1E19h+MBLRXJp84UFYE5ubDB18PqnYjNQ5cL6kLGWJvuR4xpjhCiIfdyfOHR2m5r
 9KvFQcu1gblT1887Lbk4RV/KEmSsumxw8nPFOPOKDohD0I3pOtSja9654nbIdBiRI88r yQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s94b0fq1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GIR0Y079467
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2s9ayed272-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 16:18:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x46GIq6j030814
        for <netdev@vger.kernel.org>; Mon, 6 May 2019 16:18:52 GMT
Received: from nir-ThinkPad-T470.oracle.com (/10.74.127.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:18:52 -0700
From:   Nir Weiner <nir.weiner@oracle.com>
To:     netdev@vger.kernel.org
Cc:     liran.alon@oracle.com, nir.weiner@oracle.com
Subject: [iproute2 3/3] tc: jsonify class core
Date:   Mon,  6 May 2019 19:18:40 +0300
Message-Id: <20190506161840.30919-4-nir.weiner@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190506161840.30919-1-nir.weiner@oracle.com>
References: <20190506161840.30919-1-nir.weiner@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060139
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add json output to class core.

Acked-by: John Haxby <john.haxby@oracle.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Nir Weiner <nir.weiner@oracle.com>
---
 tc/tc_class.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/tc/tc_class.c b/tc/tc_class.c
index 7ac700d7ab31..68627f4fcc70 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -333,8 +333,10 @@ int print_class(struct nlmsghdr *n, void *arg)
 		return -1;
 	}
 
+	open_json_object(NULL);
+
 	if (n->nlmsg_type == RTM_DELTCLASS)
-		fprintf(fp, "deleted ");
+		print_bool(PRINT_ANY, "deleted", "deleted ", true);
 
 	abuf[0] = 0;
 	if (t->tcm_handle) {
@@ -343,42 +345,47 @@ int print_class(struct nlmsghdr *n, void *arg)
 		else
 			print_tc_classid(abuf, sizeof(abuf), t->tcm_handle);
 	}
-	fprintf(fp, "class %s %s ", rta_getattr_str(tb[TCA_KIND]), abuf);
+
+	print_string(PRINT_ANY, "kind", "class %s ", rta_getattr_str(tb[TCA_KIND]));
+	print_string(PRINT_ANY, "classid", "%s ", abuf);
 
 	if (filter_ifindex == 0)
-		fprintf(fp, "dev %s ", ll_index_to_name(t->tcm_ifindex));
+		print_string(PRINT_ANY, "dev", "dev %s ", ll_index_to_name(t->tcm_ifindex));
 
 	if (t->tcm_parent == TC_H_ROOT)
-		fprintf(fp, "root ");
+		print_bool(PRINT_ANY, "root", "root ", true);
 	else {
 		if (filter_qdisc)
 			print_tc_classid(abuf, sizeof(abuf), TC_H_MIN(t->tcm_parent));
 		else
 			print_tc_classid(abuf, sizeof(abuf), t->tcm_parent);
-		fprintf(fp, "parent %s ", abuf);
+		print_string(PRINT_ANY, "parent", "parent %s ", abuf);
 	}
 	if (t->tcm_info)
-		fprintf(fp, "leaf %x: ", t->tcm_info>>16);
+		print_uint(PRINT_ANY, "leaf", "leaf %x: ", t->tcm_info>>16);
 	q = get_qdisc_kind(RTA_DATA(tb[TCA_KIND]));
 	if (tb[TCA_OPTIONS]) {
+		open_json_object("options");
 		if (q && q->print_copt)
 			q->print_copt(q, fp, tb[TCA_OPTIONS]);
 		else
-			fprintf(fp, "[cannot parse class parameters]");
+			print_string(PRINT_FP, NULL, "[cannot parse class parameters]", NULL);
+		close_json_object();
 	}
-	fprintf(fp, "\n");
+	print_string(PRINT_FP, NULL, "\n", NULL);
 	if (show_stats) {
 		struct rtattr *xstats = NULL;
 
 		if (tb[TCA_STATS] || tb[TCA_STATS2]) {
 			print_tcstats_attr(fp, tb, " ", &xstats);
-			fprintf(fp, "\n");
+			print_string(PRINT_FP, NULL, "\n", NULL);
 		}
 		if (q && (xstats || tb[TCA_XSTATS]) && q->print_xstats) {
 			q->print_xstats(q, fp, xstats ? : tb[TCA_XSTATS]);
-			fprintf(fp, "\n");
+			print_string(PRINT_FP, NULL, "\n", NULL);
 		}
 	}
+	close_json_object();
 	fflush(fp);
 	return 0;
 }
@@ -450,10 +457,12 @@ static int tc_class_list(int argc, char **argv)
 		return 1;
 	}
 
+	new_json_obj(json);
 	if (rtnl_dump_filter(&rth, print_class, stdout) < 0) {
 		fprintf(stderr, "Dump terminated\n");
 		return 1;
 	}
+	delete_json_obj();
 
 	if (show_graph)
 		graph_cls_show(stdout, &buf[0], &root_cls_list, 0);
-- 
2.17.1

