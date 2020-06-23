Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B1204F73
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732327AbgFWKo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:44:59 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:11647
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732257AbgFWKo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 06:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgRQsT4U6b/fN0kXrzzeT830p+BIA2YbRG/xDtNW9X/IYgSxhmy5pUcpjcKq0Ng7aM77q9w8THVoCxj9sEi2SFx0CsY5HNnonbxwAltVa2Cj0E1hSal3gK/or+6Tkb0KaHG3QNDyjTXK7EQK800Cbg5UY6F/F1J/IQKIjbS/506uoNqPjuLdFpzbkZFy+tFdLeSceR2jsXkjLfT+Qk6RghRbxgi5Ncavfc4F29D40ql77WFeQWgNv9xWRudUSMeJGmj3Tx0KI584dzpp6J/Y6IzMKr7+nXcOyVvA1DXyQ7OA1K8Ufhn6MnJwq+h7jukkKS0zrNR8jupbLn8u4dUsLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z34DgZK8ibKTaYsXnfVg8NsmFj7mYmX+OdOVZg/bWtE=;
 b=QGPW2cmmGtMmWOgqR79TxbW8p3I9d+1YpcdBtj3iy+oMZTrbgT3/8QIQ4fSyGL6rtkPE87B2H4SeejPWkfLHD5Vtn8cr3pjwyJ+xyE2viZgdJLdLi8FOs8klZPl0zYlgCNnn2ZQlr8/k9meOaDFcCkqTyxpmHutYnnyRKi+1DpUptBT7F/Rjv4P1Ai1h8RvPxis96jRP192JtA0w895Icj3f4uuL+GOjmBkN53wfW42B2iLAnd4RYh3p1MIj0glpBcWPto825EMf/lQ89EnSK0Gzu6Unjrf0xx/b1P1uelOsan3VSSdquW84qgrBHMoz2ZMOvNE1dJb4VLdLrU1+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z34DgZK8ibKTaYsXnfVg8NsmFj7mYmX+OdOVZg/bWtE=;
 b=mCBAeIM/YXljINERlnFCHm3ZXCOtShkP25QJaexcwupZFDrQgOcb9UnAdZoudUqGiZ7vYeRBiftD4sS6gHflORt4/ZWDJi0MUtke48YqFa/d+SQYZHGuGtx8mKuhoTwTNGO4W180eIhVCQjXSVkQCt9zzctokFSfFmMTmE4gj3A=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6034.eurprd05.prod.outlook.com (2603:10a6:208:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 10:44:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 10:44:53 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, jiri@mellanox.com, dsahern@kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH iproute2-next 1/4] Update kernel headers
Date:   Tue, 23 Jun 2020 10:44:22 +0000
Message-Id: <20200623104425.2324-2-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623104425.2324-1-parav@mellanox.com>
References: <20200623104425.2324-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0035.namprd02.prod.outlook.com
 (2603:10b6:803:2e::21) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0201CA0035.namprd02.prod.outlook.com (2603:10b6:803:2e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 10:44:51 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7734854b-c458-4cb7-a467-08d8176275d4
X-MS-TrafficTypeDiagnostic: AM0PR05MB6034:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6034605924DD8FF992378101D1940@AM0PR05MB6034.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +PP8Xe1U2Tl3/n2hukzEb4eqk8PbTkGVU/bBhZpGpb2ITxr9XeNPTHu+xI2ghSmevFxu/ox5FcTjuKBFxIB8r75JpjONSVK5rr2UPjoweBzVR48xkAUbsXS7m2fBgtsCr7CKARXSDORkfDYT9cW4Og5LWt3OJoYRD0zw8kQYzNB34WKO2cqfKLVH6aqcfd97qUCDLeKzYN8leUIwqjaKDI1P6J8zPBagP+FEvXRbyx1tVbHh2PmW2gA4uvsTT2GTTy4mOTwDOEJwQiowAkdyBL+nSSbmfcCuIMtljacRTvjFgZTBSGxBpP5+iWOnu/miMctjrBTclgTidm5G+Onc/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(5660300002)(66556008)(66946007)(66476007)(1076003)(478600001)(6666004)(316002)(16526019)(186003)(26005)(8676002)(52116002)(6506007)(107886003)(83380400001)(6512007)(86362001)(8936002)(4326008)(956004)(2616005)(6486002)(36756003)(15650500001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oYbRBDxMacJmHFkV+wXBVSCAqp1LQaFm9pecU3GPoc2SmrH/FQ3TWMKUfl4zvJfElbdBRh9hp4cVa3/pQSsZJq+JdylzOFyIAXak8nEVs4n6zaVkjf7vqw2hMx8bLH7NNINvq9GVBkq5559y/w9fO4fZWSkG8JYo9dHPoTrVyDFIQRvt8np7vfAIGQw+32Oszv+MysEm3g8vFrDkCcbzyleBqN1XVisNK8aWvwBHz5wErwMtCjpXNpr2hJpYUcmbz80rwTdHNQjKUtWxxH/Ewd+sRm3JjD0+UZdKtV21TaLgbR6GfIJZhLEPrDLEAeitQUKfECbZ8EZivf7sUYAkFMSkxjP9BosY451kkcK7189g7AYXdD8Q/rXsiO5oji8l+x+a20naQgrRF6jmXFp7iX7XLSqZUuZQ+On4f/4jpN7VPPPp1YnBXfluMX0LpHw1Ar0nYHOWM7W4ZRxgRCRprvPRJkM9P0O+veZqBZs/lBONKLIDQO/rZJy60H6OyvbW
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7734854b-c458-4cb7-a467-08d8176275d4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 10:44:53.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACQJERCI/WfDKzMdgYxrWH69AvYE16iT+FllaRlc+6kYHAKzPoIcPDxVPYTp16KXBs4p0Ks86fkVqHB/DZ2Xbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6034
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commit:
   b5872cd0e823e4 ("devlink: Add support for board.serial_number to info_get cb.")

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/uapi/linux/devlink.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 7b600bf1..d3ee69ba 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -451,6 +451,10 @@ enum devlink_attr {
 	DEVLINK_ATTR_TRAP_POLICER_RATE,			/* u64 */
 	DEVLINK_ATTR_TRAP_POLICER_BURST,		/* u64 */
 
+	DEVLINK_ATTR_PORT_FUNCTION,			/* nested */
+
+	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
@@ -497,4 +501,12 @@ enum devlink_resource_unit {
 	DEVLINK_RESOURCE_UNIT_ENTRY,
 };
 
+enum devlink_port_function_attr {
+	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
+	DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR,	/* binary */
+
+	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
+	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1
+};
+
 #endif /* _LINUX_DEVLINK_H_ */
-- 
2.25.4

