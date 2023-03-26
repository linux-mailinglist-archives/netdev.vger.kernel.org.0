Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361956C9763
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 20:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjCZSPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 14:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbjCZSO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 14:14:59 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3646D3AAD;
        Sun, 26 Mar 2023 11:14:17 -0700 (PDT)
X-UUID: f884979ccc0111eda9a90f0bb45854f4-20230327
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6mGaPypfEpGixNvcqokESdaxl6CBttsT5VOXge2vvus=;
        b=VrmxC2mPMhn+/ldfsCl2KqPu9Iw0pKZQiDf25rKBeCUye/TBZ5pcn4JAqbqPW0+b3jNkYn0ujlhlFUV7h/U3ZcvAugbkCtRidMrq+5mlw75MYjFMcnuY9/GBgM4Hq5w8CdvCymhTlve7DVUOvxeJN9Yp/ffMKotqox+KWL3S9m8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:a5b43e7c-0bc0-40c1-a676-520ab5b33622,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-3,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-3
X-CID-INFO: VERSION:1.1.22,REQID:a5b43e7c-0bc0-40c1-a676-520ab5b33622,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-3,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-3
X-CID-META: VersionHash:120426c,CLOUDID:c3c78629-564d-42d9-9875-7c868ee415ec,B
        ulkID:2303270213587RPB7SJ0,BulkQuantity:0,Recheck:0,SF:38|100|17|19|101|10
        2,TC:nil,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
        L:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-UUID: f884979ccc0111eda9a90f0bb45854f4-20230327
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 329016448; Mon, 27 Mar 2023 02:13:55 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 27 Mar 2023 02:13:54 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 27 Mar 2023 02:13:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3VuyHpSqhFj6rV7nNg1+0RWJXBqiJhlIY5atGjXYgdqvDI+ovRWX6UPIfmmbrTSICDtc+E2/TXd6ZEVCcTchcfUtniqLj1sY43zEKwozd+n/iz3RnKBnU1hmwJDH4gL1JwY6axQ4mm+1uuFv7yN1eT0NaQXf+1AmLYGfVZl9JNhbnj4M/tTjKzpaaDY4vKAYCGkeBcq4d6YCVohVFgX2WCIRTuvuQNMC9AgyiYUsfXmVFNLRbuqHqoVKTYDyXC/k/3YJd/Jop2FUmSt7x4mOxI6xo4PAiuzGLuV+la2TjPls9sXjZ0V0tNImqz2IC7DdczMsuqCUAyTRRig/+VjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mGaPypfEpGixNvcqokESdaxl6CBttsT5VOXge2vvus=;
 b=JXGYPTtcMCjbKEQLPXixmDtQ17K1zA3MDf2wIuNbvK7bKlLo5BpCixtcq5ffb0i5kWlA3sEzPPNEfyI31+2Gclxoy7+7HvMGnBaz6A/i+5E1BGH4RVyPII56jo0aBbsb6St7KfRKcU/FMegBRrrzqYvdvd3yBYKhDSF2XsuvjZNWSGaDiVO8xqZIku34i4aM2d0RG2VdHQwxyj/hH+1aNhWhJBLQrihdzs0a63Ra/SKrwJ/MWOnYdrbzu0uqVDy0bvsqdNoY8/Bs+GI2v02FJ2AKMkvmv32mbUC0/vUIDKbUHQzCW5v028Wpmdr3KYdihYJGMOLLVqRh7RJz3TC2Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mGaPypfEpGixNvcqokESdaxl6CBttsT5VOXge2vvus=;
 b=hJIsSO5w5vrZyh57knvX8yaN11/WaeyowRj6Q3CRYUqhanE8k0SBG8FHW3ics6Au3NDCtezX+bEIpmuXy1dEl8lDGkZBAyR+83FObWr9EZ/ykc7K4UEDyx3LnXf+ltkyQ1a1ZULT0uK6SLr4kJDk/ur04mFXhgSMOJmgaO40VNU=
