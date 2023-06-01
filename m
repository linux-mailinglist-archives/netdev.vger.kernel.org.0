Return-Path: <netdev+bounces-7239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3684E71F403
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EC692818E7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E31323D58;
	Thu,  1 Jun 2023 20:41:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0329122626
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 20:41:48 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1239A8E;
	Thu,  1 Jun 2023 13:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685652105; x=1717188105;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cxOUhmW96k37ryRC/dcUPpZVQjDQ5Es5RIk/MocYFjo=;
  b=qO/bSXSeWVUpKP9cIZJsqecKjmx3CnDcKEn9zR3VsQn7AZTbsRaICRiD
   ++4axIBWnTXZhpv57Rd8MFTpMHFj80Nq6dgvPJNirrRRDmnYCvUnfmnKu
   xuA6UVJafI07kSRYyr5FIRRZ6kEgATBtnI0IuSwRHVMqhB7I+rncnSVnd
   uUZEQIGy11j00Q37R68yZkIYCBZiBOh+nC5uNJel4X673u3D19+DDobr6
   4QQqAO3v75wu6hP2Rw7OQdqmtMw7Wclo0zxu/0pTJpkj60N55Nn6tWZVc
   MM5BJuvgJVuXt+/VL3dCA2DaBz6CnC4nhRuHGPz7xEPI1tB67hURJaelU
   w==;
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="155129884"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jun 2023 13:41:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 1 Jun 2023 13:41:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 1 Jun 2023 13:41:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bhf3d481gCwmS7TcoTGIhsg7puWuyLQhA6/KEr4S3YLOa5IDC1Ksniv8425eYXPAf0cIPrwtXc8gA7ap9/2sNikb2HMj3m+5fEjPODT93uIpvqZkxn+CLN/o/upLmTsUzvu9GxFqiIbO+qEuFukrleopoY2DpCb4i7t4uoGpC9BIccSLYGvAHqRcac0wiOdBhQGY32oQTTUCGhpLRSryjOm4SRaDIzi1vQlvy2JP5oMiuJ+j8XS862kxvn9BvhR/y53C5yT80LQ6r9e4Ufci+iEEiYrGYhLY1Yt4u+Py3CIlW8pxt16AT/zmyaDQVnD0Bo5SxikoltJCfewXo79JrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxOUhmW96k37ryRC/dcUPpZVQjDQ5Es5RIk/MocYFjo=;
 b=RTt93zTj25+aqkA4H/+o/5R23pxacFNP//P0eXYfPQEfFqSy63Qi7plM5OJGbzI3u/HfjMUkrjgq4Wf292rugS8NUy8Od1fyRDrc7o5xptt3T5HB3/kv5skoAxELbka2JT3FBWFwtgNDbIFjPCrS3iEKRxeCQgCuI0jVbDSxrLYqZgca+P54Z8cC3gNl2Mr2YRn7JVgRPIYJ0fhdohtIqgVArMopE4nuHdjO950YEsQUyCW/BvEPgds3BV6cMaHNWRLgCIhClxGReukj6GGFLwnIdYEyHWFf+Y/kYf1CN6lscr4Hd6aA/c28Xsl3yi99isPDpdhcjXq3H+S4nFI37Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxOUhmW96k37ryRC/dcUPpZVQjDQ5Es5RIk/MocYFjo=;
 b=lqtBKD9dguvbHqqRD6d2PAp3c7JyMuG32hhrtmfzLy0IzHd5x8xRu/mHv+gQBrkMQ0913Fv/6phZtJfM9COxHw/cstYYZaehJ8YmJDjHB8TYI2ufJYECjh2nXe5xIAhtq5Q3+cQwurd5IRiOP+bkGQjA8AMMd24bL0E+OCXAZf4=
