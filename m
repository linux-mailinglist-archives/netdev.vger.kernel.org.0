Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D5A6DC6A4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjDJMRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 08:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDJMRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 08:17:01 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203B44492;
        Mon, 10 Apr 2023 05:16:47 -0700 (PDT)
X-UUID: 8d35fe38d79911eda9a90f0bb45854f4-20230410
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=czXT/XBUyD2tv2TZfbaxmncnJP6b99lvR0A2dpqv2iU=;
        b=gK9J/WSXOJoiHxjkAxHtcG/+FNrv88/5XDL2Dp+369xmPdiSC2OB83rtmBDs0G88Z1bsL9aSDTFoDIZA3+VFCtVL97/VuDClx1wVgMmrhXoKrr5gNQ4QOIYXKSuAbQBp5DsseSqgEsUBQaGDmpSDfpRXx7jhPZdGLTS56LeKwWg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:955b48b0-ebd2-4c21-b0ab-16e6aa364b26,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:2296d6a0-8fcb-430b-954a-ba3f00fa94a5,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 8d35fe38d79911eda9a90f0bb45854f4-20230410
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1421823100; Mon, 10 Apr 2023 20:16:41 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 10 Apr 2023 20:16:40 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 10 Apr 2023 20:16:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWX2C/WCgM82ILNUVjjBcJdBxhldbRQO33pmMitJvjXRpZw/s6lrEk+24Yz4pHfa+XhqwtPZpKsYuZNQk+abHP9Pgbmu68zJBSgPDxs2gvO5f83Y+Zdx2XHNxKGgakBEQeVG2luflIrjao0xyoQXdIx6VcycAiGgH8xTQEsvXlNB+FqE+8tiXEX1lvVxyQ3ym2O2x+DRJ4ZhGDQ7338vVta1qS1tQHBLYqLUY7DTwLMxPaGIjjT496Iz3pmbS0oR4NwoNTI52QbClqdJoupbG53UUBCH49a6mu3Nr3mHemXmgNclunikVO7MFbQq+uGIan2MnTFvw9OESAlhq4jGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czXT/XBUyD2tv2TZfbaxmncnJP6b99lvR0A2dpqv2iU=;
 b=BZbTtRJTW66nJy0HM6eQ/gciZL7mzouy1N9cqCRr/weLSuLnyHrn+TzeIIfoQOVkLgiYLITM6gUNgHot+K3a3kMZ3NteUD1WQMBrDVMiHNSMxBW4qvJSoI2+yOw/PrMl1gnnsMo5PPMdqWvVyItmRaRPLsdYLYad/L6reqiNftS3ZiIRXmYVytbM1YOHTgaOlDRRRQQ5TaOJ4g/f38AH8yQt7KplKon6ccI/L0k7xN6wX9uShg4vGACe65PWBlnvHWrOI8bRRRvspTaws/lqjRWyBOqM3fWos4moQB+/cYm3HMIocp1JgsDLhTifBLdoyi/gCf1MLQzvk1gs9vB/eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czXT/XBUyD2tv2TZfbaxmncnJP6b99lvR0A2dpqv2iU=;
 b=SA0AOVDjhZVAjcrJR3a8Z6M/HsI7cQOBVrBzqb7ijxPostkSA0I8FGVPhc6LAPfeFMSBjti2snmS97CCoTLoSVUb+SwCU6RVFfjSY2OPDSyllm658W0PJ3vshZCQL6XwIjCp0JiPE6yEbWqvCziW0rgxosE3e+c/f+366G0bWx4=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by SI2PR03MB6512.apcprd03.prod.outlook.com (2603:1096:4:1a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 10 Apr
 2023 12:16:37 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::b7a9:e45c:f5c1:2fde]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::b7a9:e45c:f5c1:2fde%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 12:16:37 +0000
From:   =?utf-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
To:     "loic.poulain@linaro.org" <loic.poulain@linaro.org>
CC:     =?utf-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        =?utf-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        =?utf-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        =?utf-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?utf-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Subject: Re: [PATCH net-next v4 01/10] net: wwan: tmi: Add PCIe core
Thread-Topic: [PATCH net-next v4 01/10] net: wwan: tmi: Add PCIe core
Thread-Index: AQHZWKgMNDhZt253pU6OaAPAT5afDq7+6FUAgATFpICAIO1MgA==
Date:   Mon, 10 Apr 2023 12:16:36 +0000
Message-ID: <bbcd7e5155421d7671c995212d69ca7d8f575375.camel@mediatek.com>
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
         <20230317080942.183514-2-yanchao.yang@mediatek.com>
         <CAMZdPi9_xYO_MQ0BpxcqDci761uu=ZoczGMg81qkEDeOsP6apw@mail.gmail.com>
         <462e25346631c6f195ccc3d85ea58d4d0da66e86.camel@mediatek.com>
