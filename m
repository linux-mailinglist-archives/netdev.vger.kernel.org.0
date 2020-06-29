Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0045820D7C0
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732956AbgF2Tc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:32:28 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52985 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730833AbgF2TcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593459143; x=1624995143;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
  b=G/jNNF+t2kxgq0ZVr7XrDx+MzPdFRsRXVBl7Zr7ULLaMJzOHD557PNv+
   QburigCovm1aW5XCpJoQgtCqx4hF9LdmRtIh0MmGkb7BSSob7zQItzhkz
   /NvasVfKE8umBreej/3AgwBlQr75gf15C8rnuV4vGj5nMJDTCTRtS7dv6
   Ja/Ag/Ii+pfqVNocITENkle1QCuCVXXNpIGfq9Zu/51NEGj9UkiAQSpqL
   4mZUwVvgHxXF/mildYaQbR4lIGauniReKi+I6DlyCA6IPi2G5Yw2BXWcj
   vRlr3Fjq+c9i/NvpTgGVIWp3ebn4o0pK3MZrasbbAcLKMNn7JMSFBZWdd
   g==;
IronPort-SDR: KWpApKB+PRvEjKsT/R/rVZUAM5CkzZ0X1LvJW0UP4cyxu6IRemSpEhyX8X2hd7j8NzQZl0CzfX
 6ukGCJANaFYlsqvIgvkeiUt5GDkliwQavy1gQFEYe7XRePY3DjQhyiC6xZGpQNhc/SvxqpYKSS
 0lldTVl7trTFKUbh8e0ZUNrw71OEuX3UM+5W/IVv4PDxszYfM2SWwJl8eRGeD65CUgMO5pIHds
 hywYFvC46DC0evK35b9dJxJA8gvjKv2n+9RNshEWZ6y1x2z8NzEI3ZSal+DS+v1I1Q1pfRnNx0
 KKQ=
X-IronPort-AV: E=Sophos;i="5.75,294,1589266800"; 
   d="scan'208";a="78141485"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 06:10:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 06:10:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 06:10:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6vL/q4mWU3hQW4XWUDB4+B2ZiicuqKlyJ0NqSoSOiizlMBfnxGH/k979cQ89mL7lzr+vmWCXNFkTxtUQnBP0BhiBS119JhhL4O4RYyxgh4bPu2G9mCEJP70IocQC0Kftshm1esmkJFuKaIlQ+UOba95nNPZQ2dg2U7NKAVGvZ+Gaclc1Z5/p6Au3BefUr6TK8NllvS/cgSmJKvo3PZXpO+D9oKUYvyFz4MbH/SssKg9AMEPts+YxZqiWv3krzLujPL4xV04B2INEAUIUx7AMXbJla4jP3LG/5gLCdXoZQPYJRSwuRiOQ1ILDvWXjA9SvVED91TcAMlMxWhRHIIp0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
 b=SH7T403DYLjFtK7DraBVBqWt6hqBK/yI+BFwpay3x9gCkkZl0maufgbmqxO9zzX9pcpTANxxUv1SaSkbRQCfh08hHgA+6EQjfVT9v9FU8UgL/JIaMFlEdn+0OxBFBQ9O2tfbaVlzcZD+uHS3wRJqU/XQuoBwj6yduLDnXEvDCWjbbSaJiTxKBVNw7kgjuzKPJnki/SfvuTerTdTPrKIaOvjQBkKM9UntY+QCiJgmhS0j3Z16A7CqTMh9eimqvABn5Go7whDwwWC+N0r9OWy9MK3uW1ZArbMJDg/WtoQ3qnQl55K7cb2H6tWVSxUmrtygStSFWAFy5m/C9hbRcWsNkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OswM2BcmFT4BuEGV7YRpAVEHcfYykLmQXhPyMkEpFkk=;
 b=m8AiVxeuPlwXAp98RiazhBnKcQ5tdTG197QKSdiF7tgBFWqfU2GTa+46WnnjF1j7Gkwz3mezf+o/aDoHMinnwk8jutTSC6j1znvsWx1DD3+ugeT0OKKUZMNAKih+xQpRc7a+iRZdaRpHr4uiYipAXC6hrfdNogslQOoxJCYq5s0=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB3237.namprd11.prod.outlook.com (2603:10b6:a03:1e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 13:10:34 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 13:10:34 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 0/8] Add PAL support to smsc95xx
