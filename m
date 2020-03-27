Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DCA195D3A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgC0R4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:56:06 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:40096
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726959AbgC0R4F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLcNX1nG+rCGBjXkR14nD18GJiog2cklJXqHWaLGBGtX8kLquGp8251dV7BF7VmFiMQqL4Yv80k3HxPqRvxex911A75e/P0tfezo1LoJE8GYaZbc25QGu2AH1rN6/nJNAndCQxgJEbMyjtyM1808pVhzpUvzT3OJQ1ETTPhtKaQVqD/nFfnhDDiZVE38p6W2P2QbXa/J9EoncgJMJUzZwbnBRKARaBFPEx9OMC0KThG9J4W3XZcp7LGvs1zk7koyUnqpAbmDBOlTJc79F/LytqA4Nl2ol7a3KpMcuoKVPL059wC3TcXG1FOIZuJ16DPf5sWqjbyCEeNoe5urPRHkBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzXM2YeWDq2hOJayH+LpgI8Oh532EbTbaG0grV8YWqU=;
 b=QNf9hm0WGTpsxUxcWXV2A+mMcFkI5nNY37ePzesRd6Qm55LXEFR3IBSZdIXPlI7HTHqMCqFOfxamsSOqxT2Y4eU9JHer5YRwkb+DCYABmOPiZrpTLPxksLISpiwcDwpy8fgdTXtR21w+WnRmubaW1Y629x6A3SVIIcAQa9imJ9CtJcZuq4RZ2XIgapp5QTFUiR9YjErAKs2QDgsg6eoycRH8ECuRF4iLHFqNYPmL6maT+5Sw80c8gNhY3gLfTmr+ZY9IqIU1eijTMtNn1e89uJbLWttB5cZ0rNNyCBeoKETXxX9jDIDmGZv6Q+4dvb7OwrmalAsL6qOfn5DzPUAeUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzXM2YeWDq2hOJayH+LpgI8Oh532EbTbaG0grV8YWqU=;
 b=FgB8TeWvp8QYZwD355afsL7WdN5TLhRvSjpJ2xcbQC0hD59ubo7hipe4WUpQXDdRqi4dUo9cHuDQnJftXbkMeHQwzw/WjKi/bs7nVzgORXZqL8NDVHbwzgOVDdkNfhp2L//Xw2SwiCNJSy9f0FGqqXA89L04VHpTJxxOg0DW16s=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3402.eurprd05.prod.outlook.com (10.170.244.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 17:55:58 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 17:55:58 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 3/3] man: tc-pedit: Drop the claim that pedit ex is only for IPv4
Date:   Fri, 27 Mar 2020 20:55:10 +0300
Message-Id: <9d1dcd1037380a57ab8b5aaaf5be9e6888fccfdb.1585331173.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585331173.git.petrm@mellanox.com>
References: <cover.1585331173.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::24) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 17:55:57 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10b3047c-b53d-4701-e043-08d7d2781ac8
X-MS-TrafficTypeDiagnostic: HE1PR05MB3402:|HE1PR05MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3402AF694CAAD2E32C93BCDBDBCC0@HE1PR05MB3402.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(6916009)(26005)(2906002)(66476007)(66946007)(6506007)(8936002)(36756003)(86362001)(5660300002)(81156014)(6666004)(6512007)(66556008)(8676002)(81166006)(107886003)(316002)(186003)(16526019)(2616005)(956004)(4744005)(52116002)(54906003)(478600001)(4326008)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDR33qGKsH8sO1Ri1RqHpEctnEYCpF3GMWPhNw7sERr7FxCZeXgqi/aDl8CeeUlAfErHnjKxMPp713gRvTf9vfqVgGd/B9sqdwbhK9yMGOz5PTPkJsBNN9Z2uh6zvts9r98vvwxv2GLeDdTqpqJqjHQlOChsmqvWWATe/rs799vxMTNt+9IQYoKxWeTzTgRtEMi9jEXkTNeG3unt1LYKrXt0QPIyXb/lV3SEFM8ohK8x6aT82a41jrhzdktIdWqIlU0sTDVNLwO7Nw4CO1m7xSNeY7hHKEqO6hVdfDYFWaE5J09TlqA8iyEJJ27ja5uhWBYVEpwKbgBAlBPfB1A6IH70YmHqwv1TwBty5FsE1bl/P+fK3IUhaheO0xnKhsTdDGUersSiOHT3B4nd+ao5TXLU1vzKn+xBMIerB2hdDqrqLtenkfJkU6YQv199/IiQ
X-MS-Exchange-AntiSpam-MessageData: jQoyNn6QCB0mMEFq1jVBEWRtn0iKWsbaPcFZSBHVg7P04xot9hClTFKL3OZNP00FAvm77cFV4IbskJUCwU9P/8WBmo9Fma+SoKhm5TfDV300H0AfT9mOuFvtM9oU1euaJ2alWTOFwQWOQbt+2whqiA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b3047c-b53d-4701-e043-08d7d2781ac8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 17:55:58.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZA3K1O4B16Krb+JmVETNVvnO4aCQrIS+9qjGlRqq3AKIzKZejcTWtkI3+DCYxYwhDTUYtZBr+aaqw0wzJovPKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sentence predates addition of extended pedit for IPv6 packets.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-pedit.8 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 54b91d3d..ae9f7c2e 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -90,8 +90,7 @@ action can be used to change arbitrary packet data. The location of data to
 change can either be specified by giving an offset and size as in
 .IR RAW_OP ,
 or for header values by naming the header and field to edit the size is then
-chosen automatically based on the header field size. Currently this is supported
-only for IPv4 headers.
+chosen automatically based on the header field size.
 .SH OPTIONS
 .TP
 .B ex
-- 
2.20.1

