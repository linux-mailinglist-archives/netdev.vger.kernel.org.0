Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FD8B0AE3
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbfILJFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:05:14 -0400
Received: from mail-eopbgr10063.outbound.protection.outlook.com ([40.107.1.63]:4853
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730327AbfILJFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Sep 2019 05:05:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXOEZaVr9cJgR6oMQ2DHp7P7HtEyP+htADkP4ab7RpKYM8oXoTOeqUDDt32OYNXVVVTqv5dMvopHNvbxexCzE9CpFZfZnp4UGDjF/JV6XIqtriu6K0LsjQHy0BBpB0uu5OX6Jp0SjT45wiQFrR+j8jg0qlD9Xhc62GZGHzmLzM83Vm9SSwm4A7jA4KKrwhxXABuuR1DfETmQ+jyozv30eWdHooDady13RGWYnEuidYl4+14x7Kd8rU78hCjPQMGLyNUK5G5MrcuzH7UMycfjDegJUSnvNTQ0Pkix/9R7MMgRPolTxfIVJ9EkxIVEaAHvVrHf6XCkcW3eYswyUoJnBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ue2uEKJK/P78L+C+YOvgi7npOWxHADTTVwwdXPD4czw=;
 b=fw8ShUPOkLhCkUc4u3fITfV+LSScdD/cc3KmHd9LACH0dxz1wSwWQH5SNpmYN1txM1NAer4LLV+DaKvhyKwFP9jcBlpQQM9nFyZiCFFMUITZNWCzEVkzP0PUffeHEDe37FRukEgMduPwJLrbfBsujjtCoDa82eLEcPJUTIj2OQyalgnatm1lVZHXShXMk1LlGBRtwS6o8WUDtKFbCFafA5Ajork7tUJkoLPrZP3mc5YfcZp4lGtFQHJEtJgU5OTVLOT7UygY6AAsBSaDh/tFLJboLcl/RF0a01TXYFviJi2gz8fKCcIM3ifBUesFOoJpuheK+1/TFdisjC4UFVo6nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ue2uEKJK/P78L+C+YOvgi7npOWxHADTTVwwdXPD4czw=;
 b=sJ8Bj7hp/d2HuyTCpJNCwgGtvrCKsFhID4/txeTcSmavMv5ECYKeE55XL+n94eWZXzxJuzVFGR/Ld/f+d8Ztz/YHVIQHV7ExXwO3+pa4Fqkd1EOCLPXsMkVlHTB/QcRKTPpu8LloORAe0XG+tNQc0CyS3d1OeLmuFLuifPjXOAU=
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com (20.178.41.21) by
 DB7PR05MB5737.eurprd05.prod.outlook.com (20.178.105.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Thu, 12 Sep 2019 09:05:11 +0000
Received: from DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b]) by DB7PR05MB5338.eurprd05.prod.outlook.com
 ([fe80::fb:7161:ff28:1b3b%5]) with mapi id 15.20.2241.022; Thu, 12 Sep 2019
 09:05:11 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Robert Beckett <bob.beckett@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Topic: [PATCH 0/7] net: dsa: mv88e6xxx: features to handle network
 storms
Thread-Index: AQHVZ/fFKpiR45rTHECGjkP5vPFNT6cmVjMAgAAHroCAALsYgIAAqXAA
Date:   Thu, 12 Sep 2019 09:05:11 +0000
Message-ID: <20190912090508.GB16311@splinter>
References: <20190910154238.9155-1-bob.beckett@collabora.com>
 <545d6473-848f-3194-02a6-011b7c89a2ca@gmail.com>
 <20190911112134.GA20574@splinter>
 <3f50ee51ec04a2d683a5338a68607824a3f45711.camel@collabora.com>
 <20190911225841.GB5710@lunn.ch>
In-Reply-To: <20190911225841.GB5710@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0228.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::24) To DB7PR05MB5338.eurprd05.prod.outlook.com
 (2603:10a6:10:64::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ab6705db-0c5e-4fe8-dce4-08d7376050ff
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR05MB5737;
x-ms-traffictypediagnostic: DB7PR05MB5737:
x-microsoft-antispam-prvs: <DB7PR05MB5737CC6157FAF4275F2AC2A9BFB00@DB7PR05MB5737.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 01583E185C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(376002)(396003)(39860400002)(346002)(136003)(366004)(199004)(189003)(256004)(6116002)(446003)(7736002)(76176011)(305945005)(316002)(3846002)(33656002)(229853002)(2906002)(33716001)(558084003)(66446008)(86362001)(64756008)(486006)(71200400001)(71190400001)(386003)(66946007)(66556008)(66476007)(6506007)(476003)(102836004)(14454004)(1076003)(6512007)(478600001)(9686003)(8676002)(6436002)(186003)(81156014)(5660300002)(81166006)(54906003)(26005)(8936002)(6246003)(99286004)(11346002)(6916009)(4326008)(6486002)(53936002)(52116002)(66066001)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB5737;H:DB7PR05MB5338.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KSP6kkBXJjW9HgV0MQe4maAw0OYYORbHlWCi8dOcgfuUs4RvoBfqJDWv+mQ4cu1itBh/bI8/41PanpqXAYiH2nKHFU+wdwok9JTbvuBYs14CIUx/nKib4ZoEZq0iKSVg7mdQn6Vi4parPQ7X7tYCC9bv7rLJfwLftYXEcPCi00A9THdbPmbHQ7ypGFF5wuR2DEwcAUeSx6Vee/jlcPDG9gROPNy9JWosJWctFsIRKri30zhL/XzeZFm9EctyipdL6sLldjksb0yACfV7GOO7d3wqxlYSpdImtE4h7z7BhwyyPJ7S1x09HugJmLxnpGyKjjmr/Z384GqIlv1Q+wgMbk8l9kk/wrOsKBkrPBLgCOejcfbpD7iCFWLHkvlSKc2o0Ht0GkQBFlTOXoECNp2g54po3p5BsJFLIoulgB5CD4M=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D7329D8A5B00F94A8E191ECE379FE1B4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6705db-0c5e-4fe8-dce4-08d7376050ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2019 09:05:11.2647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PtmT92Vl8VrZU4bZKBjRe6Ox39Oy/tQMGyRHLI8pziYVOB5DYTb1KYfh8STWXKaqFsMnfX7ahxONW6zzXIQ+kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB5737
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 12:58:41AM +0200, Andrew Lunn wrote:
> So think about how your can model the Marvell switch capabilities
> using TC, and implement offload support for it.

+1 :)
