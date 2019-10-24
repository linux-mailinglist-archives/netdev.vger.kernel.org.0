Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F40CE3C26
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437240AbfJXTjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:39:14 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:46757
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406506AbfJXTjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:39:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjlKXWBiluW46zusZmXqcJjHhc8XTOTLr1aGoswZBurOZt0sQ/biSxi6dNOt1XIGM5YOsU0oTrKRuKbOR5q3K3lOiFmSkND07QFLrrHEk5nYq6+KJg//NLGr5pWiTKVfapCR5PNs5ALqYPWTgeAT9gE0mxeVLa2G50Xk/6BJ99itMGwkLvVITO/Ei0djcwTJM2SjWGh/XGwWdFqCQbvmG7tnhwASnJ5SgwPAehGben65kAfOW5EYuBMX6KEsCUwbof35MpGj1h84iv1klndET22cMOd53PrXZnAxjxLhqHd54ztjmK3EHglFn3Qa+nl48vU5roso0/vNfx72aVuCvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BSL/k96BG94PzpfQnMNGNjfjfbpgzOxrt+EmSpTynU=;
 b=lHDqz5JX2GRdLAgahEWGEo1k6/IxtUNE0qIuc13zFAt/mD/ijLvGubOn8TwUGpNFphj8TzhQ5PvFxIfE7v54fFU4mjZkiwn+SREYcpnTwmPUqThHFP2piC9VWD1MZ6nr2arabtPVc9AYe3gtkJf4i1QO/eXJnrAvElk8gTjb6aOOoE7VbGTLDXsRDYdXrfrem5cLJcecbDvS4l2jewiUgbnBMTyezisg07mnwxP4Lufh52nScejR1TTwn5rpxRrLctz+R8+R65EDPXmYh6rXlWj0m9njqoe9talVxToNWSwhPv415cKdCTWIxzy7oIvpe60Xm5DW3PnubCLTvJsSTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BSL/k96BG94PzpfQnMNGNjfjfbpgzOxrt+EmSpTynU=;
 b=SaZgmbt1g0maHtXAUczu/VArU0QHDRvAZ5hxFq07gTQZULSYY75RFGRqJi3ccYPPknsTyxRvGyeMEzLFCnbU9wM8qAk83X6Esi0d8Ch9XHjq+Nr9KNnJxJsGfEPuUfrcAr/qEAvyij2VqvAduHTs9aIG+ks8XXxCgSOvxavR3Xw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:39:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:39:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Topic: [net 11/11] Documentation: TLS: Add missing counter description
Thread-Index: AQHViqKwypFr0YjBW0+s0rv71ft9FA==
Date:   Thu, 24 Oct 2019 19:39:02 +0000
Message-ID: <20191024193819.10389-12-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea0eaad9-a86e-4a93-8228-08d758b9d29d
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB462326124CB6ADADC93DE167BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +wSphy5yXV6qw67J5/rdf8XlultkCUX+sl6d6XJJtp4m9UxMHUOITTwgjPHgSUH9RySgEJl4YHpn4IfQSnWZvoTF4hpU4g28/cxbRjWw45cSFQ7e98J7adxSl7CMQaVydsI9BIKnGWR0Ty1I8lL7D6ZpgzUAxC1jCLAEkpsnG5jcN6zu1KK6dVtEjVekFTwQrrg0UvQbw4gP207CdLDU74H662Pn09TU3sJ2JCtm6ToCSb81XCk3ZmTS0ZDESPXthnLm2ZUxe8QmbJ7ayyM5JNRbwRDBaV6azXePLxIhwT0PwcV0byPL8wHzKe2HO9tsC+XRMqTwskOItD8qHRzq142o7Xw7hGTTD6Uw4lpDe/hpDwWovS5gk4hpGJGYTl3W0yDUr/YitKv7rwHNzBjScgXleRNDCmdUZQAITHZeUw5ERKSWX3xyQGXriKPvo8k+
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0eaad9-a86e-4a93-8228-08d758b9d29d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:39:02.5794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: icku7RyCyRu2qtg5uCGp430tgX8FU9GN3xxfTK67yD9kgwbJIkCLuVdgjajMQCTIFR3CvDE3XjTj+FJGu5O57g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Add TLS TX counter description for the packets that skip the resync
procedure and handled in the regular transmit flow, as they contain
no data.

Fixes: 46a3ea98074e ("net/mlx5e: kTLS, Enhance TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/tls-offload.rst | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/netwo=
rking/tls-offload.rst
index 0dd3f748239f..87db87099607 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -436,6 +436,9 @@ by the driver:
    encryption.
  * ``tx_tls_ooo`` - number of TX packets which were part of a TLS stream
    but did not arrive in the expected order.
+ * ``tx_tls_skip_no_sync_data`` - number of TX packets which were part of
+   a TLS stream and arrived out-of-order, but skipped the HW offload routi=
ne
+   and went to the regular transmit flow as they contained no data.
  * ``tx_tls_drop_no_sync_data`` - number of TX packets which were part of
    a TLS stream dropped, because they arrived out of order and associated
    record could not be found.
--=20
2.21.0

