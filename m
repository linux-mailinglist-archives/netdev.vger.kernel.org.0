Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F2E2F5F20
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbhANKnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:43:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5555 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbhANKnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:43:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610620985; x=1642156985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sXN9DbQVc/sgKaFnh/p2/p/3ilUNERt3JAO34CLinWs=;
  b=OJUCFl4Ww+VPpmHKNjavVFurx8lCyv0VWbi8SE9uoVHS0YT2qEt+7+US
   Bm6uPpO+wgS4Z3qYBWPWUgkvHiN1nwvj+HDuhCgjkCoVG6kSr4hmGZplh
   zRPongmvT1RFnJmBQAvCfTrC1raJRilCUBMUdviEjyj/TglmBqndebP3Q
   tYSFi6aM+h2WPgpttLRkRltnC3ZUkN0b4rHAdb3mBo6594A86FkHtYtmV
   xVNa6ov4HEkQ5k2HvOcwWDdPoIVnA0ScpuAYPoWdVPka5gCdK7eDQWB6D
   /z5hDOpfvF802SmJoV2do9rr6PojxvZsFCLZXAQ9+qWL4AF/aedY9wDie
   Q==;
IronPort-SDR: x3+lJNpVxUieZ1DpDoiVU/9R5lEpBsPeCRkLK/ptBSTPjt1xbFne2ezggc/DxHw1veJG3VEfwb
 qveQIwK5E2lfWuzLqpgR5VsVpMwn1WAQSN/HzDIj0tPW7q5c5kxADS5fmj9DSlwR9GJcvyyonc
 hjGcyQfdjNCBErULur4B3Q0q2PuGkESv3T+5Zm5x4eP23ZBkCqlStvNl7KYeuX2zL5fctG13vx
 tqj1OD1Zu57sI1dGXWHNXBOtdkdaj4qhoxUlMMxz10iBwAUNTfLlF9s3tp4y9nvrQSgh1G2veq
 P+g=
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="40393262"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jan 2021 03:41:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 14 Jan 2021 03:41:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 14 Jan 2021 03:41:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPbao10oYZf51SQ4IYFpI84nCJjQzqMSF3p23/e6+zj2p9lITUiGTGIUuNYg87k3QQ2HrEJSnApoyRGnqiqMCAxT6rTe45J6ZnQJRf4qrLl39rhdrjqjkQ7bxgA4smYG9qoUUXQRe4K5lP09BI3/zfGjY5oc1wACsz6w0TojrRyz2NnAHFCvOJwosBj4IUZ9a6tu31H/CsjGb4dIJyMQ7Rjw4BzhGjdf2cA7sSq81cdzbhqOavzX/wHWpfZ1+/gxKV913zxj/F4j5bP2Rs6URQJ4gal/2UHAdX0lr0PfMldnTm6JXCMTEeBcY2F7noDnuavPfgXwFw5cNZPcZiW3FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXN9DbQVc/sgKaFnh/p2/p/3ilUNERt3JAO34CLinWs=;
 b=Xc+Yi5zV+yFwKhZ3knoCk9Rj4TdXNY9KnyE0ZXri0FtcDUTS0EeXBvkg4PRz1ANwzdJMAQQH7msXK7iynWLn/+jAwgQwGmIK5ckTdbOQUwb4Y40k1FN3j28DKQopDQPNRI8D7E71zQip+51eFRE05VTii7eEH7i1a8e37sVVryQp5IkPNfQxXwhQLDY6skWGHuUsgp5h6elFBd7CE+IqMw2KxpoL87DZk9XcMdiJyr/s8VS/p3xE6viI6JSh0hspJUPCIUl77uvnvpwLysG/U0eNSqzM1kpzNOcNc2t6VMlTdnL1aD2EGkXwW77M6USmOp3Eu4pkooKhLO8fX9JPSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXN9DbQVc/sgKaFnh/p2/p/3ilUNERt3JAO34CLinWs=;
 b=WFZfh7134QZOfPmFKXFLcFIWW/nZCtYH5IHs3YF0cZCWOZDh0lI/IqSfshrlRS9xMlHJOEIl2VK5fixV2LBRpJCczQdbgUSQr4nfB3+iLFKewQm8qQlLBYBjWsmHCwi9aZz+WnWvQLhfNHo5mnqHybgADCS/zvrKwU+Ic9lriYs=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM5PR11MB1674.namprd11.prod.outlook.com (2603:10b6:4:b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 10:41:46 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::b96e:6776:6971:80f4%5]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 10:41:46 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <linux@armlinux.org.uk>
