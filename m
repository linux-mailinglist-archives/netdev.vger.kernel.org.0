Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE721C7FB
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 10:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgGLIEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 04:04:39 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:7664
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbgGLIEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jul 2020 04:04:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CORIPJNGFU75Rrr71cEWMBlFwhdJsQxsQo5WouZDS0SnQWNGCz9PMWbDy+R5Jemef20yfMbKkK2xnKJldA3PCrM5opiigBV9Uvx1eeXD8YEP7mctZLKv06lC/WvKiXMCkw79KcDoSi1YpDTigVDnGheY2cJ3yryeD1MOfpAcrVxdrkLWVf8l+N86ZZRguapfsqn/YoDlIrYWRz2VDk9BN9hdvmQYcOHf9CxzKkK6bDLjBgFaGuFrlpHFYBExfb4BdCp0szXMzEtLNBLHEWImVg9s99JB3xGsqK1590i+XiM6qLzuFdqFTrVwEUCMAB2ukgHLh2K3aNc4yfpyYFX9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4Oe+mHv7qu2j77OHGf49GODL+IeoJzKVlteSqhgPDQ=;
 b=RFGKJUbzpZPTWbQ6jk9uVl0wTa38O2CFlIOY/yoQIRoptSakLlUiV8FHaN0VTOHKMyh/YJf/EwCtFN5v7pV9fMSU1gteCTr4DCWseZjcuxT3bnChSt3VRSJCf248gIHdWbIL8TjxmsQBOrAAbNCui0pxpDpch5MYMGoE7E7u2gxbupKzPAbIiuIAb6hVrdH8A54TUpljDULREwJ4sTqKtvA2CysHW6JfewPLV3nVdMS/i49d/RvObcgmuzic7rss7h5nKP8YHTXiHzzG9qY1J9fVI88LRKscwq2UFqih6mK8jpqpbbEZEsjza8JS7YwFpAOm4t57LL/uix3DbKK+LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4Oe+mHv7qu2j77OHGf49GODL+IeoJzKVlteSqhgPDQ=;
 b=hcz8+720RmutCGfviIY6vwR/1gZqlJPJ5F1ZYFYX8adIme23tcxIQB27J/+inr+yyfvU5jCz1PFYZ8ujc0jeTvaOhB/FgnBtp4SgCH//By0W14tKgTcjx1Zj1B0wxMG9H0dMDm4J4tLwVjiBRIS7zwZMTuLI1V9sD0yY28RLpmA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5634.eurprd05.prod.outlook.com (2603:10a6:208:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Sun, 12 Jul
 2020 08:04:30 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 08:04:30 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@mellanox.com,
        Danielle Ratson <danieller@mellanox.com>
Subject: [PATCH iproute2-next 1/3] include: Update kernel headers
Date:   Sun, 12 Jul 2020 11:04:11 +0300
Message-Id: <20200712080413.15435-2-danieller@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200712080413.15435-1-danieller@mellanox.com>
References: <20200712080413.15435-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0902CA0018.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::28) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM4PR0902CA0018.eurprd09.prod.outlook.com (2603:10a6:200:9b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sun, 12 Jul 2020 08:04:29 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6bd775c-319a-4767-4a91-08d8263a3461
X-MS-TrafficTypeDiagnostic: AM0PR05MB5634:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB56346D67692B3C7E01056380D5630@AM0PR05MB5634.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16JrjqhAEV5XjrylWdQo23e7rOIJ0tHwE0ChuZZ53+jE4C/LOyaU9Z54jHU0nt28ymFiYA/rkx/tTWJxDHq6+1TOsb0GbW+JbN45XNqKjrC7Q1h402B9a+2dtWBbvuVIKIfmGsIgTzspFGkVoxx64CKeYu0bFuUcMkfyw1W0V+5C8prbsKuynDNoP69NOzGf7+gXu+xHVCnT0CkLvx/+2LwoKYF9L2O1JlbxeBuQIlShGlGYeL13mJS78mu+MCqg8YtHGIHB7VTawo04+JZ45m99jTS2+PD9HWrJ9fuGN/rSnYfCmNfeQdd/dFlkS92Im8UX9oF7gAgTdsnBznDppg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(376002)(346002)(366004)(396003)(107886003)(5660300002)(6666004)(316002)(1076003)(15650500001)(66946007)(186003)(52116002)(66556008)(16526019)(6506007)(66476007)(4744005)(26005)(8676002)(6512007)(8936002)(4326008)(86362001)(956004)(2616005)(2906002)(36756003)(478600001)(83380400001)(6916009)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JeSZp9Eh6z7TB3DGZZ7OLJG0xzr2pncW4jzDKaNtCp/Pz3/iOntE5YltRdOev8aCgmie6D8s7UWyfuGCKajKhb0jznqGKoL0NDrIa5XnV9w1fTBIeeesfPdCEZ5P1JcC9qVZ7K7nhNmOY1zGjyTZPeUWOqmYpmsBuEOluO7Mu/ldWhZD7bzKHqA1XaG82aYxl8P72vehjsjwjDuq4ZylLdUIZoqrbNrP7kSlZUrUk1yMj/qWshbnUP/4E3pzr+S6cGdHU/UtnIonF7iRlHbUgYjaeLkqjejz18j+DrYdP21AelKVre1dzlb+lBXwGnMjC73TLg22s/b9PTcRZgud/B7+jT2yp4CvYEjph7n0m7av3WS71nOzb+JKMux9vCvS1lT/lTUCBeutMlGMnZ1w7HoJxRZlY+yKUvxrfHh4tc13jTEy6F24F5Miz3W5XEdKl82kIabJWfZerGLavAhARRxLCY2vOq1XmpA0PJPlNO8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6bd775c-319a-4767-4a91-08d8263a3461
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2020 08:04:30.3803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANapkMTcXHl8R4PVB6cFBdqfshcyVz7HWQR/lSH87ToWZ429aqKa+NN21Ao2b4atXmV3yzmZ/UNDC+AU8HUKPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5634
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers for following commit, with new devlink attributes.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
---
 include/uapi/linux/devlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index d3ee69ba..b7f23faa 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -455,6 +455,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER,	/* string */
 
+	DEVLINK_ATTR_PORT_LANES,			/* u32 */
+	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.20.1

