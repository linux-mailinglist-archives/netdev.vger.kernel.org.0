Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630E46D16DD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCaFjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaFjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:39:22 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0BD12CDE;
        Thu, 30 Mar 2023 22:39:18 -0700 (PDT)
X-UUID: 5e744acacf8611edb6b9f13eb10bd0fe-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=2U+etTRIrrnUPXwojzXnNfziyqZhiNlpbk5hAhY1gQ4=;
        b=cnDqeDbEbkrMryG0BwCE7DBCGm8fseKDhrzvrRez0e/zrthCS8zYouZ0HO3N2Jfsa6v6Jgju/Vs4BMX00V4mgqw7mSdny8Lysy74E5wis/j6ftwG80VaJWHYiFgwsmAwRRexnXRtssOuBqvaRGlfJkoGMkMo+Zra+Pfg1JfMUAA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:71ae1dd0-2305-4174-898b-021c7e777757,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.22,REQID:71ae1dd0-2305-4174-898b-021c7e777757,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:120426c,CLOUDID:ea040e2a-564d-42d9-9875-7c868ee415ec,B
        ulkID:230331133914ZXKAQV2R,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 5e744acacf8611edb6b9f13eb10bd0fe-20230331
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 137719278; Fri, 31 Mar 2023 13:39:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 13:39:12 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 13:39:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idqfEmWxLoCZBSxACxfKl78tL7QLOl1gCGwQ7cLKfUsMzPQO1c1mJkz3p/lAntmb2VQhmPc4pbtDBuYlSeKyk/BDM6GB5Dk+SChCMsEhqulnerwFWe2I1jeTS/gQ9vhfRjqiC9jgnre24nauxwksN72JtJXyeY+oSL0/Q5VPo6V01qDoI4NX+VjK9i729Yab9ekZcUHoOTcdw3inokYoUhNuat6y4xgN0AVCMCm357WvtwLlVoQwFF/mEk50qkNUGIpKDT/0/7/pspM0tI/rJOFHoCQYUSCF5TOT8Wb4gUD2RZs+fKU06didBUQkpYtCUxGd92L13ipnP9E2xHZVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2U+etTRIrrnUPXwojzXnNfziyqZhiNlpbk5hAhY1gQ4=;
 b=eiGZVafv8AdNnsyXVj7ccVyVF2L9ojf0nJb+lVRiIipqX7cxeA0S98B6X0AG9yV9z9Yea+vf5x9pxE0ltn+PR4VoN8DwcaM5+MH8KV9r8FYOZd6zlhYaJaJtKqj7hclLSAgzRxGHE+fe+vLw0JOD+RRWSiGKLa5WBgFmNp2/CNnFgEKYX6aemBUV7zCaunrfQPbgPcQvw8iSDnWHVlFC3A/I2kSxR+PJvrSrSCu4h6wHkRxi3Ue3HhPTC6rCdAknQZ3z/TKtLYK7CYZtCyEl7nLGjOViDgTUpyM1x5IgfadS/qxEnKjckflgZiqpcrfRTsj9KjNhBVgJx+Zybod20Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2U+etTRIrrnUPXwojzXnNfziyqZhiNlpbk5hAhY1gQ4=;
 b=j5F36U2Gf5hamMGA+pxC6Y/2xqo1G+YvwoVZE0uIvujf2PwUe4PVeGAwICoKmpzpGOC2uXtLK3Xi6McEcK6uqdq+0r911+znHp0ATQ7b288oml/fI89Dib2B4rP8ecqJGLa5cJ2lN8f6W+xOM3VTljgKkZILvDHlTFFv4y0fYEE=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SEZPR03MB6957.apcprd03.prod.outlook.com (2603:1096:101:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Fri, 31 Mar
 2023 05:39:09 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 05:39:09 +0000
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
Subject: Re: [PATCH v6 07/19] clk: mediatek: Add MT8188 ccusys clock support
Thread-Topic: [PATCH v6 07/19] clk: mediatek: Add MT8188 ccusys clock support
Thread-Index: AQHZUo67ebAyf5EUUE6d88RsAX87Y676AwgAgBp+E4A=
Date:   Fri, 31 Mar 2023 05:39:08 +0000
Message-ID: <88970ff4cee594f27d407c91d01373afc2006e2e.camel@mediatek.com>
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
         <20230309135419.30159-8-Garmin.Chang@mediatek.com>
         <500b5030-4dac-03c9-1a4c-2cf2e70b829c@collabora.com>
In-Reply-To: <500b5030-4dac-03c9-1a4c-2cf2e70b829c@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SEZPR03MB6957:EE_
x-ms-office365-filtering-correlation-id: fc8c8182-5949-4db1-92af-08db31aa3fc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FUikSVUsc6/WNTqOYMpdGSEPkk/3ZWTBv5YBWEaFI5VFA805HiuiG4GIskwopb7wImMLDgtZN+iPHErblCd0yc/rQWjKC4Q9NgobDT3FsFGVs7BxPj5MUzlHU8sSqhk4W+B1ImCqBehgkF2P3dVMgE1hfr+ikfmkhkXdbiKyBqSSmcbMM2ZS6Pue4WfclQdrpLCmeFfGZyd+EcPslzzkFntfELXwH/lG4GLCUHYE13pah2mi7OP7eAq8g2Hy1AhSHqquTAhNRYppcEZLGGXPgsOMMLFk8H353sHD9/ot99G+bkOoWNo49MmBzO2kOV6lznF5i8cC6zIo+sC6NM6SH98dSvPbCxb6VJweWjdmRNHzgrpIOOBsFCdIbMwjJIuWVxSBl2Ys56BGv15KyiocyXbT9yt1hGh9owQxkGb7Y+FjVsk2ghwV/MPXR5p40R6VsutnEnIDRi3UKVCRi6eXckWw8ewSC2jtHwEkE8Z5TGoMnaWkpF0XGLe1G7mIa94UCtNXsCyh/pmDNfLtXwh1Jh3E/C11zBCUae88EO0EgmfFTyJ6NcmSPgg1E+0k0QuEyupZaufPpDWR3Rf5FB2KqTVd5KqKZd2YNMH8kAQBu5UzLoDzg5zlarn4i53H0TfSpPrW8eXYd1J8YBde0G7HHnE2kn73xbHzXz0P7UHy9wA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(451199021)(83380400001)(66476007)(316002)(38070700005)(86362001)(36756003)(85182001)(6512007)(2616005)(66946007)(2906002)(26005)(38100700002)(6506007)(6486002)(122000001)(186003)(478600001)(54906003)(71200400001)(64756008)(8936002)(76116006)(91956017)(110136005)(66446008)(66556008)(4326008)(8676002)(5660300002)(7416002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RksxNnl4R2FybHRndWNDaitOR084Mmo1cUU5bG9rcjcxL1U5UmtMMExaWklR?=
 =?utf-8?B?akUxRUcxM3FHSEsxV1FQVXJYTUcvUUcwSVcvcWdRdTJCUGM5YzRtOXhQQ1ND?=
 =?utf-8?B?WE1NVDROamQ1UkczcXhGRUpiMXl4YzVJYi9oM2lCRndvM1oxSHRjem0xcUd1?=
 =?utf-8?B?Nmh4eWdkVFJpL09QSi9DM1oyaSswVmYyR0Q4alVKcE5mMkpXSEUwWGY3dTc1?=
 =?utf-8?B?MTJTV1FjZ2hYNVBwRGNxMllwbElLVDNsNU5LSzFSWEtyeHBucE1ES2taWlpa?=
 =?utf-8?B?OUwxQitVQ0lWYk45WGpkYmRCNHk5VC9hN1VWc2IwanJVT0kxREl2RkNCbTZ2?=
 =?utf-8?B?UUxwT29meDQrdUlnajB3SU1KTXQ2SnF0eGNGUTk4N0RZZVpZaGd3aHY3aC9S?=
 =?utf-8?B?KzhqaXpyNC9CZTB6UnNPU1pyc0hZZVo2djA5TkpWbmhvREh0NDViMWdDYUNv?=
 =?utf-8?B?Y25TSDI4ZHZWdENhb2lIQzgyVFhRNEx0Q3pEeVAzNE5PUWcvZkpPaE9QTmo1?=
 =?utf-8?B?WjZXUjdINFlkT3FUZnJ1eTBZVE5yZkR5NVpQQ0F2UURrMmsrS3Y3bmxBZGJq?=
 =?utf-8?B?ME1rZFZhcjB3cXE5UGZwY3Q1Y1JQc0FCVUNMV0Uyb1FkYXBOcWJWMXRLQ0Fp?=
 =?utf-8?B?Skt0bWFDTFptR080eWpncHM2ZlBvaFZxd0xxTEhVc2owY2pITzJ3L25nbmh1?=
 =?utf-8?B?SnA3UGh3OENwclUwYjc1MmRKQStXSi93dk82MWNGZ09CeGhHU2xDcUJjM2tq?=
 =?utf-8?B?NWFlVEtZdkpWZUtJQlN3cVpKZ1h5cEYyVFkzRWFKVlJRajR6NUFBVFZiMkEy?=
 =?utf-8?B?Vk03Si9jL29uRE9ydHlsa3FHSGdpM0QvcThKVkgyVVlpdGxVSjJvQXI4L3Yx?=
 =?utf-8?B?MVB1ZEd3NGRtYjV5cjlMSmlNL0gwZGpYbnBLTmZYc0RrekJQeWtIK0FKS0s2?=
 =?utf-8?B?ZFpqdFBlU0Yzc0tFdWtYWWd5Qk1DVldTb3BzbDRSR3dFNVNJcnlVME1mYmpH?=
 =?utf-8?B?czhiTC9qZ0xtaVpJemJYTG05V0tYNnRQK1pYYlpUVlRJd2xRWmdzcFVINUYv?=
 =?utf-8?B?cCszWjRWa3NQc043K05zS2ViajVZZHBhWXdEaGVtYkRkSkErMGkrWGJkRzVo?=
 =?utf-8?B?eUJrY3ExT0ZDL20vdWdMTHZTUGlCa0h1a252cW5TL1Q3TXFmUm5IRllWVlBN?=
 =?utf-8?B?TW5KQ2xNYzdNSFkxbnkwS04xRFord2F3WXNXMVFlSE42aEw3T2o3emk0elo4?=
 =?utf-8?B?TmRQZW5vRGlZaE51OXBpMlZBYk1RaDdzMXZhSXEvc3JjUnJHanhOeXd3Y0ph?=
 =?utf-8?B?a1kzVjlPTEEwcWcxT3g3SU5kUkpJVFRXbG1JdnZzY2pMWWU1T3l1NENxZXoy?=
 =?utf-8?B?a0ROZUJiLzRYL2NyRkhJYWNZallZdDZaWVl3L0tKWmFuaWM3bDgzWFg2QmhN?=
 =?utf-8?B?bUJDWktoSDNCRmpOY1NYZjdnRHlmaXNCNmhKcVdTSkxvYVFxK0ltcVdONnlY?=
 =?utf-8?B?Y2QwWXYyN3Z5L0Z5aTZ2aFkrSzZDQ1NpUGIvT3FzY1VsTWxXUGFBOHpDRy9O?=
 =?utf-8?B?eWhwaEJ5M2Q0RExVRUNYeS9id1lFQkVVQ3A1eUE1U2VYRmljN0tsSG14MUx0?=
 =?utf-8?B?U0NKdWdBUEtBTy9ZNnZlVGlBOURVbTF6Y2dGVCtQVzNUWWp5UXgvTVcvb3BW?=
 =?utf-8?B?dVNzYlZFQTh1MFE4OUJBeUlzSGQyTHF5VG1JY1dmYitaQnIrUnpYMFN3U1gy?=
 =?utf-8?B?N3JRdHlRbE8veWpUbnczWjY5YzA0eEsyMzhVdkRaQ3I5eDFNbDluOHBUMU1U?=
 =?utf-8?B?enZsS01zVXJFSHdVTDJIU3JCNFRNZmJsVUZISnNqZjVHdnhGUTdTVWtMUVNX?=
 =?utf-8?B?VHhUUExwNTNRMGRubll0RXQrK21jcmxkSVduRmExbnpSUE45dUlnMjFJdnVo?=
 =?utf-8?B?VmxaOHFQbE9QYnhjWFhIVzdZc0kya3ZUdVJ4OCs4WThMUG5BZ1A4cjV6OWZV?=
 =?utf-8?B?YzNLb0hDYWgzMTVQWWw0Tkhvakw2RW9OdFJWYVhjcHhPUXJONENmOUZQTWdx?=
 =?utf-8?B?UjVpQTdMZ2JrSzluRTgxaEVta3dOdWRwank5MUozTExnbFhNUXpyOTdqczNm?=
 =?utf-8?B?aWw2L3lTaXdqc0ZkUG5PNjYrMDg5eDJwY1V4d3NrSzZNa1hycnpGSjVQM3Vl?=
 =?utf-8?B?YlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7DA96C4C0F0A645A4B3FCDE1785E727@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc8c8182-5949-4db1-92af-08db31aa3fc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:39:08.7120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4X/qWpELEA1yw2pWfnuv2t19kGXs9ikVLrH7qCKHR47WMvpsomtdhQy8P2j5E+3/tmqCZn1NKReiRS00PsxlVN90f5a443wq8Yb9QREh3X0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6957
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
Og0KPiA+IEFkZCBNVDgxODggY2N1c3lzIGNsb2NrIGNvbnRyb2xsZXIgd2hpY2ggcHJvdmlkZXMg
Y2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wgaW4gQ2FtZXJhIENvbXB1dGluZyBVbml0Lg0KPiA+IA0K
PiA+IFNpZ25lZC1vZmYtYnk6IEdhcm1pbi5DaGFuZyA8R2FybWluLkNoYW5nQG1lZGlhdGVrLmNv
bT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlICAgICAgICAg
fCAgMiArLQ0KPiA+ICAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10ODE4OC1jY3UuYyB8IDQ4
DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQs
IDQ5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiAgIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWNjdS5jDQo+ID4gDQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9t
ZWRpYXRlay9NYWtlZmlsZQ0KPiA+IGluZGV4IGE0MTg5ZDI4Y2VjYy4uZmI2NmQyNWU5OGZkIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gKysrIGIv
ZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBAQCAtOTMsNyArOTMsNyBAQCBvYmot
JChDT05GSUdfQ09NTU9OX0NMS19NVDgxODYpICs9IGNsay1tdDgxODYtDQo+ID4gbWN1Lm8gY2xr
LW10ODE4Ni10b3Bja2dlbi5vIGNsay1tdA0KPiA+ICAgCQkJCSAgIGNsay1tdDgxODYtY2FtLm8g
Y2xrLW10ODE4Ni1tZHAubw0KPiA+IGNsay1tdDgxODYtaXBlLm8NCj4gPiAgIG9iai0kKENPTkZJ
R19DT01NT05fQ0xLX01UODE4OCkgKz0gY2xrLW10ODE4OC1hcG1peGVkc3lzLm8gY2xrLQ0KPiA+
IG10ODE4OC10b3Bja2dlbi5vIFwNCj4gPiAgIAkJCQkgICBjbGstbXQ4MTg4LXBlcmlfYW8ubyBj
bGstbXQ4MTg4LQ0KPiA+IGluZnJhX2FvLm8gXA0KPiA+IC0JCQkJICAgY2xrLW10ODE4OC1jYW0u
bw0KPiA+ICsJCQkJICAgY2xrLW10ODE4OC1jYW0ubyBjbGstbXQ4MTg4LWNjdS5vDQo+IA0KPiBj
bGstbXQ4MTg4LWNhbSBhbmQgY2xrLW10ODE4OC1jY3UgY2FuIGdvIHVuZGVyIGEgZGlmZmVyZW50
DQo+IGNvbmZpZ3VyYXRpb24gb3B0aW9uDQo+IGZvciBtb2R1bGFyaXR5Lg0KPiANCj4gRm9yIGV4
YW1wbGUuLi4NCj4gDQo+IG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE4OF9DQU0pICs9ICAu
Li5jY3UubywgLi4uY2FtLm8NCj4gDQo+IFBsZWFzZSBtYWtlIHN1cmUsIGZvciBib290IHBlcmZv
cm1hbmNlIHB1cnBvc2VzLCB0byBvcmRlciB0aGVtIGFzOg0KPiANCj4gb2JqLSQoQ09ORklHXy4u
Li4uKSArPSBkcml2ZXItY2xrMS5vIGRyaXZlci1yZXF1aXJpbmctY2xrMS1jbG9ja3Mubw0KPiAN
ClRoYW5rIHlvdSBmb3IgeW91ciBzdWdnZXN0aW9ucy4NCg0KT2ssIEkgd2lsbCByZWZlciB0byBv
dGhlciBjaGlwcyB0byBtb2RpZnkgbXQ4MTg4IGFib3V0IHRoaXMgaW4gdjcuDQoNCj4gPiAgIG9i
ai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5MikgKz0gY2xrLW10ODE5Mi5vDQo+ID4gICBvYmot
JChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQVVEU1lTKSArPSBjbGstbXQ4MTkyLWF1ZC5vDQo+
ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQ0FNU1lTKSArPSBjbGstbXQ4MTky
LWNhbS5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgt
Y2N1LmMNCj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtY2N1LmMNCj4gPiBu
ZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYjczODAwNjBmOTA2
DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1t
dDgxODgtY2N1LmMNCj4gPiBAQCAtMCwwICsxLDQ4IEBADQo+ID4gKy8vIFNQRFgtTGljZW5zZS1J
ZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4gPiArLy8gQ29weXJpZ2h0IChjKSAy
MDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBHYXJtaW4gQ2hhbmcgPGdhcm1pbi5j
aGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvY2xrLXByb3Zp
ZGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4gPiArI2lu
Y2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsuaD4NCj4gPiArDQo+
ID4gKyNpbmNsdWRlICJjbGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVkZSAiY2xrLW10ay5oIg0KPiA+
ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIGNjdV9jZ19yZWdzID0g
ew0KPiA+ICsJLnNldF9vZnMgPSAweDQsDQo+ID4gKwkuY2xyX29mcyA9IDB4OCwNCj4gPiArCS5z
dGFfb2ZzID0gMHgwLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArI2RlZmluZSBHQVRFX0NDVShfaWQs
IF9uYW1lLCBfcGFyZW50LCBfc2hpZnQpCQkJDQo+ID4gXA0KPiA+ICsJR0FURV9NVEsoX2lkLCBf
bmFtZSwgX3BhcmVudCwgJmNjdV9jZ19yZWdzLCBfc2hpZnQsDQo+ID4gJm10a19jbGtfZ2F0ZV9v
cHNfc2V0Y2xyKQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZSBjY3Vf
Y2xrc1tdID0gew0KPiA+ICsJR0FURV9DQ1UoQ0xLX0NDVV9MQVJCMjcsICJjY3VfbGFyYjI3Iiwg
InRvcF9jY3UiLCAwKSwNCj4gPiArCUdBVEVfQ0NVKENMS19DQ1VfQUhCLCAiY2N1X2FoYiIsICJ0
b3BfY2N1IiwgMSksDQo+ID4gKwlHQVRFX0NDVShDTEtfQ0NVX0NDVTAsICJjY3VfY2N1MCIsICJ0
b3BfY2N1IiwgMiksDQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IG10
a19jbGtfZGVzYyBjY3VfZGVzYyA9IHsNCj4gPiArCS5jbGtzID0gY2N1X2Nsa3MsDQo+ID4gKwku
bnVtX2Nsa3MgPSBBUlJBWV9TSVpFKGNjdV9jbGtzKSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0
YXRpYyBjb25zdCBzdHJ1Y3Qgb2ZfZGV2aWNlX2lkIG9mX21hdGNoX2Nsa19tdDgxODhfY2N1W10g
PSB7DQo+ID4gKwl7IC5jb21wYXRpYmxlID0gIm1lZGlhdGVrLG10ODE4OC1jY3VzeXMiLCAuZGF0
YSA9ICZjY3VfZGVzY30sDQo+IA0KPiBNaXNzaW5nIHNwYWNlOiB7IFsuLi5dICZjY3VfZGVzYyB9
LA0KPiANCk9rLCBJJ2xsIGZpeCB0aGlzIGluIHY3Lg0KDQo+ID4gKwl7IC8qIHNlbnRpbmVsICov
IH0NCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZHJpdmVyIGNs
a19tdDgxODhfY2N1X2RydiA9IHsNCj4gPiArCS5wcm9iZSA9IG10a19jbGtfc2ltcGxlX3Byb2Jl
LA0KPiA+ICsJLnJlbW92ZSA9IG10a19jbGtfc2ltcGxlX3JlbW92ZSwNCj4gPiArCS5kcml2ZXIg
PSB7DQo+ID4gKwkJLm5hbWUgPSAiY2xrLW10ODE4OC1jY3UiLA0KPiA+ICsJCS5vZl9tYXRjaF90
YWJsZSA9IG9mX21hdGNoX2Nsa19tdDgxODhfY2N1LA0KPiA+ICsJfSwNCj4gPiArfTsNCj4gPiAr
DQo+ID4gK2J1aWx0aW5fcGxhdGZvcm1fZHJpdmVyKGNsa19tdDgxODhfY2N1X2Rydik7DQo+IA0K
PiBtb2R1bGVfcGxhdGZvcm1fZHJpdmVyDQo+IA0KPiA+ICtNT0RVTEVfTElDRU5TRSgiR1BMIik7
DQo+IA0KPiANCg==
