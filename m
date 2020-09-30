Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3022727E058
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 07:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgI3F31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 01:29:27 -0400
Received: from mail-eopbgr100120.outbound.protection.outlook.com ([40.107.10.120]:19616
        "EHLO GBR01-LO2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgI3F31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 01:29:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akQ5W6dkV3OobqAFiJvzWC/Qrb5xanKVy0VZ9KqwwIzbBIsX1BM4zhIGWlQyCqUqxY7Oy4w7A7P2K0qNryGUo1GBhd75msOiq4Zv/MNzL/4Ze8zNKeeaAr3TXVPTcAaJs5O03z7tGWYaBgzs8NEouX9CuhJrBhvBms6XE4Fai5tyTUdHgRLZ5X7EQLKRNNAulw476ToEWisqRKoN1CbzKkEjmHLQcGbWVbCuYRL+jVwPrsClvDBCZCpP3cJR79vm1x8Y2+PI2vjjpQFyaClqfpqx6ooF9jYtbr9Qvl3Ttz9glNjpPpix2i5FGSEHiijMnIflt7Qp5CkC5LjPaf0fow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tutr2RCClZVWeMZE6qG7csybtPUs4H2PHeTKVpflSPc=;
 b=oe60aNRgNBAR69H8HV1i2TCVDRdHR8FUi/j5psr/nDXjTTEUPgl+JLMDKLYUsL/2Zq/uQiKJcIlR8XJbXIYRyXN9kraT0Ocxh33ASpM4YLPrfEkxCFCdCgRXw29wKxAc6tV4KO6XVnsyTkiHIMUuT26qB0IwzZDX3Wc7jL+3uhleO4kRVVgVJ6HWZEv1kUYbnRe6Exj9MQw4QHtIdWDa94N4MwsrxaThJow/xOSiMHFCa7JhpuZcbRecrpsnX7HNIv4wVBkeWtuigRO2WWyRslqTfTMP+pKDZso2jk8JVjHmyUi3/CFpJWpY7UotehRN6ocoYOTP/dPLrL/6PeqlTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tutr2RCClZVWeMZE6qG7csybtPUs4H2PHeTKVpflSPc=;
 b=jFiXEpoqLqHVN1GKFxd/QcnG/xH+j1CUNXpXkxUNlVo2zzzSurgXSw/LJv7IXAmr/royhKA8hNIkCr+LnTTR7qbpHPoqdC2k0orvztUkNHvJT/jLDjMqU8uzR+22RfYhTThUDhf8Ee3pwa7W3vfPgYWedz6SjxzZkIAyDkelboM=
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:6f::14)
 by CWXP265MB2439.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Wed, 30 Sep
 2020 05:29:23 +0000
Received: from CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f]) by CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
 ([fe80::e102:fffb:c3b6:780f%8]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 05:29:23 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Thread-Topic: [PATCH] [v2] wireless: Initial driver submission for pureLiFi
 devices
Thread-Index: AQHWlYEQBtpUmlBsIE2OcjRvCcmkD6mAppEAgAADTrc=
Date:   Wed, 30 Sep 2020 05:29:23 +0000
Message-ID: <CWLP265MB1972EC8E3D4BDE977F11C8F5E0330@CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM>
References: <20200924151910.21693-1-srini.raju@purelifi.com>
 <20200928102008.32568-1-srini.raju@purelifi.com>,<20200930051602.GJ3094@unreal>
In-Reply-To: <20200930051602.GJ3094@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.104.125.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daf1552e-969b-4e57-31f5-08d86501ca6c
x-ms-traffictypediagnostic: CWXP265MB2439:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB2439195F010B26FAF5A53D7EE0330@CWXP265MB2439.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4kLO4p2DE8Uedpx15ElBnFHJ59gBh/bqtL9F/MkUGEtUcvnTkb9B28+XwitfsEyrpDa/Ems5cHK/SniSZt9d0g6jAky4rMOV/v82D8gxQCilZKhF/r1Dkm56bmRRq/gd8PJs/4m5xFIRg8Rl/DwDn07F3ucEmp2R10B7K1hLVkpnbfxsl8DPThYA5HsbWClv3/RK9kKZH+JfzMo2tt8ut20OLs/J15zbIruvi+ykJMH7vXL0MVedJbHWOdtmldS4ihaY3JpD0q0A1IxILUdqPHsj4edmXb3/bRsvgu5XHOBckKz2k+keYxogL2OLNYb8581uC8P4YpfSEYKOqbqsYp5+NB8lKKQ62Hb7jdVvfOCqMEJSRXVSrNpKLMvEqrwu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(346002)(396003)(136003)(376002)(39830400003)(366004)(9686003)(8936002)(8676002)(2906002)(5660300002)(558084003)(4326008)(6916009)(55016002)(52536014)(6506007)(7696005)(316002)(76116006)(91956017)(54906003)(478600001)(26005)(186003)(33656002)(86362001)(66946007)(71200400001)(66476007)(66556008)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: i7+uE7bJmGc+dMWXTtrC+3bzEWI9fyclItmwTb8Zz/cByEpk7e8QnYG7OSWlyYuKhWaEdmKz2alksBDQuhLyl9awc0WJkdf8SQW5NFg3nOUheAutavU/snQnnq6db2QUOrIDotEFe2b6KVqlfz4ulk9y1grLtNeAo02AAG8m1SeDxLu5lW/IvJaFhYKot7A29cMrqyTpgDjao++H3SOst9kxtSITQ/U1WKkLkOZ33YBnR0ITmnmsczyOtPGLK5vYdfpxEVbt9Hpb0vcYWMEKbhhlcrR/P4Gkwz8TTOe1tf7GxvaKMc0TPkUi055OFhKx8xw3QYVKttox5n6hh/lW3LjsLELN43ZRhKYtPmqIz5RmhVELQD07lF+8khYeSWYuvjcY05njYJmYWOAGKMmgzqNMKZgwAvbs3C90FGmpSQrUfiLW8LQN6V+VizRsY2gSVIfQJqYbOXTrW9B6gHjcjpsRlN6CKxrjsx5xeSb1g+WYE9CyCOxUaugdjJvG0Kfed2L0nMwXffjrfAO80OsCUW6t3HVmn8xq20Z52axpvRPUPIV0U1+c7wmyz/5H3FQ41UamHJItAE3rszP1PlDqZ6FqZzCqc6K4Q2il84fw8t8+ApHSA6NNsHw3gokZ0dWWzjZh6ZG7N3SL2wd+AW/ewQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB1972.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: daf1552e-969b-4e57-31f5-08d86501ca6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 05:29:23.7111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: om+wb3mW1Z2+t8fWJzPDFxMQDD+18f+FTtdzuj32tmCZ1uyLXZ+xmU8tPA/MaZg453Ugch1H5c3/FkUcAV3Vxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2439
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
> I stopped here.=0A=
>=0A=
> Thanks=0A=
=0A=
Thanks for your comments Leon, I will resubmit after the changes=0A=
=0A=
Thanks=0A=
Srini=
