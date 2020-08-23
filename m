Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A1F24ED10
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 13:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHWLUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 07:20:44 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23566 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727043AbgHWLUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 07:20:30 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07NBKHwS010534;
        Sun, 23 Aug 2020 04:20:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=7qCr0ZbAh11cPA3cJm2/V5vbDomRHvJ5JfQBPJK1scI=;
 b=ACQXDsc1r4GU44HyzjLgVqObiwv6Mqb12qPbUF/C7L+OzmrBbNv/1oN/YslF7y5vvWmd
 3vxiSe7TvyhEeqMc3zNOmXkHEOxOWwy2N8PkNAV9b9fIEi2nVDmGEls7tsktqZic9lrt
 zzi9IQoD5pt8jNpCdwiBxNrJ3ucesUfQ/CJYZNf6+2RygNzwRrLu9DtY4nXnFPpUj5ul
 bGj+NcMwCBKtujW+SfGIFqWFqnChcOzvJCm9F+e53TpH0W7ZU7c15ALjsC+R1J6aG9Fl
 zNsmigV1U5Dnq8IenwvSFWgtgxDus/l71phx5cNsu/gXamudKiZXP9yAB7aaOPpRT0j4 bg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpb9pa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 04:20:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 04:20:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 23 Aug 2020 04:20:27 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.193.54.28])
        by maili.marvell.com (Postfix) with ESMTP id C618C3F7045;
        Sun, 23 Aug 2020 04:20:24 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Igor Russkikh" <irusskikh@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH v7 net-next 09/10] qed: align adjacent indent
Date:   Sun, 23 Aug 2020 14:19:33 +0300
Message-ID: <20200823111934.305-10-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200823111934.305-1-irusskikh@marvell.com>
References: <20200823111934.305-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-22_14:2020-08-21,2020-08-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove extra indent on some of adjacent declarations.

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_if.h | 69 ++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
index a75533de9186..56fa55841d39 100644
--- a/include/linux/qed/qed_if.h
+++ b/include/linux/qed/qed_if.h
@@ -850,10 +850,9 @@ struct qed_common_ops {
 	struct qed_dev*	(*probe)(struct pci_dev *dev,
 				 struct qed_probe_params *params);
 
-	void		(*remove)(struct qed_dev *cdev);
+	void (*remove)(struct qed_dev *cdev);
 
-	int		(*set_power_state)(struct qed_dev *cdev,
-					   pci_power_t state);
+	int (*set_power_state)(struct qed_dev *cdev, pci_power_t state);
 
 	void (*set_name) (struct qed_dev *cdev, char name[]);
 
@@ -861,50 +860,48 @@ struct qed_common_ops {
 	 * PF params required for the call before slowpath_start is
 	 * documented within the qed_pf_params structure definition.
 	 */
-	void		(*update_pf_params)(struct qed_dev *cdev,
-					    struct qed_pf_params *params);
-	int		(*slowpath_start)(struct qed_dev *cdev,
-					  struct qed_slowpath_params *params);
+	void (*update_pf_params)(struct qed_dev *cdev,
+				 struct qed_pf_params *params);
 
-	int		(*slowpath_stop)(struct qed_dev *cdev);
+	int (*slowpath_start)(struct qed_dev *cdev,
+			      struct qed_slowpath_params *params);
+
+	int (*slowpath_stop)(struct qed_dev *cdev);
 
 	/* Requests to use `cnt' interrupts for fastpath.
 	 * upon success, returns number of interrupts allocated for fastpath.
 	 */
-	int		(*set_fp_int)(struct qed_dev *cdev,
-				      u16 cnt);
+	int (*set_fp_int)(struct qed_dev *cdev, u16 cnt);
 
 	/* Fills `info' with pointers required for utilizing interrupts */
-	int		(*get_fp_int)(struct qed_dev *cdev,
-				      struct qed_int_info *info);
-
-	u32		(*sb_init)(struct qed_dev *cdev,
-				   struct qed_sb_info *sb_info,
-				   void *sb_virt_addr,
-				   dma_addr_t sb_phy_addr,
-				   u16 sb_id,
-				   enum qed_sb_type type);
-
-	u32		(*sb_release)(struct qed_dev *cdev,
-				      struct qed_sb_info *sb_info,
-				      u16 sb_id,
-				      enum qed_sb_type type);
-
-	void		(*simd_handler_config)(struct qed_dev *cdev,
-					       void *token,
-					       int index,
-					       void (*handler)(void *));
-
-	void		(*simd_handler_clean)(struct qed_dev *cdev,
-					      int index);
-	int (*dbg_grc)(struct qed_dev *cdev,
-		       void *buffer, u32 *num_dumped_bytes);
+	int (*get_fp_int)(struct qed_dev *cdev, struct qed_int_info *info);
+
+	u32 (*sb_init)(struct qed_dev *cdev,
+		       struct qed_sb_info *sb_info,
+		       void *sb_virt_addr,
+		       dma_addr_t sb_phy_addr,
+		       u16 sb_id,
+		       enum qed_sb_type type);
+
+	u32 (*sb_release)(struct qed_dev *cdev,
+			  struct qed_sb_info *sb_info,
+			  u16 sb_id,
+			  enum qed_sb_type type);
+
+	void (*simd_handler_config)(struct qed_dev *cdev,
+				    void *token,
+				    int index,
+				    void (*handler)(void *));
+
+	void (*simd_handler_clean)(struct qed_dev *cdev, int index);
+
+	int (*dbg_grc)(struct qed_dev *cdev, void *buffer, u32 *num_dumped_bytes);
 
 	int (*dbg_grc_size)(struct qed_dev *cdev);
 
-	int (*dbg_all_data) (struct qed_dev *cdev, void *buffer);
+	int (*dbg_all_data)(struct qed_dev *cdev, void *buffer);
 
-	int (*dbg_all_data_size) (struct qed_dev *cdev);
+	int (*dbg_all_data_size)(struct qed_dev *cdev);
 
 	int (*report_fatal_error)(struct devlink *devlink,
 				  enum qed_hw_err_type err_type);
-- 
2.17.1

