Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A5523D57F
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 04:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgHFCeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 22:34:01 -0400
Received: from esa8.fujitsucc.c3s2.iphmx.com ([68.232.159.88]:30466 "EHLO
        esa8.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgHFCd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 22:33:59 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 22:33:58 EDT
IronPort-SDR: NC2A5MvsphO1tdQ+xt2YUSxaofJfqPllqFcGEIVj8Ksc08dA5Kw2Pv6+GWLSGa6hHxs9OZwt13
 3u6wYEN3q8bn0q2+JRycAJA7ttVG2F51FOi0C9mOS27AP13jKEmm0LecN3oQYbNPYmZaersNMK
 R2zQvceOtcugv/4ERIpdAvy7gFOj/CdcalrXRBoBhzGiunjjiMM93JiXHqLKFkz6dURDKiggBZ
 dfHNVgwvbkZuMHghcbLhTVsFehiiV68s01cJ+tOsPTJXHcdCop194qS7+WYyHdufW23DLeyuHR
 xxA=
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="16495925"
X-IronPort-AV: E=Sophos;i="5.75,440,1589209200"; 
   d="scan'208";a="16495925"
Received: from mail-ty1jpn01lp2052.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.52])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2020 11:26:42 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFeWMVAOAeIAVuZtoUnSsBa5rGWeFF/LJ1voVKRW9xbTHt+VdsRvOGIvX4lMKtWur0M1brcaVR0YvDWmse0ldKO1Uz+TY96NSgrFMCjp5dNpE4E0vZ2BA9Dp06SnE5QylQZ+NxFgZdZN9zxY0iVPk1osU0K4L973rkXdEQ6AFmZ87pk5Xl8uCyeASpyS9+HAAd4OoV9aVn2VVYXoTs6usmaceRrK9VWZko1eYhqoifXRru9VT0vFSpZVGubRckbGSSnEqVtEKZRr7qgcVDll3OP0VjxNrnTU9hBw/CAZyGT3qDLhriClHu3mhla6DXh68R5G9/Zq3kikCfR/yCKtAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGc/Lm5UYWho7u7j5uS60DGaN3vOdSRDkaWnzmlKZLc=;
 b=muJwOGnnNJRquGiHJS161HfPIYNTF8b5wV8oFrEyDm+DPOTr4i8+wjNKVItPsk+14LZ9sjiOV4Trz6LS79ZA4BuRC9YzYGA1NvpViluGgc32xmIYxfdHA93pM698HmDXXXSx50SJIqo97nee9wLMlfrEhgO8vJvU2sfs4jlKeTxmuhGtY1tCsjNIBCcM65eSfSZkcGY4iGmglqquXHVgoSv3D6xk7ehaaLl1W/IlgfP3+67aorxcX/LHkA8YGxxJswmWkU4cerDq/oSy6CudWuXYj8qihvtMGq1XWLs7Hnv1/AHC0zf+0FYk2yPv+vlXXhVTBZtxpmfIwKSBu0ouFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGc/Lm5UYWho7u7j5uS60DGaN3vOdSRDkaWnzmlKZLc=;
 b=n6RiQMBuftftK0fbE23jjBYqCB4EWD/h3qUr4G0XeK2AH8EpaIh0jj8M6CLorbCEgM4hG70VQpVYrvJ685pfL6rgOqvurcJxu0i9rUv09LdYT7oYCFEtgmhGXJe2ZeGy/o3Q+b1fzDJilofrBcoobfQnEuq9OsmgbAFBSNAywnY=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSBPR01MB1574.jpnprd01.prod.outlook.com (2603:1096:603:1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Thu, 6 Aug
 2020 02:26:36 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::d4d3:eba6:7557:dab6]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::d4d3:eba6:7557:dab6%5]) with mapi id 15.20.3239.022; Thu, 6 Aug 2020
 02:26:36 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Sergei Shtylyov' <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Topic: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Index: AQHWZliVF0gqbKeTM0q7YOFUctSlU6kgSWOAgAEpsHCAAG+FAIAEB8Ug
Date:   Thu, 6 Aug 2020 02:26:36 +0000
Message-ID: <OSAPR01MB384475DE7B02563005FCF67CDF480@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <ce81e95d-b3b0-7f1c-8f97-8bdcb23d5a8e@gmail.com>
 <OSAPR01MB3844C77766155CAB10BE296CDF4E0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <32d3b998-322b-7c0a-b14a-41ca66dc601a@gmail.com>
