Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8940092263
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfHSL3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 07:29:54 -0400
Received: from mail-eopbgr50089.outbound.protection.outlook.com ([40.107.5.89]:39139
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727068AbfHSL3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 07:29:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AMiW4aQ4Jsu3SUYBlKT0nhbffCbpOyknwnneOJS/+rllwhZyJogP+wJGMSq442aQuAyAia1T3YMpGV1vZjWMorkJ+7xDPSnOzU+C8o1LEmvn1IZh77dYRnejLG3rVl96UIBGr1ywNx5SJSLoEG4Hf+XJIIXj0dAh/F+L1G6axIykeRaU7OjuZLvbC4XuJ62HkD1XSoYjjXU5O9Lj8tmjj8kgV1rD6KjSZyaXSWudmRfO/TIOEQMYko+7xup2BtV2nM9T/vcHCHIViQm6T5CxG3DHXwkH0pW0KDVtdxMiVzI30wq/JwDy0TmCocYJjvWXYmwTfJLRexsthmugWRt66g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qw3CzSnD3Tv4XlAT60GaTWsb5E7BFcBLhzgJqcT8x8Q=;
 b=QfLhR0ylRr1JCQ6aNUA7zmZS3dum7ySNZuFtAtQCHodLfbndfYl07CuoecMXephQNXZc/Tvz8xDc9sXRiqsx1W+17Q8KWnHBseP8cR/471Cnn2CaqZ5oyYEar5E4j8mLIySUFqP+l9trER4N0HHja+o8WvxRk89tQC/1Twq1rGrENnwzfraqMW2kwrhOIpqLToqB3ZRJ5v7AJP/d5MrLkVJPntAcqK3ohVRuCuGJvaH1SqwiDUhYInnefw1McAcT+yJ6b2L/JOkHipeZCp09cdyitPRtF/L2N1Pqsxk8u1lJIWaiUO9fG0QYPm79HsCQGF0gkL6+OC5bLfRWNF7ByQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qw3CzSnD3Tv4XlAT60GaTWsb5E7BFcBLhzgJqcT8x8Q=;
 b=fujgJDvMn4ysx1axArrgcPbRaXW8IAGTmIgDL9fPbuKAPniPqngbpY73aQxRnATwqhTw7Dnc7QEeTdjTxxjAb9E7l0Uyobz0+9Jj/gnhpGmAX3pWhX3yvBxlNUFBW+8ad/K2tblMKvbQwxXkvjhV90QJF567jvI1ptOiFDGw2HM=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5776.eurprd04.prod.outlook.com (20.178.127.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 11:29:51 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::2029:2840:eb0a:c503]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::2029:2840:eb0a:c503%7]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 11:29:50 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "fw@strlen.de" <fw@strlen.de>,
        "steffen.klassert@secunet.com" <steffen.klassert@secunet.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: patch inclusion in lts trees
Thread-Topic: patch inclusion in lts trees
Thread-Index: AdVWgSATgH/pvtR5S6u0alJsI/umUg==
Date:   Mon, 19 Aug 2019 11:29:50 +0000
Message-ID: <VI1PR04MB5567E279DEA30D7B147F9E2EECA80@VI1PR04MB5567.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 877ec063-7929-4226-54c4-08d724988c7e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5776;
x-ms-traffictypediagnostic: VI1PR04MB5776:
x-microsoft-antispam-prvs: <VI1PR04MB5776953068382DF14475B64DECA80@VI1PR04MB5776.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(189003)(199004)(14444005)(256004)(4326008)(76116006)(66556008)(66946007)(66476007)(64756008)(66446008)(26005)(52536014)(6506007)(102836004)(6436002)(186003)(33656002)(25786009)(2906002)(71200400001)(71190400001)(6116002)(3846002)(9686003)(55016002)(5660300002)(486006)(86362001)(316002)(99286004)(8676002)(66066001)(81166006)(7696005)(14454004)(476003)(110136005)(81156014)(305945005)(53936002)(478600001)(8936002)(2501003)(74316002)(7736002)(161263001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5776;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TrFCeusmXsuLZzbkUlE4RFDbKlRzX4WgTY3B8dfCMMvhT8TKDpUcyMVfFiYTNVefD52/qsq0TgjIgX7D97Q1lyARqo5Yn9Cv10OieGxpVbYgLGy6VvsaEPpK9RqUHepN6WnapdDuAZBZlYA6HCzgPirLcphBixW+EHmtG93k5w8ynigpdYlpen37geNMXO+HAa1Fm0+6IOzb32TjuNnohlEDDYCCrT7IINnrvCwwSy6yejSaXNmfbPfLfPm/Lts1YNQTfV6QqC4XB0bz7heLqYsrQsH5q5w0ONX8ZnUaYhFDsTEjeQXZMoYEnxP0xDNggsOt90HOAKhU2osmBqGM40N/JObhYHpd++3+uvQH2QBSrw6wTB5eyuZ5ewyyb6V+iXZMoXxuwqymCS28liRv0+vjAHLniWNJwJQ6dNjY6/4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 877ec063-7929-4226-54c4-08d724988c7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 11:29:50.5913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VF7E/r6sYlqYZZU/fGD8drFr3eX/KaXLe0BNvjqlTI56uWhfvdL5hXI3Sk0DGkWs3GLaCOrH6DSmA6R09kL/4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5776
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian, Steffen,

the fix below, addressing a problem from kernel v4.9, did not get picked
up in the lts trees, is there a reason for this? Are there more such fixes
that were left out?

Thank you,
Madalin

commit 7a474c36586f4277f930ab7e6865c97e44dfc3bc
Author: Florian Westphal <fw@strlen.de>
Date: Fri Jan 4 14:17:01 2019 +0100

xfrm: policy: increment xfrm_hash_generation on hash rebuild

Hash rebuild will re-set all the inexact entries, then re-insert them.
Lookups that can occur in parallel will therefore not find any policies.

This was safe when lookups were still guarded by rwlock.
After rcu-ification, lookups check the hash_generation seqcount to detect
when a hash resize takes place. Hash rebuild missed the needed increment.

Hash resizes and hash rebuilds cannot occur in parallel (both acquire
hash_resize_mutex), so just increment xfrm_hash_generation, like resize.

Fixes: a7c44247f704e3 ("xfrm: policy: make xfrm_policy_lookup_bytype lockle=
ss")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
