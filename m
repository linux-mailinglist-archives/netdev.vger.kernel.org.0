Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBB312106F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfLPRBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:01:45 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbfLPRBo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:01:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cdj7mU+3ChJ73IPBNzu7fqP4JNEihIK71yp/1xIkfBHH8p/1rHCzsWG57ZvIn9jEn5GrwXZ78Fpj/nu2UY0GY+ABLM8EcQWeYJaS9hKWEtflP8YSDZMH/eSc6m1HWvR8z6ubHgt5YPgwFm7taU+bc998COhkaghOordlUfbYWtgkBcF9yrkX3sAkOgF6cAXaCcc2Rm4gpKKm1/kuMPlyh600/mXJfztjcJdbGmLr6DxpWLt3hCqj7DAhOHXAO8lAbm+hvwpyksH1BH/57j7Wr9sGAwJveRdcEWFtTnP8ooHJBeizZgBZf/Db9nLHxgYEDU39UDoHCDbME2ki7ktssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r2Mho3Uq+QGj4+RoYiEhK5R1K/lk9BTT3G5nljch4c=;
 b=L7NoaVBOZAmsbmTSzNKpIVVoGK9jeBefS0+EiQR50kcpigq/9PFHPKFUy3Cv8mSWXrV1J0v0sfe4M/VBcd8zVMI+EmQlADNiIABP35LWA6E/1y5s58Fu+dKsT/LZ1j4OoxIYVtUPsmCVqCMFJXx8nqm9MV1yqE5MKuGr234G2L007vnFeeq+6+pUXWumoN8MO2CBqAywKnioOZ120fG34aMLTJuVdouc38yjW9u/V8UrL4gqN36xDtBTVeKYw2XccTBs7x5rZDECH0/feD4eRnpPf/QMS3a+eL4FwtjKCiQGoNyUBaNP1NJAbAt7LMnw+tB7Zet5ulxHdpJXZ74D0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r2Mho3Uq+QGj4+RoYiEhK5R1K/lk9BTT3G5nljch4c=;
 b=ERxOMVK402lJcilRMRQk5DWC15MxIwda7QgJZrNLrY2H/8UrLbq6V+If8xpdHR0FH0Y/pKyOHTFHD0Uxx9gA0JLEL4pjPRxqwVulo4LkTIHwlqoNu/n+BWAf/dyOKv76VsOLFxPwxJWVJxu4x/f/ZwnvW8oDbF8cWXU2NvJ/uaI=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:39 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:39 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 01/10] net: pkt_cls: Clarify a comment
Thread-Topic: [PATCH net-next mlxsw v1 01/10] net: pkt_cls: Clarify a comment
Thread-Index: AQHVtDJ7reNryx8FiEiQvhvPO6R7PA==
Date:   Mon, 16 Dec 2019 17:01:39 +0000
Message-ID: <90d96ea707240c2b908fcb4d258aaf33d48d6420.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fe0e0812-3c51-4967-5b43-08d782499dca
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30144B8A8F15023C099EC1ECDB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(4744005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ID+MQb9D2dR366r4Lfj2MrvJCj4wxICqQVWeGvKk3fqcCUAum1LShyyVW0XuT5QTDT5ibSXthQKdh+rsho/HOaHaMiw4iQS9vB0Aq1/miUGtxBRNYi3v/CCw03S5XRXfMUYDBTggMpX3i4rUQVp0VVY8saI6qcid1TIYQczZRqdygz4w/DPKyjCJAizUVXm9dDrEpTGR59SsQCFD8d5bcbDLvlwyGLzrH+pN1sOWh/x7evA16TEHHQ1iTYo80l5xLpY01HMsqbAuqWOlMPEG/+k9GFTIxI2U0CBe89a3IZWdl5dADnPe2qSYLyNOuynTsoIJbJZSX7f5TfdkZ0pQ0x6j2JUEfI4CSeu61uBVJqkRqfkRmKISEBniJcTTYRFwtpAL7s8VNgfzo2u0pPIULYJuzSuWRLcRqz3cM0S6BvEJYCvRQLSPAKSmO3IFKPM8
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0e0812-3c51-4967-5b43-08d782499dca
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:39.5059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Co7n3Z2/1LtQTrevzRCaqOtb730UFVwheanGoOnxgzdRH8JiBwnIHSwbO+ymr/vcppd3T2Tr3J/7WY67Q9YYkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bit about negating HW backlog left me scratching my head. Clarify the
comment.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e553fc80eb23..a7c5d492bc04 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -791,9 +791,8 @@ enum tc_prio_command {
 struct tc_prio_qopt_offload_params {
 	int bands;
 	u8 priomap[TC_PRIO_MAX + 1];
-	/* In case that a prio qdisc is offloaded and now is changed to a
-	 * non-offloadedable config, it needs to update the backlog & qlen
-	 * values to negate the HW backlog & qlen values (and only them).
+	/* At the point of un-offloading the Qdisc, the reported backlog and
+	 * qlen need to be reduced by the portion that is in HW.
 	 */
 	struct gnet_stats_queue *qstats;
 };
--=20
2.20.1

