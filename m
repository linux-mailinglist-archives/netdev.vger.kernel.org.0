Return-Path: <netdev+bounces-4533-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 315F870D333
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A1D1C20C68
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE26F1B8F8;
	Tue, 23 May 2023 05:33:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A58EEDD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:33:32 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0471B103;
	Mon, 22 May 2023 22:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684820012; x=1716356012;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=X0Ipz1wTyd1uKD3id3YXyNKOZ8FNzTVtobZ3t0qRlZA=;
  b=UUfTQQ9YfN/QzTMt8h9ZtwioZ6J0nobz9+tgNuMOxR0eSwrJJsZ2if5s
   4xUgN6zDwJDlTExE5Pt7I/dCRLHAm7/aFr6x234xffQgUNeIrZkQQrP1q
   7LUXubl790Pz5gy3utt29HjQaH7kfa+nngF5jZbOGtJ8z2/PaAYMzaBWZ
   h6vaBgcM5UuCBdRPwVpxBJOYcJWWeSvQVfxEpYcB8LTRsHSHg6Sa/gsBl
   LJ0fs9bOxNxbnYPM6BlmnFVKrUA18WQHyRJbODJ9wAjujbZeIxz1ZV+wo
   ugL+2MNQxwZOmzJFUFyYw00fB2MB1Yyn40renKZazP7VAa6F50cCL/+SX
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681196400"; 
   d="scan'208";a="215032040"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 22:33:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 22:33:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 22 May 2023 22:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=By4OFChbwKroNOv1COunGFvHVuSDx5Lyyw9ol9bURNctW4z+y2bot4FtQp4p0DgWtlJO2RKenhSU4JF/mXZjCbduprjvyfOOGrMdfe8W19mLYCXT7K753dUrMvQQVczN+uUbKvHFQS6WFCg0RBvGFsE18GWDl7I6LMd87hvNV9/MzUmT/1S31HktoD5afVTgCSG6YpksEYQqcm02RfyNcwDrMUO3JPdU+Jwx7xD4bHByRacQxKdQgB9C6VuWdXNvgnpN8EI5gQncsHHoIOruOrrgcJc4rauT01EekK4p9HcAN12Xxls2Gs8Oi2C7vuqheWX75NVFN9UVKxARGBdn9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X0Ipz1wTyd1uKD3id3YXyNKOZ8FNzTVtobZ3t0qRlZA=;
 b=AJD96liSG+m3KG1lg1t28MsdD9DLVa4JOhLrpNedA+RGEjGoNA9t/dk5i3Ubl5EXtVlljNkKYTE3BFiyiwOSqAB9QSIePPm6xWFpl425IWHZg7H42CntGYJZ/DUOauD+DKnJKb01waDTq96P0CkXlIxCt/32wM6BVdp1gX589Zgu/XbJ1QH+Rf7FcrFnVGsOzviiKVmsWdeK54y6gNb2tdllgkE1i3lrqdp+zw8gKxqcGOp/2tF4J05wpQw+a55/FmHUNOdNXTzC90o50PY821B7QHhBuCxLG5yOQ/Dl4kZfW7V8pD3OOQZ2JMlvIpB7DVRb1t2oN1XTYr0j/Mevvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X0Ipz1wTyd1uKD3id3YXyNKOZ8FNzTVtobZ3t0qRlZA=;
 b=Ky0GyOJPYIR2UWh33Lz+1HvJkYK8C6MdTjoh8X1BGGq9OVA88/unzigWxyURFrHsKHV/PdO6vtA7hthAzgvjeXfcorgERkYbK0mfY0I9ajL1hxlDX/4MY+fSFbgpehUBj7b2yHgUf3mnNlQlcF3w+qkgU2QAnZ/k1+KXcz9Wn28=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 SA0PR11MB7158.namprd11.prod.outlook.com (2603:10b6:806:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 05:33:28 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Tue, 23 May 2023
 05:33:28 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <simon.horman@corigine.com>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ramon.nordin.rodriguez@ferroamp.se>,
	<Horatiu.Vultur@microchip.com>, <Woojung.Huh@microchip.com>,
	<Nicolas.Ferre@microchip.com>, <Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Topic: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Index: AQHZjKFXg4D7h/qJg0WxwlInlNp8HK9mY46AgADzuoA=
Date: Tue, 23 May 2023 05:33:27 +0000
Message-ID: <9c45a417-80c4-5c1f-243f-916292c741bd@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
 <ZGuD/dqpQl/2wpRY@corigine.com>
In-Reply-To: <ZGuD/dqpQl/2wpRY@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|SA0PR11MB7158:EE_
x-ms-office365-filtering-correlation-id: 3a945a05-ab05-4e92-599a-08db5b4f3c85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VImiPDN44+tgdyT1QKY7cJqT56M319iF/MQhFRtx5eCDJkeYI4tu4KrOQBg9d0N16Ylpu9F0XS2SVfUGvG/NPivBIZpCM8e55gD4ASKVij8SQWyigYreIhAufNHoGF3lo4vvwknCyQPIIPEZN6xqUC1t/F6+qMsDkG5icKj2A5JoKVH8eCzO3oKaS17kqaBCKHYQlHhrQwJkYF7R3SD/OOWS0Ess1bEoEEFOe6GU1nltNX/NkWkjWi/rnlV5hVqzuztRmEhWNeZ6xlfhFgSb6aiHgocgOS+ZZ2rl1Erhf5bbtRspbcc/sKwdAjug31kP+FiVLDEJiNCsosXFgGZ/q286QZD6r/9lzeH0xtFAfoZVEWEjKy4oiWqzH/tN1rHFMxcFqaiPuoGDktWx+AHmj76X4kVu3HTlrj9Qz6yXuUY5o8/uZ9x4LL6QRBydTpZM+c2EI1KtczCnuHFTDh6/X3NjAx1uOiy520PM49qS1nx+zDqKgFb2v6ll3/b5f5pWvzue7VfnuwuIu0gpnoFVmcdYrMT6KvwIfgSeYh6OLHJz3asV5Y9QEkCLkBhN5a0DQ2VnT+Oi+mUT0LKfpKq7TIJKhrs3oyvcM42Bgx6YZcedXdbNFelLg8w8pgWelbpGYURXPerddtUjLLmChLS2lFEkyb7sbUwZ201V3bmfSsiAPy+dJFKmujKI6XZnRLA1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(8936002)(8676002)(5660300002)(7416002)(83380400001)(186003)(6506007)(53546011)(6512007)(122000001)(38100700002)(31696002)(86362001)(2616005)(26005)(107886003)(71200400001)(38070700005)(41300700001)(91956017)(6486002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(316002)(4326008)(36756003)(6916009)(478600001)(54906003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUJaamFSVVJiUk1hZjd2dlhZVFd2SjViUHUwYU9lbTR2QmtPRlpONzVwb2o2?=
 =?utf-8?B?M25LYWpqeWlJS1pYZ3Irc3RNMGpxdU1WUFhLa3ZkSEVEQTZRc3BjSGh1OTJW?=
 =?utf-8?B?bFVmSHM4dDBlYStuQmpuVDFkWkxrWFlRd3BMT1o0dzZ0OEVoMlNDN2tNN2pn?=
 =?utf-8?B?RGI5UmdrQ2VWTW9WZEpjdWNMZE1zMXB3N3Yvb203ZEJ6YVJlbFk3ZmdhLzJI?=
 =?utf-8?B?VGtTQzlDR2tlVVhkcFlZWUJZT0pEVm5VMGkzdFZUQ2NucVFDUGpxNW4yUmJq?=
 =?utf-8?B?YWhHdi9uR0wweDhHYTdLRXdIMFhKMkhpMEVUc0E3Vk5kUkpUYXJvVTdxVGlx?=
 =?utf-8?B?bko2L3Q4YjFsYzF5WXduYWZLRFNkSTVzdkg3L2ZxWG51NzE2YjRRY1BpUEox?=
 =?utf-8?B?WnJKQjJIZHNUWE0vZFd4RzliclBUa2dkUmUvbTV0bGpxSkIrRTE3RFFoSFpr?=
 =?utf-8?B?L0RiMHlLVkJBUzJjSEJqSkdkL09Mb1Z0QXZmR255VXEvUXpHYWhwWkgwOTVW?=
 =?utf-8?B?T3R6dXc2N1VKR0l2bURKMGRvUWt6NlBKOFdKc2Q0OVBTbnJwangzYm5OVlpo?=
 =?utf-8?B?ekJvSkpqS2o5WmVDZlgrWCsrNnlMa0J4R0JNNk1Ia0tWVVE5Nm9jTHh6b0RQ?=
 =?utf-8?B?em83ZVRlWlRnaVFRVDVBTGtwWDc2UHJ0RHFLeUJPMmN4eVVXQ0hLdC9nYytm?=
 =?utf-8?B?Y2J0Uk5Dbjh2R3BkVWFhUXRHbFI3bFhocFp0Uk5lZExCRWU5Rmtqa2t3cTRW?=
 =?utf-8?B?TW1pdjQxRHhlYnh0WFZMUUpEM1NrUTNxVXBvNUwvclA5UERhVlhMTzZqWXRk?=
 =?utf-8?B?U1B1TktZdm92RFJuaEgwOU4ra1loTkgxYmFoVHFGUzlyYVZiQTluSFh2YzRE?=
 =?utf-8?B?TXZhNDBtcFBnN3V4NEFvVm1xVW1OUnBLUnJoWk5LbGprMi9HcU5YczBpUE4r?=
 =?utf-8?B?UlE5VGNMRmdvaXNRblJ4OEFzTS80SFRYbGxPR3U4U1E4QzV6enoxZ2dEMlRI?=
 =?utf-8?B?SUhGYXJrMVdWWHV5OWpMS28vYVNOV2VhY1RFSm1Ya0h0QlE2bnh5M2xBRFBh?=
 =?utf-8?B?U0xiNm15WmFYYklFeEh0cnNtWjdmako4NCt2WndReVRkSnhrYWFWZjJUUWtS?=
 =?utf-8?B?MlZCcFVYbDJVNVhJWDFYUVVYWnRpRkE3bWpBcnFKTGp3RTdXVlQ2eExGV3JQ?=
 =?utf-8?B?RkFNdE9VM3hyZCtEWXNVY1dWaTFzRkE2Mk1XdDJka0Y2YmZKVTM4Ry9YUE5t?=
 =?utf-8?B?a0FCMDBxWnduM0paMzRvSWxtWXZWWjgrQmtLNjVnR2xQNFcwSkx6K3ZkR2J0?=
 =?utf-8?B?OVZtOXAraUplVVZIRUxadWpYSmJRVENjVk5oaExtNXZ4VmdkQ0Jtejh2MHdH?=
 =?utf-8?B?dFd5UlBSeE8wYzgyYVYvZ3dqYWQ3NW9WVnVweTI5ZmFETnF6OHJYUCs5Q3hM?=
 =?utf-8?B?T0xMLys4WHZKU2FBM25GZ2pRcTJqYlpZa3RjcXZWSUdJakd5eTRiejhWWnpu?=
 =?utf-8?B?MTVROTBXek5mdE5NY0ZEOGw0SFZOMVVzTjFWK01yYzBUTGIzeWRqZ2hjcmF6?=
 =?utf-8?B?Y0E1c2ZWS00rbXJFRzdINDdEcDRwSDBTbHhOdEU5MDRHdzEvbmNqa2dDOEM0?=
 =?utf-8?B?RlRtZmhKYzEyQXJIeUpWVzlrTzFyYXJsZlUvK1hhTnJod0piNEtVKzdaSThs?=
 =?utf-8?B?Qit1OXJObEd4ci9jKzdLTTZKM1RpMzd3MHVmRnhoQ1dUa3l6aHZUZmJta0Iv?=
 =?utf-8?B?VmRvZEJjako4amRGVjRzamFOU3kzUUQxOFAreml4M1ZISkpVTlVFeGkrdTdj?=
 =?utf-8?B?V0RkUXN6bmpOZEtxZVl0NlhVcXQwbnVqcW5wenhpWGJPKzZOK1JHY3EzcnZJ?=
 =?utf-8?B?b1ZhbTIvam0xQlFBMWpQYUhMNDR1MkVXNjQ3Mk1NcUhkcFZKOExZaHUyazNi?=
 =?utf-8?B?dW9STVpMeVVEYXdzaUFQbktJVmVoVDRRcEdEc2xibWUvVWJsTWRoWiszZytE?=
 =?utf-8?B?cFprTVFqcUZ5QVRjbWYyQzFhVUZCZEhqc2RWZWhZMjZMazhlR3JpZXZLamFi?=
 =?utf-8?B?SjFXd1M5MzVQai9PdEZ2aHVqWEdlUnpKUWtQNnNLR0k2WTF3bCtJRTllSkwv?=
 =?utf-8?B?YitqaktrNGRMOHMrWjZuVm10dlBqM01ITk56ckxPT3UyNFFmeWptemF5N3hO?=
 =?utf-8?B?N1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5CFBB4224FB4A49B2F1011DC768C86B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a945a05-ab05-4e92-599a-08db5b4f3c85
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 05:33:27.8652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xxug0y4s6bdbSccm6QvQrIVz4ghDP5mTa6EUWolEZBavJHqiV1/O9vmvibwKcMTAKWcynN560T/kH8msRvWK6SarGEdAx+Ej9KN2ilHJEXctD9VXsovxOO48aN+xQft+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7158
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgU2ltb24sDQoNClRoYW5rcyBmb3IgeW91ciBpbnRlcmVzdCBpbiByZXZpZXdpbmcgbXkgcGF0
Y2hlcy4NCg0KT24gMjIvMDUvMjMgODozMiBwbSwgU2ltb24gSG9ybWFuIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIE1vbiwgTWF5IDIyLCAyMDIz
IGF0IDA1OjAzOjMxUE0gKzA1MzAsIFBhcnRoaWJhbiBWZWVyYXNvb3JhbiB3cm90ZToNCj4+IEFk
ZCBzdXBwb3J0IGZvciB0aGUgTWljcm9jaGlwIExBTjg2NXggUmV2LkIwIDEwQkFTRS1UMVMgSW50
ZXJuYWwgUEhZcw0KPj4gKExBTjg2NTAvMSkuIFRoZSBMQU44NjV4IGNvbWJpbmVzIGEgTWVkaWEg
QWNjZXNzIENvbnRyb2xsZXIgKE1BQykgYW5kIGFuDQo+PiBpbnRlcm5hbCAxMEJBU0UtVDFTIEV0
aGVybmV0IFBIWSB0byBhY2Nlc3MgMTBCQVNF4oCRVDFTIG5ldHdvcmtzLiBBcw0KPj4gTEFOODY3
WCBhbmQgTEFOODY1WCBhcmUgdXNpbmcgdGhlIHNhbWUgZnVuY3Rpb24gZm9yIHRoZSByZWFkX3N0
YXR1cywNCj4+IHJlbmFtZSB0aGUgZnVuY3Rpb24gYXMgbGFuODZ4eF9yZWFkX3N0YXR1cy4NCj4+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBQYXJ0aGliYW4gVmVlcmFzb29yYW4gPFBhcnRoaWJhbi5WZWVy
YXNvb3JhbkBtaWNyb2NoaXAuY29tPg0KPiANCj4gSGkgUGFydGhpYmFuLA0KPiANCj4gdGhhbmtz
IGZvciB5b3VyIHBhdGNoLg0KPiBTb21lIG1pbm9yIG5pdHMgZnJvbSBteSBzaWRlLg0KPiANCj4g
Li4uDQo+IA0KPj4gKy8qIFRoaXMgaXMgcHVsbGVkIHN0cmFpZ3QgZnJvbSBBTjE3NjAgZnJvbSAn
Y2FsdWxhdGlvbiBvZiBvZmZzZXQgMScgJg0KPj4gKyAqICdjYWxjdWxhdGlvbiBvZiBvZmZzZXQg
MicNCj4+ICsgKi8NCj4gDQo+IG5pdDogcy9zdHJhaWd0L3N0cmFpZ2h0Lw0KQWggeWVzLCBzdXJl
bHkgd2lsbCBjb3JyZWN0IGl0IGluIHRoZSBuZXh0IHZlcnNpb24uDQo+IA0KPj4gK3N0YXRpYyBp
bnQgbGFuODY1eF9nZW5lcmF0ZV9jZmdfb2Zmc2V0cyhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2
LCBzOCBvZmZzZXRzWzJdKQ0KPj4gK3sNCj4+ICsgICAgIGNvbnN0IHUxNiBmaXh1cF9yZWdzWzJd
ID0gezB4MDAwNCwgMHgwMDA4fTsNCj4+ICsgICAgIGludCByZXQ7DQo+PiArDQo+PiArICAgICBm
b3IgKGludCBpID0gMDsgaSA8IEFSUkFZX1NJWkUoZml4dXBfcmVncyk7IGkrKykgew0KPj4gKyAg
ICAgICAgICAgICByZXQgPSBsYW44NjV4X3JldmIwX2luZGlyZWN0X3JlYWQocGh5ZGV2LCBmaXh1
cF9yZWdzW2ldKTsNCj4+ICsgICAgICAgICAgICAgaWYgKHJldCA8IDApDQo+PiArICAgICAgICAg
ICAgICAgICAgICAgcmV0dXJuIHJldDsNCj4+ICsgICAgICAgICAgICAgaWYgKHJldCAmIEJJVCg0
KSkNCj4+ICsgICAgICAgICAgICAgICAgICAgICBvZmZzZXRzW2ldID0gcmV0IHwgMHhFMDsNCj4+
ICsgICAgICAgICAgICAgZWxzZQ0KPj4gKyAgICAgICAgICAgICAgICAgICAgIG9mZnNldHNbaV0g
PSByZXQ7DQo+PiArICAgICB9DQo+PiArDQo+PiArICAgICByZXR1cm4gMDsNCj4+ICt9DQo+IA0K
PiAuLi4NCj4gDQo+PiArc3RhdGljIGludCBsYW44NjV4X3NldHVwX2NmZ3BhcmFtKHN0cnVjdCBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+PiArew0KPj4gKyAgICAgdTE2IGNmZ19yZXN1bHRzWzVdOw0K
Pj4gKyAgICAgdTE2IGNmZ19wYXJhbXNbQVJSQVlfU0laRShsYW44NjV4X3JldmIwX2ZpeHVwX2Nm
Z19yZWdzKV07DQo+PiArICAgICBzOCBvZmZzZXRzWzJdOw0KPj4gKyAgICAgaW50IHJldDsNCj4g
DQo+IG5pdDogUGxlYXNlIHVzZSByZXZlcnNlIHhtYXMgdHJlZSBvcmRlciAtIGxvbmdlc3QgbGlu
ZSB0byBzaG9ydGVzdCAtDQo+ICAgICAgIGZvciBsb2NhbCB2YXJpYWJsZSBkZWNsYXJhdGlvbnMg
aW4gbmV0d29ya2luZyBjb2RlLg0KWWVzIHVuZGVyc3Rvb2QsIHN1cmVseSB3aWxsIGNvcnJlY3Qg
aXQgaW4gdGhlIG5leHQgdmVyc2lvbi4NCg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCj4g
DQo+IC4uLg0KDQo=