Received: from SG2PR03MB5182.apcprd03.prod.outlook.com (2603:1096:4:de::17) by
 PSAPR03MB6235.apcprd03.prod.outlook.com (2603:1096:301:9c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.41; Sun, 26 Mar 2023 18:13:50 +0000
Received: from SG2PR03MB5182.apcprd03.prod.outlook.com
 ([fe80::2428:bdbc:5582:4864]) by SG2PR03MB5182.apcprd03.prod.outlook.com
 ([fe80::2428:bdbc:5582:4864%5]) with mapi id 15.20.6178.041; Sun, 26 Mar 2023
 18:13:50 +0000
From:   =?utf-8?B?TGFuZGVuIENoYW8gKOi2meeajuWujyk=?= 
        <Landen.Chao@mediatek.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "arinc9.unal@gmail.com" <arinc9.unal@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "dqfext@gmail.com" <dqfext@gmail.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "erkin.bozoglu@xeront.com" <erkin.bozoglu@xeront.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH net 2/3] net: dsa: mt7530: move lowering TRGMII driving to
 mt7530_setup()
Thread-Topic: [PATCH net 2/3] net: dsa: mt7530: move lowering TRGMII driving
 to mt7530_setup()
Thread-Index: AQHZW18D4jD4kE171kSFtPDNy25/jq8NZqyA
Date:   Sun, 26 Mar 2023 18:13:49 +0000
Message-ID: <4d9c562eb980642381cb43f65efb2ee13d742485.camel@mediatek.com>
References: <20230320190520.124513-1-arinc.unal@arinc9.com>
         <20230320190520.124513-2-arinc.unal@arinc9.com>
