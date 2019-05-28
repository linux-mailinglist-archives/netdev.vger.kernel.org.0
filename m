Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3729F2BDB0
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfE1DYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:24:03 -0400
Received: from mail-eopbgr820072.outbound.protection.outlook.com ([40.107.82.72]:47552
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727342AbfE1DYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 23:24:02 -0400
Received: from DM5PR07CA0090.namprd07.prod.outlook.com (2603:10b6:4:ae::19) by
 DM5PR07MB2876.namprd07.prod.outlook.com (2603:10b6:3:9::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Tue, 28 May 2019 03:24:01 +0000
Received: from DM3NAM05FT027.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::207) by DM5PR07CA0090.outlook.office365.com
 (2603:10b6:4:ae::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.1922.16 via Frontend
 Transport; Tue, 28 May 2019 03:24:01 +0000
Authentication-Results: spf=fail (sender IP is 199.233.58.38)
 smtp.mailfrom=marvell.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=fail action=none
 header.from=marvell.com;
Received-SPF: Fail (protection.outlook.com: domain of marvell.com does not
 designate 199.233.58.38 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.233.58.38; helo=CAEXCH02.caveonetworks.com;
Received: from CAEXCH02.caveonetworks.com (199.233.58.38) by
 DM3NAM05FT027.mail.protection.outlook.com (10.152.98.138) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id
 15.20.1943.9 via Frontend Transport; Tue, 28 May 2019 03:24:00 +0000
Received: from dut1171.mv.qlogic.com (10.112.88.18) by
 CAEXCH02.caveonetworks.com (10.67.98.110) with Microsoft SMTP Server (TLS) id
 14.2.347.0; Mon, 27 May 2019 20:21:46 -0700
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])    by
 dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x4S3LmOR005788;    Mon, 27
 May 2019 20:21:48 -0700
Received: (from root@localhost) by dut1171.mv.qlogic.com
 (8.14.7/8.14.7/Submit) id x4S3Lm2p005787;      Mon, 27 May 2019 20:21:48 -0700
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <mkalderon@marvell.com>,
        <aelior@marvell.com>
Subject: [PATCH net-next 1/2] qed: Reduce the severity of ptp debug message.
Date:   Mon, 27 May 2019 20:21:32 -0700
Message-ID: <20190528032133.5745-2-skalluru@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190528032133.5745-1-skalluru@marvell.com>
References: <20190528032133.5745-1-skalluru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Matching-Connectors: 132034874410573052;(abac79dc-c90b-41ba-8033-08d666125e47);(abac79dc-c90b-41ba-8033-08d666125e47)
X-Forefront-Antispam-Report: CIP:199.233.58.38;IPV:CAL;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(396003)(39850400004)(2980300002)(1110001)(339900001)(189003)(199004)(4326008)(51416003)(86362001)(76176011)(126002)(446003)(336012)(11346002)(476003)(105606002)(6862004)(2351001)(54906003)(85426001)(107886003)(26005)(80596001)(47776003)(2616005)(486006)(42186006)(16586007)(316002)(36906005)(5660300002)(14444005)(69596002)(68736007)(48376002)(2906002)(81156014)(81166006)(8676002)(36756003)(15650500001)(70206006)(70586007)(305945005)(76130400001)(53936002)(498600001)(87636003)(26826003)(8936002)(1076003)(356004)(6666004)(50226002)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR07MB2876;H:CAEXCH02.caveonetworks.com;FPR:;SPF:Fail;LANG:en;PTR:InfoDomainNonexistent;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee3ae233-f181-4602-b265-08d6e31bedaa
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(5600148)(711020)(4605104)(1401327)(2017052603328);SRVR:DM5PR07MB2876;
X-MS-TrafficTypeDiagnostic: DM5PR07MB2876:
X-Microsoft-Antispam-PRVS: <DM5PR07MB2876D9E36A082F51C64D6DCCD31E0@DM5PR07MB2876.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 00514A2FE6
X-Microsoft-Antispam-Message-Info: qvBoCHd/El3xFw5hHll4/JKyfL1YkfLlbjz7WUSoNqEOnFQ8rzcowEAn3qEu+nFILHiBT/dmpS8zBovBTOajJ8N+qxWYQbg4Z8hOtM0E+Rid0im6O1zzFM9VhQFHTmWu/R6WENkk/akc8GuPKnIdwGx0Z6ZsphKl2FNLcq1wR7Aq2008LwKvHvThqHyqfD+WthhsTjNDX3NxyFWRRZ3bpR6+pDlFlCOeZr9TFiH9bkox3tFSTk61Be7DcsxBCsYBUhuaY84PwfrHRc6fmFAiCOYW8ADNmB3ylZSbl/sY19ptGQ8ywr83mvOqfcVps7yw+hvQqQuiP69vfKck6+vFcZ/NNpnDqevspVmn4R5VD7RuNdHOnRNtsWtNRh/Gvvls0W5gtZyUTlJdRvgnFeWtAUK99+ynyE85nS8tLZCp0gE=
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2019 03:24:00.7072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee3ae233-f181-4602-b265-08d6e31bedaa
X-MS-Exchange-CrossTenant-Id: 5afe0b00-7697-4969-b663-5eab37d5f47e
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5afe0b00-7697-4969-b663-5eab37d5f47e;Ip=[199.233.58.38];Helo=[CAEXCH02.caveonetworks.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB2876
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP Tx implementation continuously polls for the availability of timestamp.
Reducing the severity of a debug message in this path to avoid filling up
the syslog buffer with this message, especially in the error scenarios. 

Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_ptp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_ptp.c b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
index 1302b30..f3ebdc5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ptp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ptp.c
@@ -157,7 +157,8 @@ static int qed_ptp_hw_read_tx_ts(struct qed_dev *cdev, u64 *timestamp)
 	*timestamp = 0;
 	val = qed_rd(p_hwfn, p_ptt, NIG_REG_TX_LLH_PTP_BUF_SEQID);
 	if (!(val & QED_TIMESTAMP_MASK)) {
-		DP_INFO(p_hwfn, "Invalid Tx timestamp, buf_seqid = %d\n", val);
+		DP_VERBOSE(p_hwfn, QED_MSG_DEBUG,
+			   "Invalid Tx timestamp, buf_seqid = %08x\n", val);
 		return -EINVAL;
 	}
 
-- 
1.8.3.1

