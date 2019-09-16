Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527C0B37AD
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbfIPKAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:00:31 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:62220 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfIPKAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:00:31 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: kmWU76IYdPNkmhUqo+w/2biUSKjN0P3V6QeFAChUD5f534FVH99JqrCAU+lqpsFapi9lgknJ3Z
 B+hsH75pDGWoTN8xaXGp9oiKEu77lTBDD6DrqucIv3GgHIPRwpQUjl69/ThDmJYVwN8/rz/2NE
 Re80y2Mc+c9cfWUBLg9e2k4SCTQUYqY16RVf39BPMh7NNabtIojijK0jxxpULkxKG1AG9mwR0L
 wUfnyrGH3E0uOB7RUWGVYruWQC5/nulVPG7dbb/ndax5Zgy2PullvKFtok5lX8eqw65ZUi6cA5
 sAw=
X-IronPort-AV: E=Sophos;i="5.64,512,1559545200"; 
   d="scan'208";a="49031197"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2019 03:00:29 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Sep 2019 03:00:29 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Sep 2019 03:00:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJfkqwzVv9P8xRup6+snAzOH2U/D+ztGnz1bFgNt05XYiFnBtrqxB7iIHSTdq/AhbgJva7rEC3kh+LWIF1N0uMh/7qXfHUVZDg/h6ZleZAWweGZzJvmIODLL9uPrqGY1S5Cl+oz1zTTGvTI2sWS3XVPm7isaLGk61MtxaBiU0SrVCawTaUk4UseTRzIQnzlQxsN8K+zSFqkpKwAOEdR03boTaQb3YUHQMnVN+HSi2OTKXzJTRfUHfpvz6sLWqlzeotBovYdt9cO6tSszlGsngOUtc+JBTYPk27NwTlxWAOJ07xl3XhsYfhEt0f+T16wLnLEPRc9wDqlZYJfMGaK6EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mb4L5dAb7dgBKXuN+8OADu2ykHrDiKBc9TeeSUoP0jA=;
 b=OqekFk2JXpLM32vHezrC1uWNCpB6vYbqwUw7RK3NXbrZuZji3Q3OvqG8Fvkd3W+JkHGcOQE4gcsyhLd2TfC9gWiaLf8VO5qbcoz7czK17TbGc+m/wTUqgSMm4aAhMKHm4NXx8ONwmcm96eRciftUjZccGXR+uhFTejky6gUZdd0KFV+6fiuJCWgKzA98gqTZv1E/uHPlGzOsoGP5U0MKryHwmlZwbiOsDkB+PMwTKuJWwe2b52KPDPvToDjjay2xGbvVBT0W2P1PPT/YxGAt/NIVjQqJhD7ntCFUT66pca3Hpr2vkymYUYjwpHJxhpdNfRtHJPyMcKcwbj+uOJs6cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mb4L5dAb7dgBKXuN+8OADu2ykHrDiKBc9TeeSUoP0jA=;
 b=lWdkTPdS+5f6CZjDcMUPawR3Lbu0QU2qvRs+VQ8N8gVQQPpbmbsmFcgWVwVBdbASsb3U3cIePUFy29kaTyPVWBgjLEqfcyVn8ijTmAcDDsRHJjrpSdiODahdQ5JWvuqUpf94T4eKgmOtOB0NhegV3/pvFAw7aic5YrADTYD3yAQ=
Received: from MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) by
 MWHPR11MB0031.namprd11.prod.outlook.com (10.164.204.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Mon, 16 Sep 2019 10:00:27 +0000
Received: from MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::e1f5:745f:84b4:7c7c]) by MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::e1f5:745f:84b4:7c7c%12]) with mapi id 15.20.2263.023; Mon, 16 Sep
 2019 10:00:27 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <schwab@suse.de>, <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: macb: inconsistent Rx descriptor chain after OOM
