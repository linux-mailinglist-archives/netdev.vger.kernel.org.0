Return-Path: <netdev+bounces-4884-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E4070EF6D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5A831C20ADF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E06846B;
	Wed, 24 May 2023 07:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBBA29A0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:31:15 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957EB8F;
	Wed, 24 May 2023 00:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684913474; x=1716449474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tAqd09KTF7E7b6LwMB2M884t4jONrpSneKFVK9xRY38=;
  b=hXf+eth/jEXWYYH2tVu/I0gG6m1SdDQFb+qEaZHRgOovvCSbyI9GHipx
   nK/Cl24aN0hHg44VxXJhs6pizny7me0yznG1Owvx8blkEwHHwuinm2HoU
   95NkagBwRu6Id81L5ERUFU1kSqGkaIN4L7mqURkzUhEHJkH9gQzjPtYLW
   xX0CTffCIzBu2IAYIvCx9EyenU28oGYqdPsplw25vVG0rRV2vOZ+TM4e2
   YI6GlrC6bO3cw/t5sqdgKz5RkcxFI2hLsCHkxljlECdgulIzz5ShNbARq
   PdW3Z17qx/qOcujraA1LItKI0nbMjvWB2rnhC/NfGvtJ1qUthdoCS0V55
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="214650638"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 00:31:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 00:31:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 24 May 2023 00:31:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SK6s9ZBNoHvoUtRCLiagaxWKLIdNIqktSGCXEi6UfloHNXRGlhV/2otgSsHfdgq9Ab8Xr9+ZUU24hgN9wJLZ/nFTPUw0hbi6t/FVHBWs42U1dfiO0/BarEq+n0N5on8l5O3/oTHwdGNboF3kJQ3GxLGtXXv7W0J8Co86wh3GCYg9JPSSZKEsGvzvSNLefhlPlpk9j/9cm8r0qojF+9+9SnfkiyCe0tYnMbe3cjbz/NTI1+npqJhLc2+I8wyRbX50XKX5gIvzxAYEt16aEFqdfsaUOPymD9QoVfj2/txYX25u1XU+TJOB3neMb43xIjPmKVvj9C+/fd3VEYjkIAAUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAqd09KTF7E7b6LwMB2M884t4jONrpSneKFVK9xRY38=;
 b=V4QXXssiK0TfuFSdbMABDJc0jZ3YLAN2Jcu6LZy5KQ/S592bL15qhtJPXIcLRTWgUdaTEG36UAE9Rgb/C2pXL+djbe11I0HYOsdEI41VkcbvUsAXsuAt4LNUpDWXVSLgoKTVrh2ejaSj4qh0k9cHAn81fatTxx5T73HK/3wQcTF3D05Ws7N5uVKMjS1ger42h9U8QlOx0R2hLeDB/umFanbXqKTWyfVRqZWb+DZ96/9Xra36bb7o5fBQ3BJw8+cJxeFsdJaJ19Wmhcw5jtXkgkEe99+n8BjyQzheDJSjYGXEIyL4zXFmTr6ehI/M8nbn7hjrGfeKqzqbXhFitF1tIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAqd09KTF7E7b6LwMB2M884t4jONrpSneKFVK9xRY38=;
 b=SIMheXn8ql3TWms08EgZWRT4RVlYK/VWIxdu5Bcp7bD/TybnZVRMDAyAQZ3Z9FHebTlEciuabJlrrM1R1/j6clYgHh7wZPf6JRIw/fr91d/HML9nIqh/9+X7anjHr9at8faibSY8Vi1eXbfgd6XjCl0vBc/493zTZzZgAmSvurI=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 CY5PR11MB6306.namprd11.prod.outlook.com (2603:10b6:930:22::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.15; Wed, 24 May 2023 07:31:10 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 07:31:10 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Topic: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Index: AQHZjKFISJBP+UyLBEKuwTcTckxbq69mPN6AgAEZewCAAHNJAIABQN8A
Date: Wed, 24 May 2023 07:31:09 +0000
Message-ID: <2523bd58-2b2c-723f-6261-aa44ca92e00a@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
 <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
 <b226c865-d4a7-c126-9e54-60498232b5a5@microchip.com>
 <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
In-Reply-To: <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|CY5PR11MB6306:EE_
x-ms-office365-filtering-correlation-id: cc1e5590-584d-480f-b531-08db5c28d823
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3j3n/aaOBpZ1+YivI9VGJr9GjgtytCrc0juvB5Cw+OdIb64XJk5ypFzSLqGGDOWL/RzLAHbxQQsz3TngD3tejUZaXlWljL7S4JmLcU5flSFJ3LSZJuTbYzdXXAgZN+RnsbhCPzaV6ftkgPTnKeKNumPOkot25d7PHi8/wodQgt0UjLAOnuSit2rMtZ0/j0TeukwVY17QWrZCFlhbVWWdo3zFlfqaxCYgYqiQh+AR7ja2fcvH2b3J3phcsVN9IlkWDBGyQTxCFz3dlbImzIuE156ewSj+ttTkjgU9Ti4IJmSLIzWkazawGtzrP373yAfDkjUKQZV0Ll+NbkbdH51IOJkex8aRdgzOTjw81WgyHR+W+QoDr/pGOv37jHioo3PhenzaugeemKB2nshdt/uMWpsrTLfC0T1PVvmLdQA+6Yn1FePjwdA3+g9+TcS0QIpKvfReKrRIHmyYBIlb1OYRc+0/kcD0Hxe1ehuu6kATArw9TjBWmRs7vEEb/2flWGd6jBmedi4CtYmINyp9pYZc0ZF5AvcYFu/MA17V6T4ucJd5inAWxWdV9Nz/GJvKC7YCV31VRUM0CdQ+SbJ2YRlXiJdUbsCPcrKGQHHdkZUfNS3KTPlqJNlF3v9Z1YCn0vZflYVRwwGoVV20363LE8rtGZuSAIUaE/JajFitRMhWtHc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(2906002)(2616005)(36756003)(186003)(7416002)(107886003)(8936002)(8676002)(5660300002)(6512007)(6506007)(26005)(53546011)(478600001)(76116006)(66946007)(66476007)(66446008)(91956017)(66556008)(64756008)(6916009)(4326008)(31696002)(86362001)(38070700005)(31686004)(38100700002)(54906003)(122000001)(41300700001)(83380400001)(6486002)(71200400001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3RZRTlmcWxrbStGV3Q1RVBYek94aXdFUFpuZlVldG8wVFlHZ2UxQWk0WkRF?=
 =?utf-8?B?RFZMVzRPY1FSdURadG14QXlrZUpBMFpZdWV6OE5Oay9MdE5tc2tVTDlBQTJH?=
 =?utf-8?B?TG8vSmF1NmNLT2s4V003a29DQmh3dmJOTlBNLzROb0plTzltSHhpRnU4WG1w?=
 =?utf-8?B?N2N5OCtTa1c3d29XNXdWek1pN0VLOHhzNk1wc2RCS1dvdytER3BBandpVytQ?=
 =?utf-8?B?Z1BNeXdBcWpnU0ZodHc4bVVnS0RDaVNmUFpkU1BTTlBwOVBZaEg1alRLOS9I?=
 =?utf-8?B?OFFtcFB4RVJRQ2xKbFM0ZHNvQ3VVOUt4bTdWcVBXeGlqNGx0dTVqcWRVSlgz?=
 =?utf-8?B?Z3cvQ1lDRmZ3WXRXLzRUZEYrMkx3Sk5LbThZVGJqYnJmSzE2UW1zRmo4a3Vq?=
 =?utf-8?B?NThLSFBUamR5OFhTbllQcm9aSTg4OUxoaU9iaVpIVjhyY05mOVlpVVFqUXFW?=
 =?utf-8?B?NlkwRDdHSjhNOG0zWDZ0Mmc5SXVHQktFSG42NzJMbjlEQkVFcnF2V3pKS2NH?=
 =?utf-8?B?U0I2M1kya1Z5aUtEdEJDeDFsR3lrY1dlM3l6YWhFdWljWDRLUHlTNHZKdzhv?=
 =?utf-8?B?bEZrUG9pK08zeU82NVlGaHdUaWJiVEhMdzJNcVpDVWEydFNVeWRUNTRWdDJ0?=
 =?utf-8?B?aE9KYlVHTnpWdzFJakRjVFpLdXV6K2Q1U3FWMTNIUWJ1RTZzSDNmSDNnQU9R?=
 =?utf-8?B?Z1YrWVNjM2dzeVhWeXpJZVB3dDAzQXhwTVd0NzdTeERPby9DU2I0N1FvSnZZ?=
 =?utf-8?B?a3MweFBRZE5pUTB0WmRSOXgzdldRY1RseDdWaEhzUjBaZVNOM3lSOHhLODdr?=
 =?utf-8?B?Wjc4RG5UNWpNMWpCbmJRNDhraFNrbHh5U3E2bi9ZR0VucTFPc3FXSnFtN3pt?=
 =?utf-8?B?OHQ4WmxMYndLd3ZKcThnQ2t5Z2FoeTh1NjY1c3ZiQU5JY0xSSGt5V1Ztc1FY?=
 =?utf-8?B?Z0pudk9MbFo5OVVSSW1vaDkxZWJWQlRiSHJ4ZWpGc1J4TEFBWUI2N09ITmhI?=
 =?utf-8?B?eVVJWENXZ2tTMmw5ZHU4WGl5eXlFRkg0c0FFMjB4cWJEMndRSC9PRUd2b09D?=
 =?utf-8?B?Y2tWbHJTMlZuRGVKY0ZkMGk5R0RyU0ppVW1XVUYvUnZUOFhRUVJiQStnNzE3?=
 =?utf-8?B?emZHMG9jMmEzcExVdWFmODd4NWZDYXJ5QVN1MU4rWW5seVgwUTNObmdzMDB6?=
 =?utf-8?B?ZktJS0JNOVUzWlYvSVlkOG9BT2k0S3ZjV0NzRmlxNERkRmZOUG03TzRiUmll?=
 =?utf-8?B?SVpGc2pjaWdBSGo2WnI2VXJVaFlpME1RODJEZzliekVJdGhQa1JjbW40VWtL?=
 =?utf-8?B?dTRVdEJhcklQajVYYkxyV0M5Q2pQNXRaQXZzRkRmR3plNjBPdkFqa0RMRDVw?=
 =?utf-8?B?WStDWGtwMGc3ektSZG9EUCtHTkNLQkV4SjhZYzdhK2hIOGJWck5wL3hkU2xx?=
 =?utf-8?B?T0Npck9nMmxUenljK0pLMmFFZ2g2QTRPOFlIRkQvQjYrNHBSQWVpV2MwMnhs?=
 =?utf-8?B?Wmxhc2xJVFpQNzd1RUREODd0QThZaXE5eERzcmtmRlNCakRReXNFZ2lEUnlT?=
 =?utf-8?B?QjBOd0psUndpZ2tvYnRidTMwTElCUlpvWHdTRzZ4THZGU05MYlhKY1RBUjQ4?=
 =?utf-8?B?c2Q2S2pubXY4YW4wNFhMK0dObU1BakxxRCs1QTZCMU9KSkpITjF3THQ0ZktE?=
 =?utf-8?B?bGtmSXhIK25VVFk1Um12Sng0c0FsQWJNcEMxeDZqcUwxT3F5TTJ2dGpmak54?=
 =?utf-8?B?bHFURnBZS0pWL2IveGZwQ3VaSFRvOVBQaFlsZ0g5VDNzMzVweEFMS0U1Q2Jv?=
 =?utf-8?B?c2Y3aWU1blNzQ1Y4cGprYkJyQnYxM2hkbTNXSkpPWld1ZzcyTWl0WGY3S3Fq?=
 =?utf-8?B?MWRIUG5CM0Rnc2tEMjJIWXU5VUQyKzlnOFd5QkFwdG1wRVlXYXBDNnpRTi9i?=
 =?utf-8?B?aGZ1a3dWbkgyeVJvUzdzNjBBbDZHRDN0RWtHb0JkeXFaczhldUp3NjU4eGdK?=
 =?utf-8?B?bTE0a2F3MnZKU1RvQ05LRllqVkVhTldkVG1UeDkrN2NYa21wZG5aNjFPVTM5?=
 =?utf-8?B?L3Zic0VoZ3hzNis0REZrT0FtZ0Jma0VxbWROcHJ1Wk9JcnNsRG5JV0JtVi9j?=
 =?utf-8?B?bmF0Wko5TGprenUrRzRockRJc21zTmMxcFNlRzcrTmxCTTFLRUlIcXlZRGRr?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4BF2ED06788A7641BFB3F58758E2E99C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1e5590-584d-480f-b531-08db5c28d823
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 07:31:09.7682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I5ymAWSBCCwW2GEjAq9zM4tmzIAmym6mP2JQhvefyUu9uW9FW7D3EXIMCQh0b+ouCueeoLwkYFkt82cBvFoeirt7A/s5xzkJvbGKWRdrH0FBb9X9hGqT4DSWzniCqR4b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6306
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpQbGVhc2UgaWdub3JlIHRoZSBwcmV2aW91cyByZXBseSBmb3IgdGhpcyBj
b21tZW50IGFuZCBjb25zaWRlciB0aGlzIG9uZS4NCg0KT24gMjMvMDUvMjMgNTo1MyBwbSwgQW5k
cmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiAN
Cj4gT24gVHVlLCBNYXkgMjMsIDIwMjMgYXQgMDU6MzA6MDZBTSArMDAwMCwgUGFydGhpYmFuLlZl
ZXJhc29vcmFuQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+PiBIaSBBbmRyZXcsDQo+Pg0KPj4gT24g
MjIvMDUvMjMgNjoxMyBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4gRVhURVJOQUwgRU1BSUw6
IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0
aGUgY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBPbiBNb24sIE1heSAyMiwgMjAyMyBhdCAwNTow
MzoyOVBNICswNTMwLCBQYXJ0aGliYW4gVmVlcmFzb29yYW4gd3JvdGU6DQo+Pj4+IEFzIHBlciB0
aGUgZGF0YXNoZWV0IERTLUxBTjg2NzAtMS0yLTYwMDAxNTczQy5wZGYsIHRoZSBSZXNldCBDb21w
bGV0ZQ0KPj4+PiBzdGF0dXMgYml0IGluIHRoZSBTVFMyIHJlZ2lzdGVyIHRvIGJlIGNoZWNrZWQg
YmVmb3JlIHByb2NlZWRpbmcgZm9yIHRoZQ0KPj4+PiBpbml0aWFsIGNvbmZpZ3VyYXRpb24uDQo+
Pj4NCj4+PiBJcyB0aGlzIHRoZSB1bm1hc2thYmxlIGludGVycnVwdCBzdGF0dXMgYml0IHdoaWNo
IG5lZWRzIGNsZWFyaW5nPw0KPj4gWWVzLCBpdCBpcyBub24tbWFza2FibGUgaW50ZXJydXB0Lg0K
Pj4+IFRoZXJlIGlzIG5vIG1lbnRpb24gb2YgaW50ZXJydXB0cyBoZXJlLg0KPj4gVGhlIGRldmlj
ZSB3aWxsIGFzc2VydCB0aGUgUmVzZXQgQ29tcGxldGUgKFJFU0VUQykgYml0IGluIHRoZSBTdGF0
dXMgMg0KPj4gKFNUUzIpIHJlZ2lzdGVyIHRvIGluZGljYXRlIHRoYXQgaXQgaGFzIGNvbXBsZXRl
ZCBpdHMgaW50ZXJuYWwNCj4+IGluaXRpYWxpemF0aW9uIGFuZCBpcyByZWFkeSBmb3IgY29uZmln
dXJhdGlvbi4gQXMgdGhlIFJlc2V0IENvbXBsZXRlDQo+PiBzdGF0dXMgaXMgbm9uLW1hc2thYmxl
LCB0aGUgSVJRX04gcGluIHdpbGwgYWx3YXlzIGJlIGFzc2VydGVkIGFuZCBkcml2ZW4NCj4+IGxv
dyBmb2xsb3dpbmcgYSBkZXZpY2UgcmVzZXQuIFVwb24gcmVhZGluZyBvZiB0aGUgU3RhdHVzIDIg
cmVnaXN0ZXIsIHRoZQ0KPj4gcGVuZGluZyBSZXNldCBDb21wbGV0ZSBzdGF0dXMgYml0IHdpbGwg
YmUgYXV0b21hdGljYWxseSBjbGVhcmVkIGNhdXNpbmcNCj4+IHRoZSBJUlFfTiBwaW4gdG8gYmUg
cmVsZWFzZWQgYW5kIHB1bGxlZCBoaWdoIGFnYWluLg0KPj4NCj4+IERvIHlvdSB0aGluayBpdCBt
YWtlcyBzZW5zZSB0byBhZGQgdGhlc2UgZXhwbGFuYXRpb24gcmVnYXJkaW5nIHRoZSByZXNldA0K
Pj4gYW5kIGludGVycnVwdCBiZWhhdmlvciB3aXRoIHRoZSBhYm92ZSBjb21tZW50IGZvciBhIGJl
dHRlciB1bmRlcnN0YW5kaW5nPw0KPiANCj4gQ29tbWVudHMgc2hvdWxkIGV4cGxhaW4gJ1doeT8n
LiBBdCB0aGUgbW9tZW50LCBpdCBpcyBub3QgY2xlYXIgd2h5IHlvdQ0KPiBhcmUgcmVhZGluZyB0
aGUgc3RhdHVzLiBUaGUgZGlzY3Vzc2lvbiBzbyBmYXIgaGFzIGJlZW4gYWJvdXQgY2xlYXJpbmcN
Cj4gdGhlIGludGVycnVwdCwgbm90IGFib3V0IGNoZWNraW5nIGl0IGhhcyBhY3R1YWxseSBmaW5p
c2hlZCBpdHMNCj4gaW50ZXJuYWwgcmVzZXQuIFNvIGkgdGhpbmsgeW91IHNob3VsZCBiZSBtZW50
aW9uaW5nIGludGVycnVwdHMNCj4gc29tZXdoZXJlLiBFc3BlY2lhbGx5IHNpbmNlIHRoaXMgaXMg
YSByYXRoZXIgb2RkIGJlaGF2aW91ci4NClNoYWxsIEkgdXBkYXRlIHRoZSBhYm92ZSBjb21taXQg
bWVzc2FnZSBsaWtlIGJlbG93Pw0KDQpBcyBwZXIgdGhlIGRhdGFzaGVldCBEUy1MQU44NjcwLTEt
Mi02MDAwMTU3M0MucGRmLCBkdXJpbmcgdGhlIFBvd2VyIE9OIA0KUmVzZXQoUE9SKS9IYXJkIFJl
c2V0L1NvZnQgUmVzZXQsIHRoZSBSZXNldCBDb21wbGV0ZSBzdGF0dXMgYml0IGluIHRoZSANClNU
UzIgcmVnaXN0ZXIgdG8gYmUgY2hlY2tlZCBiZWZvcmUgcHJvY2VlZGluZyBmb3IgdGhlIGluaXRp
YWwgDQpjb25maWd1cmF0aW9uLiBSZWFkaW5nIFNUUzIgcmVnaXN0ZXIgd2lsbCBhbHNvIGNsZWFy
IHRoZSBSZXNldCBDb21wbGV0ZSANCmludGVycnVwdCB3aGljaCBpcyBub24tbWFza2FibGUuDQoN
Ck9yIHN0aWxsIEkgaGF2ZSBhIG1pc3VuZGVyc3RhbmRpbmcgaGVyZT8NCg0KQmVzdCBSZWdhcmRz
LA0KUGFydGhpYmFuIFYNCj4gDQo+ICAgICAgICAgICAgIEFuZHJldw0KDQo=

