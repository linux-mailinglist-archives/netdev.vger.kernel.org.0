Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D015615BCA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 06:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiKBF1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 01:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKBF1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 01:27:17 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E40C248EB;
        Tue,  1 Nov 2022 22:27:15 -0700 (PDT)
X-UUID: 8290a26b14ea466da43bf2bbb4db4b4c-20221102
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fRITEL96tSVeLU5kub1ZOyi1hyhcZ5AxFSehq80q4Ys=;
        b=YO4G5cAYHWeepyMJUD1Mo93OfeqJ/UneG284uoCpn+nluQCGiEAIchpFM8rRLqwGdFujhol4zb6AKBx/RPIM/6yStCDPBsrl3wCoANQS5F55fKLcferrIVBmiBLxshl54vndsqUsiqm8DLg9WAZY1SzE0HtA8zhU3XQPYrPofYc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:a994a052-7612-45c3-8e85-d7fdd99e8902,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:1
X-CID-INFO: VERSION:1.1.12,REQID:a994a052-7612-45c3-8e85-d7fdd99e8902,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:1,FILE:0,BULK:0,RULE:Release_Ham,ACTION:re
        lease,TS:1
X-CID-META: VersionHash:62cd327,CLOUDID:57f62beb-84ac-4628-a416-bc50d5503da6,B
        ulkID:221102132713H7YBEM7B,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 8290a26b14ea466da43bf2bbb4db4b4c-20221102
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1186123767; Wed, 02 Nov 2022 13:27:12 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 2 Nov 2022 13:27:11 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 2 Nov 2022 13:27:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Um3SswKk19Hcw0oRVBUoGvw3yFYUEBAYwhBQ6b8okAj7lYqH1NAMUwIhha4sn4jIzGQ+lkfyua5NoW853rR63w7A1KnDGWG9PpHTl/xPjbXcaVZVipBMbl+RIzn1F6uEikIt52A+hmjn5v0Vz4YpRgMU8RIuLOtBqzO2ZChfG82yMm5ryn9NNblSMdtLSBN/fh8L5n5nbC8+3Ky8KUvDAN7AKN3jgG5kBAMPu6dJYcKSCvLsCP1nS4F4L2jfQ99EKQftGONPo3VSgNInMbBACmar8Mz7G55plLMUY8fTCuwMbbSmG+b3J6uj4LEBXi13ly5GyMoMFu9UA5R43ka86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fRITEL96tSVeLU5kub1ZOyi1hyhcZ5AxFSehq80q4Ys=;
 b=IoG67c/hKa9nlfGT6W/HVVz0y4ujPiXoF/Olt6/VoUSXxod8eJ7+Glu3YcXyxzJ+Hb6N+sktFyr387spbdxRb1yoWaokOAQF3KO/C7I5XgO/1gRE3MFkDx7Blxkiq4Rsi6lgEKxMaLG9lXOScGk42LcardPoF4gCV6w4SyoqIEp5tZ0wgpi2qGKVhunTg94QAOJ2vTzsrdK39iLI18g7tm8NRTvZdfAZItm0i9hA84pUdxt3NxdVpuBe5h/6st9fmui41zDtCfz+hFfpekgxUeWslrr/xlo3rfN06dpOdEHlhiGKuksh/chhVJT7clx+omLu5oU91nd05J7rId3OIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fRITEL96tSVeLU5kub1ZOyi1hyhcZ5AxFSehq80q4Ys=;
 b=LAH5w3aktORC/CYDTcYyvPYgky2YkpkTVLwj3eE859cQQuWgxd4O9QGN35K3XB1Ny8sWk/bJOx1LWgdihXgb5LY2nKecbeiScOaNYgrC5df+7hR78XXXyuU9SJt/4laAQfUU93SWK8vtsJzmLvTG8CF/GxcDFr2DtQKQPY7OahM=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by KL1PR0302MB5283.apcprd03.prod.outlook.com (2603:1096:820:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.17; Wed, 2 Nov
 2022 05:27:08 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6%9]) with mapi id 15.20.5791.017; Wed, 2 Nov 2022
 05:27:08 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     "loic.poulain@linaro.org" <loic.poulain@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>
