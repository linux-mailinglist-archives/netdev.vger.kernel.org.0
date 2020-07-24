Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8596D22CB14
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgGXQ3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:29:45 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:56943 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGXQ3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:29:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595608184; x=1627144184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=14xRivRQsHnmDdmRpGpQcnbd/XGZURbXV6Mw/qCE65E=;
  b=k36eEGeP2FEuCsssj68QHqm4QfTLCA1f3C3oYxlzkNRzoTtc4XQ6zSeT
   4gp633vQIL+U05//D9zbzbdVUAZTjSKAhbBSYohU+a5sqGQON5lnNqPks
   EbkbuHMeh20CIckIWd+BjPi4KUq/P/2Ywaet2r+IRGMTUzmVZA8xAgrvV
   24hmZfkeClweHJiKW3Wy+VBsTuVF8DDEnGYRWumkAb4GpMDmb61WeMYoW
   TfQK/lmbAIPGJV0E7rqTKQeKEfmqlSz28Yyog+sBp6SzvtuO1bSEo1Skr
   5gtYnuGpbCL43j+3t8FlbKpTkrzCqC0PUUl49/JjrVhjOkGb8ft0dS0sm
   Q==;
IronPort-SDR: ta6bCFYsf/gwwMc6SGdau57cqVAI1e9XEymZ3qvevNEMpaFn8yHhtbSXvZLEMB/WJ2ON8AH0kA
 Q7xXbMbC13NbwL9POqVG7dc5m7pwi963XgGkfFTTwwTXfUf2/2vPFUp4MBn3k6h+xrL8zM/Bjp
 CY724gs4iJzGRYnIxpET1mfb6h4+OAUgg6tjuYg8f5YJvIjgQyM52vUl3foZ+auvDx06rv0kU4
 YGyRszh6qL31IEZbDUOvnGyzcVTqXl07W5GAVpRJfpHfli82p/xqIKF/hhvl2LXor8wOkOLuo+
 pNQ=
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="83189487"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jul 2020 09:29:43 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 09:29:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Fri, 24 Jul 2020 09:29:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B37vbjzdpO16zEuq5pm/IVJEZXeiP3LaFBvGtDTOaj8GnIB9rE4OPPInu/IONXU5NpAlJTVdSy9yV+lwT8ifg6pK+D/l+SmcfPslJdrRqWBzR6uSEe+HaN+uExb+Xw3r+MVGSpIY+LcxuUgbvd1iPpmQU8cUcaQVnohIZCX9/BYILvj3LmlCwE6+P7+rNJjH1lNQ+geqKXbxtfqR4VI0r1RFkhcCzJGSdf1Axq+Z5Y95Wy9M3EcgCAGUu4Gez5irtNrdfe3f6zMZbjFmhrtThtmSU7q2Ofc3T+KEsihtMKpaEZ8R0bdbl66UBYQJ9VIPr02msU38AdgSmQodTXgp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14xRivRQsHnmDdmRpGpQcnbd/XGZURbXV6Mw/qCE65E=;
 b=lZ0XQKNknt4TIHR9WIZfTLGs5UKMs5/48ew0401FKUBkWm1H+xGwjjeiM1Wo32uWQ2bUJCBXhGTAOAnBho5XC12MIQurPyV5ERZts0WmEDJcdX8KgQZjhm2iYc7LUwiJ2wXbBfogOw4j5jfS5rO1gEN0WTJDtI6tqFOab2037XRhnDv6/4xj2Aqj4AkjfSe3iGTwe01fQlj/kKeVT3Vc33lE2bc3KXTgLkasjJ/lOck1jXTNnOV2oKhyn1UKklT5WvFFzK6qoyfoVmLCRE6XFqPzoNobjZLyR/BTzZG5ilL4tQ9KHhpnpSRSjqzxfKYeOeyGkPdqSHkBlVWaNGd2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14xRivRQsHnmDdmRpGpQcnbd/XGZURbXV6Mw/qCE65E=;
 b=Y/O07vC3j7fzqG6StfqXbP/fHQEqrp/fijqLg6TuE/ybHR25Ezq5uAVbLMYquc+Dh9uiUU9uuC/Uaq1yh0yt5uziTAaERZ3BCBaPK8O2mEbhtq/ac27BMlyBDusH1e8moR9HqyAKd/vHo8gLYHH7/AauTXv8+SCIAiWPZCQZe7c=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3744.namprd11.prod.outlook.com (2603:10b6:208:f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 24 Jul
 2020 16:29:41 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54%7]) with mapi id 15.20.3216.026; Fri, 24 Jul 2020
 16:29:41 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Topic: [PATCH net-next] mscc: Add LCPLL Reset to VSC8574 Family of phy
 drivers
