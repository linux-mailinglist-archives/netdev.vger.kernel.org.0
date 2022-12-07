Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8846464A8
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 00:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLGXA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 18:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLGXA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 18:00:57 -0500
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2AF17BC3E;
        Wed,  7 Dec 2022 15:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1670454056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tzxusobkMnozhNQd63olUUZOBScuP1brmk1e3vK3Guo=;
  b=ZRLitdneIQKFvkh4gxhmvWqxDAhgzHTKZSCo/lr9i+VvDuDaFDwHq8Xw
   /S/yMkuxEnoKH8tB3nJ3xZZs3/lBHa7TmnlCHQOfAQrPYwQxzH+pw6/DL
   Wq5mXKpuR3pe3M7g0aRW25C0sDZToTzrxzUDeYDwIhEBTcYlOI07sLkMr
   k=;
X-IronPort-RemoteIP: 104.47.73.47
X-IronPort-MID: 86161264
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:o/IhF6uC9NqMcjWr9P0ZKT5xvufnVLhfMUV32f8akzHdYApBsoF/q
 tZmKWzXb6mLazb9L9h3YY6z8EhQscODztAxTVQ4rC03Rn4W+JbJXdiXEBz9bniYRiHhoOCLz
 O1FM4Wdc5pkJpP4jk3wWlQ0hSAkjclkfpKlVKiffHg0HVU/IMsYoUoLs/YjhYJ1isSODQqIu
 Nfjy+XSI1bg0DNvWo4uw/vrRChH4bKj5lv0gnRkPaoR5QWGyCFPZH4iDfrZw0XQE9E88tGSH
 44v/JnhlkvF8hEkDM+Sk7qTWiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JFAatjsB2bnsgZ9
 Tl4ncfYpTHFnEH7sL91vxFwS0mSNEDdkVPNCSDXXce7lyUqf5ZwqhnH4Y5f0YAwo45K7W9yG
 fMwCDNRSCC/l9qK2OilGvNCp/1/deW1BdZK0p1g5Wmx4fcOZ7nmG/mPyfoGmTA6i4ZJAOrUY
 NcfZXx3dhPcbhZTO1ARTpUjgOOvgXq5eDpdwL6XjfNvvy6Pk0oui/6xb7I5efTTLSlRtm+eq
 njL4CLSBRYCOcbE4TGE7mitlqnEmiaTtIc6ROPhqKcw3gH7Kmo7Fx4mBGSSp6mFkU+mffd8N
 hct6jMQhP1nnKCsZpynN/Gim1aAvxgBS/JdEu437AyLwK3T5kCYGgAsTDFbb8c9nNQrXjFs3
 ViM9/v5CDoqvLCLRHa18raPsSj0KSUTa2gYakcsVQIY5/HzrYd1iQjAJv5nEaionpj2FCv2z
 jSisicznfMQgNQN2qH9+krI6xqqq4TFQxAd+AraRCSm4xl/aYrjYJangWU39t5FJYedC1WE4
 n4NnpDC6PhUVc3S0iuQXO8KAbeloe6fNyHRikJuGJ9n8Cmx/3mkfsZb5zQWyFpVD/vosATBO
 Cf70T69LrcKVJd2Rcebu76MNvk=
IronPort-HdrOrdr: A9a23:zUAFaqxMDrXEUghDL/PuKrPwPb1zdoMgy1knxilNoH1uH/Bw8v
 rE9sjzuiWE6wr5J0tQ++xoVJPvfZq+z/JICOsqXYtKNTOO0FdAR7sM0WKN+Vzd8iTFh4tg6Z
 s=
X-IronPort-AV: E=Sophos;i="5.96,225,1665460800"; 
   d="scan'208";a="86161264"
