Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA06730132
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfE3RqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:46:14 -0400
Received: from mail-eopbgr50075.outbound.protection.outlook.com ([40.107.5.75]:33351
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfE3RqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 13:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hI4U9Q9hLXS8H1NyY2xudjZU6gbFkgNCeI1zhItFZuk=;
 b=n4Pl41TAj9J/w+f60iRhLGjARvACh/mDCLl87rPjOfhNoCzwNe36fArVN/vIjWU4xwhaZQKiZ8bFPomihF1Cm3y1cPwgH2LXHrbT8N+WaybFc3+igoy3ReGp8xTNnHTOM1L0HmtA6lTDLK6H65lrqgm1vIFwJ+Bh95Gyx4Af/YI=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3328.eurprd03.prod.outlook.com (52.134.13.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 30 May 2019 17:46:09 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::603a:6eb9:2073:bde4%5]) with mapi id 15.20.1922.021; Thu, 30 May 2019
 17:46:09 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Thread-Topic: [RFC PATCH iproute2-next 1/1] tc: add support for act ctinfo
Thread-Index: AQHVFwbJ/p/rOXTiw0SyKMktH1aCdKaD7TWAgAAD3AA=
Date:   Thu, 30 May 2019 17:46:09 +0000
Message-ID: <26B0B7FA-51E8-472C-8A54-A872C816B260@darbyshire-bryant.me.uk>
References: <20190530164246.17955-1-ldir@darbyshire-bryant.me.uk>
 <20190530164246.17955-2-ldir@darbyshire-bryant.me.uk>
 <20190530103219.048b4674@hermes.lan>
In-Reply-To: <20190530103219.048b4674@hermes.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a02:c7f:1268:6500::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec5c2243-e128-48f3-b32c-08d6e526b346
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR0302MB3328;
x-ms-traffictypediagnostic: VI1PR0302MB3328:
x-microsoft-antispam-prvs: <VI1PR0302MB332845CC4C829F42F92C94F4C9180@VI1PR0302MB3328.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 00531FAC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(396003)(346002)(376002)(136003)(366004)(199004)(189003)(6512007)(83716004)(81166006)(256004)(446003)(33656002)(486006)(36756003)(6916009)(81156014)(186003)(6436002)(8676002)(476003)(82746002)(53936002)(508600001)(68736007)(11346002)(229853002)(74482002)(7736002)(2906002)(2616005)(6116002)(46003)(71190400001)(66446008)(4744005)(76116006)(71200400001)(86362001)(66946007)(14454004)(4326008)(53546011)(66556008)(99286004)(76176011)(5660300002)(25786009)(6506007)(8936002)(6486002)(6246003)(73956011)(66476007)(91956017)(102836004)(305945005)(316002)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3328;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ypg/hMAXafduFGrbePCZLy5vFb4VijDAze7KK/wVZef2hiaYQ5VS+2vbx9JfsQDo8PtVEEm8A/S1Pcu8qtDWBj5BXOAtmeq4v16sHqkk0Icmxu5x/8C396tEjJM4J5p9rnYDgaC8gym0mLG2cFibvBWngWTzxZWWoxKC6Xlt46D9adS7zjItU9dmmZwmBCXoDflK3NoMG8hY22mbU3myKCG5upqb2EJ+gF4zQIRU/dSQafduGye6oR3hTmIud2SXYwCNDcEiyw1aPNf42AgWvXLweaFZW26o3jykco7qpgzxUtWOMImwXVISCwgAWSdiz2tkkqee8UH4DtBKtxLptxGz/WXhmJSDs7jsJYFIrYfjO1H6+wS1aps6idvRumlX7/HETveQ2Z9ZWObmHed/0dpLC3tmuzWinei73ofXHc8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FAFB90280CAF3348A527A0F3566CC0C2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5c2243-e128-48f3-b32c-08d6e526b346
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2019 17:46:09.7305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kevin@darbyshire-bryant.me.uk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3328
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 30 May 2019, at 18:32, Stephen Hemminger <stephen@networkplumber.org> =
wrote:
>=20
> On Thu, 30 May 2019 16:43:20 +0000
> Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> wrote:
>=20
>> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
>> index 51a0496f..b0c6a49a 100644
>> --- a/include/uapi/linux/pkt_cls.h
>> +++ b/include/uapi/linux/pkt_cls.h
>> @@ -105,7 +105,8 @@ enum tca_id {
>> 	TCA_ID_IFE =3D TCA_ACT_IFE,
>> 	TCA_ID_SAMPLE =3D TCA_ACT_SAMPLE,
>> 	/* other actions go here */
>> -	__TCA_ID_MAX =3D 255
>> +	TCA_ID_CTINFO,
>> +	__TCA_ID_MAX=3D255
>> };
>=20
> This version of the file does not match upstream (the whitespace is diffe=
rent).

Ooops.  Fixed.  Will send a v2 at some point=