In-Reply-To: <462e25346631c6f195ccc3d85ea58d4d0da66e86.camel@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|SI2PR03MB6512:EE_
x-ms-office365-filtering-correlation-id: 0f1f669b-37ed-4d27-62e0-08db39bd6e95
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +uOE87V1Y9vgQC4Zc1lK1duWRw6y9KM1JZ3wv5hDqe9jTZdVlWymrlCEMaCe15tySR/aiWu5/3kUNg5cgYzpi3nKaxUlKIsu0GRh3olmYHDtBNCIM0IM+daOrpC+WMe8Ch7zzVaZXpPnp6AYX6Ah8dzros6JFud+HviqWQ/z7EjKg2LDJPoc6993Pzdh92RNGVhDaHhNC0PGRoe0JwhqdCYs4HdCPtGDJA7HBHyx2FQ0WCY9G/7M6vreuXxpDX/HrHAyyU87o64Y55v+IYknt95I04CJV/9wOfZfM83TBFP/s9//F8crKhcgcKFCMznV/t8rrGPl4Z5WHOAE3QaRhMynNNwYOKpg61KT4o0b4S4tuIenQAh5ZtNCDI40L+Fo3//zQUnwAMNjE6r2bEoBn4wibt3gATaomuHXNAJXuv6iE2cGoA+oy5BEVhi6vTCssMVFIe9+DhvqNcFJMCDuIHYwJlvObkgZKncVtguiRZJTcqggwah1kek1t5OAt0SCwExxtEqnjuBtj+wjJS+RyDVyNg/8V1Rd3uZ9opjOWeLeedL/G/tBuYcM61ODGWSTDFwRPizc9kAkelh7MVC/2ME1PmiXwqXNjxPyGDy0xbYSAHvVID1Jno7LGv1GZ25JMDKsv9heoK7eGudAmvR2NYQI0xeKyeQwJSyOYJmgUpqEkPuRoJQ8YfJQEGpDVfsd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(84040400005)(451199021)(38070700005)(38100700002)(122000001)(85182001)(86362001)(36756003)(71200400001)(107886003)(66946007)(6512007)(26005)(76116006)(54906003)(186003)(64756008)(6506007)(2906002)(66556008)(4326008)(316002)(8676002)(478600001)(6916009)(8936002)(66446008)(66476007)(5660300002)(7416002)(41300700001)(6486002)(2616005)(83380400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnVyUDI1bnNmMUh3a0tBT0d4T3lEcFM3UTU0ZjN0S1NURHdTN0hnc3JjYU5C?=
 =?utf-8?B?M1lENjM2UnZoYXZ1UXdqOUYyWGFOR2cxc0VqNGZYTnBRN2tmVG82Sldid3hv?=
 =?utf-8?B?ZEVldDVvUjZ5SENIMlJNeXJqYUpkTFgvTFVPbUVpRGpraXlrUVJZOVBJVmhS?=
 =?utf-8?B?ZUJ2V1hxQnNqL0JxSmNQZGVnU09UNjBpS2tMaERhOVk0QVhaNGgySWZ3azBZ?=
 =?utf-8?B?ajJxZkdJQVp2Y0c2WTdDY2Q5ckVUdjkyS3BXcC81dENrOFFKVWsybEVyQ1B4?=
 =?utf-8?B?R1JNUEwrUFN0NFd6WVZJK1ppSWRzTTFqbFYxK2NRbExQdWowKzlQcXRRMkRn?=
 =?utf-8?B?RXpRM3RJVlZMVUtkeHBhRk5leEsrVGFEL3d1QzFKV0p6T2diY29RdVJkTVpy?=
 =?utf-8?B?SkxWSG1TeVUyNGlGUkw2Um5CV2NMemhvd1dhVE1NM3VRVWxRSnYxNnRjbW5Z?=
 =?utf-8?B?dTlpTVp1N0hMYmxwZ25pTjZEWGp6ejJkUFZaaWJOUHFzaFo5RzkvVC9zK1NN?=
 =?utf-8?B?TTcyZ1lNYU1yUGhQUEV4ajFYeFJKbFl0K1FraS91c2xwM0EwWlJGeUViZ0hY?=
 =?utf-8?B?YjlFbDlUaXp5VmxzdU41TFA3UWFIbWxiYk01QnliSjdOQ1BCdXdPdjlYTC93?=
 =?utf-8?B?WjFSekFVWGhucGc2UVp5YyswM3poaWYvZ2RRa2FZSmUzMlJQTlp3MWYzVDRm?=
 =?utf-8?B?Z1RHMlRaZ2IzUzR4Q2MrNFhyZDBVUFJjd0txa05QSm5oQ3lSRzcxOElUV1ds?=
 =?utf-8?B?c01vRUtyalZCN2pZWURsYTVvTFI3NEpMTGdkdnhhU2YzbWxNN0JGOEFQU2xN?=
 =?utf-8?B?SGI1QXQwQUYxSkhHeFRVUUttelRRSWJDZ3NRSlpzc1RISTltb3E3eFV3V1FX?=
 =?utf-8?B?RDdVb0VLeDBoOEFVMzdvcFdwUUwvS3RQY2E0b01PYUkxNDM2N2x3R1Bzc3Ay?=
 =?utf-8?B?Kzc4d28zekNVQm12VUQ2S2crNXZ0QVQ4dS91MWlTQ25OL1djRmlGTHE2NFZY?=
 =?utf-8?B?MkJoendTMkd6aXUvSitpMWpxZ0YzUEE3TWF4SzNCTWd4S1d3Y0QvVWVXcGMy?=
 =?utf-8?B?MzN1Um8yUUxFazNDeVpCMWVIdzV0Q2lBMlhXZURxVkNCZ2VWUWZ0cksvUFZP?=
 =?utf-8?B?QVRoS0pBRE9ZMm9Wb3duZEhDaG9LWGlOYkJHT2FMeGhrbDBxTGl2Z2lSc1RG?=
 =?utf-8?B?bU5XTnB1SXdDeENUMGttWGt4VzhSZlRyRnBaeXE0R20vQnpnWERsWUV1U0RR?=
 =?utf-8?B?OXJBbGlKOWlwS1FWSEVhTXoxNHJBK0lUMVAzTFdHY3dvQTVzazNsTDlQZFRh?=
 =?utf-8?B?ZDZVaGUxaGFhNEhqTHRHalc5d1dLMStvVlVlVlNhL0NVZDlFZjNETXA3S1A2?=
 =?utf-8?B?bGF3UE83YmVjcVFiUXFidTNaand2QkRVZ0pzajF2NU44Mk5aeW1IZ0NUY1g3?=
 =?utf-8?B?VGM4VTFPNDB6UjEzdHZLd2FxM2k2V1J4UlB4L2lrK29lcjh5K0RFN2NOVW40?=
 =?utf-8?B?VFJRaUMwV2hKRmRKWWNveGoyZTZkcHFPKzRmb2hIM0wyUExtdXZMWmE0V0Jp?=
 =?utf-8?B?RXBtTDRmenVkR1hCT3lHT3MycTRoMEpqVk9vUmxwWXpvWWN5QzhjNUtEQ29I?=
 =?utf-8?B?OGxOMjhoa0twU295Ty9OZERXSWVqNEcxTW5ucGN1OVJCQUlxT0tUZkVTbW15?=
 =?utf-8?B?MmptMVBXUlgyTFNxSzV0QTM3bzB6TENoVTlhTWJlTU5SMmVHMEx2UnJkZUVG?=
 =?utf-8?B?NzczaC8rdmUyUmlOK0F3ZitNVisvbTNLZ2JHUlhNNTMycTRKbXAzOC9BMWZo?=
 =?utf-8?B?Vi90RURTMGNrNUp0VGxheE5YZnB5VFZzSmRJclFWY0hhQVRXSTZFOWVWdDlV?=
 =?utf-8?B?NmVoSGVCY3lXRDNQenV5OFdkSWFLd0hBMHJWU2ZBUERKSFlsOXkrWFFBUU9Y?=
 =?utf-8?B?T2FhRERjVjhwSWMxRk5lWUFYUStRalhaS2ZhWldabGtNN05yOFdqZ1pONnlw?=
 =?utf-8?B?a09rU3dWTC9wd2RSSFY0K0NmS2hKNHE1SDRRbFZPekF1bUxuMENMNUZiNCt2?=
 =?utf-8?B?akRSV2Z2WXdCWHlqYjFOcEFKR0hKbUw2Sy9rakFnbDNQYWpyN2lOckJnZXgy?=
 =?utf-8?B?elRmczE3bnNSNnZ5YlNjeXY2NzJZWmlsOURjQytrc3lYUExiamxPQ3hmZk5Z?=
 =?utf-8?B?ZkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F355000D38BAC648BA3168128B90E1E3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1f669b-37ed-4d27-62e0-08db39bd6e95
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 12:16:36.9515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H62WE1ERDeg+2A5isBtpvj3CRSQVn/iNS32oBElX8UBgIOZ86ztTk3S/RMu7BAfAapE+t0KYYSrrHLfuKiWhi7hELamfu5yiQPD6zq0xQCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6512
X-MTK:  N
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTG9pYywNCg0Kc29ycnkgZm9yIGxhdGUgcmVzcG9uc2UsIHBsZWFzZSBjaGVjayBmb2xsb3dp
bmcgcmVwbHkuDQoNCk9uIE1vbiwgMjAyMy0wMy0yMCBhdCAyMToyNiArMDgwMCwgWWFuY2hhbyBZ
YW5nIHdyb3RlOg0KPiBIaSBMb2ljLA0KPiANCj4gT24gRnJpLCAyMDIzLTAzLTE3IGF0IDEzOjM0
ICswMTAwLCBMb2ljIFBvdWxhaW4gd3JvdGU6DQo+ID4gSGkgWWFuY2hhbywNCj4gPiANCj4gPiBP
biBGcmksIDE3IE1hciAyMDIzIGF0IDA5OjEwLCBZYW5jaGFvIFlhbmcgPA0KPiA+IHlhbmNoYW8u
eWFuZ0BtZWRpYXRlay5jb20NCj4gPiA+IHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBSZWdpc3RlcnMg
dGhlIFRNSSBkZXZpY2UgZHJpdmVyIHdpdGggdGhlIGtlcm5lbC4gU2V0IHVwIGFsbCB0aGUNCj4g
PiA+IGZ1bmRhbWVudGFsDQo+ID4gPiBjb25maWd1cmF0aW9ucyBmb3IgdGhlIGRldmljZTogUENJ
ZSBsYXllciwgTW9kZW0gSG9zdCBDcm9zcyBDb3JlDQo+ID4gPiBJbnRlcmZhY2UNCj4gPiA+IChN
SENDSUYpLCBSZXNldCBHZW5lcmF0aW9uIFVuaXQgKFJHVSksIG1vZGVtIGNvbW1vbiBjb250cm9s
DQo+ID4gPiBvcGVyYXRpb25zIGFuZA0KPiA+ID4gYnVpbGQgaW5mcmFzdHJ1Y3R1cmUuDQo+ID4g
PiANCj4gPiA+ICogUENJZSBsYXllciBjb2RlIGltcGxlbWVudHMgZHJpdmVyIHByb2JlIGFuZCBy
ZW1vdmFsLCBNU0ktWA0KPiA+ID4gaW50ZXJydXB0DQo+ID4gPiBpbml0aWFsaXphdGlvbiBhbmQg
ZGUtaW5pdGlhbGl6YXRpb24sIGFuZCB0aGUgd2F5IG9mIHJlc2V0dGluZw0KPiA+ID4gdGhlDQo+
ID4gPiBkZXZpY2UuDQo+ID4gPiAqIE1IQ0NJRiBwcm92aWRlcyBpbnRlcnJ1cHQgY2hhbm5lbHMg
dG8gY29tbXVuaWNhdGUgZXZlbnRzIHN1Y2gNCj4gPiA+IGFzDQo+ID4gPiBoYW5kc2hha2UsDQo+
ID4gPiBQTSBhbmQgcG9ydCBlbnVtZXJhdGlvbi4NCj4gPiA+ICogUkdVIHByb3ZpZGVzIGludGVy
cnVwdCBjaGFubmVscyB0byBnZW5lcmF0ZSBub3RpZmljYXRpb25zIGZyb20NCj4gPiA+IHRoZSBk
ZXZpY2UNCj4gPiA+IHNvIHRoYXQgdGhlIFRNSSBkcml2ZXIgY291bGQgZ2V0IHRoZSBkZXZpY2Ug
cmVzZXQuDQo+ID4gPiAqIE1vZGVtIGNvbW1vbiBjb250cm9sIG9wZXJhdGlvbnMgcHJvdmlkZSB0
aGUgYmFzaWMgcmVhZC93cml0ZQ0KPiA+ID4gZnVuY3Rpb25zIG9mDQo+ID4gPiB0aGUgZGV2aWNl
J3MgaGFyZHdhcmUgcmVnaXN0ZXJzLCBtYXNrL3VubWFzay9nZXQvY2xlYXIgZnVuY3Rpb25zDQo+
ID4gPiBvZg0KPiA+ID4gdGhlDQo+ID4gPiBkZXZpY2UncyBpbnRlcnJ1cHQgcmVnaXN0ZXJzIGFu
ZCBpbnF1aXJ5IGZ1bmN0aW9ucyBvZiB0aGUNCj4gPiA+IGRldmljZSdzDQo+ID4gPiBzdGF0dXMu
DQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFlhbmNoYW8gWWFuZyA8eWFuY2hhby55YW5n
QG1lZGlhdGVrLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFRpbmcgV2FuZyA8dGluZy53YW5n
QG1lZGlhdGVrLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vS2NvbmZp
ZyAgICAgICAgICAgICAgICAgfCAgMTQgKw0KPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vTWFrZWZp
bGUgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0
ZWsvTWFrZWZpbGUgICAgICAgfCAgIDggKw0KPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0
ZWsvbXRrX2Rldi5oICAgICAgfCAyMDMgKysrKysrDQo+ID4gPiAgZHJpdmVycy9uZXQvd3dhbi9t
ZWRpYXRlay9wY2llL210a19wY2kuYyB8IDg4Nw0KPiA+ID4gKysrKysrKysrKysrKysrKysrKysr
KysNCj4gPiA+ICBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL3BjaWUvbXRrX3BjaS5oIHwgMTQ0
ICsrKysNCj4gPiA+ICBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL3BjaWUvbXRrX3JlZy5oIHwg
IDY5ICsrDQo+ID4gPiAgNyBmaWxlcyBjaGFuZ2VkLCAxMzI2IGluc2VydGlvbnMoKykNCj4gPiA+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9NYWtlZmlsZQ0K
PiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL210a19k
ZXYuaA0KPiA+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVr
L3BjaWUvbXRrX3BjaS5jDQo+ID4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3d3
YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmgNCj4gPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJp
dmVycy9uZXQvd3dhbi9tZWRpYXRlay9wY2llL210a19yZWcuaA0KPiA+ID4gDQo+ID4gDQo+ID4g
Wy4uLl0NCj4gPiANCj4gPiA+ICtzdGF0aWMgaW50IG10a19wY2lfZ2V0X3ZpcnFfaWQoc3RydWN0
IG10a19tZF9kZXYgKm1kZXYsIGludA0KPiA+ID4gaXJxX2lkKQ0KPiA+ID4gK3sNCj4gPiA+ICsg
ICAgICAgc3RydWN0IHBjaV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KG1kZXYtPmRldik7DQo+ID4g
PiArICAgICAgIGludCBuciA9IDA7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIGlmIChwZGV2LT5t
c2l4X2VuYWJsZWQpDQo+ID4gPiArICAgICAgICAgICAgICAgbnIgPSBpcnFfaWQgJSBtZGV2LT5t
c2lfbnZlY3M7DQo+ID4gPiArDQo+ID4gPiArICAgICAgIHJldHVybiBwY2lfaXJxX3ZlY3Rvcihw
ZGV2LCBucik7DQo+ID4gPiArfQ0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBpbnQgbXRrX3BjaV9y
ZWdpc3Rlcl9pcnEoc3RydWN0IG10a19tZF9kZXYgKm1kZXYsIGludA0KPiA+ID4gaXJxX2lkLA0K
PiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpbnQgKCppcnFfY2IpKGludCBp
cnFfaWQsIHZvaWQNCj4gPiA+ICpkYXRhKSwgdm9pZCAqZGF0YSkNCj4gPiA+ICt7DQo+ID4gPiAr
ICAgICAgIHN0cnVjdCBtdGtfcGNpX3ByaXYgKnByaXYgPSBtZGV2LT5od19wcml2Ow0KPiA+ID4g
Kw0KPiA+ID4gKyAgICAgICBpZiAodW5saWtlbHkoKGlycV9pZCA8IDAgfHwgaXJxX2lkID49IE1U
S19JUlFfQ05UX01BWCkgfHwNCj4gPiA+ICFpcnFfY2IpKQ0KPiA+ID4gKyAgICAgICAgICAgICAg
IHJldHVybiAtRUlOVkFMOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICBpZiAocHJpdi0+aXJxX2Ni
X2xpc3RbaXJxX2lkXSkgew0KPiA+ID4gKyAgICAgICAgICAgICAgIGRldl9lcnIobWRldi0+ZGV2
LA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgIlVuYWJsZSB0byByZWdpc3RlciBpcnEs
IGlycV9pZD0lZCwgaXQncw0KPiA+ID4gYWxyZWFkeSBiZWVuIHJlZ2lzdGVyIGJ5ICVwcy5cbiIs
DQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICBpcnFfaWQsIHByaXYtPmlycV9jYl9saXN0
W2lycV9pZF0pOw0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUZBVUxUOw0KPiA+ID4g
KyAgICAgICB9DQo+ID4gPiArICAgICAgIHByaXYtPmlycV9jYl9saXN0W2lycV9pZF0gPSBpcnFf
Y2I7DQo+ID4gPiArICAgICAgIHByaXYtPmlycV9jYl9kYXRhW2lycV9pZF0gPSBkYXRhOw0KPiA+
IA0KPiA+IFNvIGl0IGxvb2tzIGxpa2UgeW91IHJlLWltcGxlbWVudCB5b3VyIG93biBpcnEgY2hp
cCBpbnRlcm5hbGx5Lg0KPiA+IFdoYXQNCj4gPiBhYm91dCBjcmVhdGluZyBhIG5ldyBpcnEtY2hp
cC9kb21haW4gZm9yIHRoaXMgKGNmDQo+ID4gaXJxX2RvbWFpbl9hZGRfc2ltcGxlKT8NCj4gPiBU
aGF0IHdvdWxkIGFsbG93IHRoZSBjbGllbnQgY29kZSB0byB1c2UgdGhlIHJlZ3VsYXIgaXJxIGlu
dGVyZmFjZQ0KPiA+IGFuZA0KPiA+IGhlbHBlcnMNCj4gPiBhbmQgaXQgc2hvdWxkIHNpbXBseSBj
b2RlIGFuZCBpbXByb3ZlIGl0cyBkZWJ1Z2dhYmlsaXR5DQo+ID4gKC9wcm9jL2lycS4uLikuDQo+
IA0KPiBXZSB3aWxsIGNoZWNrIGl0IGFuZCB1cGRhdGUgeW91IGxhdGVyLg0KTm8sIHdlIGRvbuKA
mXQgcmUtaW1wbGVtZW50IGlycSBjaGlwLiBBZnRlciBzdHVkeWluZyB0aGUgaXJxX2RvbWFpbg0K
aW50ZXJmYWNlIHlvdSBzdWdnZXN0LCB0aGUgVE1JIGRyaXZlciBsZXZlcmFnZXMgb24gTVNJIGly
cSBkb21haW4uIFdlDQp1c2UgcGNpX2FsbG9jX2lycV92ZWN0b3JzIHRvIGFsbG9jYXRlIE1TSS1Y
IGlycSBkZXNjIGFuZCB1c2UNCnBjaV9yZXF1ZXN0X2lycSB0byBiaW5kIGludGVycnVwdCBzb3Vy
Y2VzIHdpdGggaXJxIGhhbmRsZXJzLg0KPiA+IA0KPiA+IFsuLi5dDQo+ID4gDQo+ID4gPiArc3Rh
dGljIGludCBtdGtfbWhjY2lmX3JlZ2lzdGVyX2V2dChzdHJ1Y3QgbXRrX21kX2RldiAqbWRldiwg
dTMyDQo+ID4gPiBjaHMsDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IGludCAoKmV2dF9jYikodTMyIHN0YXR1cywgdm9pZA0KPiA+ID4gKmRhdGEpLCB2b2lkICpkYXRh
KQ0KPiA+ID4gK3sNCj4gPiA+ICsgICAgICAgc3RydWN0IG10a19wY2lfcHJpdiAqcHJpdiA9IG1k
ZXYtPmh3X3ByaXY7DQo+ID4gPiArICAgICAgIHN0cnVjdCBtdGtfbWhjY2lmX2NiICpjYjsNCj4g
PiA+ICsgICAgICAgdW5zaWduZWQgbG9uZyBmbGFnOw0KPiA+ID4gKyAgICAgICBpbnQgcmV0ID0g
MDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgaWYgKCFjaHMgfHwgIWV2dF9jYikNCj4gPiA+ICsg
ICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiA+ICsNCj4gPiA+ICsgICAgICAgc3Bp
bl9sb2NrX2lycXNhdmUoJnByaXYtPm1oY2NpZl9sb2NrLCBmbGFnKTsNCj4gPiANCj4gPiBXaHkg
c3BpbmxvY2sgaGVyZSBhbmQgbm90IG11dGV4LiBBRkFJVSwgeW91IGFsd2F5cyB0YWtlIHRoaXMg
bG9jaw0KPiA+IGluDQo+ID4gYQ0KPiA+IG5vbi1hdG9taWMvcHJvY2VzcyBjb250ZXh0Lg0KPiAN
Cj4gQ3VycmVudGx5LCB0aGUgZnVuY3Rpb24gaXMgb25seSBjYWxsZWQgaW4gdGhlIEZTTSBpbml0
aWFsaXphdGlvbiBhbmQNCj4gUE0ocG93ZXIgbWFuYWdlbWVudCkgaW5pdGlhbGl6YXRpb24gcHJv
Y2Vzcy4gQm90aCBhcmUgYXRvbWljLg0KPiBPbiB0aGUgb3RoZXIgaGFuZCwgdGhpcyByZWdpc3Ry
YXRpb24gZnVuY3Rpb24gd2lsbCBvcGVyYXRlIHRoZSBnbG9iYWwNCj4gdmFyaWFibGVzIOKAnG1o
Y2NpZl9jYl9saXN04oCdLCBidXQgaXQgdGFrZXMgdmVyeSBsaXR0bGUgdGltZS4gU28sIHdlDQo+
IHRoaW5rDQo+IHNwaW5sb2NrIGlzIHByZWZlcnJlZC4NCkFueSBpZGVhcyBvciBjb21tZW50cyBm
b3IgdGhpcz8gUGxlYXNlIGhlbHAgc2hhcmUgaXQgYXQgeW91cg0KY29udmVuaWVuY2UuDQo+IA0K
PiA+IA0KPiA+ID4gKyAgICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5KGNiLCAmcHJpdi0+bWhjY2lm
X2NiX2xpc3QsIGVudHJ5KSB7DQo+ID4gPiArICAgICAgICAgICAgICAgaWYgKGNiLT5jaHMgJiBj
aHMpIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IC1FRkFVTFQ7DQo+ID4g
PiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKG1kZXYtPmRldiwNCj4gPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIlVuYWJsZSB0byByZWdpc3RlciBldnQsDQo+ID4g
PiBjaHM9MHglMDhYJjB4JTA4WCByZWdpc3RlcmVkX2NiPSVwc1xuIiwNCj4gPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgY2hzLCBjYi0+Y2hzLCBjYi0+ZXZ0X2NiKTsNCj4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyOw0KPiA+ID4gKyAgICAgICAgICAgICAg
IH0NCj4gPiA+ICsgICAgICAgfQ0KPiA+ID4gKyAgICAgICBjYiA9IGRldm1fa3phbGxvYyhtZGV2
LT5kZXYsIHNpemVvZigqY2IpLCBHRlBfQVRPTUlDKTsNCj4gPiA+ICsgICAgICAgaWYgKCFjYikg
ew0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldCA9IC1FTk9NRU07DQo+ID4gPiArICAgICAgICAg
ICAgICAgZ290byBlcnI7DQo+ID4gPiArICAgICAgIH0NCj4gPiA+ICsgICAgICAgY2ItPmV2dF9j
YiA9IGV2dF9jYjsNCj4gPiA+ICsgICAgICAgY2ItPmRhdGEgPSBkYXRhOw0KPiA+ID4gKyAgICAg
ICBjYi0+Y2hzID0gY2hzOw0KPiA+ID4gKyAgICAgICBsaXN0X2FkZF90YWlsKCZjYi0+ZW50cnks
ICZwcml2LT5taGNjaWZfY2JfbGlzdCk7DQo+ID4gPiArDQo+ID4gPiArZXJyOg0KPiA+ID4gKyAg
ICAgICBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwcml2LT5taGNjaWZfbG9jaywgZmxhZyk7DQo+
ID4gPiArDQo+ID4gPiArICAgICAgIHJldHVybiByZXQ7DQo+ID4gPiArfQ0KPiA+IA0KPiA+IFsu
Li5dDQo+ID4gDQo+ID4gPiArDQo+ID4gPiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiA+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmgNCj4g
PiA+IGIvZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9wY2llL210a19wY2kuaA0KPiA+ID4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYjQ4N2NhOWIzMDJl
DQo+ID4gPiAtLS0gL2Rldi9udWxsDQo+ID4gPiArKysgYi9kcml2ZXJzL25ldC93d2FuL21lZGlh
dGVrL3BjaWUvbXRrX3BjaS5oDQo+ID4gDQo+ID4gV2h5IGEgc2VwYXJhdGVkIGhlYWRlciBmaWxl
LCBpc24ndCB0aGUgY29udGVudCAoZS5nLiBtdGtfcGNpX3ByaXYpDQo+ID4gdXNlZCBvbmx5IGZy
b20gbXRrX3BjaS5jPw0KPiANCj4gRG8geW91IG1lYW4gdGhhdCB3ZSBzaG91bGQgbW92ZSBhbGwg
Y29udGVudHMgb2Yg4oCcbXRrX3BjaS5o4oCdIGludG8NCj4g4oCcbXRrX3BjaS5j4oCdIGRpcmVj
dGx5PyBUaGUg4oCcbXRrX3BjaS5o4oCdIHNlZW1zIHRvIGJlIHJlZHVuZGFudCwgcmlnaHQ/DQpB
bnkgaWRlYXMgb3IgY29tbWVudHMgZm9yIHRoaXM/IFBsZWFzZSBoZWxwIHNoYXJlIGl0IGF0IHlv
dXINCmNvbnZlbmllbmNlLg0KPiANCj4gPiANCj4gPiA+IEBAIC0wLDAgKzEsMTQ0IEBADQo+ID4g
PiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEJTRC0zLUNsYXVzZS1DbGVhcg0KPiA+ID4g
KyAqDQo+ID4gPiArICogQ29weXJpZ2h0IChjKSAyMDIyLCBNZWRpYVRlayBJbmMuDQo+ID4gPiAr
ICovDQo+ID4gPiArDQo+ID4gPiArI2lmbmRlZiBfX01US19QQ0lfSF9fDQo+ID4gPiArI2RlZmlu
ZSBfX01US19QQ0lfSF9fDQo+ID4gPiArDQo+ID4gPiArI2luY2x1ZGUgPGxpbnV4L3BjaS5oPg0K
PiA+ID4gKyNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPg0KPiA+ID4gKw0KPiA+ID4gKyNpbmNs
dWRlICIuLi9tdGtfZGV2LmgiDQo+ID4gPiArDQo+ID4gPiArZW51bSBtdGtfYXRyX3R5cGUgew0K
PiA+ID4gKyAgICAgICBBVFJfUENJMkFYSSA9IDAsDQo+ID4gPiArICAgICAgIEFUUl9BWEkyUENJ
DQo+ID4gPiArfTsNCj4gPiANCj4gPiBbLi4uXQ0KPiA+IA0KPiA+IFJlZ2FyZHMsDQo+ID4gTG9p
Yw0KPiANCj4gTWFueSB0aGFua3MuDQo+IFlhbmNoYW8uWWFuZw0KDQpCVFcsIGNhbiB5b3UgaGVs
cCBjaGVjayBvdGhlciBwYXRjaGVzIGFuZCBzaGFyZSB5b3VyIHN1Z2dlc3Rpb25zPw0KDQpNYW55
IHRoYW5rcy4NCllhbmNoYW8uWWFuZw0K