Received: from mail-dm6nam04lp2047.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.47])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Dec 2022 18:00:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hudyhsSvIAx0/vaDKY0m+eZChiCGNann4HpAwVznuufgCEphmInnt5kSSksAp8EHD9P2cQ5s3KMcslpj4iyRZtufUZY/4GUJiRGCyeCL2e/D9hEfx6hZJUH9mUzNGb2mvmfj7/EoZBm9GNuNmuyjP1pj6nCq1K4M/pIazoMyQTRqgqzm9AAKMvmzof2k+TEGXIy8ebred97aqBMY3YXe7y5fiTvEgsE6RPsdxJSBBdjXV5908/LO/NjT3wHepyDbLE5JGF3trOH9dgO8zMwKqQizINiaLtwzPJcNwjXP9Nz2m5/udjaLbzzY0yY0veC7peMb8o+seou6TUWKGLeHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tzxusobkMnozhNQd63olUUZOBScuP1brmk1e3vK3Guo=;
 b=QkNduR5OjumtanWYpFB5RxKU1xecbrmZKM1JcPdMUsXmm/fLd2moYi54xqQ8xGuj0CitlPFX0OcBGw+Sdt1HqyXpLiKpS5lJGXGZ2lIJ2lh6o8J73JHKegayocz3mPOD9x1cKCvNaffa+DHDga34KTYyDj03hwczbwWRaWoOg8YulmxY7GFKfJlMa49y+lKLpyzJL+WdsxeQxzeyCkVaDri1O8AQJPMQx0T7v++tSgaA7vRBRgX/MPEVeBiWi0JaTtCkZw5wenzHatP1rQCJ37Ez0UxPGjihBuw1pa1IJI+BRuSo0pWRiL/1r9oZsLwxIp2UMofOK+Ukrc7tD3pC7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tzxusobkMnozhNQd63olUUZOBScuP1brmk1e3vK3Guo=;
 b=VFXA85PO63dGZ19ASrzNUIecbaYG0mzkfzDm/F69UQcDJKciPSr7SSOu4MTVn0IUPSbEp9CgyJ5aq24XNqecWdnR5FfsB5LwSVb5AHod9t1QFbTyRD9FCl8TrWhiTG66E3e3CYi1OJPw2qnatrTgHURiWovL23ys6JHv1LF2nLk=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by MN2PR03MB5245.namprd03.prod.outlook.com (2603:10b6:208:1e6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 23:00:53 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19%6]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 23:00:53 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Sander Eikelenboom <linux@eikelenboom.it>,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Xen-devel <xen-devel@lists.xen.org>, Paul Durrant <paul@xen.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Xen + linux 6.1.0-rc8, network to guest VM not working after
 commit ad7f402ae4f466647c3a669b8a6f3e5d4271c84a fixing XSA-423
Thread-Topic: Xen + linux 6.1.0-rc8, network to guest VM not working after
 commit ad7f402ae4f466647c3a669b8a6f3e5d4271c84a fixing XSA-423