Received: from SN6PR11MB2926.namprd11.prod.outlook.com (2603:10b6:805:ce::19)
 by CY8PR11MB6962.namprd11.prod.outlook.com (2603:10b6:930:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 20:41:42 +0000
Received: from SN6PR11MB2926.namprd11.prod.outlook.com
 ([fe80::76c9:329a:749:8c52]) by SN6PR11MB2926.namprd11.prod.outlook.com
 ([fe80::76c9:329a:749:8c52%4]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 20:41:41 +0000
From: <Woojung.Huh@microchip.com>
To: <justin.chen@broadcom.com>, <andrew@lunn.ch>,
	<florian.fainelli@broadcom.com>
CC: <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>,
	<bcm-kernel-feedback-list@broadcom.com>, <d-tatianin@yandex-team.ru>,
	<Yuiko.Oshino@microchip.com>, <Horatiu.Vultur@microchip.com>,
	<Steen.Hegelund@microchip.com>, <Rakesh.Sankaranarayanan@microchip.com>,
	<Arun.Ramadoss@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Thread-Topic: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Thread-Index: AQHZlAIdlxw5rN1al0SxVgd5D0bhKK92GuyAgAAHrQCAACLhAIAAAs+AgAADH4CAAALRAIAAHLIQ
Date: Thu, 1 Jun 2023 20:41:41 +0000
Message-ID: <SN6PR11MB29261BD713D2FE27F2FBCCD3E749A@SN6PR11MB2926.namprd11.prod.outlook.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
 <ZHi/aT6vxpdOryD8@corigine.com>
 <e7e49753-3ad6-9e03-44ff-945e66fca9a3@broadcom.com>
 <eda87740-669c-a6e1-9c71-a9a92d3b173a@broadcom.com>
 <e3065103-d38c-1b80-5b61-71e8ba017e71@broadcom.com>
 <312c1067-aab6-4f04-b18e-ba1b7a0d1427@lunn.ch>
 <81cf54eb-98a0-e786-3526-fa422e0c504c@broadcom.com>
In-Reply-To: <81cf54eb-98a0-e786-3526-fa422e0c504c@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR11MB2926:EE_|CY8PR11MB6962:EE_
x-ms-office365-filtering-correlation-id: 8df0fb56-011d-4775-ec46-08db62e09b03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 72Bu/alvB7S6SlyA4UlR6B1w9gPucbPG5P3iGakLU3jB53ZC8PQbEOCXtwjkeKWo/VfK5t5Qyn4Kv8PXK0OqKiBp7+Vnia2/y/bYhQt/8OR/QOe9nFVeuk4lm0cOu83D+84rBWRLLcZeIw25f8mquWhtKne9X0xDavptvFCl1HmSB1ZPzNdHBs/VUzG9z+ty6tf54nRRMfeg0kd8WCR3XIOPeZ0jAKtCB1n7e0TlLLb6Kwj2D1pKyvadhOqnTfuB4d3qCzP35PXBHoXnVcmGNCbTKkc3ze0l/MW8V0EWYNhkzJSpBNPofEhJ2ml7gdxTeaXanFhiRas8PVpso0DA4V3DLh2TG0THuuy4HGdVkTJhStbK4FyCDzC6VV/IZP8lNY3eY4A5cRc+4MvBXS+50Zd5E+X4nnhg1PaumOE2kSEcDebrKTddaeMc1C5crIkn63/7U75w7Nd+CbXstTNLj+KQ7/Kr+znX3gQnwSxHWBPW+hJkuAbrLxiZvtLb9wVST6aap0ha1FFwFN7N6q8ugzDG6buENbTQKAwkbt1aCLRmeIsQN4vAHfy3idU+4mNJN1oyfcyPqTYR/DsvThe2FhgBNdxEjp+CrhYt8T4Mr24wtzNffQWfIakQFly5spLa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2926.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(76116006)(66476007)(66946007)(66446008)(66556008)(64756008)(7416002)(4326008)(316002)(41300700001)(110136005)(54906003)(2906002)(52536014)(5660300002)(8936002)(8676002)(7696005)(478600001)(71200400001)(107886003)(55016003)(6506007)(186003)(9686003)(83380400001)(33656002)(53546011)(122000001)(26005)(86362001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHZJYWtDb2tYVit4UytuU0pRZWY1Q2JzcWZSZ2Z1VXVWOUU5aWRvMjd4MXJE?=
 =?utf-8?B?MUh4MzU1Q3RhSWhXZUtPUUtzTkx5bDNjdnRiY2tNV002dWo3THg0bXgzNHMx?=
 =?utf-8?B?Ym9sQWFyZTJldndjNVdKSHJCQmU5N1NJOWZ3eTJaZWFua0ZvSnFmcDV5NXpZ?=
 =?utf-8?B?aUtZL1B5VlVtTjVYdUZCSGwwQU9QWWJtR09ONXU1V0Q2VDUwam9mZndLQmtT?=
 =?utf-8?B?VDY3b3dYRVBJVmxtMTBuZ2VJYndLTGIvanNubkx3RjF2K0o5bnNZS3JrWkRC?=
 =?utf-8?B?dzBOQ0wrdktIeTZPTGFENSs2SFljYkl3RTNkRkhtMXB5dmdZV05UdnlDc3hj?=
 =?utf-8?B?bDBBajlKbnRjRkwzNFBtZXpjNmpYWm5zNWV5UUhKOERTbW9kMzZOSW5lbzZE?=
 =?utf-8?B?UUl0dWJkRC93UWEzNXRlT0tOdTMzRE14WHdBTDlMR0pwWFJJNUY4NitjZVZV?=
 =?utf-8?B?bXJEMS91ZnhNZTFpRDh6aEhsSWV4QnpFU0RJcjRJUkIya1Q4ZFpNbUJMWS85?=
 =?utf-8?B?S3B4WTJscnEwOGxCd0w1MVdFOFdWTVYwQU1KUjdHdFJiR29pQTlIWEZOZGhO?=
 =?utf-8?B?WDhqdUxJNFNlU3R5Y0Z1WmYzTDlDa01LcmRtcTF0WnhNYi80UjBvRlpLSld1?=
 =?utf-8?B?Yk5jLzVCU1h4WWFiMmllYnFLdEpoNVNoVjN1SHV0YnowS0pxWmt3NytnUUFi?=
 =?utf-8?B?WDJkNStaZkI3WmphZURjZEJoYkpQTXJNd0JMLzZDU2RQT3Bva0YxcFlYbWQ4?=
 =?utf-8?B?MEVqT2MzRkc4WkppQ0wxcjVubi9JdzhBei9FWkZENS9NSDlLYlQrVGd4cUpR?=
 =?utf-8?B?ZWRrV1FnTmxQeXRJVFJCK1VBUENNQjhKYXlZOEpZbEx1ZVFocVI0K2dPdjJT?=
 =?utf-8?B?bEZheHpsN3hmdit4MFpWTTg5OTZwNTZPSFM3T2QvRHp4R2xGV2Z6Z3hDWStZ?=
 =?utf-8?B?OUdPMzd2WDdjYVJ1czU2cWtld00yRytVTlFwQUZmSUVnQW9SWkw4a0dUZGxv?=
 =?utf-8?B?Uk9USlRWc3JZR3pZRmUvbk9McE5xbGRaUmIybFhONHlvUHFINTc3RTlCYjdt?=
 =?utf-8?B?dGVrVDBRR05aa0ppRWNvVk5uVExqUzhuUGNwK3E1aEMxYUsyNjY4R1dmMWY3?=
 =?utf-8?B?OXZvWHQwLy9TeVVHOE5USnJWc1BlRVF6SG0wMHdoWjJBQzR5Z1JjbDYvNnY1?=
 =?utf-8?B?VjZaakVXaW9DZVBOV2NLZFRPVGJENnlhbkQ3TTVLQUx6Z1NaRmYyUkFIUGtW?=
 =?utf-8?B?Mk5POU9NRHhxNEFyK1p3U3RSQzdwNHFOR3ZjUUI2QXI2UW1vMWVOS1hLdmNM?=
 =?utf-8?B?bFh5TTRrbld3dmlnNEd4WU1ldUdvL0ttdm5GV3NMc3NmYy8xbmdGYlU1d2cr?=
 =?utf-8?B?M2VQYUdHamNFQTNaUk1CZ1JOeXFoRFhCRGlHblJsMmRDT1k1QjNVL2tGMGx1?=
 =?utf-8?B?OTFSL0VnNm1XNVk0Z3hJK2lEL3BpcDRxeWp2ZE9XMmpST3N0YmJwVnlEa2dB?=
 =?utf-8?B?eFBFeVVpMGFCTnRFUERCeDZIQ0ZCTHhpWkpPNjFrbjI5VFp4QnNPb1VDK2Y3?=
 =?utf-8?B?RDM3VkpPZ3VTeFBVdzE4UkVLdmJvR3NFUEhvWldOOTZHYnNXeUFTYWUyaGlq?=
 =?utf-8?B?WTZWUXo2a2I0L3pUZUtuM3VOcHM0UEc0TXhIdUhSQVBRb0FQQkczZElsYnJH?=
 =?utf-8?B?cDEvV2NOdm5PcUUrVTMvblVlM0VXK1lQSXF6UWc3T283QTFacEFVZmI5Nk5x?=
 =?utf-8?B?SDBEZ2ZJUlRJMjhWSlM2S0V6UlpzeUQwSGVjVDgzd3drWlZmNktJakdKS3hk?=
 =?utf-8?B?RzJtQ3dXSXp5Z0FjVGdibXkyWmZEdVg3ZkRNV2xzMFhpNkFOTGtFbml6WVlZ?=
 =?utf-8?B?cUhIc29jeFk0UkFOdkNtQ2VtMWN4YUFZd3lBdXUwSWF4TzA4MmQrK1h4ZmZJ?=
 =?utf-8?B?bm5oVWVlWGo3dGQ1L0IwTDIrZFhiU2NtMndEVk1tZFdocmIvcFpHdEN6SG1o?=
 =?utf-8?B?NVhHSjB6YjF0NGhOZzBQSkpOSUtROHdwallNQitReG1hcEJBMUNjQzllcVd5?=
 =?utf-8?B?R2pCTjkwNzcrd0x0YURNaTVFWHN4S3dnbVhheEViOVJvR0hlT3NBSXh1aFZl?=
 =?utf-8?Q?dieQkVFPRalm2zrhMqXu90j7t?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2926.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df0fb56-011d-4775-ec46-08db62e09b03
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 20:41:41.5506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjQoeTFtdhKf51zQYpmI7JtXIjNINiqEAKA0O95rGdyUwOstbI0XUshZs3Xcc5qLcv1QtN7A7AYRJl3J6rBIIZuycJrvLajcwy7TE7fuukk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6962
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBPbiA2LzEvMjMgMTE6NDggQU0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+Pj4+IEkgd2FzIHBs
YW5uaW5nIHRvIGZvciB0aGUgQnJvYWRjb20gZHJpdmVycyBzaW5jZSB0aG9zZSBJIGNhbiB0ZXN0
Lg0KPiA+Pj4+IEJ1dCBJIGNvdWxkIGRvIGl0IGFjcm9zcyB0aGUgYm9hcmQgaWYgdGhhdCBpcyBw
cmVmZXJyZWQuDQo+ID4+Pj4NCj4gPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEp1c3RpbiBDaGVuIDxq
dXN0aW4uY2hlbkBicm9hZGNvbS5jb20+DQo+ID4+Pj4+PiAtLS0NCj4gPj4+Pj4+ICDCoCBuZXQv
ZXRodG9vbC9pb2N0bC5jIHwgMTQgKysrKysrKysrKysrLS0NCj4gPj4+Pj4+ICDCoCAxIGZpbGUg
Y2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4+Pj4+DQo+ID4+
Pj4+PiBkaWZmIC0tZ2l0IGEvbmV0L2V0aHRvb2wvaW9jdGwuYyBiL25ldC9ldGh0b29sL2lvY3Rs
LmMNCj4gPj4+Pj4+IGluZGV4IDZiYjc3OGUxMDQ2MS4uODBmNDU2ZjgzZGIwIDEwMDY0NA0KPiA+
Pj4+Pj4gLS0tIGEvbmV0L2V0aHRvb2wvaW9jdGwuYw0KPiA+Pj4+Pj4gKysrIGIvbmV0L2V0aHRv
b2wvaW9jdGwuYw0KPiA+Pj4+Pj4gQEAgLTE0MzYsMTUgKzE0MzYsMjUgQEAgc3RhdGljIGludCBl
dGh0b29sX2dldF93b2woc3RydWN0DQo+ID4+Pj4+PiBuZXRfZGV2aWNlICpkZXYsIGNoYXIgX191
c2VyICp1c2VyYWRkcikNCj4gPj4+Pj4+ICDCoCBzdGF0aWMgaW50IGV0aHRvb2xfc2V0X3dvbChz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBjaGFyDQo+ID4+Pj4+PiBfX3VzZXIgKnVzZXJhZGRyKQ0K
PiA+Pj4+Pj4gIMKgIHsNCj4gPj4+Pj4+IC3CoMKgwqAgc3RydWN0IGV0aHRvb2xfd29saW5mbyB3
b2w7DQo+ID4+Pj4+PiArwqDCoMKgIHN0cnVjdCBldGh0b29sX3dvbGluZm8gd29sLCBjdXJfd29s
Ow0KPiA+Pj4+Pj4gIMKgwqDCoMKgwqAgaW50IHJldDsNCj4gPj4+Pj4+IC3CoMKgwqAgaWYgKCFk
ZXYtPmV0aHRvb2xfb3BzLT5zZXRfd29sKQ0KPiA+Pj4+Pj4gK8KgwqDCoCBpZiAoIWRldi0+ZXRo
dG9vbF9vcHMtPmdldF93b2wgfHwgIWRldi0+ZXRodG9vbF9vcHMtPnNldF93b2wpDQo+ID4+Pj4+
PiAgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPj4+Pj4NCj4gPj4+
Pj4gQXJlIHRoZXJlIGNhc2VzIHdoZXJlIChpbi10cmVlKSBkcml2ZXJzIHByb3ZpZGUgc2V0X3dv
bCBieXQgbm90DQo+IGdldF93b2w/DQo+ID4+Pj4+IElmIHNvLCBkb2VzIHRoaXMgYnJlYWsgdGhl
aXIgc2V0X3dvbCBzdXBwb3J0Pw0KPiA+Pj4+Pg0KPiA+Pj4+DQo+ID4+Pj4gTXkgb3JpZ2luYWwg
dGhvdWdodCB3YXMgdG8gbWF0Y2ggbmV0bGluayBzZXQgd29sIGJlaGF2aW9yLiBTbw0KPiA+Pj4+
IGRyaXZlcnMgdGhhdCBkbyB0aGF0IHdvbid0IHdvcmsgd2l0aCBuZXRsaW5rIHNldF93b2wgcmln
aHQgbm93LiBJJ2xsDQo+ID4+Pj4gc2tpbSBhcm91bmQgdG8gc2VlIGlmIGFueSBkcml2ZXJzIGRv
IHRoaXMuIEJ1dCBJIHdvdWxkIHJlY2tvbiB0aGlzDQo+ID4+Pj4gc2hvdWxkIGJlIGEgZHJpdmVy
IGZpeC4NCj4gPj4+Pg0KPiA+Pj4+IFRoYW5rcywNCj4gPj4+PiBKdXN0aW4NCj4gPj4+Pg0KPiA+
Pj4NCj4gPj4+IEkgc2VlIGEgZHJpdmVyIGF0IGRyaXZlcnMvbmV0L3BoeS9taWNyb2NoaXAuYy4g
QnV0IHRoaXMgaXMgYSBwaHkgZHJpdmVyDQo+ID4+PiBzZXRfd29sIGhvb2suDQo+ID4+DQo+ID4+
IFRoYXQgcGFydCBvZiB0aGUgZHJpdmVyIGFwcGVhcnMgdG8gYmUgZGVhZCBjb2RlLiBJdCBhdHRl
bXB0cyB0byBwcmV0ZW5kIHRvDQo+ID4+IHN1cHBvcnQgV2FrZS1vbi1MQU4sIGJ1dCBpdCBkb2Vz
IG5vdCBkbyBhbnkgc3BlY2lmaWMgcHJvZ3JhbW1pbmcgb2YNCj4gd2FrZS11cA0KPiA+PiBmaWx0
ZXJzLCBub3IgZG9lcyBpdCBpbXBsZW1lbnQgZ2V0X3dvbC4gSXQgYWxzbyBkb2VzIG5vdCBtYWtl
IHVzZSBvZiB0aGUNCj4gPj4gcmVjZW50bHkgaW50cm9kdWNlZCBQSFlfQUxXQVlTX0NBTExfU1VT
UEVORCBmbGFnLg0KPiA+Pg0KPiA+PiBXaGVuIGl0IGlzIHRpbWUgdG8gZGV0ZXJtaW5lIHdoZXRo
ZXIgdG8gc3VzcGVuZCB0aGUgUEhZIG9yIG5vdCwNCj4gZXZlbnR1YWxseQ0KPiA+PiBwaHlfc3Vz
cGVuZCgpIHdpbGwgY2FsbCBwaHlfZXRodG9vbF9nZXRfd29sKCkuIFNpbmNlIG5vIGdldF93b2wg
aXMNCj4gPj4gaW1wbGVtZW50ZWQsIHRoZSB3b2wud29sb3B0cyB3aWxsIHJlbWFpbiB6ZXJvLCB0
aGVyZWZvcmUgd2Ugd2lsbCBqdXN0DQo+ID4+IHN1c3BlbmQgdGhlIFBIWS4NCj4gPj4NCj4gPj4g
SSBzdXNwZWN0IHRoaXMgd2FzIGFkZGVkIHRvIHdvcmsgYXJvdW5kIE1BQyBkcml2ZXJzIHRoYXQg
bWF5IGZvcmNlZnVsbHkNCj4gdHJ5DQo+ID4+IHRvIHN1c3BlbmQgdGhlIFBIWSwgYnV0IHRoYXQg
c2hvdWxkIG5vdCBldmVuIGJlIHBvc3NpYmxlIHRoZXNlIGRheXMuDQo+ID4+DQo+ID4+IEkgd291
bGQganVzdCByZW1vdmUgdGhhdCBsb2dpYyBmcm9tIG1pY3JvY2hpcC5jIGVudGlyZWx5Lg0KPiA+
DQo+ID4gVGhlIE1pY3JvY2hpcCBkZXZlbG9wZXJzIGFyZSByZWFzb25hYmx5IHJlc3BvbnNpdmUu
IFNvIHdlIHNob3VsZCBDYzoNCj4gPiB0aGVtLg0KDQoNCnNldF93b2wgaW4gZHJpdmVycy9uZXQv
cGh5L21pY3JvY2hpcC5jIGlzIHVzZWQgdG8gc2V0IHRoZSBmbGFnDQp0byBhdm9pZCBQSFkgcG93
ZXIgZG93biBhdCBzdXNwZW5kIHRpbWUuDQpMb29rcyBpdCBpcyBvbGQtZmFzaGlvbmVkIG5vdyBi
ZWNhdXNlIGZyYW1lIHdvcmsgaXMgbm90IGNhbGxpbmcgc3VzcGVuZA0KYWZ0ZXIgY2FsbGluZyBn
ZXRfd29sLiBXZSB3aWxsIG1ha2UgYSBwYXRjaCBmb3IgaXQuDQoNCkJUVywgdGhpcyBwYXRjaCBp
cyBjaGVja2luZyBNQUMgZHJpdmVyIHNldF93b2wgYW5kIGdldF93b2wuDQpTbyBJIGRvbid0IHRo
aW5rIGl0IGJyZWFrcyBkcml2ZXJzL25ldC9waHkvbWljcm9jaGlwLmMgc3VzcGVuZCBvcGVyYXRp
b24gYW55d2F5Lg0KDQpUaGFua3MuDQpXb29qdW5nDQoNCg==