In-Reply-To: <20230320190520.124513-2-arinc.unal@arinc9.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SG2PR03MB5182:EE_|PSAPR03MB6235:EE_
x-ms-office365-filtering-correlation-id: 24bb0ec3-d217-4240-5c6c-08db2e25d96e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LP7MPSIq8vNYxbNilrUA7WT2jD04lGk5+BWpjjMogrGPa6NkMBkGrmO20ipZZdcyf6ocygbGnR9Tr1Og1lRGMszSJSFS3DS9VQDp4I5ZwW/NlMqHrRc5N74e0aV/r3T6GtALhE5Y7NYtoocLh/gJV4ZEOuyxTt+kiruqnVGnBrzrFMPSmuOPWitijQc78ocYW0RxOWtvpcaOmCSjlItOtAg2H1pGAochB11ilqCkmI8VMUijbKC7s+oAur5zK/B0KuNivaIq7Ku61ffX/BhOOAJ0Lw87qe2efEKHYrJ/+gLS+XoLt2+JdbSfWaPv792nDEiqU98o8VEv6JZuf3y8Vds72ithssWBR75HVYTvUJY4Jc9AdwTMUapbi8oI6QEsBpSqyFxdfdr836qel6rQeECkttfaU8pShyMwpvPxdJ19K8rZQF+vlhUtMQflUAdlqJR7JyGeJgzPVwGQPk+8BkWschV2YMecvBepzbKPC0/pskzftvAsqfeXYfsP61A3UAZc00tsdoDXL1ErMvOdUkushExxiKvx4zZfkEmpbouyVnltaWid+LLYZkpeYs/NQJov6iV5yG0JjTRBEZknhmdJ3L1Hc8KSzOzfJxRsoqFTgpAbdvdJG8qidUVktOpj8S7UXkYNG7b7Z3NFg1c/4bX89cP6H12GL6hpzwq6wNLFpE+PAHrOQYK+jcQlVN/T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR03MB5182.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(39850400004)(346002)(366004)(451199021)(54906003)(4326008)(316002)(6506007)(6512007)(26005)(5660300002)(2906002)(7416002)(8936002)(921005)(4744005)(38100700002)(38070700005)(122000001)(86362001)(8676002)(91956017)(66556008)(66946007)(66446008)(76116006)(64756008)(66476007)(186003)(2616005)(85182001)(41300700001)(36756003)(478600001)(71200400001)(6486002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXkzZXJWeWk1dUx0Ny9xZDFrYmVNTnIwU2Fyd3FEVnE5cDZzYmdlYXlzRGVN?=
 =?utf-8?B?dlluUVIxcC9ZU1VXcVpLZ2phemRSdElqeHg1TlRER01VQkV3RTlINGE4UUdI?=
 =?utf-8?B?bUdzQWo4MjA3aGVOU2VZT2Z4MWFCWXkwY3d3NU5zaVd1eE1NemdZaXhSekt1?=
 =?utf-8?B?QktnNkVWVzhuUHNUTUI4Q1NTMGRocDhjeUtRMmpLcmQxMC9qeXZoWkQ5Skto?=
 =?utf-8?B?Z0c3RmltOVduUXIxOGhCaXZpQmduNFhSQ29SZU9vQjZLTnpNMnIyeVp5My9B?=
 =?utf-8?B?UjhidXFhWTdRSktRbTJNRWo2MktrelNFTVdhQkxVYzBuREs1VjVMVFU3Wlpl?=
 =?utf-8?B?N3g0Ky9rQVRGYVlqQjEzUUljL1A3R1JyWWFSQTRMV2NOOXBZVVFhTHFvQ0ZW?=
 =?utf-8?B?UkdkZERtSDNHUjZMMHBjcHZzK1VBSjJka0ovZWV3ZzI1Unlzdmk4ZFRUdmYz?=
 =?utf-8?B?QU5sWEdlOUJQOGFaUmdlUytaZVZEN0lBYVNuVlFUT0UreUhGbEloQlowNWp3?=
 =?utf-8?B?RHBVVi90VUtmcEIrK0FKaDFZT0ErRUw5NG1EakFGOFJxVmFVQU1CR3kvVStM?=
 =?utf-8?B?NUNXQmUvd0RiQWU5K0t0WWM4NWlqQzZtWldLVEtDRVQ0Z2ZKK0gwWDZ1L1Vl?=
 =?utf-8?B?SFZGMlgwcUYwK0crdlJBTGJVTGkwakg1OG55Q2JTSW55U3NvTDk3b2RvdFNF?=
 =?utf-8?B?Q3ZucUYwMG1tS2hQT2UyYTNPYmNMZ1p6UHV0S2pPTjRJTUNCTkg2MDZRSlFW?=
 =?utf-8?B?LzlvQWlDRE5wNHdMNVg3SXZQWlI4OWc0Z3phRUdtV0twYlg3U0tJeDBjQnJO?=
 =?utf-8?B?VkxNdHVYdW5neUlmWGZ0Z1hXYVlFU29wRUsxalQyZGkyK0Fyam03cXF5czk4?=
 =?utf-8?B?dmNWcTcyUldHbFIxWVlrY2NNTDF4K3JuSTNYdCtQOUtHQ0pxa2hLWGpoTWpY?=
 =?utf-8?B?aXQxdE51UE5sNDhwUk9Ia3NBSHoyQjcvbkZzdjhORzM2a2tZb2N2MlNpWHFl?=
 =?utf-8?B?WkZYWUZVbXhDUnMrQ1dRcDU0WGRLY3hEZ1g4U1Z3UVlXQUJDR3BxWWJIWmJh?=
 =?utf-8?B?N2ZXYkxKcitZNnlHbHpGOUZqM1liRFFDbHJDaUZhSk9oSE5yaERWTHMrdGg4?=
 =?utf-8?B?Z1N6a3VWTHJrejRkbjl2Tzl1V0lPR0E3eTgvN2xPOVQyclR0c0xNYlptS1BO?=
 =?utf-8?B?NmdFajV5bTQ0U1hudmNlUzFOaEo0Z2pVcVJteDdvMWJQWFdRaTJJaS9LRG9I?=
 =?utf-8?B?RWFYTit5VDBhVGdiOFJudTVHcG9OOXltZ1NQV3BrdmRpVG1MeDFLc0FFOWNT?=
 =?utf-8?B?bVhSNGFNNFRhWTJVa1pmc3NTSklTY0NNcHJIZ2FrQ0E0WWxNRDJkSm84bUFk?=
 =?utf-8?B?eHRnbnVXcDRkbXhVS3JxOEJ3VUJFYXE0SkQ0aFpyb1lUa2VQczlGUk4wbDNw?=
 =?utf-8?B?YWJxWkJ3YzFjdmVCdFgvTmNFUWFsN3RiQ2RYb1dHSEtaYWxWU250ZUZGRWZv?=
 =?utf-8?B?VnJ5MHZyZjkyMmdtTTcvL3dPYWNSQXNoVWwySHRjMURjRUpCcThVZFI0Q2w1?=
 =?utf-8?B?OG9wR0pXNnQrWE5BbSsvVDlYZzVhYU5saXJ4Z0hzb1ovVHdyeEdNblAxQ081?=
 =?utf-8?B?aEQ2SXMvZ3lqb1FWMkRKSU1HMElJTU42N2hzTTRIQlY4QkZQSS9Sb0Q5YVEx?=
 =?utf-8?B?Q0MzMzBPVVdlQVQ1SFhabExFRmpOUjk0KzAwOFlhWk1GMi9xWDd6WC9rcS95?=
 =?utf-8?B?WndYYWJIS3lwcm5XNXFvcjBXMU1nNDhRY25LUC90anZoelUvaW80czJxTEww?=
 =?utf-8?B?TTlBcUZpMmZqN3FERHRJWWsvc3QwTklDVjBpVWlwWkJjdGp0WXlYRHpZWVR0?=
 =?utf-8?B?MW80RGtEeXBmYXNMaFVTM0ZTOGVsTWVsbDE1MTFkOUFPTXdZN2dUamJLMTNX?=
 =?utf-8?B?OHZ2dGFMM0t5NTU2N0kvSHdIUi9WZmpDUjBvSURHc0VWc3BSSWFyRHVWRXZO?=
 =?utf-8?B?UmJYNnpWajBRRU85b2xTbTBQS2V6MTFiM0g2MlVOd05DY2VZOVRkeFRkVUNF?=
 =?utf-8?B?dnZKMlRZcWNwTDROTVJ4anpZNmFucXNFS2hzRjlSUkw5UnJLbU03YzZnUTdw?=
 =?utf-8?B?UzE0N05oVkE5RHZkNFgwVWxvc2ZZVDk0UGJzNFBhRGFibWthR2JpdENNR2Jt?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08BAC12111F2084C988EF741E0004A0D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SG2PR03MB5182.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bb0ec3-d217-4240-5c6c-08db2e25d96e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2023 18:13:49.8988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TaJL9k0assa6AFA42lhXp75+lGP9ZgPIY77Bg7n1DXzqHRqRAodd0cOS377x6MohCIb4gMS2EC8ol12it0qQeyteFy2vR8+14teWFms5UII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB6235
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTIwIGF0IDIyOjA1ICswMzAwLCBhcmluYzkudW5hbEBnbWFpbC5jb20g
d3JvdGU6DQo+IA0KPiBJIGFza2VkIHRoaXMgYmVmb3JlLCBNVDc1MzAgRFNBIGRyaXZlciBtYWlu
dGFpbmVycywgcGxlYXNlIGV4cGxhaW4NCj4gdGhlIGNvZGUNCj4gSSBtZW50aW9uZWQgb24gdGhl
IHNlY29uZCBwYXJhZ3JhcGguDQo+IA0KPiAtLS0NCj4gQEAgLTIyMDcsNiArMjE5OCwxNSBAQCBt
dDc1MzBfc2V0dXAoc3RydWN0IGRzYV9zd2l0Y2ggKmRzKQ0KPiANCj4gICAgICAgICBtdDc1MzBf
cGxsX3NldHVwKHByaXYpOw0KPiANCj4gKyAgICAgICAvKiBMb3dlciBUeCBkcml2aW5nIGZvciBU
UkdNSUkgcGF0aCAqLw0KPiArICAgICAgIGZvciAoaSA9IDA7IGkgPCBOVU1fVFJHTUlJX0NUUkw7
IGkrKykNCj4gKyAgICAgICAgICAgICAgIG10NzUzMF93cml0ZShwcml2LCBNVDc1MzBfVFJHTUlJ
X1REX09EVChpKSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICBURF9ETV9EUlZQKDgp
IHwgVERfRE1fRFJWTig4KSk7DQo+ICsNCkkgZ3Vlc3MgeW91IGFzayB0aGlzIHBhcnQsIGFuZCBJ
IHRyeSBteSBiZXN0IHRvIHJlY2FsbCB3aGF0IHRoZQ0Kb3JpZ2luYWwgYXV0aG9yIHNhaWQgeWVh
cnMgYWdvLg0KSXQgaXMgdXNlZCB0byBhZGp1c3QgdGhlIFJYIGRlbGF5IG9mIHBvcnQgNiB0byBt
YXRjaCB0aGUgdHgNCnNpZ25hbCBvZiB0aGUgbGluayBwYXJ0bmVyLg0KPiArICAgICAgIGZvciAo
aSA9IDA7IGkgPCBOVU1fVFJHTUlJX0NUUkw7IGkrKykNCj4gKyAgICAgICAgICAgICAgIG10NzUz
MF9ybXcocHJpdiwgTVQ3NTMwX1RSR01JSV9SRChpKSwNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgUkRfVEFQX01BU0ssIFJEX1RBUCgxNikpOw0KPiArDQo+IA0KPiANCg==
