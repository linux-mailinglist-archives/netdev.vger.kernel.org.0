Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1DD06D1E0D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjCaK31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjCaK3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:29:00 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBDE1BEA;
        Fri, 31 Mar 2023 03:28:42 -0700 (PDT)
X-UUID: cb8c33d4cfae11eda9a90f0bb45854f4-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=beg6dbkhjYHFK75c7fKPAbpUE4RAGS1Z79O36Cf8OiE=;
        b=hRvQF3b3eaQ+uT7ST5w9P6T0SgHMJex5XtZkGYxp57/fh2P9Lke071mK1bCl1lVsywwrRXCZTj0Y5zR7t2NlfVcBtsTUdcFfi3vGErJFab+otwZZ+0FykQeI7bThw3FaMS87y8KUI+yWwFgbmHrujghXbX5UpDAtpHjeMVm2Jv4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:37e61732-a24b-43ba-841b-e459972b0c1e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:c2c7f8b4-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: cb8c33d4cfae11eda9a90f0bb45854f4-20230331
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1729560657; Fri, 31 Mar 2023 18:28:36 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 18:28:35 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 18:28:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gontyocKO+o449fUk39tkfSKFqCRENpNnEJgWEOLBFBAUn1mLwK7dtJU8CP61wBWVTKzYi9cWq9qU3CquHq55lYMUzwsvWIJ9QeOonYqlwbhe2FEaiMM/ws3XXLv3L+sDerRtrAUFjy3tj3hH5pCEZGD+gu2BUNB6Las8dQEBVZipgrxQJBQ1N7yWD3i+sUxC5gihCohXi7Nv+1UHQjbNTLnB4FpMxDfB2ZXDmPI31P0HV9zkVEMbE9dBymIFWwWrgb9UMJL7LYmQw6aMd+5OcgMTCMnltBvcTgqcHmWFBauZrCxY3ylJi1ESxa+S/H36LTq+ATM09iywXkxDQu3fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=beg6dbkhjYHFK75c7fKPAbpUE4RAGS1Z79O36Cf8OiE=;
 b=MGOOxflI7NhzqZjvwHoxbl5EE6z5l2EGnb032RA+q6YND9UDMjI0gDbcmQH1+zN7JFYp48978HsXwNcyrlEeiK6suqf4c15TbMWcj4qbOOdUXhLSbTVJggROPtNEH1k7Jia5bD7DpeUK3DviL8LflboNtS4ifMrNhkygRRvAzffYRmAT8DHd75YytO+p0kzsXAkVUgtfmDw1sIyxt4ZKG6lSXqAJAK5JpBQtU0Nr1jIcaVLg53ZFO8OGMbe+J6V3LIAWucF4yKZx1wQD6B6klSCJm7nILFML3TJOIf83tia80oUnfagLToaQy/apq/Rx0TH072NR93qsoCnHWNyFzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=beg6dbkhjYHFK75c7fKPAbpUE4RAGS1Z79O36Cf8OiE=;
 b=rJwtZdJ5MkPuFy8GtQbEm90ifd2PyZah9S2ht2b+4DrdxD3WOIJHUa+P9NUETChtCrtd7Sq/YKBKlQGZGQV033j71vB9JYvEUXeI/pUshK+mmzSn5JnrWVla5AKhbUfXpR0RONhR4Kld6DrsDaURUpKrsJR0PR5v9lRZtfEJ/kk=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TYZPR03MB5853.apcprd03.prod.outlook.com (2603:1096:400:120::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 10:28:32 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 10:28:32 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 06/19] clk: mediatek: Add MT8188 camsys clock support
Thread-Topic: [PATCH v7 06/19] clk: mediatek: Add MT8188 camsys clock support
Thread-Index: AQHZY6nh8ASLjiPdJUKWD7Ml/aq2xq8UpgEAgAAJv4A=
Date:   Fri, 31 Mar 2023 10:28:32 +0000
Message-ID: <8696263f00f19c6453f31de74ce59bdbc41305cf.camel@mediatek.com>
References: <20230331082131.12517-1-Garmin.Chang@mediatek.com>
         <20230331082131.12517-7-Garmin.Chang@mediatek.com>
         <816f8d82-b66d-6fad-51d7-a37c241b0417@collabora.com>