Thread-Index: AQHWYS1Pa/FhIgpObUi5DOaSOO6xe6kVq1KAgAE9OVA=
Date:   Fri, 24 Jul 2020 16:29:41 +0000
Message-ID: <MN2PR11MB36624200516FB937C0E91F0DFA770@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <1595534997-29187-1-git-send-email-Bryan.Whitehead@microchip.com>
 <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
In-Reply-To: <c8791db0-b036-51c0-c714-676357fd8be1@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [68.195.34.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d459c2f9-02f9-41dd-ca0e-08d82feec42d
x-ms-traffictypediagnostic: MN2PR11MB3744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3744967595A9BEA7943072F3FA770@MN2PR11MB3744.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UAsTqX5cGHdHg705FguNQIuhFKlDZWAWjfoQbUs5fjWLDgU/20X0W8pE586tlqxYPPirwt8xvjL4UsQxJlv0HyUYb4/2rg570+AzEFLWDViJXiz/yuwTk9MdbQME7kNVzn9GaieUWypL3DmONo6M4Dds/izxU8fsAZg4cLrD0hhWxhunmRwSph1ezvW4/WWToR0ZJinQBUL4gvRN41SQ++vCZTX3wnqZEhzxscLVJgCfrr+lKZ9MM3vkDYtimR6cjXxt5JOOvX8nwoHjkz/Ru7WYIdKm/gP0gXz5G5koWqBlAiaMiS8Qa+cRFekMLDEE78NYLJvCLFRXAA43AzfhfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(64756008)(66446008)(54906003)(66556008)(66476007)(83380400001)(66946007)(71200400001)(107886003)(6506007)(33656002)(5660300002)(26005)(2906002)(76116006)(316002)(52536014)(8676002)(9686003)(86362001)(55016002)(4326008)(110136005)(186003)(7696005)(478600001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: clWO2x9Qht0mzlk+SJqlwm5w0yXTb56KJCU0yl1IJBd0c4NFAUQLKEzm6kTkpDnauSO/Ki6xv3S1JrNy1HaQn8hK4G35JeFxcaojjk2eLde8uL9aiMEfkIDR/vVYvdiA0cubt/ERm+4pQ3vsUxvSODd+xsVBzBx29CO6fsUlpcs1wIcimpqFAWGNqXPmNHeWp76lKnihrPUz5J89uZTRTPbcPHXKePlfRA525xYOcmvRy7JatWdagbgBLEPml3vPlmXXB2IDEcxh1H5ZvfQ/ivY9Lark3xDchb716SQIwBotQjVlXEGaRe6gwXRkT0uGr1Q1lBZrlyjW3sV1i9BqNU2SfnrhrngG4R5ajytSgX9jadnqPi4o0CkG9CK6THDjvSlvwH5XAF2MyNK0D33Pgq9yFYhuvi4q/n78ZuBJ1+EzVxu7gYE49HiHWKp3iSXbt1CNOmutWRwUatanxBp5ddnaDA0hfUzdLiQO3jmjBbk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d459c2f9-02f9-41dd-ca0e-08d82feec42d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2020 16:29:41.1852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kd+MW4PnvKWSbzJstjjiTfsgkWp8iWSDHk7sU2Gpe2gz05VAzfmWDSv4xOr1Zw57YiXGsoHMCnFy6GuoPdoo5g8cva3IUkfLFYJ8w+K0e34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbiwgc2VlIGJlbG93Lg0KDQo+ID4gIC8qIGJ1cy0+bWRpb19sb2NrIHNob3VsZCBi
ZSBsb2NrZWQgd2hlbiB1c2luZyB0aGlzIGZ1bmN0aW9uICovDQo+ID4gKy8qIFBhZ2Ugc2hvdWxk
IGFscmVhZHkgYmUgc2V0IHRvIE1TQ0NfUEhZX1BBR0VfRVhURU5ERURfR1BJTyAqLw0KPiA+ICtz
dGF0aWMgaW50IHZzYzg1NzRfd2FpdF9mb3JfbWljcm9fY29tcGxldGUoc3RydWN0IHBoeV9kZXZp
Y2UgKnBoeWRldikNCj4gPiArew0KPiA+ICsgICAgIHUxNiB0aW1lb3V0ID0gNTAwOw0KPiA+ICsg
ICAgIHUxNiByZWcxOGcgPSAwOw0KPiA+ICsNCj4gPiArICAgICByZWcxOGcgPSBwaHlfYmFzZV9y
ZWFkKHBoeWRldiwgMTgpOw0KPiA+ICsgICAgIHdoaWxlIChyZWcxOGcgJiAweDgwMDApIHsNCj4g
PiArICAgICAgICAgICAgIHRpbWVvdXQtLTsNCj4gPiArICAgICAgICAgICAgIGlmICh0aW1lb3V0
ID09IDApDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCj4gPiArICAgICAg
ICAgICAgIHVzbGVlcF9yYW5nZSgxMDAwLCAyMDAwKTsNCj4gPiArICAgICAgICAgICAgIHJlZzE4
ZyA9IHBoeV9iYXNlX3JlYWQocGh5ZGV2LCAxOCk7DQo+IA0KPiBQbGVhc2UgY29uc2lkZXIgdXNp
bmcgcGh5X3JlYWRfcG9sbF90aW1lb3V0KCkgaW5zdGVhZCBvZiBvcGVuIGNvZGluZyB0aGlzIGJ1
c3kNCj4gd2FpdGluZyBsb29wLg0KDQpUaGVyZSBhcmUgYSBjb3VwbGUgaXNzdWVzIHdpdGggdGhl
IHVzZSBvZiBwaHlfcmVhZF9wb2xsX3RpbWVvdXQNCjEpIEl0IHJlcXVpcmVzIHRoZSB1c2Ugb2Yg
cGh5X3JlYWQsIHdoaWNoIGFjcXVpcmVzIGJ1cy0+bWRpb19sb2NrLg0KQnV0IHRoaXMgZnVuY3Rp
b24gaXMgcnVuIHdpdGggdGhlIGFzc3VtcHRpb24gdGhhdCwgdGhhdCBsb2NrIGlzIGFscmVhZHkg
YWNxdWlyZWQuDQpUaGVyZSBmb3IgSSBwcmVzdW1lIGl0IHdpbGwgZGVhZGxvY2suDQoyKSBUaGUg
aW1wbGVtZW50YXRpb24gb2YgcGh5X2Jhc2VfcmVhZCB1c2VzIF9fcGh5X3BhY2thZ2VfcmVhZCB3
aGljaCB1c2VzIGEgc2hhcmVkIHBoeSBhZGRyLCByYXRoZXIgdGhhbiB0aGUgYWRkciBhc3NvY2lh
dGVkIHdpdGggdGhlIHBoeWRldi4NCg0KVGhlc2UgaXNzdWVzIGNvdWxkIGJlIGVsaW1pbmF0ZWQg
aWYgSSB1c2VkIHJlYWRfcG9sbF90aW1lb3V0IGRpcmVjdGx5Lg0KRG9lcyB0aGF0IHNlZW0gcmVh
c29uYWJsZSB0byB5b3U/DQoNClJlZ2FyZHMsDQpCcnlhbg0K