CC:     <hkallweit1@gmail.com>, <andrew@lunn.ch>, <davem@davemloft.net>,
        <kuba@kernel.org>, <rjw@rjwysocki.net>, <pavel@ucw.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Topic: [PATCH] net: phy: micrel: reconfigure the phy on resume
Thread-Index: AQHW6Y6UrG2j4PiM1k2BT3XuGZuJHg==
Date:   Thu, 14 Jan 2021 10:41:46 +0000
Message-ID: <fe4c31a0-b807-0eb2-1223-c07d7580e1fc@microchip.com>
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
 <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
 <d9fcf8da-c0b0-0f18-48e9-a7534948bc93@microchip.com>
 <20210114102508.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20210114102508.GO1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [82.76.227.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10fe355b-c275-4dc5-5a52-08d8b878fdf6
x-ms-traffictypediagnostic: DM5PR11MB1674:
x-microsoft-antispam-prvs: <DM5PR11MB1674397A8C169DCDEBA4381187A80@DM5PR11MB1674.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+9eqpDft6dwB+SnsrpWKtRVsoXik+GmYGxzf3gpQKCdFqWt9MG1jL59pqDGTbBck6lv12WRQ6DgGV9xz2sZX7PulxRQxRtTIbJc2hZvbRFy/nM1fM+09cxAnd1A3WQjnAzZzXNg+eOyOo39rDb5YpCKDgITj3SgHzujicqzAcjBgZQm9t0YEAzEnooaxWCwOAUPXUrvriZOnYCn/WVUgY2C1erJy5LQc776nq/Il86//kHE/G0tIDD8aklzYc2UjEjHWEcqQI73Ob2lKSCcBcBz0xkW024AcVG6ZL7PSMgvaOzH8Ha1FpfJXYtyyqAXmZp2xqhFEGvXN3fLbZ1H/PDLBZ4QbtCid2a4ntOiABO4Xlb0mwBdTy+WnEaqHhy4N1c+qp4S49bOpFAPi8VpuQZuaApJIVV/mM8kZdTjkLZm3Y8KSz0vDhpxdeM/nobVTHnPa9QMwL/L8Unv4zP0YLS9h2pKKCic5BYZORKQ7O00RB75hb9dkwqW2AKU8fICrpMguqC0WeswKy2JXBdkq3pA4sKDnAe+dcPLZSSOxM44yQfhp5cPDU0lwvdXzaB8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(39860400002)(366004)(376002)(66946007)(66446008)(8936002)(64756008)(36756003)(186003)(66556008)(66476007)(8676002)(91956017)(76116006)(6512007)(83380400001)(53546011)(26005)(31696002)(6506007)(6486002)(4744005)(54906003)(31686004)(4326008)(478600001)(966005)(6916009)(316002)(7416002)(71200400001)(2616005)(86362001)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L0hnVGs5aHFpYlp4cWVaM0ZLM2VJa3dudzFTZFJFV1g5Y0lMZlBOSk1EUDZ3?=
 =?utf-8?B?bDh0MHBxcmVJNDY2V2V6dzMwZHk1SUFxNkUxNHNvTUh5ZFpjSmxuQ0t0cmNS?=
 =?utf-8?B?TEVVK293SmF6dkNCTTV3Sm5nblF5SnUxRzBoeDdESUhrUHZYcm5WdkpkRWZi?=
 =?utf-8?B?L3ZrTm13cW4rYld2WVhBVXUrSzVwcUdKT20wUGU5NXgrUTJNMXNBNHJqalFu?=
 =?utf-8?B?L3VjNVZWZlBIUUNCdHRTYlR2YzJ4RlMzUThPZzUwcmxkd3RsbWkwZENuREVm?=
 =?utf-8?B?Z1V3Z3BUMk1rZGR0UGVwZ3RqZlhDNGY3VUtKRFRFbHVhWW13Q0tjZU9NVUtz?=
 =?utf-8?B?anl0NXY0ZFBPSnA3K1FvOUdsaDhudVNBWUgwRXp0cC9wUFczNy9TeFFwcEw4?=
 =?utf-8?B?NXpLWTcvOGp1U3N4UjBndm45TlY3bzNZRGE5M21sTzJYa1JoTVpVZlhYZWVa?=
 =?utf-8?B?cWk3OUtmVWxTcjdET0VrZitMTk5adkMzcnphQXZqa3ZaZDYybml0bzN4U1Az?=
 =?utf-8?B?MHk4a1gyb0VFbEJqMjlPUEZPVlJlWCs5WWhWdXJPZGFET0NCd3pqMlJoRUFi?=
 =?utf-8?B?eXRXaHZLSC93eFNoekRWUWRGUTNnRnUzSjYvL2hZZnJTQ3JyTFJlcHZKV1lM?=
 =?utf-8?B?NVpJVVJ3ZktFOGxwVEJuVUh5RVJiVE90MjNvUW1ZRUg5UlRvNUtZaEhZTE14?=
 =?utf-8?B?U25GMlpDMFZUQUpBN2VtLzZpQUk3bVluMTNITWVjSDV1QmVIem9MMDd2MlIx?=
 =?utf-8?B?NCtXK1RuTFpDYWdhTkpxMUV5ZmJ4UkpZTmtKVmhZZlFHTGFFeTFUNnlKQUx2?=
 =?utf-8?B?aHZkZnNFRDJ4bEJiY1NXcmoxT0JmeVZmQ01pZitqc25GdXd6eDE3eTl1eFhW?=
 =?utf-8?B?OFN1NWxaOTZtUGNsZ3ZEeHVGekdPdW1RRHZmS2JlTEw1cWhNaTZMRTc4UnZw?=
 =?utf-8?B?OGRFQTFvMlRuOFZzWlNaclR5RDJ4NmFiRGN3YUZXdnlwY2c3ZFIvYVAyTjRC?=
 =?utf-8?B?eGJBZjFlL0FvOTRLdldPaDUxbHZsOGd2WWR1RDRWcG1zQ3ZnbXZlM1h5Y283?=
 =?utf-8?B?NlFvUnNTSXRjSkFUYXRWZm1heTlWZzhoM1pWQXFRb0VQZE4vNWtZc3BWY3hq?=
 =?utf-8?B?QVhIVDRSeTRqUmVZSUN0UUl1ZjBUTEpDYlpuSWt2YnpKYUxnRmwzOTViV08r?=
 =?utf-8?B?ZTdRZ29ocS9KaXkzRDdnTVlKRmNEQTVTaEZTUDc0M0N1RU5uZm5JQ2RIa3Ft?=
 =?utf-8?B?T3R6cGNxaXZEVGlJTjFjTU80ODFoWk5lUFZFTWpkaFJPVU4vOXVDS1pqeXdF?=
 =?utf-8?Q?URMAccFex70lLDaVkmYttzB1mnBSojB/75?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B109A135574A5448683246C753961E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fe355b-c275-4dc5-5a52-08d8b878fdf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 10:41:46.8112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wfmWtEw5A+gJx20JuopMAZH+o1GxXOm2cjieW9Qc3eCdLK7xYoHl2q5i8DKwBwB5XbFhzJ5LPgYq5vkUJYedo7w7tJ/1SjHHT7/gAUfFysM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDE0LjAxLjIwMjEgMTI6MjUsIFJ1c3NlbGwgS2luZyAtIEFSTSBMaW51eCBhZG1pbiB3
cm90ZToNCj4gDQo+IEFzIEkndmUgc2FpZCwgaWYgcGh5bGliL1BIWSBkcml2ZXIgaXMgbm90IHJl
c3RvcmluZyB0aGUgc3RhdGUgb2YgdGhlDQo+IFBIWSBvbiByZXN1bWUgZnJvbSBzdXNwZW5kLXRv
LXJhbSwgdGhlbiB0aGF0J3MgYW4gaXNzdWUgd2l0aCBwaHlsaWINCj4gYW5kL29yIHRoZSBwaHkg
ZHJpdmVyLg0KDQpJbiB0aGUgcGF0Y2ggSSBwcm9wb3NlZCBpbiB0aGlzIHRocmVhZCB0aGUgcmVz
dG9yaW5nIGlzIGRvbmUgaW4gUEhZIGRyaXZlci4NCkRvIHlvdSB0aGluayBJIHNob3VsZCBjb250
aW51ZSB0aGUgaW52ZXN0aWdhdGlvbiBhbmQgY2hlY2sgaWYgc29tZXRoaW5nDQpzaG91bGQgYmUg
ZG9uZSBmcm9tIHRoZSBwaHlsaWIgaXRzZWxmPw0KDQpUaGFuayB5b3UsDQpDbGF1ZGl1IEJlem5l
YQ0KDQo+IA0KPiAtLQ0KPiBSTUsncyBQYXRjaCBzeXN0ZW06IGh0dHBzOi8vd3d3LmFybWxpbnV4
Lm9yZy51ay9kZXZlbG9wZXIvcGF0Y2hlcy8NCj4gRlRUUCBpcyBoZXJlISA0ME1icHMgZG93biAx
ME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCj4g
