Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBC56D16C2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCaFZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaFZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:25:15 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E590010407;
        Thu, 30 Mar 2023 22:25:13 -0700 (PDT)
X-UUID: 66471c52cf8411eda9a90f0bb45854f4-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XjdC3pseIS8lmK2ZIKxb1FzwSSf94/aJ1nzVv4zbiHw=;
        b=pCMt3GzCejnd2Tuuh2x3dNcbjv0miCe5sX6jbFB9LK/oc2inYveekCBrwUWYc73hWuyYrFLPCvhPZT7lunKP1o63A2XDNxbTvYBTmYaZQcWCe4yPLHHTHTENrlMZLgf4xCd5QWlGRF2BKR7m/heuHW5xfeVqElzdnEd+gNMhwj0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:885ebbdf-fecd-4e24-bba9-5a58864d5e9b,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:885ebbdf-fecd-4e24-bba9-5a58864d5e9b,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:e0817cf7-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:23033113250976DGKBP4,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 66471c52cf8411eda9a90f0bb45854f4-20230331
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1276080445; Fri, 31 Mar 2023 13:25:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 13:25:06 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 13:25:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmcolyZAQp0BiucPHXiqXVy8msn5ckgO7Scm/ZDySNdiOF86RpII+JB3vHOgARVtXiVSPuJU8phKp6VHpNs8MLS1kmpC8zmupuEQrXNvxCIGBydMt4/1TCigPYV+5LF1ArcGCrY/mmIiqC+QTvoczd7jI1OgNlgDFp4GrdKhBlFDN56QkP3wLUi4bCRTB4PsE8j+IGPq4aiAXfpO80w0JmdaLh8KPNIW9gUxhdZBD30S8L698JLV3oeB/LN2z41ZZ4rkfhFNbN8KHKAEnZpMq+jSFOQekbJ1F2pTFxvlDyzk6mXRBpAwjC9kUga0YKjIwqJ6U1ibAoLTpVEx37sPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjdC3pseIS8lmK2ZIKxb1FzwSSf94/aJ1nzVv4zbiHw=;
 b=jMkj+UT3yARHNIOR8jAWCxvq/PaJ8yih+RI9eCdJXiDSZwBw175tOs8KQ/dl6K7toE7CGijugzz4YFiaFzmoyGavebdTfi5fTR84cCFV11ya6h/siwFbhQsnrB+qRyCbY0JNTL3fiwjl/lTQFQE36imOqAUt54/Rlw0yLXWsHsQ4RNngNmFnD2feg3qnrPUKZ+61BCZNRD4hx0hKuQPRRtXqGLPtO+1zUntgkPluFXTyh23jUR5UhMtamGodOKVgLeHhtl+7uFKN/tRxOrUmk86ulrkAbVc/sYefIsa02gDMB3YGD2z/S1HV3xi+qDFi3tDObpGnFqVI3E+0ndEH9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjdC3pseIS8lmK2ZIKxb1FzwSSf94/aJ1nzVv4zbiHw=;
 b=onucjxdCjd8HbgnzWpXlrLmP6YWKUf2tbJ2CIzAwJ37170npcCxd9jzE90+ivW6tPeUGY78j1ZY6rSRPtIYcIpgdN/KzJ+48vNeEe3m8Xdx7KAf419JkSf9jPiXHtj9GdYAFaRCLwEMyDa+OE7fXnJauw53dV1CpKWBd90WITr4=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by PUZPR03MB6909.apcprd03.prod.outlook.com (2603:1096:301:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 31 Mar
 2023 05:25:04 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 05:25:04 +0000
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
Subject: Re: [PATCH v6 08/19] clk: mediatek: Add MT8188 imgsys clock support
Thread-Topic: [PATCH v6 08/19] clk: mediatek: Add MT8188 imgsys clock support
Thread-Index: AQHZUo697HZXLyaDkEqjaRUnoDvPR676BJeAgBp4kgA=
Date:   Fri, 31 Mar 2023 05:25:04 +0000
Message-ID: <cd9d19eb096722f1733224ac3fcfbe3f7b266ca5.camel@mediatek.com>
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
         <20230309135419.30159-9-Garmin.Chang@mediatek.com>
         <69ae7cc9-5f75-20a1-922c-a0d505a94fef@collabora.com>
In-Reply-To: <69ae7cc9-5f75-20a1-922c-a0d505a94fef@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|PUZPR03MB6909:EE_
x-ms-office365-filtering-correlation-id: f0674523-7ef4-40ad-2929-08db31a84857
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wgxW1PGiGTA0YAAjo29p+cWLfu3qp5gXPTuFNCMWUcYl/dcqsHZ1U9QE3esRJgn2tqBmKozNsOA2CMPAQ8cLuamAYi35QwHhf+LMOGbP5WnEkFJx260BNptjsezcZrSl8YGYVlySsiqlPEl//TJOJn/1FSrMC3lbZFwr0ibr1Lw7OkfnZj40nLCueDis17gwv7D0RhGYdhdU29foLf3CXUsLaHD8BDtUISC14EuYhiVpRZdpSNF8wAQD3d4j/XRMgZkbo4dv5WzshCTJuqSqDS7+jE4S0EJig6sUrn0I8hW27uq/YjeBf8/Qwbm9L/GY73XlI+TUX0R0UUuYZSC735ddrIG87/Z7gsDRcrfwgAq2uuPpZCKvYAN/IhAhsP7t05/HJEI7kgWsg5A9l3b565vBpiJKy5QR6B8wquASBx+wIWyFKWOdJPR2RUhR5X8HHxYpuEUy63Wgq1f9+PARwUhHeiuLu6/BWUV84zbljx89FxKkJdeiCDnDcjR3B3GoHow+d+aNnFje5uUkTRykAfS3hrdeYRGrxehJyh4ROEcKOgLVD/GEzdhD1bxtwmp4KgOpUKNVcCQbIhkCNcW4f8rl/UA8ugklYpPlvc6uuxaqaXUxNHFZbKMuNWyWPy1cAGIeHxwv+HRGrwQZZVfh/YH917/MGkRDM2ZkUpajr4o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(122000001)(38070700005)(26005)(8676002)(38100700002)(2616005)(86362001)(71200400001)(6512007)(110136005)(2906002)(8936002)(316002)(7416002)(186003)(66556008)(6506007)(36756003)(83380400001)(478600001)(66946007)(41300700001)(66476007)(85182001)(66446008)(91956017)(76116006)(64756008)(4326008)(54906003)(6486002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFVadDZVb3N1LzFoM2U3VERrbXFTWWhQc0FGTFNmYmRRMEl1YUQ1TUZENk9N?=
 =?utf-8?B?VGV0dUdTUkNQTkM5SFp0MkhKMU84S3U2ZVhMejUweTNoWTlvcVNKdkVmaUsx?=
 =?utf-8?B?RER5dnV6amFHR0sxekFOSWlqTnIvSzF3RVo5RFBBMC9OWER2TU0rZmFzTE53?=
 =?utf-8?B?S1BYbUswWXdkT0FlanIzRHdWM1pWSjlBRUN6ZGpQU2lkUFNGaVU0MTVQbTZ4?=
 =?utf-8?B?UU9tL2NLMGhZaGpSVkdzWUdwNVhVT3krbXlYMTZsdnpjUHVhcWNJN2dEWWhQ?=
 =?utf-8?B?RlFWT3hmRmVwS2kzM2VpcHBPUk9SQkpydkVJclVNNjBpZmUrUFQ3UGtLd0Jm?=
 =?utf-8?B?aEtvam55OVYwTXlFWHV2ZGlySHRIYVRmTjRDbCtFOG5pbXFZMmNSb09IS2Zq?=
 =?utf-8?B?VTBrTjA3aU55VWpTT0J4TEVtdnZ5eFcxV2ZNRnY4MG1VcVI4eHBwT0dBSVU2?=
 =?utf-8?B?SHZteGVCUFdUTHFCRTNoUFE5YWRJelllTGplYitENjVDQkVNeFFuZ0V3VE9s?=
 =?utf-8?B?b0JwcmRwL09SKzlyaUs2cHdaMVBnSHlkU2lSdHlUZGVPQlVXdGpIUEdpUXRV?=
 =?utf-8?B?R2M3cys5WkFUZ0hVT0JtS1RCSEZPbU9UMGdhSDJvVzNpblJzMXZTdm5EZmlk?=
 =?utf-8?B?ZFhyR0ZVMnBNbjFzRlpRSDdFRkJmRC83Q1FZb2VJeENab0lTeE5CK0x2d2g2?=
 =?utf-8?B?cVgza0tqVjZHQkhiOVMxL2kwOXg2YythazNWYjc4M1ZHS2ZBY1c2SG81RVlv?=
 =?utf-8?B?bk1GT1J5MHB6WE1mZUZNSzU5VkxSRDlXbU0wUTVkMnczRUVmQlh0aGh5RmI1?=
 =?utf-8?B?anh4WERjc3BaOHhTK0FCUFk0bVg2aE90YlpxR3FWR3p2TTMrRzlxTU1EcVpx?=
 =?utf-8?B?VzB2WEIrME52SEZmaWkrYkVUQUhRSUZaM0N5Yy9XeGs5OXJqVzgrTEFtYnBl?=
 =?utf-8?B?NmQ0cU0zWTN3NWI3WWtCQWE3a2ZSbDk4MHZ6dWEyU25vZmZ4cWJRSjRNQkZJ?=
 =?utf-8?B?RVFxNHlMRTE0S0dSSjkrbUx4NjQyY0FNRmV5Vlk2a0lQMm5ndDVXSUNXczBt?=
 =?utf-8?B?enZjUkN3OVk0ZWZxNWdwRWRXZEk0c3ZBeE1tdkpia0RJbmVqNkJDZ3dEZmZH?=
 =?utf-8?B?Vk05RmgxakZxRjRKZ0NqbTlQbGxUeERQSExqSjBaUHlJVnFoT2FsY3k0R25a?=
 =?utf-8?B?Rm5ja3Z4Sjd3Y05ZUk1oM21IMmJBRXVCSmNudFdwMkp4Z2JUejNjLzVpd3cv?=
 =?utf-8?B?MVgzUXFRcVR1cHdMRlliT2UzRHErVUxTU2htbXl1OXRkNDRVYkxaeGxlMU43?=
 =?utf-8?B?UkxnOWxSUVRWMWhNbU4vRXoyNUdEVjlsb213dVJVVHMySUNmQlMwelY0OFNz?=
 =?utf-8?B?TTVlSW5zQnhvYXFlY2t3Wm4xTjJwVXFYVEFWeVpRYVVpck9iSjZPOERTYXJy?=
 =?utf-8?B?cXdFbWJCYm5XVmswRDM2Q2dnUU4wdmZ2aWNOT0ZGdFVCaDh5SjVXc0NSdkxG?=
 =?utf-8?B?a0NwTEh3MjBGd1ZLeHlLa0hIcTI4bGRwVjFwNThZdFpPN0JwWDY2Z2lyK3Qr?=
 =?utf-8?B?REgwb3NnNy9CUUZyU0dGZ1ZxZDFyeU1ycU5YbTg5ZjRiK3lHeW84V1o4Ny9p?=
 =?utf-8?B?T3RnaStOV012TnRyNGFqN2Q0cVJBRmVqQnBPQXVMMnVoS0hjVWQ4czBaOHdP?=
 =?utf-8?B?M1VudXRhdm1OaXFvTWdnMkdBeVpRcWM4NG1WZ0xKUUxHakpqeEgyYmVrRElv?=
 =?utf-8?B?bklXWGFoZEMyR2FwSlJheUpad0o4RUgvRjBxYnNkMVBvN0ZPUy8yRVMvNGti?=
 =?utf-8?B?ZVRNSkdDY2l0OXFEcUhWaG5CWDVIKzBBZ0cvNGVUNCtod29zVVZwbEJWYlVi?=
 =?utf-8?B?VUVZc3RuZVNORVVmMmp0SkxQTjRwU2JCYTk5akVITnpKS0g3SFc4WFhmL0xH?=
 =?utf-8?B?NXBPRVYxQzgwRlQ1SVdBcWpPSFhsZWhhSEcxK1lpKzRPZS9Zb2JUR1V1UjhO?=
 =?utf-8?B?cGY4dHFkNVdTVDBtdjFvZmxzVnJFZmx4OTJRay9hVEovQlJHUnA2alJqeGJV?=
 =?utf-8?B?alNWWjRtVXp5V3NHL1BSR0RzZk5VbHVqaXNvZ3lrQmFmK0Q1bVo5K3ovTW9M?=
 =?utf-8?B?d2NVcDc1UjBGVFgyVkUwSEJOaDRRWWJ6UWdaTjNIWlU5Zjh5cnhVREx0a0dD?=
 =?utf-8?B?Rnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <82E26B1E711C9C4395E50786FE036B06@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0674523-7ef4-40ad-2929-08db31a84857
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:25:04.0839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CFlPuf4aSlRNRxqyZEYCnxlOvLVB2KlIIj07NjZ3Ci0b7J/jFRFh7FiaKgnHlJ/1o5Nen1KsDFbkrAyC1z1YZx4C52eNYATuFdzPsy1ryGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB6909
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTE0IGF0IDEwOjEwICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gSWwgMDkvMDMvMjMgMTQ6NTQsIEdhcm1pbi5DaGFuZyBoYSBzY3JpdHRv
Og0KPiA+IEFkZCBNVDgxODggaW1nc3lzIGNsb2NrIGNvbnRyb2xsZXJzIHdoaWNoIHByb3ZpZGUg
Y2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wgZm9yIGltYWdlIElQIGJsb2Nrcy4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBHYXJtaW4uQ2hhbmcgPEdhcm1pbi5DaGFuZ0BtZWRpYXRlay5jb20+DQo+
ID4gLS0tDQo+ID4gICBkcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZSAgICAgICAgIHwgICAy
ICstDQo+ID4gICBkcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWltZy5jIHwgMTEwDQo+
ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTEx
IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBk
cml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWltZy5jDQo+ID4gDQo+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRp
YXRlay9NYWtlZmlsZQ0KPiA+IGluZGV4IGZiNjZkMjVlOThmZC4uOTM1ODA1NjMyMDE4IDEwMDY0
NA0KPiA+IC0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gKysrIGIvZHJp
dmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBAQCAtOTMsNyArOTMsNyBAQCBvYmotJChD
T05GSUdfQ09NTU9OX0NMS19NVDgxODYpICs9IGNsay1tdDgxODYtDQo+ID4gbWN1Lm8gY2xrLW10
ODE4Ni10b3Bja2dlbi5vIGNsay1tdA0KPiA+ICAgCQkJCSAgIGNsay1tdDgxODYtY2FtLm8gY2xr
LW10ODE4Ni1tZHAubw0KPiA+IGNsay1tdDgxODYtaXBlLm8NCj4gPiAgIG9iai0kKENPTkZJR19D
T01NT05fQ0xLX01UODE4OCkgKz0gY2xrLW10ODE4OC1hcG1peGVkc3lzLm8gY2xrLQ0KPiA+IG10
ODE4OC10b3Bja2dlbi5vIFwNCj4gPiAgIAkJCQkgICBjbGstbXQ4MTg4LXBlcmlfYW8ubyBjbGst
bXQ4MTg4LQ0KPiA+IGluZnJhX2FvLm8gXA0KPiA+IC0JCQkJICAgY2xrLW10ODE4OC1jYW0ubyBj
bGstbXQ4MTg4LWNjdS5vDQo+ID4gKwkJCQkgICBjbGstbXQ4MTg4LWNhbS5vIGNsay1tdDgxODgt
Y2N1Lm8NCj4gPiBjbGstbXQ4MTg4LWltZy5vDQo+IA0KPiBpbWdzeXMgY2FuIGdvIHVuZGVyIGEg
ZGlmZmVyZW50IGNvbmZpZyBvcHRpb24uDQo+IA0KPiBJIHdvbid0IHNlbmQgYW55IG1vcmUgY29t
bWVudHMgb24gdGhlIG90aGVyIDEwIGNsb2NrcyBmb3IgdGhlIHNhbWUNCj4gcmVhc29uLCBzbw0K
PiBwbGVhc2Ugc3BsaXQgdGhlIGNsb2NrcyBhcyBuZWVkZWQuIENoZWNrIHRoZSBvdGhlcnMgbGlr
ZSBNVDgxODYsDQo+IE1UODE5MiwgTVQ4MTk1Lg0KPiANClRoYW5rIHlvdSBmb3IgeW91ciBzdWdn
ZXN0aW9ucy4NCg0KT2ssIEkgd2lsbCBtb2RpZnkgYWxsIG10ODE4OCBjbG9ja3MgYWJvdXQgdGhp
cyBpbiB2Ny4NCg0KDQpUaGFua3MsDQpCZXN0IFJlZ2FyZHMsDQpHYXJtaW4NCg==
