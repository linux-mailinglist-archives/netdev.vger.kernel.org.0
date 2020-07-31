Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BC1234837
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgGaPKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:10:18 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:48320 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGaPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596208216; x=1627744216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iDBf4B/4JnMVpAXTFkMg8iF03P+cgQOnemPjBvsZ+gc=;
  b=ktoDIWteQrsypeYofyD42FZFFBCfycRdRASgAD3wM1eSHpn2esw3slQf
   dfMlIupXaRiOOlB9Q+MHZxX8JzwXuHHK9akQH42V05HpXPLgpZydnHBHH
   XCX66JdXOHuLaGSPDMc9r2GmLSJpVW71h0TVkBY3zLjoIQBHnjk+4inZm
   NqHr6d+sCqipvWCKK0YDA4piAWsjMIqFlZ2tDVUpae0AA4wyzYftfBE74
   4vz7+SuqmkUZ0c91MJpkUWWNUotpeJLd0zvjZL0lZfIlgRs5pAP6AQhhf
   FNzqEP4ZbJ0qaNlyU/FSdVzaLAwO3mdffn2ZpHJPQV4K2txG54JFTqdcP
   Q==;
IronPort-SDR: 67YlY98piZw5NUEPZv+6URck8I8VYCyzVa7wwbGQFuAAuM/XZEatpbYbF09KoBRDTkiC5L01HV
 7/XXXmsRm04baR2Nho7/Q2e01y5c43Q9i24/kYf3Z1RcUH/SQtZx/xWoPctdWI5aowUw52XbzY
 CLJ5UDEqRsI6StMdtqI98eaXiUbiA23CQ2KpqWtwVpQVHxXFRa1+0egA5UFUZcX0Ch27dNiF5t
 AAOb3Tdvj0lmHiE2wQvzG1b+bPqYUv/QBr42IZnUWaEGmdkWdhxBOd7voxm1fcMHJ0/l8cdUn3
 Wag=
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="21246469"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 08:09:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 08:09:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 08:09:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0NW0Q1fF4ueMAnUaqMt0bImYN9+GXvthjX3lKrfbSKJ30sPfmslU5c7sIfH/3uCIy8+XdWTG78FGW7RYivCXd2qSne5qX4owsiIjEwCsEi2WUPjNz2ErmgpeT81QiGWj0pFf6pk03tjmCApC+8xwpxDqce8mFnB+mUr2UcoJtzUW1ZraOdCIntOGKi1ajObPeg4BfDqknOIk87hLiPg1WyEhJYRnK7pZ+yC5Eqcb3pEVE/FSUGxVUcOtqmBQQLQg5w9br8ZIBxuSuR/BdhsTOz65LKEQy6owFHTH09HCNksR0vxAOYKKeSsywpJ6T37rr290GE2C5VuYCqFI6ywlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDBf4B/4JnMVpAXTFkMg8iF03P+cgQOnemPjBvsZ+gc=;
 b=GQtvDeKe+5ai4Q5b6i5EzucfsZwbXCEsVH2nuwgTfFTkt/CVzx7CNkwkt7Zn1PQGlFGIKSIvJXYrsc/EPXzDCpDa5nd5s/tdGy0z2EGBKBxfC2eLalRrmQ0EsScimTAWW+LFnaAhUG3dlDNKJFHcSOXJnrXpI4YmkjMphwS8eiQ0ihuqACxzjHBqsROGhjzwFjpz0bkSgiD/GJ9Bve9Ji8UpfL3B5MoNHjpCl4lk37iUwh2kjfp247vVfrCqHE5/ilQRMJea4vMXHSYUMGLHY0GbVM1QU8eL/o/kdASNK1+a98UVKhb3NnA0bBlp/JBrmCrdZS9bSxZkab877su0iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDBf4B/4JnMVpAXTFkMg8iF03P+cgQOnemPjBvsZ+gc=;
 b=YAsM6zlJZsSLgBKuEaCSEsVeuCG4C69Yci1KsFCNC1bKDEw2Iv53tbipmP2RfLC2kS7O8UPxAihe0e8daCdHYa/RVudIbtTsVszh/kwolRzvjeL0nwcvbRoUM3LpWBErp5ePtXhrBltG4KN9ygRx4H8kiIsaLhHQVF1YVB3PYww=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3904.namprd11.prod.outlook.com (2603:10b6:208:13c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 15:09:54 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::64d6:baa6:7bec:3c54%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 15:09:54 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>
Subject: RE: [PATCH v2 net-next] mscc: Add LCPLL Reset to VSC8574 Family of
 phy drivers
Thread-Topic: [PATCH v2 net-next] mscc: Add LCPLL Reset to VSC8574 Family of
 phy drivers
Thread-Index: AQHWZDoJOMli1TWDh0mTm2gmvm/SO6kgy/yAgAABHICAAP1yIA==
Date:   Fri, 31 Jul 2020 15:09:54 +0000
Message-ID: <MN2PR11MB3662BEB7C0E1E92D37A2FC97FA4E0@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <1595870308-19041-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20200730.163617.337691110259436047.davem@davemloft.net>
 <94cacb22-c31d-4cd3-3872-2e431bafb0da@gmail.com>
In-Reply-To: <94cacb22-c31d-4cd3-3872-2e431bafb0da@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [68.195.34.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0908dbb4-594a-4fce-8338-08d83563c80a
x-ms-traffictypediagnostic: MN2PR11MB3904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB390485B742A8EC527C2DE8B2FA4E0@MN2PR11MB3904.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 87gXp3StK68e6prFjc+AxdsPt5F9i1Ms1UrMJUxPUhfYPc2J7LuyghCc6NCbFKFKyAbAzXCmsFvYRj26B/Na0KCFn/hsZOrYrG2F/oe71BBCN998bK+a/O6dimNtoMjRkrWBjqksgEL3L43RsepPK8eUP/9etYNt7KPpGx5fet/ID1hk/iUjJJ51ygQVm+Evf9wRWxzkH/FxWGAFrTcJL7f3ftsM7UWiMB9LjvNkNVzYtXRatjXN3l4pXRgqXRPsshr1MN8xWGkf6A/YEiWjqGM2nJC+f24Yktrmh0W6joB6a8X42dt+adTjTg7eHey+r7rdYOWgoa89z4JJ8Oa52Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(346002)(366004)(376002)(39860400002)(26005)(186003)(316002)(110136005)(54906003)(66446008)(7696005)(33656002)(64756008)(66556008)(66476007)(66946007)(71200400001)(6506007)(53546011)(55016002)(9686003)(2906002)(76116006)(4326008)(478600001)(86362001)(5660300002)(52536014)(8936002)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: i7sTuNGwM9w8cb900XIguBlGWZueAhFmZJO1eiZ8zv9wZZIIixk6W/J53cirpkG0ahS5mMTb9kL4OnNzdxP1/1LSmW7PFiImzNASwuNTf+4iENfkR660rYQ+y4ZtNzaNrfmfJtbzdb610EbInupOHWpMVZr7M5c/p5JIXuqsy0C/LnHdDUEud2BFP+XRjl8TfJlDfD7PvxtLakv2RRqLSiARQiQ26Ca2kqnPc3jZOmkJJ7UnN2XUgVVH0SNpp0/G5XbYeFuf4BA8maCz/dQvzZFxk3rxKtm/S3u5R4VXODwGJJ8Uh3fLsqaCMY2+qBg6qWr0oJLwmgYehRALVKv+yTcWsAemBfono4Mab+/jefMKPBWQ8LHXTGTae+CJoQmdKEtktqtf8sy48kv/acWJ/23QWOgXfsNuecUUPuPtKwnQkAgTNOm1H93KotVu9/NbNUVsbpab+Y2Ud3Rvq5avU3iuoh6DKBWrzJyhEEIecj8djSDf4dwfbqs7d7LWQJDJWy13rPXQnMA1TS0TlQwmjI6EbOg0qH/5CQXJ/u5pNkuc+RMJ82FeaQoNP6cX10bKY+hSD729+5O4KKEkdTkNQ1djMkdl2c7Un5rlbCPW9ihItOxphani8p2sJvI4j0QlQ6sL2jNOXqIWndt1QcbkUQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0908dbb4-594a-4fce-8338-08d83563c80a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 15:09:54.6092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EB28XrZRY/zfbXzZO2fPzifM/trFXjNK7zLgAX6Q0/KRmd8twBuydkxTJjYWlfk38FgtW+gCJp+lO/9A0l0DYZvKs5I6D2/Un6LYrxDwIC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3904
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIERhdmlkIGFuZCBGbG9yaWFuLCBzZWUgYmVsb3cuDQoNCj4gT24gNy8zMC8yMCA0OjM2
IFBNLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4gRnJvbTogQnJ5YW4gV2hpdGVoZWFkIDxCcnlh
bi5XaGl0ZWhlYWRAbWljcm9jaGlwLmNvbT4NCj4gPiBEYXRlOiBNb24sIDI3IEp1bCAyMDIwIDEz
OjE4OjI4IC0wNDAwDQo+ID4NCj4gPj4gQEAgLTkyOSw2ICs5MjksNzcgQEAgc3RhdGljIGJvb2wg
dnNjODU3NF9pc19zZXJkZXNfaW5pdChzdHJ1Y3QNCj4gPj4gcGh5X2RldmljZSAqcGh5ZGV2KSAg
fQ0KPiA+Pg0KPiA+PiAgLyogYnVzLT5tZGlvX2xvY2sgc2hvdWxkIGJlIGxvY2tlZCB3aGVuIHVz
aW5nIHRoaXMgZnVuY3Rpb24gKi8NCj4gPj4gKy8qIFBhZ2Ugc2hvdWxkIGFscmVhZHkgYmUgc2V0
IHRvIE1TQ0NfUEhZX1BBR0VfRVhURU5ERURfR1BJTyAqLw0KPiA+PiArc3RhdGljIGludCB2c2M4
NTc0X21pY3JvX2NvbW1hbmQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwgdTE2DQo+ID4+ICtj
b21tYW5kKQ0KPiA+ICAuLi4NCj4gPj4gKy8qIGJ1cy0+bWRpb19sb2NrIHNob3VsZCBiZSBsb2Nr
ZWQgd2hlbiB1c2luZyB0aGlzIGZ1bmN0aW9uICovDQo+ID4NCj4gPiBQbGVhc2UgZG9uJ3QgZHVw
IHRoaXMgY29tbWVudCwgaXQncyBub3QgYXBwcm9wcmlhdGUuDQo+IA0KPiBBZ3JlZSBwdXQgYSBt
dXRleCBhc3NlcnRpb24gaW5zdGVhZCBpZiB5b3Ugd2FudCB0byBjYXRjaCBvZmZlbmRlcnMgYXQg
cnVuIHRpbWU/DQo+IC0tDQo+IEZsb3JpYW4NCg0KSSB3YXMgc2ltcGx5IGZvbGxvd2luZyB0aGUg
cGF0dGVybiB0aGF0IGFscmVhZHkgZXhpc3RzIGluIHRoZSBkcml2ZXIuDQpXb3VsZCB5b3UgbGlr
ZSBtZSB0byByZW1vdmUgdGhlIHNhbWUgY29tbWVudCBmcm9tIHRoZSByZXN0IG9mIHRoZSBmdW5j
dGlvbnMgaW4gdGhlIGRyaXZlcj8NCg0KVGhlIGxvY2sgaXMgYWxyZWFkeSBjaGVja2VkIGluIHRo
ZSBleGlzdGluZyBsb3cgbGV2ZWwgZnVuY3Rpb25zLCBwaHlfYmFzZV9yZWFkLCBhbmQgcGh5X2Jh
c2Vfd3JpdGUuDQpUaGUgY2hlY2sgaXMgb2YgdGhlIGZvbGxvd2luZyBmb3JtDQoJaWYgKHVubGlr
ZWx5KCFtdXRleF9pc19sb2NrZWQoJnBoeWRldi0+bWRpby5idXMtPm1kaW9fbG9jaykpKSB7DQoJ
CWRldl9lcnIoJnBoeWRldi0+bWRpby5kZXYsICJNRElPIGJ1cyBsb2NrIG5vdCBoZWxkIVxuIik7
DQoJCWR1bXBfc3RhY2soKTsNCgl9DQpJcyB0aGlzIGEgcmVhc29uYWJsZSBtdXRleCBhc3NlcnRp
b24sIG9yIGlzIHRoZXJlIGFuIGV4aXN0aW5nIHByZWZlcnJlZCBoZWxwZXIgbWFjcm8gdGhhdCBj
YW4gYmUgdXNlZCBpbnN0ZWFkPw0KDQpCcnlhbg0K
