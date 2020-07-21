Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E779228130
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGUNmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 09:42:20 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:14768 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGUNmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 09:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595338937; x=1626874937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
  b=dQUJRm1JR2W8sQxw/qYTJ3/rwQLhCFm3C5bxMBVCcFkyHtFgO3/jAmtJ
   m1S2Tiaz43x3XlJTm45cnWIlmX1UWhosAoiAnlAxbCFfIZ2eTVQc8Nc+U
   jSp9ZaqjzKwFMbiQojrNS/RnnG+G0QR61C1cOdh1Mpz+XOppkOK7e4UbO
   cudf+qAe5WhUhqd3386RYBaWOITbP1v3d26DIPKw/QlReS6Au39bMg4Hr
   9oIU/m2d5cFjLR7zkh4kAiEWcu/jTBC34GqGpxSRwTap7idyn2LpteMnm
   mhth02xzTZCPIkdCUN0iNgn5AvPZCr6CuDb7H0Acdtc8XA/1al8n4R8py
   Q==;
IronPort-SDR: klCkh6v+AUqHCc5vkH4h5JmmydmFdbM0VTg60K8x9ezAOJexzzgrwZ0cJgbX63qMeyaBJarkRr
 gofphkE4fAqwixIZpAdj0cSrYHK4512TOw2IOjhpqQihLJEe+Hby5o/9PvA/BsqJZXQEoFKruX
 7BAbDGGKSe4aKj7KJVHHQdMZm62dRakLg3RuuxDzebB5ef38pJzmoJOjv/Y3iVFGVMUYtn8dN0
 WRVG7TJfyZLSx4iGaevgSBui5pU0XjxKmdHon4d4Nkiiqfb4x5vi1w1/hHRHsj98pCpCn2HvmD
 apQ=
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="82667024"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jul 2020 06:42:16 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 21 Jul 2020 06:42:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 21 Jul 2020 06:42:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXQ/0Fl++PInyyUf+s4RhpirnfnaaXQOwPfFK2cZJwaYWP0QgC6JBff3iidCPh+DPrEEfIozCrG6xnPH4DNbv9jgwUBjh/K9lv53qp+suvyFCN+jjNgGyKdxCFsoRvxVQc94T0hzB2kLPq0CGBjJSdf84KHFcV4gRchUPdDs3fWRh8SD4Xlgay3qAbmqbbICwWZR/BCksfAwgX8Lk2cV/X5GykLdFOLwkTD18i3Z51RmTRwsp/CmmLGD4ofseS1wmuDzb7avHHBpH0W+XIkepC9/0rwqT1McVU0T0RiUXCcUuj9sXHHw8x5rpH9mTmS3TY0p1Xad2Mk0JM+llM7FRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=CWF3hSxBKaxPuWV3GOhsp0+Xuzibl1LHxs54WqVIiArSLQlJIufDhg4TSkU4Na7knOYd55T9HTe1gEA0+uHouoTYNoVrzMxdH+E5cf0I+nrjeWjN9ma2qbCLuD9gjUb4KegtzecNeeshZN3rgrW66OuoI9br/+vA5LE6B5vfjaV64DE/Px6b2yGjGo2JG8HmlAns6gsJ5m8Hu4Qx7nzM0/8Ne5HjwPvPjOb7IJLcjxu+1fi1nMxPrEYs2+KSFC34hxgKjV6v4xQYFEQB67Bs3bsm9J1q4PRlcp1WbJX/LRVYzUAKHSRrkjUls0LJES0YUg974Yzu3HRuU8CVHL4+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCIemFwHVUPk9JG5bOXVOGvcvPDUygaTIGU9mXoRy0Y=;
 b=VxOxNHrAhvxoz3W8sVH5qucEJPPv0iIBsx1gOGFjZ2yEE5iD61HC9kdWnH3pbL05QFiLJe0PzMfH8Aa/YnBErYVk+CBtuLgIgqB7cgKd1mTSsa/mI0m6U8hrrLUweazU4gFTKqDMzpfe41V2WlJdFODneEOarXNFz+44MjxUqvg=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SN6PR11MB2656.namprd11.prod.outlook.com (2603:10b6:805:58::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 13:42:11 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 13:42:11 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>, <robh+dt@kernel.org>,
        <alexandre.belloni@bootlin.com>, <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Topic: [PATCH net-next 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Index: AQHWX0Zyppx1UbfeIEWndPdIyI+OoqkSCXKAgAABdoA=
Date:   Tue, 21 Jul 2020 13:42:10 +0000
Message-ID: <1915e800-85b4-070b-26f3-9e5d0bac8f44@microchip.com>
References: <20200721100234.1302910-1-codrin.ciubotariu@microchip.com>
 <20200721100234.1302910-4-codrin.ciubotariu@microchip.com>
 <20200721133655.GA1472201@lunn.ch>
In-Reply-To: <20200721133655.GA1472201@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16a8cd59-c967-447c-5e84-08d82d7bde9a
x-ms-traffictypediagnostic: SN6PR11MB2656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB26560C3793379D509C5C4F05E7780@SN6PR11MB2656.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sJ5NECnZnEOjmmS2M6mLxhxa1IqNjBkOe8B0iAyXSv5/vKATu/Lxkf+t6q2jJyl9O7oraBOT63guBkh6b/fLqK2fClnHcIShxQDAGGRWbsZSd2Sku+Jq43l4K8UhVR7mHTY+zvNdd6Q/7W2KxjgkNlpLd611XLEUUiIVokiVz175SmKApS4FerxaBevc8Rddv8zRo+ivdTkN8PohH6PDNgO/0UFAm46koVK5U/5E+zyZAaLOwPt2LUsHRayc13A83Vjrx2F+gCUS4pc9oSxQBj4tRN1Hoj2Ck7VI/OFlBfQdRucgczY3qI0f32TNqk2Cq2eeaVGyma3uB4ThC6UNiR2ufAz+7BMMCUqDW/VDCTLGs2bHfTk4x+Kytn+Jqae7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(36756003)(71200400001)(6486002)(31696002)(6916009)(4744005)(2906002)(186003)(6506007)(31686004)(53546011)(8936002)(86362001)(26005)(54906003)(107886003)(498600001)(8676002)(76116006)(66556008)(64756008)(66946007)(66446008)(66476007)(5660300002)(4326008)(6512007)(7416002)(2616005)(91956017)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Hl05VEcOLM0JR0O0AWzamzAwJGXzq2qBt4GAtHtRpipUNrrs6XZjcDnBlW1kUniMSBCc9K+jZ5Xvjo12QfzwuwZ9jiBL3BgqNEM59gk9x3rATN9u2EE2AKTj5nv+tN3I2A9rQ23T1KSu7vK7CLAH9jjPIIxmaH0+kkjpEp8Dcs0xlxK/9ABNcaKSNOYzRYqEQp9KsQLqOXVQ63YWYXOw2AfPN6c/jV4rkmjHU1xtGaNFkGa8iui1GX/+A8kLZg0QkTS2An8B78kiC4MfyDdN9dnuK/+8KtdtKTz+7/7oQ5A3uj/OoLiuz/IT2cqU2P8NB7fQxpFPW471lfyHMJf6OQGzayjZH484iQ3uAWeVfsrRM0bQvsgbtJeONxb4z09AyeAm4S0zfdJSE24n5+4Y9mZolz4sJf7XbcjAI87BbBBOdx8SqNk8ZZrtQNM3I1t6o7Wu9yXUFrIFpdNxNjt1EhPew50KvGNE8c26LTEkedDSOYKk2rL/xgXK307SsDoZ
Content-Type: text/plain; charset="utf-8"
Content-ID: <B00F39E82142D640A6D5299F35678E43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a8cd59-c967-447c-5e84-08d82d7bde9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 13:42:11.0082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvD2WHT6xP+Mc+CLxPTBDoUJuWatIRpGsxqsaMmh+alKKaPnahQ01t1uB8K/35g+vQH8boXmLB46D+8QzSDDyxR38fuiV9+bcGvNh2e8KE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2656
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjEuMDcuMjAyMCAxNjozNiwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IEBAIC03NTUsNyArNzY1LDYgQEAgc3RhdGljIGlu
dCBtYWNiX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0IG1hY2IgKmJwKQ0KPj4gICAgICAgICAgICAg
ICAgICAgICAgICAgKiBkZWNyZW1lbnQgaXQgYmVmb3JlIHJldHVybmluZy4NCj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICovDQo+PiAgICAgICAgICAgICAgICAgICAgICAgIG9mX25vZGVfcHV0
KGNoaWxkKTsNCj4+IC0NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG9mX21kaW9i
dXNfcmVnaXN0ZXIoYnAtPm1paV9idXMsIG5wKTsNCj4+ICAgICAgICAgICAgICAgIH0NCj4gDQo+
IFBsZWFzZSBhdm9pZCB3aGl0ZSBzcGFjZSBjaGFuZ2VzIGxpa2UgdGhpcy4NCg0KU29ycnkgYWJv
dXQgdGhpcywgaXQgd2FzIG5vdCBpbnRlbmRlZC4gV2lsbCBmaXggaW4gdjIuIFRoYW5rcyENCg0K
PiANCj4gT3RoZXJ3aXNlIHRoaXMgbG9va3MgTy5LLg0KPiANCj4gICAgICAgICBBbmRyZXcNCj4g
DQoNCg==
