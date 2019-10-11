Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0001ED3AFF
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 10:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJKIZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 04:25:08 -0400
Received: from mail-eopbgr720084.outbound.protection.outlook.com ([40.107.72.84]:27376
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726535AbfJKIZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 04:25:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmF54AYzkA1oqWRWq31bcys3ybcZp2G4YKvjdObmtpJa/0IyM1BlSSqMZyBodt1GNpfHrACSTJtH4784ngK5+r/Vcg34ztgbqmz4jjPntxk/QHeNBV3Dzs/wpzIHxNBhOUWs0569melB3YW3jWvtQQqWC4VbWamULsC7PS1cuHQYv7KC++o0C5uqhyvGcA1pv8wNTgsRI9anD69VGrbGEMBbj9/7kNzm/d1YNK5xtJF1e4c2uMBzj3CN7jXucdeIF6mvjJXrXlg7RJ5E/qhhxzp9yR3S5JWsELBk5pJFWPpZwKWczYHQyRX3xo3JsU1VdhRygBpTNPqnt9IYFQx9rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0odK6kuBb+hW9yzlFeVtOH9DvJ4cyLa/N/327qdJdAs=;
 b=F+rhx++8AiKBi7EZr9VxE/3RPjafNpJr+g/GE/Oh78IwBunqjSbKr5aZS0jZTfCcaL/HYbZv8u7O8EtaUPEi9Z0DvC3Ipre11xyw3RgHo7oae7MpqmlsIf9x9EQL6E/n5ylwKsyay8J6jf4OaX6LwPd2xuSPO1h7ZBfDpsaoDXI9tJkIOMQxCsnHDAkA/gE0/SES3LgY4KQaiFq+VXUoPPWfkkU8tK2tHeq3awp+Yde1DG46ynpM81Gx/Yqd9kJuev+GzSqE13rAE+rlkIk59f3KH3uLPKRMvzChoeHQdqwciVjIlbo6HenbD+NLP4DdmSZWi2VjYItK6cxaFt5sNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0odK6kuBb+hW9yzlFeVtOH9DvJ4cyLa/N/327qdJdAs=;
 b=AZkQ++uDqgG9CCzHb03L6oyjyQeo1JXWCjvJWDMYLBmZuDI4wUfa+JTY75c5XEbtwzwAf6NTFRlsp8ho1Rxq0Lyun0QXe5T+1K5ANDlg/4DSf3ktP7btMEsOlT1Vgo1DpWg2Zm0auDEwI2zXLqk2YKCivWg1ZhCOSWfKyjr8vs4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3636.namprd11.prod.outlook.com (20.178.221.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.19; Fri, 11 Oct 2019 08:25:04 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 08:25:04 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Simon Horman <simon.horman@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/4] net: aquantia: temperature retrieval fix
Thread-Topic: [PATCH net 1/4] net: aquantia: temperature retrieval fix
Thread-Index: AQHVf3MyinrvQ3/1i0m6scHoj7ZlYqdU7U+AgAAuhgA=
Date:   Fri, 11 Oct 2019 08:25:04 +0000
Message-ID: <b72e135a-1f00-54f6-5548-874cc17756dd@aquantia.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
 <8167dd20577261b78fbbd8bcad6c9605f510508b.1570708006.git.igor.russkikh@aquantia.com>
 <20191011053826.d3mppta6xzw7wx6j@netronome.com>
In-Reply-To: <20191011053826.d3mppta6xzw7wx6j@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0148.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::16) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec031efb-a95b-42de-be47-08d74e24843b
x-ms-traffictypediagnostic: BN8PR11MB3636:
x-microsoft-antispam-prvs: <BN8PR11MB363633C002499E4BC274638D98970@BN8PR11MB3636.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(346002)(366004)(136003)(396003)(376002)(199004)(189003)(476003)(446003)(6512007)(11346002)(26005)(2616005)(102836004)(6246003)(6506007)(44832011)(316002)(386003)(186003)(6486002)(229853002)(54906003)(6436002)(25786009)(3846002)(486006)(508600001)(6916009)(14454004)(99286004)(6116002)(8936002)(256004)(66066001)(76176011)(81156014)(81166006)(8676002)(7736002)(64756008)(305945005)(52116002)(31696002)(71190400001)(71200400001)(86362001)(31686004)(66476007)(66446008)(66946007)(2906002)(4326008)(558084003)(5660300002)(66556008)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3636;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DdN7KK4b/LvwWzzO/lgf6CoTR7jnseieeLigtH5l/rDEoOgFkr7ROfVf1DqKw9E77+/ngAqrHHTbEhrKCXs7zoXIQC605pOnvtVd6SxSVbU/vm9xdQ4sG91R1EKnh7YsLV2/QKd2Vqf8SvbLwM+4FnGzirCOy9G7UjNKU69IDQ6XnSRHER9PzmronfvObnCZ2lTTVHslTStPKBj43QaDH0GcaNivskYjYmR3+A1Ys6qtafkH8KKueRO0EeZ7Ryl7jD6TJA9sj7UX9MFrA1ZwQS66lYbBfqZ+8/xDYB816orUqcr5YX212FOv1QXIik4TBQvqWhkNthfPYFpUmHi50PChXNaEHRqWC1bf6DeqRWfldUuDcppAFqH7Euwnu+FDDlmftzRGI0fwdrHMGAMVbuf/C55Mk/cW7v0wBH6rpDE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9FB6BF8B2823744966476F0DA7587EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec031efb-a95b-42de-be47-08d74e24843b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 08:25:04.1910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3C52Rxit9MOOZuynKKbZFxewhDV1XmOCdVpZZfjj4kKl0ijx9E2paD/p1Kg/DjKx7gc39oxWnlhhbMC1/WmbVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3636
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiAgCSAqIHRvIDEvMTAwMCBkZWdyZWUgQ2Vsc2l1cy4NCj4+ICAJICovDQo+PiAtCSp0ZW1w
ID0gdGVtcF9yZXMgICogMTAwMCAvIDI1NjsNCj4+ICsJKnRlbXAgPSAodGVtcF9yZXMgJiAweEZG
RkYpICAqIDEwMDAgLyAyNTY7DQo+IA0KPiBQZXJoYXBzIHdoaWxlIHRoZSBleHRyYSBzcGFjZSBi
ZWZvcmUgJyonIGNvdWxkIGJlIGRyb3BwZWQgYXQgdGhlIHNhbWUgdGltZS4NCg0KSGkgU2ltb24s
IHRoYW5rcyBmb3Igbm90aWNpbmcgdGhpcy4gV2lsbCBkby4NCg0KUmVnYXJkcw0KICBJZ29yDQo=