Thread-Topic: macb: inconsistent Rx descriptor chain after OOM
Thread-Index: AQHVbGIsZPEARKNyhE2It7RNJ/kTNqcuElQA
Date:   Mon, 16 Sep 2019 10:00:27 +0000
Message-ID: <51458d2e-69a5-2a30-2167-7f47a43d9a2f@microchip.com>
References: <mvm4l1chemx.fsf@suse.de>
In-Reply-To: <mvm4l1chemx.fsf@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR07CA0277.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::44) To MWHPR11MB1549.namprd11.prod.outlook.com
 (2603:10b6:301:c::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190916130020333
x-originating-ip: [86.120.236.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eed9259c-2afe-4d3c-094c-08d73a8cb36c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR11MB0031;
x-ms-traffictypediagnostic: MWHPR11MB0031:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB00317BF8301BC796C010E260878C0@MWHPR11MB0031.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(396003)(136003)(346002)(199004)(189003)(71190400001)(478600001)(8936002)(66476007)(53546011)(66446008)(64756008)(66946007)(66556008)(6116002)(3846002)(5660300002)(316002)(2906002)(66066001)(476003)(486006)(31686004)(81166006)(81156014)(256004)(446003)(8676002)(11346002)(7736002)(305945005)(26005)(6506007)(71200400001)(386003)(102836004)(36756003)(14454004)(110136005)(53936002)(6512007)(229853002)(2616005)(86362001)(99286004)(31696002)(6486002)(52116002)(76176011)(4326008)(6436002)(6636002)(25786009)(6246003)(4744005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB0031;H:MWHPR11MB1549.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LaF7kVeEM1kSTqg4Pv6CEWDh6DrL+AlJjU1/piRCg3idjaUYQwaU0hi95KCZHUYLDINrfX9wMTMeEj6KleN0o4ljeElKp1CnAwPtmqOEyNpTD5e9JcRoN89RVhQJN0cJKLzzFiKD5uizvduRKKiZMNmGSxMv1yxchU37jguwXoO0INO2xnID6SqYgxw70xVJuP/ZaHw0AS4pH/tRAp85vmQmSSsm0PuulxI0VjyNIpeMNR3T/dKocheq1+8XTrMcN56VgacQMO22OFRov2mThxe3QafYCT/oJj9CtUb5eJ9xwOvwK0kP98GC808QTMunayFNdnQRk5iDiMRLe4/HgCEUT9q0IBy2GGQ/jM64SjDKj6cTAyoifjd2/E6fkjeueV1N/96NudOgadQ5sJZ0OvR9Bsy5IxZXk58NjmtWP5o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC72BE53C416F744A03891B8E0D174E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eed9259c-2afe-4d3c-094c-08d73a8cb36c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 10:00:27.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kSwaDT/XfJfXgqm1R8jCGOfjPrTfbn/m9xEe4eMVXeqxneKDPl406iS/ioxt4a95ArEvee8dlGbfHa8yZnQ3wcHT9XWo+AO4DLkhsocXZVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0031
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmVhcywNCg0KSSB3aWxsIGhhdmUgYSBsb29rIG9uIGl0LiBJdCB3b3VsZCBiZSBnb29k
IGlmIHlvdSBjb3VsZCBnaXZlIG1lIHNvbWUNCmRldGFpbHMgYWJvdXQgdGhlIHN0ZXBzIHRvIHJl
cHJvZHVjZSBpdC4NCg0KVGhhbmsgeW91LA0KQ2xhdWRpdSBCZXpuZWENCg0KT24gMTYuMDkuMjAx
OSAxMDo0MSwgQW5kcmVhcyBTY2h3YWIgd3JvdGU6DQo+IFdoZW4gdGhlcmUgaXMgYW4gT09NIHNp
dHVhdGlvbiwgdGhlIG1hY2IgZHJpdmVyIGNhbm5vdCByZWNvdmVyIGZyb20gaXQ6DQo+IA0KPiBb
MjQ1NjIyLjg3Mjk5M10gbWFjYiAxMDA5MDAwMC5ldGhlcm5ldCBldGgwOiBVbmFibGUgdG8gYWxs
b2NhdGUgc2tfYnVmZg0KPiBbMjQ1NjIyLjg5MTQzOF0gbWFjYiAxMDA5MDAwMC5ldGhlcm5ldCBl
dGgwOiBpbmNvbnNpc3RlbnQgUnggZGVzY3JpcHRvciBjaGFpbg0KPiANCj4gQWZ0ZXIgdGhhdCwg
dGhlIGludGVyZmFjZSBpcyBkZWFkLiAgU2luY2UgdGhpcyBzeXN0ZW0gaXMgdXNpbmcgTkZTIHJv
b3QsDQo+IGl0IHRoZW4gc3RhbGxlZCBhcyBhIHdob2xlLg0KPiANCj4gQW5kcmVhcy4NCj4gDQo=