Thread-Index: AQHZCoTvgsRUlGOV1k6xRNsUUF4cHa5jCngA
Date:   Wed, 7 Dec 2022 23:00:52 +0000
Message-ID: <56054539-4a02-5310-b93f-6baacaf8e007@citrix.com>
References: <2f364567-3598-2d86-ae3d-e0fabad4704a@eikelenboom.it>
In-Reply-To: <2f364567-3598-2d86-ae3d-e0fabad4704a@eikelenboom.it>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|MN2PR03MB5245:EE_
x-ms-office365-filtering-correlation-id: 3d740aef-8089-4394-95e4-08dad8a6e410
x-ld-processed: 335836de-42ef-43a2-b145-348c2ee9ca5b,ExtAddr,ExtFwd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FW6K2neMlNBGFM+YIkflKw2tY7L4AFwWig5LMLnh6oIysPmJ8xl1NuY77NNU8GDJm4I9lK7rfhnjwdbd8hZVMwsouhOLcP7Fc0ewDM0KKAh7cuMzg53QtsvLg/9wR3ieUX6C3fLv9Ag/rFoJx+0eKsBfAyK1GL4weUSZqFbT6xCw+phwfSPDhsuGFpFtxFJynkfOEulNcdM1ysIAQaLrsZG35V28nWfLylgQs/qAiz2ARYKUWQkhvn0htRmbToc4ZOipEwbJKlGb+tvcNSI2MklGqe7GqBW6KZ3j/PA4vw0GqDODUWbAPQ0FUryYMqsF9Eci5g0aGe2RWAMe01VbS2scM8c4Ejon0Yb/n7MnZ9B2UHSPqmCeBDVo5tNI5EeeAAhZlsX2a1ZuLU7FpEfRTaQoYhdMCC8eXunngHqJszCrYfLXvgw/nnvSBILaQB0eFAj8fUMWBGFx1qqpt8nQAyZt1BdKScgyChgLCoBKUV8ckXMUgOla+4hv8xJ1nDW6nYptR9YAcCZggNgsJx8aSApy/GsOtbvz2TbJOfpzvWtKvsf1xrEbtAZDtQAD43tEt9dQ78kKLSlv/obWHEEbUgu0Fu5KYxelpGrIrFhhfdnacX5MvrDBdg3pSHJXMnbKwOgr49OLOq/pKPQMP+eMvKoN+2I2IyDbogarjIgE4UqTbCIMyAODgWHn/jxNuwaYgdDNOIl8MFSPCzhwHGwQtmofZR9chLBjYuseKYnxkfdinxMDsIZa5L6HjryAbLvi5nNqTQxJpdq9LCSAdOqvuFZ/S3IwhRzYBMz3NhUOjbE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(36756003)(31686004)(4744005)(5660300002)(31696002)(86362001)(82960400001)(38070700005)(2906002)(8936002)(4326008)(41300700001)(122000001)(83380400001)(66446008)(91956017)(66556008)(966005)(66476007)(6486002)(66946007)(478600001)(316002)(2616005)(76116006)(110136005)(54906003)(71200400001)(38100700002)(8676002)(186003)(6506007)(6512007)(53546011)(26005)(64756008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmg5TUJ1bFJ4UzMybmlKLzVPSzVHVXY0bWNoRGxJTFRVTjgrVjhmNVBJU1dq?=
 =?utf-8?B?bmtTblFxUTNhdFo5d0NlVXMycnFVd0g5dThub1FyK2RLT0djQTZ2REdQRU5r?=
 =?utf-8?B?NHY0ZW5HaU9lZ0ZsenZpRXlNbGtZVXE4WDFrblJ4ZDJHSyswcU1TdnMwdkZU?=
 =?utf-8?B?Y244YjA3cGpkY1RmYTJjRlhQdnZTelEyWEFhbG1lNFZVZ0VaM1QzVk4yNGY4?=
 =?utf-8?B?THdqd3NYVVdEMGgzMjFhZHdzU1MvZVZZc3kxVEI3YmVXSzlNbFd0Y3ZjK2Fi?=
 =?utf-8?B?Mnc5LytJTkw2Vm1USG02OURCVzg0ZldGbWl5RDUxaG1wc0RqYkZ0S3l3UXd0?=
 =?utf-8?B?a3dTWlJEdWZmOXNFSnhaWVdadHk5Q2prUnc5YnI2VG52dGg4YkYwWUY2YW9j?=
 =?utf-8?B?dE5pSG5ybE0zZmdSdVVPTjFHRGpvWmhscmdvYjVmM0hKN2xiM3U4N3F1Q1k2?=
 =?utf-8?B?WVpiQWRiOTM3MUVjZG9xM0ZUOWZzWFNGNVdEMlA3aDlqcTY1Qk95MzFtMy9S?=
 =?utf-8?B?NFVkaVpObkZQL2VDR1NmZlBDTVM0eXVVZDNZVXVWRTBiOG1BbmllUi93b1cx?=
 =?utf-8?B?N1JUWkNya0dNSXlLTEwxTVhnUG5uc25KZHNjQnNwTWUrZUYvcjRYVW5ZajFy?=
 =?utf-8?B?bzJvTWl5MU8yQ0hYZTYwREhNQ3kvdXNCa2JRWUpwbTF6Q3ZTWlZValRHUC9w?=
 =?utf-8?B?TmhZSDd0ZzJkUVJXaUtkSUxqRVdvSmRUbG9adHRMNGs5bFN5RGRGbEo0OWVO?=
 =?utf-8?B?MDJOd3BVVWNEd3BsUVpsb01oV0p2WFdzVHdsdUxxUzRldmxKRkdPT3lVVWRs?=
 =?utf-8?B?eG43SlBHMVJUVWE2N1lvNVY0OVA3TkZZVmp5QVBKMHErVlhYOGhPSEFqMTh1?=
 =?utf-8?B?MG84b3h4Z3hOb3FUVjNrQ2FMb1NaMllBOTRzR0dhV25tN2p4VmhmQWtrZC9M?=
 =?utf-8?B?a2RtN0s5WmZHVnhJUEh2aklXZlVLVHgwdFM5RkVVa2tFSE5OcklCYTNIYUEv?=
 =?utf-8?B?aWhoZzE5QURVL1A2anRiRStzbXcyQUUxR0ViNmlZRm9Qb1poTGZhOVZCZVZR?=
 =?utf-8?B?RG5HR0xpSllmQTF2TGZ0UnMvQTJjWit2VlVwSHVuUXRVd0VNQ3JlS25EdXBy?=
 =?utf-8?B?NWFlRk5ZMW54a296VlZ4OE05WnVnc3NnWGZxWGVXeHdqL1k3V0xneTRiOHU4?=
 =?utf-8?B?M1RvLzM1Sy9pWG9JWTB1QWlWMHJkd25GS05RQm1IN2lLemRiQzhPT0EwUXFv?=
 =?utf-8?B?d3phVmlZQVY0MENHaW1abjlGVTlWTVFzT0owQjloLy8xSm11MGNRWlFDVFhp?=
 =?utf-8?B?bk1XSVB0WXN1TFR6ZWNKQmtHY1AwdEJUdjdmbU5mL21BdDZBZnhhUVdRanV5?=
 =?utf-8?B?dTIxeC96WVppRjFycHFud20wcUVzWU5wd01mVE95cFoxK3lwOHJzSlZQbHVs?=
 =?utf-8?B?bUJhVlVJRmJmcW4vWjdra0ZLRzJINGR5UUNucGM3UmZQMXhsMVl2NkdIRmdn?=
 =?utf-8?B?dEFxYTlKSXR5STZvM25Yd2t4NzFVSVBZQmhmZGdxOC8zV3J3aW5sMkl0aUR6?=
 =?utf-8?B?RnJ6eFRQOUZ0dUZuV0VFem1MM2JLa1NGWTJIc1Y1WmhCZjV5eGxsb2Z6dDJj?=
 =?utf-8?B?c2VWK1h3dER1QVlLMW55OHg5VlhCb25Fc1FGQ0ZPT3JUbW9Qa1F6ZUNQOHlT?=
 =?utf-8?B?K1ltem1QL3pZbVlZSnl0UmNKQ1VCQzVrMHd4VXBUdzM4M1AvSVMveE5uc2U3?=
 =?utf-8?B?SXpkeCtneEFFSTV5WXJGVDExOHZtWnJndnUzT1Bzcys3L0c2Rm1uRGlrbkVa?=
 =?utf-8?B?dFhmYWlSY3orREJWb1NmQ05sZmErMzhDYjRDK3pXN3ZHZC94WjBHTlVuR1NW?=
 =?utf-8?B?UEkzbHZqR3U3Ni82Z05LL1pHMXRYeFFPc2RpTGNKK2hVZW1ocTRGakVTNTV4?=
 =?utf-8?B?dFAyRnZYY2svV05razRjKzdwVjhJZGJQazcrYkk2NjN3dVk3M3ZkZFVERnFW?=
 =?utf-8?B?bEpNeWN2RnpWK05XUFFnaDZTNTRBN3greXpibUVHczdnSDlDa0ozK0phODRm?=
 =?utf-8?B?clNxV0QyZ3ZaY2Z0YUxJeE9iK2tOYVM3VlkxK2lSQ2l1RUFNQ09oekd3VHZR?=
 =?utf-8?Q?FpTPWlZcOFenxUoL920cl7EeC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05B6E0BCE5A54146B982884531C7FA19@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d740aef-8089-4394-95e4-08dad8a6e410
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 23:00:52.8340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1sGoN4IfqUFFCK0IiqrHCiywv6TF5yuC9fosUJD8d7ZrRlePIZchyjWutGzGJLv0NdbABIiYUMlm+l3bSYQOe007cOHgpuO6UVF9BoGKZng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR03MB5245
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcvMTIvMjAyMiAyMTo0MiwgU2FuZGVyIEVpa2VsZW5ib29tIHdyb3RlOg0KPiBIaSBSb3Nz
IC8gSnVlcmdlbiwNCj4NCj4gSSBqdXN0IHVwZGF0ZWQgbXkgbGludXgga2VybmVsIHRvIHRoZSBs
YXRlc3Qgb2YgTGludXMgaGlzIHRyZWUgd2hpY2gNCj4gaW5jbHVkZWQgY29tbWl0IGFkN2Y0MDJh
ZTRmNDY2NjQ3YzNhNjY5YjhhNmYzZTVkNDI3MWM4NGEgZml4aW5nIFhTQS00MjMuDQo+DQo+IFVu
Zm9ydHVuYXRlbHkgd2hlbiB1c2luZyB0aGlzIGtlcm5lbCBJIGNhbid0IFNTSCBhbnltb3JlIGlu
dG8gdGhlIFhlbg0KPiBndWVzdCBJIHN0YXJ0LCBidXQgSSBkb24ndCBzZWUgYW55IGFwcGFyZW50
IGZhaWx1cmVzIGVpdGhlci4NCj4gQSBzdHJhaWdodCByZXZlcnQgb2YgdGhlIGNvbW1pdA0KPiBh
ZDdmNDAyYWU0ZjQ2NjY0N2MzYTY2OWI4YTZmM2U1ZDQyNzFjODRhIG1ha2VzIG5ldHdvcmtpbmcg
ZnVuY3Rpb24NCj4gbm9ybWFsbHkgYWdhaW4uDQo+DQo+IEkgaGF2ZSBhZGRlZCBzb21lIG9mIHRo
ZSBsb2dnaW5nIGJlbG93LCBwZXJoYXBzIGl0IGF0IGdpdmVzIHNvbWUgaWRlYQ0KPiBvZmYgdGhl
IHN0YXRlIGFyb3VuZCB0aGUgWGVuIG5ldHdvcmsgZnJvbnQgYW5kIGJhY2tlbmQuDQo+DQo+IEFu
eSBpZGVhcyBvciBhIHRlc3QgcGF0Y2ggdGhhdCBJIGNvdWxkIHJ1biB0byBzaGVkIHNvbWUgbW9y
ZSBsaWdodCBvbg0KPiB3aGF0IGlzIGdvaW5nIG9uID8NCg0KWFNBLTQyMyB3YXMgYnVnZ3kuwqAg
Rml4IGFuZCBkaXNjdXNzaW9uIGF0Og0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy94ZW4tZGV2
ZWwvNjgxNzczZGQtNjI2NC02M2FjLWEzYjUtYTkxODJiOWUwY2MxQHN1c2UuY29tL1QvI3QNCg0K
fkFuZHJldw0K