Thread-Topic: [PATCH net-next 0/8] Add PAL support to smsc95xx
Thread-Index: AQHWThasjETFJ00TsE6e9DO1qi+OZQ==
Date:   Mon, 29 Jun 2020 13:10:34 +0000
Message-ID: <089b6427583b22d01b213f75919ffd4f3b074ff7.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21835354-7fcb-49d1-5128-08d81c2dcf00
x-ms-traffictypediagnostic: BYAPR11MB3237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB32377685FAEBA98821462D12EC6E0@BYAPR11MB3237.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YuUMsJp86dhH8Ru5EuILNU8/xTxUM1cdt78SVrc6JvIXVOcdrXakNeFrc5jFBHr4zFDlViq6+mAZg+/3T//jEZaAeciDU0mWIHf19R4Q3c4btMSzhfDwFIdHLCc5AcT9z7yy0SPQ5z971gMutjdGcNdcQPHndCpVAJMbqYlnaHOjhTQRE2sD2WtFb6qp+PKRcUMugm8T8Q9Wv3RekrXGJD5BojIGDHWpWXqQqZ/wHL6mK3Bi2hMqgn7FLF+e6Y+4ALP/TBaP/q+sIfKaDpXe3H/59q9GqJY6LJ8qe7jblZlgHP0yWFHRfsP7Zg0ktEkbcP3OQ6oDUglvM09xn62ufQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(39860400002)(366004)(396003)(346002)(186003)(76116006)(4326008)(6512007)(8936002)(110136005)(36756003)(71200400001)(66446008)(66946007)(91956017)(66476007)(6486002)(2906002)(86362001)(66556008)(5660300002)(107886003)(64756008)(8676002)(316002)(83380400001)(2616005)(26005)(4744005)(478600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GPmkpX499rPbhyDAA2wGMMPaHZ6lWW4m8fpj1zwlelZn7W4T1/cKxl5p3IeaspmACnEv/edCzzX5doATJvS7pQu4QVHnWc/sGca3533VSe6W6X5SpGupN9lZ1KbuE6iolJb1mtLuiS4CBCwW13tP34RDPELk4+SuBJSYKB++qFlGE665zwHLXW8F1KgXjxzzpEvnERQP94A3XIvuHHH6MdZGlww1Rwug9v3Utz2u644fdqxwTp+GPiz9pvoXSRI3CMSYOKzP3+CbJByjq/HpvxAOl6xUKByhzqNxrWyCJPEPBzC0xtpyUyxbmlP6MRqcvqYzw8q3LZDt45o0Hbkkg4P7c43WYpLM2A8Ube40GGwl9JTf4sftdwvDxDNxgP2r5uV2zjdI71qfFzNrV+J9E4ZxRn4iY0nkSLJbiQYZFRx+mO0WVSwnt0Qtqar+8HceCDO1JBg+Y4EIpKT1YN90yGXC40qGnb/fT29zfFBhlEY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27697A90C1EB63468255F2C8538B43A9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21835354-7fcb-49d1-5128-08d81c2dcf00
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 13:10:34.3046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IZi1u+TAG1WlBEY3M9ey3iVSfEZCiwZ33lzP3pp2GLLtp1SZxASaQrr2JN9eRfTr7VO8i5h0m8imRg9UulvbxoTsWSZRfACz3OKMrzBCmA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3237
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG8gYWxsb3cgdG8gcHJvYmUgZXh0ZXJuYWwgcGh5IGRyaXZlcnMsIHRoaXMgcGF0Y2hzZXQgYWRk
cyB1c2Ugb2YNClBoeSBBYnN0cmFjdGlvbiBMYXllciB0byBzbXNjOTV4eCBkcml2ZXIuDQoNCkFu
ZHJlIEVkaWNoICg4KToNCiAgc21zYzk1eHg6IGNoZWNrIHJldHVybiB2YWx1ZSBvZiBzbXNjOTV4
eF9yZXNldA0KICBzbXNjOTV4eDogYXZvaWQgbWVtb3J5IGxlYWsgaW4gc21zYzk1eHhfYmluZA0K
ICBzbXNjOTV4eDogYWRkIFBBTCBzdXBwb3J0IHRvIHVzZSBleHRlcm5hbCBQSFkgZHJpdmVycw0K
ICBzbXNjOTV4eDogcmVtb3ZlIHJlZHVuZGFudCBsaW5rIHN0YXR1cyBjaGVja2luZw0KICBzbXNj
OTV4eDogdXNlIFBBTCBmcmFtZXdvcmsgcmVhZC93cml0ZSBmdW5jdGlvbnMNCiAgc21zYzk1eHg6
IHJlbW92ZSByZWR1bmRhbnQgZnVuY3Rpb24gYXJndW1lbnRzDQogIHNtc2M5NXh4OiB1c2UgUEhZ
IGZyYW1ld29yayBpbnN0ZWFkIG9mIE1JSSBsaWJyYXJ5DQogIHNtc2M5NXh4OiB1c2UgdXNibmV0
LT5kcml2ZXJfcHJpdg0KDQogZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgfCAzOTQgKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxODYgaW5z
ZXJ0aW9ucygrKSwgMjA4IGRlbGV0aW9ucygtKQ0KDQo=