Subject: Re: [PATCH] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Topic: [PATCH] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Index: AQHY6Nh95ZC9QMr6OU2rT6GQPCNuca4gR4aAgADNu4D//6dKgIABPEEAgAMPhYCABh19gA==
Date:   Wed, 2 Nov 2022 05:27:07 +0000
Message-ID: <fc0793c2e87d1944780a243258328cd148088c01.camel@mediatek.com>
References: <20221026011540.8499-1-haozhe.chang@mediatek.com>
         <CAMZdPi_XSWeTf-eP+O2ZXGXtn5yviEp=p1Q0rs_fG76UGf2FsQ@mail.gmail.com>
         <82a7acf3176c90d9bea773bb4ea365745c1a1971.camel@mediatek.com>
         <CAMZdPi_tTBgqSGCUaB29ifOUSE5nWa6ooOa=4k8T6pXJDfpO-A@mail.gmail.com>
         <3abbe6ea016b865b6762708fe8234913884a0ed5.camel@mediatek.com>
         <CAMZdPi-LCzrzM1eGsA_mKH-GZ1LgYXQqs4k8r=8gQAC3BRUFNg@mail.gmail.com>
In-Reply-To: <CAMZdPi-LCzrzM1eGsA_mKH-GZ1LgYXQqs4k8r=8gQAC3BRUFNg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|KL1PR0302MB5283:EE_
x-ms-office365-filtering-correlation-id: c25aa920-99aa-4917-90c0-08dabc92e2a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aCf6aJSi28UES+JaAHW0J9YSwF2iNqjFn97dtR9OkeTmImf/l/7o/A7U9wJjH+v/vpPcwknXr/fQ1SDPDm9Y/ODTd7s0fHoQAImgCfKulvjtAjVGHM4h3Qdzb3yMvVo02hPFRKUpeJfjVvPMQfDPnL2m0DL9Wz3VqBKCzUdQjzi/6S9D3/nT36oOajb5TXagx5j8XmtnwcH9VVHQi4mxJPPy9+Xur3lvDYjmdWH0rXQHr+0g+W3M+5wgbaSldTTjDC+Wz9N/zkI9cChPpvFbeICCJkjUgFA4zZ8HiI0z8ltTDykx3U4Q+pm498DfCMg+bhCjnIqoK/LlvW3G8HfuvopFpMLfqEKvMxZP+RD+GMoyZGAkfUjM/ZdDN3lyUM4DzqTXbw5/jOn3MTALamdjdUcKuQSwmqKsm4Jhnn+eD5r7Ew2ybKIlnbIQPFppMBbq3GFIETo94+8wUy/UatBgq/NUXUJkMsPzQwVfw0q5tVY8DAeqx4MtHcygBhZne3XJ6d1+aReNM3EyvdbsvmM0kceuHtFQjDuysWIRmFJdmPTnZsnUgVfV5IQyngNmtX0ykJ8dx9Mk0KbCtDbsexzqyEbcXtHrLoT9h68w0BoYBt1/poKeS7PkJUmMoRry5bcROHfyC6Q3lc92xsnUHpc39KLyY+qzveIpoo0OtFxpbNCK8zGnlMgd7SjObNvdqRYx4b7pM+fSiSvoSOMvT7ENPnAzF/MudjiC2XIhUyyZhu95CJWnrq6arSOxtIptVEH+qDgRncvJ8dVZeH4EZVeOmqldNgq5yxOW/Dgm3ozb6haAlW+4hQHzzGd1Vkqh70eAeumvGEdRmu13g0zTDiBG6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(85182001)(36756003)(316002)(71200400001)(7416002)(122000001)(38100700002)(38070700005)(86362001)(83380400001)(2616005)(186003)(478600001)(26005)(6512007)(6506007)(6486002)(107886003)(5660300002)(6916009)(4001150100001)(2906002)(64756008)(41300700001)(66476007)(76116006)(8936002)(54906003)(66446008)(4326008)(66556008)(66946007)(91956017)(8676002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGdTQzlGbXFpdVowcVBTeE1IUTUvWEVCOENQT1NwY0VTcmVURUoxQWJLRUVH?=
 =?utf-8?B?N1lZbHpnaU40czEwL1pmbXFrWjNaNUxmN3FDOEp5VlkwbG9UQTB6N3hkb3F1?=
 =?utf-8?B?N1RFdUFpN2Q4dk9SVjU0MnZFMkxtNks4am9rRmdEcVZyTmlnVG1VOTBuMnZB?=
 =?utf-8?B?UEFBT2NpMS9wRHMwV3Jpbk05NVJCYkh1YWxsZndoS040ejJ2M01yUDRCeHZj?=
 =?utf-8?B?YU1FUUJBY3pzc1ZNTmptSVdxK1crNUJUOU5sWkdNKzA0MXI3UnBGU0kzTzN6?=
 =?utf-8?B?cEhWYmg2QWZSZTFuVG5Td0FLc2UzS3RuZU8wM3NKdkJ6TmpBaTQ1bGFWakhK?=
 =?utf-8?B?ZEliT2dmc2NRaHJVQjZlUTZJYitZN2VEOGdldmduelZYRFVFMTZTUk9IN0Vm?=
 =?utf-8?B?ZnloL2xvVjBsWHV4RmtpN2NtOGRMSHUzQk4rd3ZXMDIyS3VmTHVOeFNQaS95?=
 =?utf-8?B?N2tVdVdJYTJlZ0dhL1EzZEdyWWhtK3JoWnpFT1VYMG8vcjExbTF0NUhiN2NQ?=
 =?utf-8?B?RnFxdkxjTHl3Sk9FazhpUmUyOU43d21QZEMrMW8yaXFKYThuaDY3M3dOZDFF?=
 =?utf-8?B?emZzQmFuWmhSMkRqTGdxU0pEaUJ5WHdXcVlzMGxiMEdmYkJNUG81NURERHVh?=
 =?utf-8?B?UVpwV1IwNC8rY0xZbHYrU1RWT0pPNStvbEpvVEh0YjVteE1Idkx0TmFPTHMw?=
 =?utf-8?B?emRpVlhIWjdtUnlHSnE0Q1lxTzVFdWppQzFHcnVwRWVTYnNjYXgvS1lidWto?=
 =?utf-8?B?eVdZVkNMTk9YQjgySVE1N2ZXci9uSnhBMjZKNy9TVEFmOHNpcVlJVVNWdjk4?=
 =?utf-8?B?czYzTjcwVWRBSGZXemVQcUduMnptWnVCYlRRZ3I3bFM1UlE4MEFyeDdYMkNx?=
 =?utf-8?B?cHJBVmYwVEkwMnV1eVk4V3lCb0JMekJWajBEOTh4ZzZ4ZFRRSmtMWmxaQkRD?=
 =?utf-8?B?WCtlVGZEVzdUYzdMUmx1NnpxQUpEcnFlWEkyWk5FMmhZbC95WWkxbmg2UGo0?=
 =?utf-8?B?eWpNOW5oUkVVaWp1T1JkdzRrMDRPWk84SUVURFZvSjl3YWY0QkE5VCtuYWU1?=
 =?utf-8?B?aG0ydFE3M0t0SVY0S09uaDBLc2NqS1Jzbk5uVzBmcmRaY2NKSk9BSSs2Umtk?=
 =?utf-8?B?b3dNWEJVanpqaE9RSWl6cnBpQlJIMDYvUlBEOU00UjZjL1YvbStFNHYwb1VT?=
 =?utf-8?B?YzRzVlNwUG16c2NYM3FnVXlacDVoNml1YXVpM0xQYlFSTEFLSFZEZkJOVHF0?=
 =?utf-8?B?TThROFY3QTVEbmVGOCtOazQ3bmpaaCt4WFhDVFU3NlNTTXlXRnZ1YS82MFE2?=
 =?utf-8?B?empSVU5sdGhpQzBKclJ5dE43MTZzL2QvRElRYU9wUytVMVd1OXEzRGcwZmtn?=
 =?utf-8?B?OTIyRTBBa1dQTVJCeHVZbWhXS2M5NFNPcnJvQTQyZ0QwY1B3NStTT2JCOVpE?=
 =?utf-8?B?cnloc09zUDJnNjF5TVVya3Ryamp6SjJYQ3RJZWJqU0R5eVd4UnVRZis3eXFa?=
 =?utf-8?B?ODFHaEdPbGZPTjBDZ1ZGaHM1N2pQWUZ6NCtIR01HYXFFcVluR2tzWW1mdkFp?=
 =?utf-8?B?ZEVRbENJVlg4TFFzaFdqR3lIdjN5WE8vSVdyWUVvUFdCTzdEZlNzUmgyZmc1?=
 =?utf-8?B?a1k0cEtUdDhLNWgzeG5qSEJpdFRTUTErcVhjekdyR2Z3RFZ1UVJGbnJuK0N5?=
 =?utf-8?B?aUtxdWQ4K1hsd1hZc1NINEoxbkU4N3JGRDU2VmJ3SlRQbEl2VFA4T2xuWWhr?=
 =?utf-8?B?bzlRWlZOZk1VWnZ6MTBrZHZiclUzTHNYS1VXQVAzeEhmY05ESDZZa0ZRYzhD?=
 =?utf-8?B?eGxpUmQvNDNNbTc4YWkrVWRiaVV2SWUrUkNsa1NzRU90NlNEbHNROHNQS1hI?=
 =?utf-8?B?b0U1MFNsaitiZk1Td2FWcnN2T3Ircm5zOEl0RHR4WVVUOEdRK0YyZUZnSjUx?=
 =?utf-8?B?T0xJZzBkbjBXQ25nY3FqMGpycVd4MFhXS1c3V1VIRzJZeFQwS3J1QXcreFFH?=
 =?utf-8?B?TXBPYlJ3OUhNdk5IUHBOb1hjQWVLLzJablRwWVd1ZlFYZUlFcjVaQmF3SW9o?=
 =?utf-8?B?bG5wemRZY204N3pMQ3lDL3Ewd0VWaks2bnhHNlBnbmtHdXJTSkZTem1PTE1u?=
 =?utf-8?B?aHp1R0tDMkV2YUFHWGVoWWVGQyt1S21aeGNjYmk2LytXY1l0T0UycjR3K1VM?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F8E9D421F2EDBE46998264E2C648D85E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c25aa920-99aa-4917-90c0-08dabc92e2a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2022 05:27:08.0135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uub8eDCRN42XXe9ZD1StbOeSarSEreLGUYJndrzqYhouxVTCBfs7yOYsWcurulFqzYSMhho6JatxciAr6iOIj9CguD7FHozrlbrPUv22VuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0302MB5283
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIyLTEwLTI5IGF0IDEwOjA0ICswMjAwLCBMb2ljIFBvdWxhaW4gd3JvdGU6DQo+
IE9uIFRodSwgMjcgT2N0IDIwMjIgYXQgMDM6MTksIGhhb3poZSBjaGFuZyA8aGFvemhlLmNoYW5n
QG1lZGlhdGVrLmNvbQ0KPiA+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFdlZCwgMjAyMi0xMC0yNiBh
dCAyMjoyNyArMDgwMCwgTG9pYyBQb3VsYWluIHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyNiBPY3Qg
MjAyMiBhdCAxMzo0NSwgaGFvemhlIGNoYW5nIDwNCj4gPiA+IGhhb3poZS5jaGFuZ0BtZWRpYXRl
ay5jb20NCj4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+IA0KPiA+ID4gPiBPbiBXZWQsIDIwMjItMTAt
MjYgYXQgMTU6MjggKzA4MDAsIExvaWMgUG91bGFpbiB3cm90ZToNCj4gPiA+ID4gPiBIaSBIYW96
aGUsDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gV2VkLCAyNiBPY3QgMjAyMiBhdCAwMzoxNiwg
PGhhb3poZS5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+IEZyb206IGhhb3poZSBjaGFuZyA8aGFvemhlLmNoYW5nQG1lZGlhdGVr
LmNvbT4NCj4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gd3dhbl9wb3J0X2ZvcHNfd3JpdGUgaW5w
dXRzIHRoZSBTS0IgcGFyYW1ldGVyIHRvIHRoZSBUWA0KPiA+ID4gPiA+ID4gY2FsbGJhY2sgb2YN
Cj4gPiA+ID4gPiA+IHRoZSBXV0FOIGRldmljZSBkcml2ZXIuIEhvd2V2ZXIsIHRoZSBXV0FOIGRl
dmljZSAoZS5nLiwNCj4gPiA+ID4gPiA+IHQ3eHgpDQo+ID4gPiA+ID4gPiBtYXkNCj4gPiA+ID4g
PiA+IGhhdmUgYW4gTVRVIGxlc3MgdGhhbiB0aGUgc2l6ZSBvZiBTS0IsIGNhdXNpbmcgdGhlIFRY
DQo+ID4gPiA+ID4gPiBidWZmZXIgdG8NCj4gPiA+ID4gPiA+IGJlDQo+ID4gPiA+ID4gPiBzbGlj
ZWQgYW5kIGNvcGllZCBvbmNlIG1vcmUgaW4gdGhlIFdXQU4gZGV2aWNlIGRyaXZlci4NCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBUaGUgYmVuZWZpdCBvZiBwdXR0aW5nIGRhdGEgaW4gYW4gc2tiIGlz
IHRoYXQgaXQgaXMgZWFzeSB0bw0KPiA+ID4gPiA+IG1hbmlwdWxhdGUsIHNvIG5vdCBzdXJlIHdo
eSB0aGVyZSBpcyBhbiBhZGRpdGlvbmFsIGNvcHkgaW4NCj4gPiA+ID4gPiB0aGUNCj4gPiA+ID4g
PiBmaXJzdA0KPiA+ID4gPiA+IHBsYWNlLiBJc24ndCBwb3NzaWJsZSBmb3IgdGhlIHQ3eHggZHJp
dmVyIHRvIGNvbnN1bWUgdGhlIHNrYg0KPiA+ID4gPiA+IHByb2dyZXNzaXZlbHkgKHdpdGhvdXQg
aW50ZXJtZWRpYXRlIGNvcHkpLCBhY2NvcmRpbmcgdG8gaXRzDQo+ID4gPiA+ID4gb3duDQo+ID4g
PiA+ID4gTVRVDQo+ID4gPiA+ID4gbGltaXRhdGlvbj8NCj4gPiA+ID4gPiANCj4gPiA+ID4gDQo+
ID4gPiA+IHQ3eHggZHJpdmVyIG5lZWRzIHRvIGFkZCBtZXRhZGF0YSB0byB0aGUgU0tCIGhlYWQg
Zm9yIGVhY2gNCj4gPiA+ID4gZnJhZ21lbnQsIHNvDQo+ID4gPiA+IHRoZSBkcml2ZXIgaGFzIHRv
IGFsbG9jYXRlIGEgbmV3IGJ1ZmZlciB0byBjb3B5DQo+ID4gPiA+IGRhdGEoc2tiX3B1dF9kYXRh
KQ0KPiA+ID4gPiBhbmQNCj4gPiA+ID4gaW5zZXJ0IG1ldGFkYXRhLg0KPiA+ID4gDQo+ID4gPiBO
b3JtYWxseSwgb25jZSB0aGUgZmlyc3QgcGFydCAoY2h1bmspIG9mIHRoZSBza2IgaGFzIGJlZW4N
Cj4gPiA+IGNvbnN1bWVkDQo+ID4gPiAoc2tiX3B1bGwpIGFuZCB3cml0dGVuIHRvIHRoZSBkZXZp
Y2UsIGl0IHdpbGwgYmVjb21lIHBhcnQgb2YgdGhlDQo+ID4gPiBza2IgaGVhZHJvb20sIHdoaWNo
IGNhbiB0aGVuIGJlIHVzZWQgZm9yIGFwcGVuZGluZyAoc2tiX3B1c2gpIHRoZQ0KPiA+ID4gaGVh
ZGVyIChtZXRhZGF0YSkgb2YgdGhlIHNlY29uZCBjaHVua3MsIGFuZCBzby4uLiByaWdodD8NCj4g
PiA+IA0KPiA+ID4gSnVzdCB3YW50IHRvIGF2b2lkIGEgYnVuY2ggb2YgdW5uZWNlc3NhcnkgY29w
eS9hbGxvYyBoZXJlLg0KPiA+ID4gDQo+ID4gDQo+ID4gdDd4eCBETUEgY2FuIHRyYW5zZmVyIG11
bHRpcGxlIGZyYWdtZW50cyBhdCBvbmNlLCBpZiBkb25lIGFzDQo+ID4gcmVjb21lbmRlZCwgdGhl
IERNQSBwZXJmb3JtYW5jZSB3aWxsIGJlIGluaGliaXRlZC4NCj4gDQo+IE9LLCBzbyB0aGUgc2ti
IGZyYWdtZW50YXRpb24gaXMgdmFsaWQgaW4gdDd4eCBjYXNlLCBidXQgdGhlIHdheSBvZg0KPiBk
b2luZyBpdCBpcyBraW5kIG9mIHNwZWNpZmljIHRvIHQ3eHguIE1heWJlIGEgbW9yZSBhY2NlcHRh
YmxlDQo+IHNvbHV0aW9uDQo+IGZvciBhIGdlbmVyaWMgZnJhZ21lbnRhdGlvbiBmZWF0dXJlIHdv
dWxkIGJlIHRvIGtlZXAgdGhlIGV4dHJhDQo+IGZyYWdtZW50cyBwYXJ0IG9mIHRoZSAnbWFpbicg
c2tiLCB1c2luZyBza2IgY2hhaW5pbmcuIFRoYXQgd291bGQNCj4gYWxsb3cNCj4gdGhlIGZyYWdt
ZW50cyB0byBzdGF5IGxpbmtlZCB0byBhIHNwZWNpZmljIHVzZXIgdHJhbnNmZXIuIFNvIGlmDQo+
IGZyYWdtZW50YXRpb24gaXMgZW5hYmxlZCBmb3IgYSBnaXZlbiBkcml2ZXIsIGNvcmUgb25seSBm
aWxscyB0aGUNCj4gaW5pdGlhbCBza2Igd2l0aCBNVFUgc2l6ZSwgYW5kIGFwcGVuZHMgYWRkaXRp
b25hbCBza2IgYXMgZnJhZ21lbnRzLA0KPiB5b3UgY2FuIGxvb2sgYXQgbWhpX25ldF9za2JfYWdn
KCkgZm9yIHNrYiBjaGFpbmluZyBleGFtcGxlLg0KPiANCk9LLCBJdCBpcyBhIGdvb2Qgc3VnZ2Vz
dGlvbiwgSSB3aWxsIGltcGxlbWVudCBpdCBpbiBwYXRjaCB2Mi4gQWxzbywgYW55DQphZHZpY2Ug
b24gcmVzZXJ2ZWQgaGVhZHJvb20/DQo+IFJlZ2FyZHMsDQo+IExvaWMNCg==