In-Reply-To: <816f8d82-b66d-6fad-51d7-a37c241b0417@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TYZPR03MB5853:EE_
x-ms-office365-filtering-correlation-id: e3e88a12-3af2-4774-2302-08db31d2ad68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z4i2fMtmkz/as4AETpRsztUrafU+UAEI2iRVeJ5zT7VeA9s6SEcRoVtyIGO+UeE8KbCki09ggPBTTgwnXhLL+ES0ZRyQmRZo7qvB26iGNjG+PaVoWGWWepeuA6rc8dQDHFmwk6DcCHio0xiaApnuGE/XTylpq17bQPoat95BnIQMIe/+YsN3jgPo96RnC0AUBJZkcbcShWMGtxr+qjMdt+FtO61qkHbiI8tWLNtoRg34L3JYzyRVVUUoV3ExII88vfW3PHLCu8im4xKUgz6B0dZYHTfdXL+gi/2hhD2yH8RszMK+OhjY+WnjhzvMAE2M2C/HA/bX9GbCK13i334u99+I/0PuT9clzKsi9lNk6jaGpGvvEZ5+ad27z7C4qnME3Ye2WFey8RuD04DvaGmxTJWxxOs4o0NWaBqouv0twSccHan3tdMPa7WInM56/g9krUM3pL61G4lKYFWfN3PSQErYtxF/Q61mb2kp3U3EG83JiiLz8UOgCEtaxOpTG9Dyzko4DanRZj0Em7sszzSwMTnkBPs3qQAH4DBlaCmXq8Wj9lUnuiH+qx5/XJdUQBt6p0BSmthsmBXi//XrLvUF1uVa6P+FgLsKLMKMguP2Q05rq1luspNtmzuMMQeoKQyA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199021)(186003)(6512007)(8936002)(86362001)(38070700005)(6506007)(5660300002)(7416002)(66556008)(478600001)(76116006)(91956017)(66476007)(54906003)(110136005)(316002)(41300700001)(66946007)(83380400001)(26005)(2616005)(2906002)(36756003)(85182001)(6486002)(122000001)(64756008)(4326008)(66446008)(8676002)(38100700002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WnVNSG9OMWQzRXA3MGQ1REkrTnFWN1NYVDczRzMvTGlxUnNsQjgrdDk5OGRD?=
 =?utf-8?B?Zi9rcUUzTHhJNjJyYmUxVUJEY3lNUkllK3k5SXpFNk1FanJzRi9Da2d5TG1N?=
 =?utf-8?B?eW9BbWxEOUMvazNXUVFqUHk4dWRDNXVRakMzbDhvck9ZMWZES0I1cVZZVHpy?=
 =?utf-8?B?cGpPWHp2dmVtT2JKYjNFSkJYRmZDQXczSWoyd1RBdVNYVlZrMU5YZG5tc3Y1?=
 =?utf-8?B?dmIyb3VEQ3lNYStnd0VGQjhlWDhZNXNEZ3FhcitaNlpnOUpYVnFqcEpneXQx?=
 =?utf-8?B?N3RmOFQ0MGdTcWJKOTBuM1A2cHdDM3FhbjNhUm5wanFUbWl6ZTZIbkE3eWZ1?=
 =?utf-8?B?S05EMUs2NXFFbWRFNXd1VVR6Qkl0aTdlS0hZdGhjdDJCUHBYQXhpa0pjcmgz?=
 =?utf-8?B?anQ2bXVsMkNiSExucW1zZUtUTndmakNkNkFDb3kxNTNKWGw3RDAvTjRkTHhT?=
 =?utf-8?B?d01uNnBHTXVOL2d3Y2ZRbmxqTmZ1bnVNMERGa2dueHd1dGdFQzVUUUR6ZjFo?=
 =?utf-8?B?OE9GblRSVlN0c1h4ZWFwV3RMRlBRbktMMld6TUh1YnU2emFaU3dnTUNwTXh4?=
 =?utf-8?B?ejFOTlF4Wm1ydCtQeGNRYTZ5ZEpjZjZSVG4rTjQ3aWhoenBFcTI5eWx2eGFy?=
 =?utf-8?B?OG9ncXduNE5mNitodjR3bjNMVFpmUHJWSi9PMmg0Sm9sMkFiSERTbUxXOUtu?=
 =?utf-8?B?VGd2Qjc5NUZ3Y0dTWUlFWFgzSDlRbkNPM21kUDNucnRpc1VDZHQ4dDRwcU0v?=
 =?utf-8?B?azNWUXQzVXVZay9iMDBxVlg4QkZTOGtxeHhHVkROQXJRbmhDVG0rcXZwbTNk?=
 =?utf-8?B?RFZGZUtQc3lQMG5EODFIOGQ2aHlnVk5vRDBDKzFWTDBnOThrZUFyQWhucXI3?=
 =?utf-8?B?UE9rUnEzNFNLT29CMHJYY1RuUU5VaC8vT2NLTEUrdTJORWZiNUhxR2FyVmly?=
 =?utf-8?B?MXJIMWFFdm01K1BWZHdPeHI2ZWhLdzZXeVJWcmcwdlhKQWJMNWwyS1hUcXA4?=
 =?utf-8?B?Ynd5aExxOVhHNDUwT3dYZUZ5cGtoZU04bms3NFQ3Y2JCUE9hYlJYbkNlR05l?=
 =?utf-8?B?NFNiOEpWWGRkb0Q5U0s3T0lkclAyVEhKOFpSWEJ0YjZMUm0rVlVjUFVHeCtZ?=
 =?utf-8?B?Z1A2emFuMTJabjBlU1dUb2Npemd1a3M2ZDAxVmJJWjE2UFA1M00vbjRKdlVw?=
 =?utf-8?B?QkpxNlQxMXNwbFVPd2NWNkVqOGYrUWdSNTl0NUoyM29TbEFxUzNiT0FiSUFx?=
 =?utf-8?B?ZG96UU01K0NVUkR4ZVE4N3FPZG4vUHNZUjkwNHBicTJuZjQySjlEaGIyQ21L?=
 =?utf-8?B?bUE0akNoUXJKNXVidTRaVjlwSXdybjlsWjFsSk1JbFREakp5YWQ5UHVUay9M?=
 =?utf-8?B?WnZFSHp1Yyt5TVZwU0VFVmIyd1J4ZGNsM0FlNVBSa2kyMFEzRU5hbGlTcnhG?=
 =?utf-8?B?TXhoZ3hsS29TbHBLaHV0R0wyelFyazBkd2JrWkdkS3o4d2FoemU5Y0xiQjdP?=
 =?utf-8?B?SGVIbjRyMXJmLysrQmRleTU3ZjAxME12VHF4VHRKOWpwZXhja2k1VzhLbTR1?=
 =?utf-8?B?UWpTank0UFlIaHNyOEFBZWUvYURBZ3QxajZDNE1McHhNck9ZZENhUktYUWox?=
 =?utf-8?B?Z0VvN3VWY0d0bUhOeHE2UW91RnBQUE5uZU1UY09iREFXYmxJZ3FoODR2NzQ1?=
 =?utf-8?B?cGFDcW90UG1IdWdNM1d3VVQwRTgvcnNwcmpsWlJDYVNXN0NmMUxXT3I1bkR6?=
 =?utf-8?B?K2ZxSU9oRkhlWHNBT3BDQTlWdW1TY1l3d1QxL3Y3N2haZ1BHdmpjaUhUK0tF?=
 =?utf-8?B?WjZYUWpudGFUUytLZ2tZSGpPTC9IVjl0bURuSnVIQzhaeVIxempKTnd5bGJD?=
 =?utf-8?B?UEdZRFFZWHRoWmgrUnZiZDJYV1hldm5mbUtuOXBmdjJvVHRQZkt1WkhIcnFQ?=
 =?utf-8?B?dDlzL2FkWFZvOWNKZHlKN1hwdEl2eFhWcEQxVyszd0p6VWxzUzJnY1FlOGNQ?=
 =?utf-8?B?RWpYemUwOG55UytjbSttdndJWUFUUEJxMmdBd0prYWZDcU5mWm5SdHJBeXRN?=
 =?utf-8?B?MTdxVEhpMTU3cDBwdk5kR21xWUcxc2lLT3JtcW9LVnNPN3Q3b2RpVzFlcnk1?=
 =?utf-8?B?eXZobkR5Ti9iZmJScGVEb0xjNTJtUUZtZGNVcC9nS1IzSDJRY0xKM2M4ais5?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31451856BDB098469B7842C66D65B9B5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e88a12-3af2-4774-2302-08db31d2ad68
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 10:28:32.4765
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M66F6v3r99gXrDyM6alFYdhoISwvIDMFtIqGQu+RfsJTeL9OfFcBMA3prRKhpLELdlcmXpzkcE46sgEL+cJBlLft7HaoIUi6i8Z8xch1BQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5853
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAzLTMxIGF0IDExOjUzICswMjAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtz
IG9yIG9wZW4gYXR0YWNobWVudHMgdW50aWwNCj4geW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRl
ciBvciB0aGUgY29udGVudC4NCj4gDQo+IA0KPiBJbCAzMS8wMy8yMyAxMDoyMSwgR2FybWluLkNo
YW5nIGhhIHNjcml0dG86DQo+ID4gQWRkIE1UODE4OCBjYW1zeXMgY2xvY2sgY29udHJvbGxlcnMg
d2hpY2ggcHJvdmlkZSBjbG9jayBnYXRlDQo+ID4gY29udHJvbCBmb3IgY2FtZXJhIElQIGJsb2Nr
cy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBHYXJtaW4uQ2hhbmcgPEdhcm1pbi5DaGFuZ0Bt
ZWRpYXRlay5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IENoZW4tWXUgVHNhaSA8d2Vuc3RAY2hyb21p
dW0ub3JnPg0KPiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvS2NvbmZpZyAgICAg
ICAgICB8ICAgNyArKw0KPiA+ICAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUgICAgICAg
ICB8ICAgMSArDQo+ID4gICBkcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWNhbS5jIHwg
MTIwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgIDMgZmlsZXMgY2hhbmdl
ZCwgMTI4IGluc2VydGlvbnMoKykNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL2Ns
ay9tZWRpYXRlay9jbGstbXQ4MTg4LWNhbS5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvY2xrL21lZGlhdGVrL0tjb25maWcNCj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL0tjb25m
aWcNCj4gPiBpbmRleCA2ODFkMzkyNjIwYzUuLjkxNzBmNzZhOGVlNyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL2Nsay9tZWRpYXRlay9LY29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVk
aWF0ZWsvS2NvbmZpZw0KPiA+IEBAIC02OTIsNiArNjkyLDEzIEBAIGNvbmZpZyBDT01NT05fQ0xL
X01UODE4OA0KPiA+ICAgICAgIGhlbHANCj4gPiAgICAgICAgICAgICBUaGlzIGRyaXZlciBzdXBw
b3J0cyBNZWRpYVRlayBNVDgxODggY2xvY2tzLg0KPiA+IA0KPiA+ICtjb25maWcgQ09NTU9OX0NM
S19NVDgxODhfQ0FNU1lTDQo+ID4gKyAgICAgdHJpc3RhdGUgIkNsb2NrIGRyaXZlciBmb3IgTWVk
aWFUZWsgTVQ4MTg4IGNhbXN5cyINCj4gPiArICAgICBkZXBlbmRzIG9uIENPTU1PTl9DTEtfTVQ4
MTg4X1ZQUFNZUw0KPiA+ICsgICAgIGRlZmF1bHQgQ09NTU9OX0NMS19NVDgxODhfVlBQU1lTDQo+
ID4gKyAgICAgaGVscA0KPiA+ICsgICAgICAgVGhpcyBkcml2ZXIgc3VwcG9ydHMgTWVkaWFUZWsg
TVQ4MTg4IGNhbXN5cyBhbmQgY2Ftc3lzX3Jhdw0KPiA+IGNsb2Nrcy4NCj4gPiArDQo+ID4gICBj
b25maWcgQ09NTU9OX0NMS19NVDgxOTINCj4gPiAgICAgICB0cmlzdGF0ZSAiQ2xvY2sgZHJpdmVy
IGZvciBNZWRpYVRlayBNVDgxOTIiDQo+ID4gICAgICAgZGVwZW5kcyBvbiBBUk02NCB8fCBDT01Q
SUxFX1RFU1QNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUN
Cj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gaW5kZXggMWE2NDI1MTBj
ZTM4Li5jMjM1ZTlhMGQzMDUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsv
TWFrZWZpbGUNCj4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IEBA
IC0xMDIsNiArMTAyLDcgQEAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTg2X1ZFTkNTWVMp
ICs9IGNsay0NCj4gPiBtdDgxODYtdmVuYy5vDQo+ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NM
S19NVDgxODZfV1BFU1lTKSArPSBjbGstbXQ4MTg2LXdwZS5vDQo+ID4gICBvYmotJChDT05GSUdf
Q09NTU9OX0NMS19NVDgxODgpICs9IGNsay1tdDgxODgtYXBtaXhlZHN5cy5vIGNsay0NCj4gPiBt
dDgxODgtdG9wY2tnZW4ubyBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Y2xrLW10ODE4OC1wZXJpX2FvLm8gY2xrLW10ODE4OC0NCj4gPiBpbmZyYV9hby5vDQo+ID4gK2ot
JChDT05GSUdfQ09NTU9OX0NMS19NVDgxODhfQ0FNU1lTKSArPSBjbGstbXQ4MTg4LWNhbS5vDQo+
IA0KPiBQbGVhc2UgZml4IHRoYXQgdHlwbyBoZXJlLg0KPiANCj4gQWZ0ZXIgd2hpY2gsDQo+IFJl
dmlld2VkLWJ5OiBBbmdlbG9HaW9hY2NoaW5vIERlbCBSZWdubyA8DQo+IGFuZ2Vsb2dpb2FjY2hp
bm8uZGVscmVnbm9AY29sbGFib3JhLmNvbT4NCj4gDQpUaGFuayB5b3UgZm9yIHRha2luZyB0aGUg
dGltZSB0byBoZWxwIHJldmlldy4NCg0KT2ssIEkgd2lsbCBmaXggaXQgaW4gdjguDQoNClRoYW5r
cywNCkJlc3QgcmVnYXJkcywNCkdhcm1pbg0KDQoNCj4gDQo=