In-Reply-To: <32d3b998-322b-7c0a-b14a-41ca66dc601a@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 26cd4b64ae534207be5656c31801da05
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [118.155.224.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aba36aea-0edb-4781-5f7b-08d839b02489
x-ms-traffictypediagnostic: OSBPR01MB1574:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB15748F2DC2BD95B261A74B10DF480@OSBPR01MB1574.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DplxOZ5BPKcKetAyHxTW/a3RSYaMGDDd6DLxScfHqhLnaatSgXNhJ/xJKiGE28FGGI0KmrCuW0opYGjTltm+tu5tBrYFWJTIEThXoys0WJFn3klxK8u17O3i3NFf4tTV2ynGj3UhCQf22EJqEoURB7xcI7CIb4JRma8ieBkItPGeklx/qp6k5ozd6Rv3zXRgF31v+9TThlxb0r27+EeFkwKIzuYhMzxy2OuxnY/R5mY08wp9UYtEeoI7RjuWLHedXbZnNaWzZZLQyk3hytM1eIYETUXhrmnOQfVrniVHbwDt5MMjMGYLQQCMCF1mn6Y0FKGXkCPe9PRf1AxqPT/ZVxvOZAtaFvM2ORALaSshgjfjPq4EB37PHu0B6Mo66wag
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(86362001)(71200400001)(4744005)(5660300002)(2906002)(478600001)(8936002)(52536014)(54906003)(85182001)(316002)(66946007)(6916009)(66476007)(66446008)(64756008)(66556008)(6506007)(26005)(76116006)(4326008)(33656002)(83380400001)(7696005)(8676002)(55016002)(186003)(9686003)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GkGL6vAQkXMKP7Uca1zc7YAKi1eeX7cytaCZMv7WY/RDb5vqZVmWPIhju4N0BWiPPWfN8UFi48VjDIJXlAEE8KhW1YBpWQnbFG9QV2+qGMlDwRvfvddRVyTu5MbCazfcEEmJ+jJn3pflKQ5+hHjtqHncfQZLKl7g9URqgPkxYAL4j7DkZfx51F2cOBFuGTUFWfwrHd7ISjC0HrAEkycGqUUjJyKBsNkB2jhxlRVR0gtsuF8W7KRUDTF1/kvCW1Day74rXVMozmPAjpwrhJ0Mdm34OLzNJz+DVwZQk9NYCq4UDUPlzjIwMIGSj8KNysP8dBNhOrGrBz2IB5b/Mpa8esotvVgbUuyCc3MpLyhP0sOFaU2JsSyxrVTIPVyBlahhpoTuG+iu8z24duuBv8B0OJhfYFSxw8oXuM/DbiTZLvfw89cL7XoEOKlwjJ8/wgEC0sMPi/50Xl8ihLAGnmzcFKkaxArOClgqrXWDHAmnB/SZnwzyVpEGC+PXryUxeIidaR8AKcp9pAKvxzu23BB5E7RFXWWK/dl+1d1DX2LsB8Hq8RF/VkM7rl/LztOCk8XOvHM9ba6gAQMkOoF8xiLp6mWeULYJk3hbQ88hmVlOFGRz88q5npw1b+6uuHnMIOabR0MfPjQGVBtQG+iN13E81Q==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba36aea-0edb-4781-5f7b-08d839b02489
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2020 02:26:36.2375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 98b94yEdEDlDcA6kO1iJiLuxvAaXxDs+G0nNHOVyCtRi0Hw8zH8cN4IeK8f4W7QIgVMbb6SK22TruyBVGM5d7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1574
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+ICAgIFRoZSBzdWJqZWN0IGFsc28gY291bGQgYmUgbW9yZSBjb25jaXNl
Li4uDQoNCkknbGwgdGhpbmsgYWJvdXQgaXQuIFRoYW5rIHlvdSENCg0KPiAgICAgTm90IGF0IGFs
bCBzbyBjb21tb24gYXMgSSB0aG91Z2h0ISBPbmx5IDQgZHJpdmVycyB1c2UgbWRpby1iaXRiYW5n
LA0KPiAyIG9mIHRoZW0gYXJlIGZvciB0aGUgUmVuZXNhcyBTb0NzLi4uDQoNClllcy4NCg0KPiAg
ICAgRG8geXVvIGhhdmUgUi1DYXIgVjNIIGF0IGhhbmQsIGJ5IGNoYW5jZT8gSXQgZG9lcyBoYXZl
IGEgR0V0aGVyDQo+IGNvbnRyb2xlciB1c2VkIGZvciBib290aW5nIHVwLi4uDQoNCkknbSBzb3Jy
eS4gSSBkb24ndCBoYXZlIGl0Lg0KVGhlcmUgaXMgYSBTSUxLIGJvYXJkIG9mIFItQ2FyIEdlbjIg
aW4gdGhlIG9mZmljZSB3aGVyZSBJIHdvcmsuDQpCdXQgSSBjYW4ndCBnbyB0byB0aGUgb2ZmaWNl
IG5vdyBiZWNhdXNlIG9mIHRoZSBDT1ZJRC0xOSBwcm9ibGVtLiANCklmIEkgY2FuIGdvIHRvIHRo
ZSBvZmZpY2UsIEknbGwgYnJpbmcgaG9tZSB0aGUgU0lMSyBib2FyZC4NCg0KPiBXZWxsLCBkdWUg
dG8gdXN1YWxseSB1c2luZyBORlMgdGhlIEV0aGVyQVZCIChhbmQgRXRoZXIgdG9vKSBkcml2ZXIg
aXMNCj4gcHJvYmFibHkgYWx3YXlzYnVpbHQgaW4ta2VybmVsLi4uDQoNClllcy4gSSB0aGluayBz
bywgdG9vLg0KU2luY2UgaXQgaXMgbmVjZXNzYXJ5IHRvIHJlZHVjZSB0aGUgSW1hZ2Ugc2l6ZSBm
b3IgZW1iZWRkZWQgdXNlLCBJIGZvdW5kDQp0aGlzIHByb2JsZW0gd2hlbiBjaGFuZ2luZyB0byBh
IG1vZHVsZSBhbmQgdGVzdGluZy4NCg0KPiAgICBUcmltIHlvdXIgbWVzc2FnZXMgYWZ0ZXIgeW91
ciBnb29kYnllLiBUaGF0IG9yaWdpbmFsIG1lc3NhZ2Ugc3R1ZmYNCj4gdHlwaWNhbGx5IGlzbid0
IHRvbGVyYXRlZCBpbiB0aGUgTGludXggbWFpbGluZyBsaXN0cywgbmVhcmx5IHRoZSBzYW1lIGFz
DQo+IHRvcC1wb3N0aW5nLi4uDQoNCk9LLiBUaGFua3MuDQoNClRoYW5rcyAmIEJlc3QgUmVnYXJk
cywNCll1dXN1a2UgQXNoaXp1a2EgPGFzaGlkdWthQGZ1aml0c3UuY29tPg0K
