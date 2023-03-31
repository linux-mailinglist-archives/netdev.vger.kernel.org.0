Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5520D6D16E8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCaFnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaFnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:43:45 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4801BC5;
        Thu, 30 Mar 2023 22:43:42 -0700 (PDT)
X-UUID: fc1d1540cf8611edb6b9f13eb10bd0fe-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hOH57yT8dtG6dlMQBz563H8Yxe3ZghcVU4zy/hHGJDc=;
        b=SzHY2cwlrS8gZMsh/aFJP/9HE5xCwMo8zfwr7UUnTvRsptXtfza/LC3VaxP44NFAzrE5TgzkSdak2zas+c2OMNFHajC296kaDqBtclmsK3pW6mJCQRat+gs/GEGFnSt+Loj7YTC7DS7Kq9ViCeT3prhLDmOPR88Woa6a575d11s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:6bb8cb11-689a-4a4f-8e64-b0712293e20f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:6bb8cb11-689a-4a4f-8e64-b0712293e20f,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:2eff7cf7-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230331133914ZXKAQV2R,BulkQuantity:5,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:41,QS:nil,BEC:nil,COL:0,OSI:0
        ,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: fc1d1540cf8611edb6b9f13eb10bd0fe-20230331
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1883426967; Fri, 31 Mar 2023 13:43:38 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 13:43:37 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 13:43:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPBiF2H0DLhULPOLBK1phJAm/cy5WhqC1OXrJsLJdDpdmoI+GvZVh0dGYmK0HVugaGsZ84gbY9lF3eolUawr6GmlDBgnn8vRTtRvWhdAnFnMR2sb1FxHDciIPXrihCAnLjqJ2eyX//m8dQV4GYmvGK4MWU6qSkY5WkDg9meXKhd3YRRyYKZWuaK5abiCvV7CnyTNK2RlqEWylAfkiEb3oBZCHWhvYgC/RfsCER7SovWqGZybMuV2bztc6QDd074AIf7Ww9cymumn2osWl1FTo9ToP+3ZjZw2wfl5KUG7vrlibTG6rbtJgZvVxXCgJjb3LNnQic1HuiXhIfZ0IyCnGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOH57yT8dtG6dlMQBz563H8Yxe3ZghcVU4zy/hHGJDc=;
 b=AIm0uf6V9zmFXZ/kBzXeY7Y0MsUhRmfrGYukZdN5UPVM1SoZj4DeHDKlNOj4c5Mi2vX0Jlpeeame+iFu0hvXPCgd4eb8xavidBmdfIX1UvpEEHh1F9QI70Crq1S/W4Y0grp5jyF0iWjA5NGx9IfpyqMMtUaUSJZiLz5hKQF9pb/MYR9t/iu5HpvphWEH3KDo8dCnrMsslwslBN4NT+EXUhAPzWFgtfyW1Ck8ylgMNm1W1Yrxug0eDsDyqTYNMN+Ou10i7HI9Fd2OWNH387JfYTpbJbfWKgSMdriuMGhHJZDAL0Qj1uboq3l0rvkUF5DVxafJxcjHw6KKGTxsQTE8wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOH57yT8dtG6dlMQBz563H8Yxe3ZghcVU4zy/hHGJDc=;
 b=vgW1q2qPiGpgHgbMKb91bEHnktJhMLUdfZknyV9DQJpt5t6152L4ZgMr0L6CbZiZinuv7QKwAubgkoGgvRzvOG02/hlSuLcJOHGtgG/UMtzvQNuxTM/aTV6E+Hy7bBtP710ITLSJsNhtp1mp/qB+mb4JxtA6lKSHdGuKIo5ynbw=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by KL1PR0302MB5377.apcprd03.prod.outlook.com (2603:1096:820:45::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 05:43:34 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 05:43:34 +0000
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
Subject: Re: [PATCH v6 05/19] clk: mediatek: Add MT8188 infrastructure clock
 support
Thread-Topic: [PATCH v6 05/19] clk: mediatek: Add MT8188 infrastructure clock
 support
Thread-Index: AQHZUo676EqaUpeVOUSvI3fWEAQ1k676Aw0AgBp/SgA=
Date:   Fri, 31 Mar 2023 05:43:33 +0000
Message-ID: <daab983e618e064f84fa5e7eeae320a92d673eb8.camel@mediatek.com>
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
         <20230309135419.30159-6-Garmin.Chang@mediatek.com>
         <0fa530f3-f22b-ce45-e030-d746ae5896d5@collabora.com>
In-Reply-To: <0fa530f3-f22b-ce45-e030-d746ae5896d5@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|KL1PR0302MB5377:EE_
x-ms-office365-filtering-correlation-id: cb6922b4-1cae-44d4-ef19-08db31aaddb1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rJmpFK7ppGWixD3bpKI7LN98K1llEq9cO5KKDn1NB63NrD9sKCIFX9QPXW0obIfSTuXvNeGH7FbgK93Q0OP1RUshmI1RhuzhLBdCznPS7Zxaa9yarPWEl0Qy3w9W6wl+spUkcFjcdgQB0xLIGjewuPv0WGhKMHrZI8M10bf/7pKISX2XJTx2MbFjqMal9mEkER2Czw1MyHhYePH0ML8XwjVgysjSakdfQegFBm2VQwnvPY3q2+znlUDUWnxfDNs5MbEWb35rinEODo3Iu8Up2TLEVZX4bXNWDZVopAiutUdmm2XhJrgsaMM6TkNvts6YF8g15BmIu5TVrvkgdYhSE2DddRZqQ0fB/2HVFRIEU8yeNdRc3FYL9SXHQQR4hLXZ924cjcDCgt39EQxtLpLA2BMsRwrXlFZJmWbj+Pq5/EP4dfdHJ5Ij6RVonM/rdI8PjQugOAN/L2dIODOVQ6/sM1GS57csCQ0pX4hmxbb3jZygwPjpJ2My/irRbRiNYGhXlJzB70BUEDJaOg1c6Jzmqe4IqwJuR+Okg0FJG31NI2rkqs4q2tj5uR4JsihHHND4x1gka+78P6hkZ64ir68ZjGxVaazrogsL3nIAtQtVa5Iaeu/XXyCFTTE8z0kZySai/3M/yLV+o13Xae665P3CBjYRaYGsqI4m6DPj8Ui9HGo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(110136005)(7416002)(54906003)(478600001)(66946007)(66476007)(316002)(5660300002)(85182001)(38100700002)(36756003)(86362001)(2906002)(4326008)(38070700005)(66556008)(91956017)(66446008)(8676002)(76116006)(64756008)(41300700001)(122000001)(8936002)(6486002)(186003)(6512007)(6506007)(26005)(2616005)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTg4WVN6dkNMeGd1MnJKSFV5VU9KUVAxOVdJYU5nT0RVYzJ3RzJmems1VGFI?=
 =?utf-8?B?QTc4cUlYNkhsdzVMOVRaSjRaQnA0Ky96cDZ3SDdkOWVtS05uRStYWEhLeElD?=
 =?utf-8?B?S3Y5bFNVdWNkenlMMzh3aGU1bXpiNVo4R1l4QnU5QSszNVlrM3lmMHROMUZo?=
 =?utf-8?B?K0ZwUnduRDVpMWY3cVhBbFRVdElpT21BUWVVWldYbTRtNDB3aEZlTCtKNjcr?=
 =?utf-8?B?RGI0c2pLdForUmowdS9ydEliamRodjlETktmQnllWHlSMll1YVJQMDhGdExQ?=
 =?utf-8?B?RThNTXlLZ2hPWDFqaDZ3dnhyb2tHTzM2M3pGV1FWRXlBUjRYNXZNSmFkYjRo?=
 =?utf-8?B?RWtjY1FvaFk0RGprVUVVOFRnYjBSK2NpRnRLVjUrRDhZWFNSNmEwY2oxZ21T?=
 =?utf-8?B?Mm1sdlMwZkJhZm9ZQUVRVGowWnQ0S1I3T2pmaGtQM2l6NWQxV1Zmc041S2FS?=
 =?utf-8?B?RTUvSFQxTmJ6eDRnTjFUY0tqSUI0ZWRaRFV6a3Zld2FQYWRWK3RZT2k2bFRs?=
 =?utf-8?B?dUZpdU10Rnh3NDhYcGh0MVJTajE2L0FHWlJrOERSVG5MWTE1dzQxNnlnODRi?=
 =?utf-8?B?LzkvalFTMWdaT0ZwT254Y0JsWnBGcnNvLzhyR1dQa0d2eitFSnVjMGZoTlVT?=
 =?utf-8?B?OFM3UDViUmIzOXFZa2ZvWGMxVHdIZWpEWFJXRUpmVU80alZUNndFbDdIeXp2?=
 =?utf-8?B?Y1gwUlo4Q1A4V0dhUm1MbDBqNEVOL2RpNUJGbUpVeFY1Vm1WOHArYVNVcVpw?=
 =?utf-8?B?WE5lK2IwZUdiMWdrL0FMcjNyUFFKZHNGVCtpZmRIZUVFMnovN29QUkNVbzNS?=
 =?utf-8?B?KzhYOE15WnoxL0dXWEN3RlBnQkFhNTFjRk1nR1RlWlYxa3VWYkxlb1pkQ0Rm?=
 =?utf-8?B?anF5SmdrNWZvZTYvbm94NVR4WGhrM041ZVFiTmRQdmtZYnh0THhZNlZLZEJo?=
 =?utf-8?B?N1BIZWM0eVV2MEphRmhTaTl6YTZGU0x1eUJpSWJLTDVNajkva2xTU3lEQXJD?=
 =?utf-8?B?NzRLd0E1QzJaRmdUWlI0bnordllDSXhJWlN0Q0tMR09nZ2NSanRHSVZ1TE1R?=
 =?utf-8?B?aUV4M0ZsM1NnZ0U2Y3UrN0I1aDJrenZnYzNvU2FNanlnUzN6emJNMGpGZGxP?=
 =?utf-8?B?ZWZzY1ZUWjRWQW5wK3dZdjhySFhLTjlLSzlrOEt3NEFWdGRQdE1lV3YxV2VQ?=
 =?utf-8?B?TG5OdHVMZXNOYmhkMzlOeWthMmtxK2o3M1huck9EYW5CVnpmSjBqejg2NUNs?=
 =?utf-8?B?amdYR2lVbFpobmhUajFBQUJBMjVOUm5YcTc2U3ptUjlVa0hFbm54enJOblVs?=
 =?utf-8?B?OXdSR1RpcHVUd0dmVFJPUytNKzVNQlNTcDRwd0JNOVowc1c5Nk9iNGI0eXNQ?=
 =?utf-8?B?UHZ4RzRUQVorUjNyWWoxL1RsZFFVMGZPWnEzTGFBTzJlOFlZWkhtc3hLSlJB?=
 =?utf-8?B?eDFqOFQ4WmF6RGc3NTFwNE4xNWhyM0U3K1ZGa01jY0lnZzJ1WVgwTTA4NE5W?=
 =?utf-8?B?eCtEQ0VGRy9qaVVCc2prNlc0bTYySmFCdXF6Q1RrcjJaaU9uNStFVEVIUDEr?=
 =?utf-8?B?YkJJVXBtYmRaNm0vYlppaTc2UmEwZE9XZGJZZEJiSVNmRGtMenh5MUlYbFVI?=
 =?utf-8?B?T2dZN1dWNFJySGo2R21VWURScTVSa2pwYXRBNGpKWkRFb1dQYXJjb29neFI2?=
 =?utf-8?B?d2w5ZlVBK2o4NzhyT1FteFZQak0zbVNwcGFUM3BHbVA2b29jOEozMEtFYkUz?=
 =?utf-8?B?NlNncU9vZXk4WXZSRkJidVNweDJWL0FhMDZCU2JVZGhDNTJOcCt0WThIT2Q1?=
 =?utf-8?B?SUY4N2ZzZnBvWVlvWlJGYjVnWVU4d1RIVFV3elM5eG83VlJkemNWb29rYnRK?=
 =?utf-8?B?bzBRSWpEK2U4QUdzYTJmOUMxcFB5ZklNY1Y3RWs0Sk9zT21Gczc2a01QVGtU?=
 =?utf-8?B?bUs5V3l6dXEva3hweUpYblcwVzh4SjVSdFV5VEdtYzF0RzVZT084dlZsR2ky?=
 =?utf-8?B?TWpaRGFtQStjM1BraDdwRlYzdGxUdEk3TmtaU3kyVW5ZakdjVGxUN3hpQ1pQ?=
 =?utf-8?B?bFBVYlRFakM4c0ExcFJzdWJNYWFaK0ZKcVdJbVZvMWcvNkQzZ1dXK2Z1VnBB?=
 =?utf-8?B?aWwwZVE3V3EzZ25BWmpadGU0Vlo5Z2N2TlVoSHpKR216akdFVXZIVElwdVd1?=
 =?utf-8?B?OHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B66C0873C2317488686483CA29BE805@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6922b4-1cae-44d4-ef19-08db31aaddb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:43:33.6372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E825CXGKQ/ues+sPT0N6gvk92Yal18jJ5FPpX1mEuaPGKdbNEVfSr6fcKzLvzdSXLUMwS+m8xDi/F+8k6UWMEkncIoSOYgald/gRbVwN1dY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5377
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTE0IGF0IDEwOjA1ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gSWwgMDkvMDMvMjMgMTQ6NTQsIEdhcm1pbi5DaGFuZyBoYSBzY3JpdHRv
Og0KPiA+IEFkZCBNVDgxODggaW5mcmFzdHJ1Y3R1cmUgY2xvY2sgY29udHJvbGxlciB3aGljaCBw
cm92aWRlcw0KPiA+IGNsb2NrIGdhdGUgY29udHJvbCBmb3IgYmFzaWMgSVAgbGlrZSBwd20sIHVh
cnQsIHNwaSBhbmQgc28gb24uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5n
IDxHYXJtaW4uQ2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBDaGVuLVl1IFRz
YWkgPHdlbnN0QGNocm9taXVtLm9yZz4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvY2xrL21lZGlh
dGVrL01ha2VmaWxlICAgICAgICAgICAgICB8ICAgMiArLQ0KPiA+ICAgZHJpdmVycy9jbGsvbWVk
aWF0ZWsvY2xrLW10ODE4OC1pbmZyYV9hby5jIHwgMTk2DQo+ID4gKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDE5NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10
ODE4OC1pbmZyYV9hby5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlh
dGVrL01ha2VmaWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IGlu
ZGV4IGYzOGE1Y2VhMjkyNS4uMTcyYWFlZjI5ZDVkIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFr
ZWZpbGUNCj4gPiBAQCAtOTIsNyArOTIsNyBAQCBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgx
ODYpICs9IGNsay1tdDgxODYtDQo+ID4gbWN1Lm8gY2xrLW10ODE4Ni10b3Bja2dlbi5vIGNsay1t
dA0KPiA+ICAgCQkJCSAgIGNsay1tdDgxODYtaW1nLm8gY2xrLW10ODE4Ni12ZGVjLm8NCj4gPiBj
bGstbXQ4MTg2LXZlbmMubyBcDQo+ID4gICAJCQkJICAgY2xrLW10ODE4Ni1jYW0ubyBjbGstbXQ4
MTg2LW1kcC5vDQo+ID4gY2xrLW10ODE4Ni1pcGUubw0KPiA+ICAgb2JqLSQoQ09ORklHX0NPTU1P
Tl9DTEtfTVQ4MTg4KSArPSBjbGstbXQ4MTg4LWFwbWl4ZWRzeXMubyBjbGstDQo+ID4gbXQ4MTg4
LXRvcGNrZ2VuLm8gXA0KPiA+IC0JCQkJICAgY2xrLW10ODE4OC1wZXJpX2FvLm8NCj4gPiArCQkJ
CSAgIGNsay1tdDgxODgtcGVyaV9hby5vIGNsay1tdDgxODgtDQo+ID4gaW5mcmFfYW8ubw0KPiA+
ICAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4MTkyLm8NCj4gPiAg
IG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5Ml9BVURTWVMpICs9IGNsay1tdDgxOTItYXVk
Lm8NCj4gPiAgIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5Ml9DQU1TWVMpICs9IGNsay1t
dDgxOTItY2FtLm8NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10
ODE4OC1pbmZyYV9hby5jDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWlu
ZnJhX2FvLmMNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAw
MC4uZWRjMGJhMThjNjdmDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RyaXZlcnMvY2xr
L21lZGlhdGVrL2Nsay1tdDgxODgtaW5mcmFfYW8uYw0KPiA+IEBAIC0wLDAgKzEsMTk2IEBADQo+
ID4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4g
PiArLy8gQ29weXJpZ2h0IChjKSAyMDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBH
YXJtaW4gQ2hhbmcgPGdhcm1pbi5jaGFuZ0BtZWRpYXRlay5jb20+DQo+IA0KPiBQbGVhc2UgdXNl
IEMtc3R5bGUgY29tbWVudHMgKGFwYXJ0IGZyb20gdGhlIFNQRFggaGVhZGVyKSB0byBiZQ0KPiBj
b25zaXN0ZW50IHdpdGgNCj4gdGhlIG90aGVyIGNsb2NrIGRyaXZlcnMuDQo+IA0KDQpUaGFuayB5
b3UgZm9yIHlvdXIgc3VnZ2VzdGlvbnMuDQoNCk9rLCBJIHdvdWxkIG1vZGlmeSB0aGlzIGFuZCBi
ZWxvdyBpbiB2Ny4NCj4gPiArDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9jbGstcHJvdmlkZXIuaD4N
Cj4gPiArI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPg0KPiA+ICsjaW5jbHVkZSA8
ZHQtYmluZGluZ3MvY2xvY2svbWVkaWF0ZWssbXQ4MTg4LWNsay5oPg0KPiANCj4gb3JkZXIgYnkg
bmFtZS4NCj4gDQpPay4NCj4gPiArDQo+IA0KPiAuLnNuaXAuLg0KPiANCj4gPiArDQo+ID4gK3N0
YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2Nsa19kZXNjIGluZnJhX2FvX2Rlc2MgPSB7DQo+ID4gKwku
Y2xrcyA9IGluZnJhX2FvX2Nsa3MsDQo+ID4gKwkubnVtX2Nsa3MgPSBBUlJBWV9TSVpFKGluZnJh
X2FvX2Nsa3MpLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9k
ZXZpY2VfaWQgb2ZfbWF0Y2hfY2xrX210ODE4OF9pbmZyYV9hb1tdID0NCj4gPiB7DQo+ID4gKwl7
IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE4OC1pbmZyYWNmZy1hbyIsIC5kYXRhID0NCj4g
PiAmaW5mcmFfYW9fZGVzYyB9LA0KPiA+ICsJeyAvKiBzZW50aW5lbCAqLyB9DQo+ID4gK307DQo+
IA0KPiBNT0RVTEVfREVWSUNFX1RBQkxFIGlzIG1pc3NpbmcNCk9rLg0KPiANCj4gPiArDQo+ID4g
K3N0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIGNsa19tdDgxODhfaW5mcmFfYW9fZHJ2ID0g
ew0KPiA+ICsJLnByb2JlID0gbXRrX2Nsa19zaW1wbGVfcHJvYmUsDQo+ID4gKwkucmVtb3ZlID0g
bXRrX2Nsa19zaW1wbGVfcmVtb3ZlLA0KPiA+ICsJLmRyaXZlciA9IHsNCj4gPiArCQkubmFtZSA9
ICJjbGstbXQ4MTg4LWluZnJhX2FvIiwNCj4gPiArCQkub2ZfbWF0Y2hfdGFibGUgPSBvZl9tYXRj
aF9jbGtfbXQ4MTg4X2luZnJhX2FvLA0KPiA+ICsJfSwNCj4gPiArfTsNCj4gPiArYnVpbHRpbl9w
bGF0Zm9ybV9kcml2ZXIoY2xrX210ODE4OF9pbmZyYV9hb19kcnYpOw0KPiANCj4gbW9kdWxlX3Bs
YXRmb3JtX2RyaXZlcigpDQo+IA0KPiBNT0RVTEVfTElDRU5TRQ0KPiBPSy4NCj4gDQo+IFJlZ2Fy
ZHMsDQo+IEFuZ2Vsbw0K
