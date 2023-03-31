Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856046D16EC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCaFpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCaFpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:45:06 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B05269E;
        Thu, 30 Mar 2023 22:45:04 -0700 (PDT)
X-UUID: 2cc37f36cf8711edb6b9f13eb10bd0fe-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=zWm2vszbMNY89V+3xcwAh5W70/qq2bDH4YC80CtYI6w=;
        b=BFWgXHPXS9KtY8NTL6E1dUPjMmmc+/Sg0Fwlcr1MXlUtLEF4F15X/MK+udj2RnXa8ih6tjFow1g7fUEYlp28akzu0i3y3Hbw9Uxy12WCJewgr7YoiFcYFDY/biWbBDyO/0vkQ4e6kZSEOW7pHQZPWDl6A0ArxbhVndGHbel8Gfk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:186c924a-87d1-4ae0-a643-38ea5cd0c06e,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:89097df7-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 2cc37f36cf8711edb6b9f13eb10bd0fe-20230331
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 909805227; Fri, 31 Mar 2023 13:44:59 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 13:44:58 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 13:44:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzAcEUfmd/O0fEkZH4Qp64y/GEcprz6pXQVX5PoxA7MeKgOonNRavvgUai4vvIkOElRO1wsp0l9zLj5btdJgB5aR6vjUOSrMSovTjALMB9CEX7RS71Fky2jWkA5iYa25VShQ87Y05nEk8Yyi+RCNLpobwgirlEtbKnFHidrlJ7iA5SZki7eCL46IWt0yxkXAlhp8MGyLETYcHAzzVN2wTFtymsAjN4weK+rD6tjcu9etYT132W0iWyunb5QmGYKDUKVDoRuVWF7OzqAoi17vqL06YFa0cK+uGjFXusEmKAUY4wO1F8TfOJ+SZoGzoBwn0ujaCvkmkLdLy8cfwgqN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWm2vszbMNY89V+3xcwAh5W70/qq2bDH4YC80CtYI6w=;
 b=FkA6d5rAi28yNNGAiEI02nD6ji73dFosAcYFT0SVlI8wnXM/8Wk1NyYs2zlAbjHALfYP3ESxdricarU3AwFrNiAzNzlGNXPBNJqewF65VqLBhvvrXZdsVfo+JRyCV3MKDAdbyRVsEek0rQs9sP9iXPogqlAN/CeaizPJvlZg4b9rjZTAOxWSR0/qEEBUR9DsZEUqwUlR2BprlKWOdVAxR0WfotecMMks/XbXC+pgQuo5LQEmSDKquH+gqvJRmf7gFEEA4JRcO/YXbn156WmDqWvWh4q6xiQnxiwf6G+tf4lxj4rhyiw6ry2MFG2aXmE1WhLujUegmgtzCJi13xRedQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWm2vszbMNY89V+3xcwAh5W70/qq2bDH4YC80CtYI6w=;
 b=U8spgrOPtbDyOsbvMguIufqSZZzTF37eI9x3dTiXMPy0eMUVI+4xdZCNGS4dRR+ze/f7CXQxnC2tAGIvKxB6liAPfto0hDOLpW6uUtAX60V0Ifmp/v5GFA5MD7K3y7app3dE+FARkllpO1xvoAYKjWFoEEHnqB1FFVdklKHV7Rw=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SEZPR03MB6618.apcprd03.prod.outlook.com (2603:1096:101:79::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 05:44:51 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 05:44:51 +0000
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
Subject: Re: [PATCH v6 04/19] clk: mediatek: Add MT8188 peripheral clock
 support
Thread-Topic: [PATCH v6 04/19] clk: mediatek: Add MT8188 peripheral clock
 support
Thread-Index: AQHZUo68KXdzpPXAKUKtTu7ULYwZEK76Aw8AgBp/pAA=
Date:   Fri, 31 Mar 2023 05:44:50 +0000
Message-ID: <df0ba96a1af802be74c468bac3b137544103780e.camel@mediatek.com>
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
         <20230309135419.30159-5-Garmin.Chang@mediatek.com>
         <5d0e98ee-3610-d07f-6060-a30050c41bd6@collabora.com>
In-Reply-To: <5d0e98ee-3610-d07f-6060-a30050c41bd6@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SEZPR03MB6618:EE_
x-ms-office365-filtering-correlation-id: cdfea115-a6ab-430e-82cb-08db31ab0bd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XiR8zFIVTVkWDWy4zxneuOIjvKJOU8rbKn33wSfUyB5GQWSWLWysksPjoBQcAkFjaTrBQXWh2+cELaBpeMn7Wk9Jt1XOt8ICdV5263pNG9fSNQ+s/pwhiSpShijXPFQ2o72B42E6sdmFWdYmlfuLUbxl9mxy5t9vFI8ZeKRID7rtHstEPmHBnaQNvcb+wecT+fDYxkguU6OswfxFtEf4oQI6OsM4RCMPVVCygDPVy4P67aGWEnw+/FLFBFAXxV1n+6nc6eVDsQ8ENIFRvj/Rdj3h2I7HoD6ddVbIjGUQ1v9JrJ5oJ9iNsXina/Vva5BeGW6wB+RqNEZeXTfgHa1eb0FrSRs8oub5DAXGtLvpcebiprycTHjSQLE0arKBEZL4QWJhr4eX8vyxqvbewRm/JVnuoKGAid5zYHqGmE4FM3Q3kCr4xBJccOH/sp2+mKYA2f6RqGEYZ6cAXd0oSx7RvrQji13dKlccKrfLFnCrYP3i+P5+/N+nEPO5IRtUWPR8toW3zZ1cK9Mb6DYsHrpgchGuDaL1mW9fFdCKHKW8cHqX5s+wPY8RXbF9tc4Qe/Gm0m5xWiSwjoe2mnpzkGnudMbkKWahGgP5zray1hKsOMHzlGRTfW2Vjq8zO6/4JgDh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(36756003)(85182001)(4326008)(110136005)(8676002)(54906003)(91956017)(66446008)(76116006)(66556008)(64756008)(316002)(6486002)(66476007)(66946007)(71200400001)(5660300002)(41300700001)(8936002)(478600001)(2906002)(7416002)(86362001)(38070700005)(38100700002)(122000001)(186003)(2616005)(26005)(6506007)(6512007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFl0ZXYvcXdiUXlQMkpuKzVoRHd0ZU56akhLRzJPN1N5OTdyQWJzNTAwdmV0?=
 =?utf-8?B?eW5XT0QwRkpieStxUXduNjllb3N1Vk1xOS9lUy9LV2puWXFEbHRvMEJUTHZu?=
 =?utf-8?B?YU56TFhqcm5QNjU4YVdidDYwcDRmdDNTVG9IL0oyaTJ3K3NLM3UwRm5FNmVT?=
 =?utf-8?B?dEUreVdKemlNZXVTeWJXSGFwOVJ4cFoybEozS3pSaWRDc1FWM2lSOGdGZkJJ?=
 =?utf-8?B?Y2RlUzJrMVFRMU5nVTg3YUZ4c1djdkdRQTM2WnhtSTcvdzhDdnF6U3plOXQw?=
 =?utf-8?B?dFRUa2V5UmZxQUlHL09ERDRFWXVtb3FiY3ZiQjVleXV1MGRobWdlM2c3Ri90?=
 =?utf-8?B?eFZubWgvTjlOcTJIS0kzRFNkOEgyVnZnV3BBWTltVGxRSFh3RXUveDI3ZDJ2?=
 =?utf-8?B?Y0h6b0FWalZDWjJlZytQSm5uQmp3eUw0OVh3eTV1ZWVjM2ozb1JkSUFsVzFr?=
 =?utf-8?B?MS90SzhyNHFGczFubzRhY09XUTExMlBMU3RzeW5haElwdnBKUm5iMWhETE9V?=
 =?utf-8?B?V3hyV2RSVm9UYkNzVUpmaWNESzg4Q1lYS1VOTHhLelprdGxhS3JnNjFvRlow?=
 =?utf-8?B?d1U3MWFqbEtYZHJNNlpYeC9IYUJoS0VQalIxMkRxSTBGTW5yaDZFK29HcFg0?=
 =?utf-8?B?V2RFTGlzZFF4RGdlcHA5Y3Buc3hodVNFVVZXMjdON2pEeU54d0pQR3pHVXJS?=
 =?utf-8?B?aCtoV256UEZFUEl6M1JIQVhXQUFZbGw5djdtWmwzazVUbmNSNG9FNHBJY1hs?=
 =?utf-8?B?dXN2S0d6UmgyUWd4QkNLOTZoN0dnR1ZIL0pNYVBidlZpVTQxZSt1cEozYi9M?=
 =?utf-8?B?SWZmbSs5aFM1cHlub3lWYkdibXg5SGg0cC9hNTFCS0JIKzlka0xWQVM5aVZP?=
 =?utf-8?B?dHZ2MzBpWmczdmczdHRyZWE2VUx6VWU0K0hXNXZYQWFOQklJdWx4QVI0T3Zo?=
 =?utf-8?B?bXA2LzhUVlRqVnprbnkxOTR4b0RNOC9NMzNpSncrN0h6bzFtd1poY1F3d2xu?=
 =?utf-8?B?bHcxVHdrY29CMlFzM2l3bWZwUzU3TE9hZ2tUR2pBSTR0b2N6Vnl3ajNzNERo?=
 =?utf-8?B?L1phbGdmcWxIc1hqdFM0Mm9kQmU5dnFkZUxiaEJxcDIwQ3c0ZWlqVXA0citx?=
 =?utf-8?B?eW1wNWVaemdseUZxTkZEVHBsK3k5MmxYVktaVDNqY3FIeWFXWThUakU5SmlX?=
 =?utf-8?B?OVI2WTVZbE9WMURQd2UzMWJMSVZkOUhGRFpYYUd0UWZra1MwK2NNSjF4blpl?=
 =?utf-8?B?a0lVbmV6eFUzMmNqNEpVZ29GOUtEbmlFUlgrQkdZVisyZWIwOWFPWVoycDJr?=
 =?utf-8?B?WGFXaktrZ3hoZkdUVkFpY3NMSU83THZmN1d5TDhaY2NSRmU1WkJVOXVUN0Jo?=
 =?utf-8?B?RDIwSE1iK05CUG1uWEdydnFMWWw0ZzF6VmF0Ny92amZiWnpWdEJNdzdNSGRH?=
 =?utf-8?B?VFNPeG1WU25BOS81L3d3RkxMck5hOXVla3FLYVBaaFdWdTExaDFhRkhkWHBh?=
 =?utf-8?B?UGF5N09GV21IWlVjN0JmaFQvMGtmRFZVZWd5bHdmMVF6YWJLMjRuMm9wK3pU?=
 =?utf-8?B?TGwyNitoZEx3OFNwTlRjVTVpMmM5a1hoRTQzWmthNHZFSXVaQXNhYnpLd1o4?=
 =?utf-8?B?bVArWStSQW1JOXQrSXNPUmRvaTNnVlB3cGFjMk9FRmVLejVZY3hXUGhyNUVw?=
 =?utf-8?B?WmtsWmpzVmhxTzQ4SHE4R1pva2ZTVERLVDl3dVVxeU1ydmVqY2lKdG1jdStJ?=
 =?utf-8?B?Ry93cVVQM1Ryd0lpekR4bWNvdWduMzBUMi9JNndKR0N4T1ZqMFExcjFzQlpn?=
 =?utf-8?B?bTRFdnY4emY3OWNycG1vd1dUM3h4MHF3N1JuVnNOb05TbmpNNjBxOEVVRTdi?=
 =?utf-8?B?bERBR090OWM1NFRWNzRpemx2bktYZnVxUGNKMnNhUzdTSG1UZHFGRzNXQkNm?=
 =?utf-8?B?Y1dKT3VUYW5xWnc0VE5wZ0xQMDVXRE96bjMzckJQaWMyNHJtdW5DcEliNktx?=
 =?utf-8?B?QmVua1dYQ3dadlZrUGlybEkvT0VTYS9xcXdDOVVNUGZhYW82WTdVeU5UdlAv?=
 =?utf-8?B?WFBTNkg2ejFIRWI3ZGpDTnFnU3o1RU0zZ1ZVeXlrUU9xV0xjcElUbmdodDEw?=
 =?utf-8?B?eXR3eWtWancyT0N2aVdROWMyQmxDVWZ4NFNyazRnQmppM0RLNDkrZjU4VVFy?=
 =?utf-8?B?UXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E69327DDAE7CA2418F201BD31E248E9A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdfea115-a6ab-430e-82cb-08db31ab0bd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:44:50.9880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LHz8Mp8SaDKJMJXHJOHWTEwdZiXlSpsPWZYY4Pj9bRJMKakYtjLMlt/RPaCpHoki/4hScO/U5H9Cpm/WIUCLAHTGndeYkd0QhFQ/RzeuT5A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6618
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
Og0KPiA+IEFkZCBNVDgxODggcGVyaXBoZXJhbCBjbG9jayBjb250cm9sbGVyIHdoaWNoIHByb3Zp
ZGVzIGNsb2NrDQo+ID4gZ2F0ZSBjb250cm9sIGZvciBldGhlcm5ldC9mbGFzaGlmL3BjaWUvc3N1
c2IuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5nIDxHYXJtaW4uQ2hhbmdA
bWVkaWF0ZWsuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBDaGVuLVl1IFRzYWkgPHdlbnN0QGNocm9t
aXVtLm9yZz4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlICAg
ICAgICAgICAgIHwgIDMgKy0NCj4gPiAgIGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgt
cGVyaV9hby5jIHwgNTYNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAgMiBmaWxl
cyBjaGFuZ2VkLCA1OCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10ODE4OC1wZXJpX2FvLmMNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBi
L2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gaW5kZXggZDg0NWJmNzMwOGMzLi5m
MzhhNWNlYTI5MjUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZp
bGUNCj4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IEBAIC05MSw3
ICs5MSw4IEBAIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE4NikgKz0gY2xrLW10ODE4Ni0N
Cj4gPiBtY3UubyBjbGstbXQ4MTg2LXRvcGNrZ2VuLm8gY2xrLW10DQo+ID4gICAJCQkJICAgY2xr
LW10ODE4Ni1tZmcubyBjbGstbXQ4MTg2LW1tLm8NCj4gPiBjbGstbXQ4MTg2LXdwZS5vIFwNCj4g
PiAgIAkJCQkgICBjbGstbXQ4MTg2LWltZy5vIGNsay1tdDgxODYtdmRlYy5vDQo+ID4gY2xrLW10
ODE4Ni12ZW5jLm8gXA0KPiA+ICAgCQkJCSAgIGNsay1tdDgxODYtY2FtLm8gY2xrLW10ODE4Ni1t
ZHAubw0KPiA+IGNsay1tdDgxODYtaXBlLm8NCj4gPiAtb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtf
TVQ4MTg4KSArPSBjbGstbXQ4MTg4LWFwbWl4ZWRzeXMubyBjbGstDQo+ID4gbXQ4MTg4LXRvcGNr
Z2VuLm8NCj4gPiArb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTg4KSArPSBjbGstbXQ4MTg4
LWFwbWl4ZWRzeXMubyBjbGstDQo+ID4gbXQ4MTg4LXRvcGNrZ2VuLm8gXA0KPiA+ICsJCQkJICAg
Y2xrLW10ODE4OC1wZXJpX2FvLm8NCj4gPiAgIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5
MikgKz0gY2xrLW10ODE5Mi5vDQo+ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJf
QVVEU1lTKSArPSBjbGstbXQ4MTkyLWF1ZC5vDQo+ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NM
S19NVDgxOTJfQ0FNU1lTKSArPSBjbGstbXQ4MTkyLWNhbS5vDQo+ID4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtcGVyaV9hby5jDQo+ID4gYi9kcml2ZXJzL2Ns
ay9tZWRpYXRlay9jbGstbXQ4MTg4LXBlcmlfYW8uYw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0
DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi42ODMwMTA0NTNhMTANCj4gPiAtLS0gL2Rldi9udWxs
DQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10ODE4OC1wZXJpX2FvLmMNCj4g
PiBAQCAtMCwwICsxLDU2IEBADQo+ID4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wLW9ubHkNCj4gPiArLy8NCj4gPiArLy8gQ29weXJpZ2h0IChjKSAyMDIyIE1lZGlhVGVrIElu
Yy4NCj4gPiArLy8gQXV0aG9yOiBHYXJtaW4gQ2hhbmcgPGdhcm1pbi5jaGFuZ0BtZWRpYXRlay5j
b20+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvY2xrLXByb3ZpZGVyLmg+DQo+ID4gKyNp
bmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4gPiArI2luY2x1ZGUgPGR0LWJpbmRp
bmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsuaD4NCj4gPiArDQo+ID4gKyNpbmNsdWRlICJj
bGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVkZSAiY2xrLW10ay5oIg0KPiA+ICsNCj4gPiArc3RhdGlj
IGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIHBlcmlfYW9fY2dfcmVncyA9IHsNCj4gPiArCS5z
ZXRfb2ZzID0gMHgxMCwNCj4gPiArCS5jbHJfb2ZzID0gMHgxNCwNCj4gPiArCS5zdGFfb2ZzID0g
MHgxOCwNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNkZWZpbmUgR0FURV9QRVJJX0FPKF9pZCwgX25h
bWUsIF9wYXJlbnQsIF9zaGlmdCkJCQkNCj4gPiBcDQo+ID4gKwlHQVRFX01USyhfaWQsIF9uYW1l
LCBfcGFyZW50LCAmcGVyaV9hb19jZ19yZWdzLCBfc2hpZnQsDQo+ID4gJm10a19jbGtfZ2F0ZV9v
cHNfc2V0Y2xyKQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZSBwZXJp
X2FvX2Nsa3NbXSA9IHsNCj4gPiArCUdBVEVfUEVSSV9BTyhDTEtfUEVSSV9BT19FVEhFUk5FVCwg
InBlcmlfYW9fZXRoZXJuZXQiLA0KPiA+ICJ0b3BfYXhpIiwgMCksDQo+ID4gKwlHQVRFX1BFUklf
QU8oQ0xLX1BFUklfQU9fRVRIRVJORVRfQlVTLCAicGVyaV9hb19ldGhlcm5ldF9idXMiLA0KPiA+
ICJ0b3BfYXhpIiwgMSksDQo+ID4gKwlHQVRFX1BFUklfQU8oQ0xLX1BFUklfQU9fRkxBU0hJRl9C
VVMsICJwZXJpX2FvX2ZsYXNoaWZfYnVzIiwNCj4gPiAidG9wX2F4aSIsIDMpLA0KPiA+ICsJR0FU
RV9QRVJJX0FPKENMS19QRVJJX0FPX0ZMQVNISUZfMjZNLCAicGVyaV9hb19mbGFzaGlmXzI2bSIs
DQo+ID4gImNsazI2bSIsIDQpLA0KPiA+ICsJR0FURV9QRVJJX0FPKENMS19QRVJJX0FPX0ZMQVNI
SUZMQVNIQ0ssDQo+ID4gInBlcmlfYW9fZmxhc2hpZmxhc2hjayIsICJ0b3Bfc3Bpbm9yIiwgNSks
DQo+ID4gKwlHQVRFX1BFUklfQU8oQ0xLX1BFUklfQU9fU1NVU0JfMlBfQlVTLCAicGVyaV9hb19z
c3VzYl8ycF9idXMiLA0KPiA+ICJ0b3BfdXNiX3RvcF8ycCIsIDkpLA0KPiA+ICsJR0FURV9QRVJJ
X0FPKENMS19QRVJJX0FPX1NTVVNCXzJQX1hIQ0ksDQo+ID4gInBlcmlfYW9fc3N1c2JfMnBfeGhj
aSIsICJ0b3Bfc3N1c2JfeGhjaV8ycCIsIDEwKSwNCj4gPiArCUdBVEVfUEVSSV9BTyhDTEtfUEVS
SV9BT19TU1VTQl8zUF9CVVMsICJwZXJpX2FvX3NzdXNiXzNwX2J1cyIsDQo+ID4gInRvcF91c2Jf
dG9wXzNwIiwgMTEpLA0KPiA+ICsJR0FURV9QRVJJX0FPKENMS19QRVJJX0FPX1NTVVNCXzNQX1hI
Q0ksDQo+ID4gInBlcmlfYW9fc3N1c2JfM3BfeGhjaSIsICJ0b3Bfc3N1c2JfeGhjaV8zcCIsIDEy
KSwNCj4gPiArCUdBVEVfUEVSSV9BTyhDTEtfUEVSSV9BT19TU1VTQl9CVVMsICJwZXJpX2FvX3Nz
dXNiX2J1cyIsDQo+ID4gInRvcF91c2JfdG9wIiwgMTMpLA0KPiA+ICsJR0FURV9QRVJJX0FPKENM
S19QRVJJX0FPX1NTVVNCX1hIQ0ksICJwZXJpX2FvX3NzdXNiX3hoY2kiLA0KPiA+ICJ0b3Bfc3N1
c2JfeGhjaSIsIDE0KSwNCj4gPiArCUdBVEVfUEVSSV9BTyhDTEtfUEVSSV9BT19FVEhFUk5FVF9N
QUMsDQo+ID4gInBlcmlfYW9fZXRoZXJuZXRfbWFjX2NsayIsICJ0b3Bfc25wc19ldGhfMjUwbSIs
IDE2KSwNCj4gPiArCUdBVEVfUEVSSV9BTyhDTEtfUEVSSV9BT19QQ0lFX1AwX0ZNRU0sICJwZXJp
X2FvX3BjaWVfcDBfZm1lbSIsDQo+ID4gImhkXzQ2Nm1fZm1lbV9jayIsIDI0KSwNCj4gPiArfTsN
Cj4gPiArDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2Nsa19kZXNjIHBlcmlfYW9fZGVz
YyA9IHsNCj4gPiArCS5jbGtzID0gcGVyaV9hb19jbGtzLA0KPiA+ICsJLm51bV9jbGtzID0gQVJS
QVlfU0laRShwZXJpX2FvX2Nsa3MpLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0
IHN0cnVjdCBvZl9kZXZpY2VfaWQgb2ZfbWF0Y2hfY2xrX210ODE4OF9wZXJpX2FvW10gPSB7DQo+
ID4gKwl7IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE4OC1wZXJpY2ZnLWFvIiwgLmRhdGEg
PQ0KPiA+ICZwZXJpX2FvX2Rlc2MgfSwNCj4gPiArCXsgLyogc2VudGluZWwgKi8gfQ0KPiA+ICt9
Ow0KPiANCj4gTU9EVUxFX0RFVklDRV9UQUJMRSBpcyBtaXNzaW5nDQo+IA0KVGhhbmsgeW91IGZv
ciB5b3VyIHN1Z2dlc3Rpb25zLg0KDQpPaywgSSB3b3VsZCBtb2RpZnkgdGhpcyBpbiB2Ny4NCj4g
PiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIGNsa19tdDgxODhfcGVyaV9h
b19kcnYgPSB7DQo+ID4gKwkucHJvYmUgPSBtdGtfY2xrX3NpbXBsZV9wcm9iZSwNCj4gPiArCS5y
ZW1vdmUgPSBtdGtfY2xrX3NpbXBsZV9yZW1vdmUsDQo+ID4gKwkuZHJpdmVyID0gew0KPiA+ICsJ
CS5uYW1lID0gImNsay1tdDgxODgtcGVyaV9hbyIsDQo+ID4gKwkJLm9mX21hdGNoX3RhYmxlID0g
b2ZfbWF0Y2hfY2xrX210ODE4OF9wZXJpX2FvLA0KPiA+ICsJfSwNCj4gPiArfTsNCj4gPiArYnVp
bHRpbl9wbGF0Zm9ybV9kcml2ZXIoY2xrX210ODE4OF9wZXJpX2FvX2Rydik7DQo+IA0KPiBtb2R1
bGVfcGxhdGZvcm1fZHJpdmVyKCkNCj4gDQo+IE1PRFVMRV9MSUNFTlNFDQo=
