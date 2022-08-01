Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C501586220
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 03:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238580AbiHABI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 21:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiHABI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 21:08:56 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C05DEB3
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 18:08:50 -0700 (PDT)
X-UUID: 5ab14b4d02844c6984534c3ba9c7b037-20220801
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:b869e636-caf3-414d-9188-342e44c8e3d3,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:46
X-CID-INFO: VERSION:1.1.8,REQID:b869e636-caf3-414d-9188-342e44c8e3d3,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:51,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:46
X-CID-META: VersionHash:0f94e32,CLOUDID:8666d4d0-841b-4e95-ad42-8f86e18f54fc,C
        OID:671f0ebf25e1,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 5ab14b4d02844c6984534c3ba9c7b037-20220801
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw02.mediatek.com
        (envelope-from <haijun.liu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1967805732; Mon, 01 Aug 2022 09:08:35 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 1 Aug 2022 09:08:34 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 1 Aug 2022 09:08:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZKAHZ7vQy+DpHipnvgvXNpQ89lEuytkqvceRGA9+LI4cy1+k2DH+y/8TJkztoRER4OnmJbCpMDdt9QCs4UeIu/JG/l3EzumXWnECczTs14GvgMCUgDfYSbZAVGGR4ry/EWKXWizqjGYUPntFZgPGMq/ciQZqBj+oEhFrXhmkEdf3aj8sNO8GA1Y9mSD6jq2/04w9T5ibYUwpTbTtPYxy4Ylbdy28mmw8Ryad3YFW4uu+3dQZyscTC1pqUoeEIC9rLIC41H+SeFaBkasPs5ZHgvhfUU51hllzCkSwM8uaTV4yAwbxfZ4Qa9Su1JVaK+QkC3ufamqF1zo3r41l0qSmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMwVyXca25XvBZzN9VJoRQO9zx4x6ADSfgETopPwdc8=;
 b=U5KUoQCXmni6ZIcKHPsrM49ELAXVnLZxW1e0J6yDmuGac+SonZARCJn1cPYwFdGym+GytQy7N6QSXzRA/vCOzujtmNywSlSwzVKqHJqmM4VpU7qVvUz1VDEx6LOvTiSnP9Ml+atg8mRnYp9K/YSc4Xxnlppbx/Q6T7fGhy6b7QYNuAbFId5GRHZUGuXSLT5uZxqPpMFX12tBbr0zxExoKkiwusJ1lm23Knmbdbu4rBDk51TvTTfyyyGs4FipUVIuc12e/DlpAPzCipjgbmBBMAxvKEZFio9jn7Vfm/6VuL/bM3evf6RKapJlRS4erIqTeITjquKjlhH0DyCBVJutcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMwVyXca25XvBZzN9VJoRQO9zx4x6ADSfgETopPwdc8=;
 b=GQcDAPJ4l9SzD/rbsyDkgGs6CZGmje1FAwn1FAn1EHx1DHIoxe31nXO+3ujjxzT6aX3hbfW4Ek2fq9yoNIwLqvjEfApOQ3NIGk/Re4lXk1D9YxP4TgqLA35tAmqdV9OhdIF8rGXzC9udUA7O9KzIIwfCL70SWoSkPHaTufLW2I0=
Received: from KL1PR03MB5833.apcprd03.prod.outlook.com (2603:1096:820:84::6)
 by PU1PR03MB3013.apcprd03.prod.outlook.com (2603:1096:803:2c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.12; Mon, 1 Aug
 2022 01:08:32 +0000
Received: from KL1PR03MB5833.apcprd03.prod.outlook.com
 ([fe80::8c50:baac:e7c0:686e]) by KL1PR03MB5833.apcprd03.prod.outlook.com
 ([fe80::8c50:baac:e7c0:686e%4]) with mapi id 15.20.5504.013; Mon, 1 Aug 2022
 01:08:32 +0000
From:   =?gb2312?B?SGFpanVuIExpdSAowfW6o778KQ==?= <haijun.liu@mediatek.com>
To:     Slark Xiao <slark_xiao@163.com>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        "m.chetan.kumar@linux.intel.com" <m.chetan.kumar@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: t7xx support and long term palnning
Thread-Topic: t7xx support and long term palnning
Thread-Index: AQHYoL3oCavnblxNTkad5FEubE30Wa2ZQQEQ
Date:   Mon, 1 Aug 2022 01:08:31 +0000
Message-ID: <KL1PR03MB58332BD04FCAA5F3AB932BDBE49A9@KL1PR03MB5833.apcprd03.prod.outlook.com>
References: <2564536c.449f.1823950ce01.Coremail.slark_xiao@163.com>
In-Reply-To: <2564536c.449f.1823950ce01.Coremail.slark_xiao@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ca8ab97-3ec3-4002-ea3b-08da735a59cd
x-ms-traffictypediagnostic: PU1PR03MB3013:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G0NukITQqzOw7U3uwfidQMOerQ7hFy4GyrflASS+KMrxONlR8wMp06s+FpGJ/V1wiRlLSjKvkPwKh4bpjBqxt0/VRqXpS+4Syuipywn9T1VQhUbP5jNJWC1CwdVXDup2bgHqLdklMPzvDrwRPbT/h825YpChFZoOlY3684TaM8X4KJYTg2QHCLmb/ILUfOsYn4SkeZTzzgaO6ym/4pIXJSZuZGJqL1bxHuLIqOiH6RMqfHnl8hLKgon+HsNbWIsw7PIdk46OrKUjA9diBJvQDmmBQW2eq8a3xX3+7We+t2EOihRgXf3qiG5lrkfV4jMlDVQpZX9VBIoknyeT/RtgFgv2LYuqNECUhIE0jv17rg+d3kn2WoyXTsgVVGkfWdwox/EitFEWUYXsQ+XXpKXpTiAJ332amWO1LGm5m6m5G2nZSq45J2MquClfUxuwYr7sYFyvQ3B2CPkGFatjXD9EgTk+3ibrGxw3tAWF6KmAgd8iwycZ+cIHOh1lOTJz8cccxvpxoGV1626HosR1yt6MUGazeMxTKZk2ugZexVe97HjwD+yrMcN+JQxkaefNDvS54hzpwau4vXrQLnG0PUkH2eQnwXjMCuAhhN3ZKTMH1RHdYed5V+eqBeDIKdS1i9dkAyyK9LFjtPRyRXE5mBq7KK16jhrxJIPzlXjTURJgYIt4Bug0JrviaEcHhJYr1VK/DhDuFATMsHwbGQIc37lx4Nf/AKfp2UEtmLlcA26cemidnxJZPjuCWo13zOhfRZzCs57hMPajguGwwHH6SrvvZqkZm9B7IvA40enAmQcOlV5oLnHLp605gmQ6awxHehKd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB5833.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(396003)(366004)(39850400004)(5660300002)(52536014)(8676002)(33656002)(76116006)(8936002)(478600001)(4326008)(71200400001)(64756008)(66446008)(66476007)(66556008)(66946007)(86362001)(55016003)(9686003)(26005)(186003)(41300700001)(2906002)(38070700005)(6506007)(7696005)(53546011)(38100700002)(122000001)(85182001)(110136005)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?R1JhVXNqWDY0cEJLRnhWd3ExQkpsVDloZUwzd0F4QzJTZ3Q5N1R0Y0tycjVV?=
 =?gb2312?B?cW9jbWlOa0dOWTEybmNsSFVpUXUrejF0czZxUEhYSkh3RVVqYmszZGhaMkZ2?=
 =?gb2312?B?NWV0cFBBS2hydk9ORllsa2hqOG1LVkR2RTh1elo5QVRLT2xpNGw4aytYVFp2?=
 =?gb2312?B?L2w3UmZ3aUNGMk5SVi9ndnIybjFjQ3BiMU05MFZ1VlhtVU5BblFnY2I5UWtQ?=
 =?gb2312?B?MFBYZmcyK2dlNy95WlVHaTBtTHdmQ1JYSU0rR2NKZUhyRDI1dXVyT1haQTZU?=
 =?gb2312?B?Z2FGOXIxa096Z2IzTkVKeFY1MzRlNVNtWjRZT2RuNGRQRWhaT0h5UVJ1L3Za?=
 =?gb2312?B?L1BXblRwc3VzUVR2M3puMWRNRHdyYXB5KytxTEMwMTBHUlpBQlN6M3JOdlcv?=
 =?gb2312?B?VTNnQVdOUk1CQllLd2w3VThhR09EeDVwdXU0Ky9zZlZlL0lvOHlOVWZnT2lZ?=
 =?gb2312?B?cndxeGtqaXNwUUZ1YWlubFdoU2p1MG10L29xUWhNbGtoVUFmTEZWR1ZiWUJR?=
 =?gb2312?B?c2I3MFFGdGpMaE8rbFRRc0tzMWlGWjFkOE4xSlBGWjQ4UWdrK3pXS2RvNFc4?=
 =?gb2312?B?eEJmbUVhL0hYalZ6Y0xCbGYzM25PSTNwUFdvL3dZaE1vbDFGTzZkYm8rMTdV?=
 =?gb2312?B?Tmk0OWtTekI2U1phMmF1ZHVKOG9VSUJZbytiY01ub3RQOHExWEh6UzErVm4r?=
 =?gb2312?B?WWplNzVWT2g4SEYzSVlDVkxrcnpQQXNjOTBEbm5DWUN3ZjhWUmNneTJRc0xq?=
 =?gb2312?B?UDZYcG1pRXk1dGtUYUE0RWxmQWkrTkF1Q24wYW1EQkMrZVZPYmQrWGFkK3gx?=
 =?gb2312?B?TFY0azlPVHhEQjNmaHUyUDhjdHdyMDZjN3F0R0hXV1hQaDNiSGRIOFZTNEd0?=
 =?gb2312?B?MXMzeGZvdnVnY1JOdXlSRnQxVytaOThXY001ZWsvWHhaYlZLeTVmaHJBR2RS?=
 =?gb2312?B?ZFQ1a0lvVCtBTzFlZXpLaW9Rc05jTkZYWGNGd2gxMTVFblNGMjVZVUNFOUMw?=
 =?gb2312?B?SFBHSXhQQ3BWa0NaRUNGZWZrWi9ydW9hYzU5ZW5SaDNGeWFVZUplOGdtRWRT?=
 =?gb2312?B?bnAxeDVTTzh6Q05ONC9yaTUxZnI3NGhpckZQUG44dlZKSVpQQkRUZjZkclRV?=
 =?gb2312?B?ZnpNdVBKNG1HOUpzTENCRkpiWGZ6S2hEN2t6Q3VFUGpCekRhMEpLaUNVRHc2?=
 =?gb2312?B?QVhhTUdTZ29tVEttRk9aT01qYytUZlk1Mi9YcThZeXY1QjhpR0hyTWxoVGc3?=
 =?gb2312?B?TlF1YmFPckxYdjF5V1ZKcjRMaFk3MmlWRi9YcmlvQ0NHcXZoU1hUWEptMU0w?=
 =?gb2312?B?U004VW9FMHhyMW5FcUo3VTZ5c3EycnN5dTRhcUthZi9OcGE1NHFSOVNDNzg5?=
 =?gb2312?B?S1FiTlhkVU9iVXA4eWI0akNreS9iNjhXUXRRRTg5SWs4UVBWVXhWUC82NXND?=
 =?gb2312?B?WllCMkowNWppS25BbXhCSTFrTW5hc0ozblVFTmV2T1lyM3U3VUNpVERGMkc0?=
 =?gb2312?B?L1NoaW9LNk00dlIxcHpybUU2dlFwY3VaUHQvellCUG9aU1ZSdzU4QlNWLzE3?=
 =?gb2312?B?N1dLMVdNTlhEc25VNHllbmx3MFY1NnMzZlNCMzNVbHFsV3BxR0RrSzRxYndh?=
 =?gb2312?B?Rlh4OGMzVVEwQVUvQ2MyTkVNd21Ba3BHclg0WmJYZXV0cFk5Q2pVTVBjOGdM?=
 =?gb2312?B?anBablZLODc3bGpOVWUrMmpZU0VVT1dCZ3VLbTBWejI5d3NSdjV4Ri84czda?=
 =?gb2312?B?M1lmU3U1ekFOU0tjR1NrMWt6VnZCTEl2MUtEMlhnSTdpa0hzdmxNZWJUeEdD?=
 =?gb2312?B?YXcrbnJkdjA0K2d4cy9yYWNBZlo5TjB5RURjQVY4YzNwcG9Ld0RsZ29LVlA5?=
 =?gb2312?B?a0tlN2VvcUIxc2hnME5Ba0NYN3Q4V0RGOGpvQlMrcXhLNmRZd0hmbXlxaHE4?=
 =?gb2312?B?U0NMcTNnalJYUENzNzcxbng2dXdTeWlJUnFaWktXOW5rVDhNMkFkK0IwMU9D?=
 =?gb2312?B?WERJcWF5MnR3Y09neTlVYVVadldVMmJ0MGdqVkw0SGNheE5jZGtIMXdkSmxn?=
 =?gb2312?B?M2YreVZUWFB3dG9TUGhoK3A2L2FUdW01bllPRU14NkpOMnZOLy9mYWE3OWY2?=
 =?gb2312?Q?ovBciKn6N7ZgTCaz9nOcix+hL?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB5833.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ca8ab97-3ec3-4002-ea3b-08da735a59cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 01:08:31.6626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IOT+dqTQb43CAGWBJv2XctvZgQaZ/rDVYZMKjWRKtlcnsYFCy5pwCqT6WkoRlsNY4paDt6wUvW5O3wYy4Qgxxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR03MB3013
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,RDNS_NONE,SPF_HELO_PASS,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2xhcmssDQoNCkhhcHB5IHRvIGhlYXIgdGhhdCB5b3VyIHF1ZXN0aW9uIGFib3V0IFQ4eHgu
DQpZZXMsIE1lZGlhVGVrIHdpbGwgcmVsZWFzZSBUOHh4IHBsYXRmb3JtLCBhbmQgd2lsbCB1cHN0
cmVhbSBUOHh4IGRyaXZlci4NCkZvciBUOHh4LCB3ZSBwcm9wb3NlZCB0byB1cHN0cmVhbSBhIG5l
dyBkcml2ZXIgc2luY2UgdGhlcmUgYXJlIHNvbWUgaGFyZHdhcmUgY2hhbmdlcy4NCkFib3V0IHRo
ZSBkcmFmdCBwbGFubmluZywgdGhlIDFzdCBzdWJtaXNzaW9uIGZvciByZXZpZXcgc2hvdWxkIGhh
cHBlbiBpbiBlbmQgb2YgdGhpcyB5ZWFyfiANCg0KQlINCkhhaWp1bg0KDQotLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2xhcmsgWGlhbyA8c2xhcmtfeGlhb0AxNjMuY29tPiANClNl
bnQ6IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgMzowMyBQTQ0KVG86IGNoYW5kcmFzaGVrYXIuZGV2
ZWdvd2RhQGludGVsLmNvbTsgbGludXh3d2FuQGludGVsLmNvbTsgY2hpcmFuamVldmkucmFwb2x1
QGxpbnV4LmludGVsLmNvbTsgSGFpanVuIExpdSAowfW6o778KSA8aGFpanVuLmxpdUBtZWRpYXRl
ay5jb20+OyBtLmNoZXRhbi5rdW1hckBsaW51eC5pbnRlbC5jb207IHJpY2FyZG8ubWFydGluZXpA
bGludXguaW50ZWwuY29tDQpDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogdDd4
eCBzdXBwb3J0IGFuZCBsb25nIHRlcm0gcGFsbm5pbmcNCg0KSGkgYWxsLA0KICAgQXMgZmFyIGFz
IEkga25vdywgTWVkaWFUZWsgd291bGQgcmVsZWFzZSBUOHh4IGluIHRoZSBjb21pbmcgZGF5cy4g
DQogICBJbiB0aGUgbGF0ZXN0IGtlcm5lbCwgd2UgaGF2ZSBzdXBwb3J0dGVkIE1lZGlhVGVrIHBs
YXRmb3JtIHdpdGggbmFtZSB0N3h4eC4NCiAgU28gSSB3YW50IHRvIGtub3cgaG93IHNob3VsZCB3
ZSBleHRlbmQgdGhlIHN1cHBvcnQgZm9yIHQ4eHggZGV2aWNlPyBVc2UgdGhlIHNhbWUgZHJpdmVy
IHQ3eHggZm9yIGN1cnJlbnQgdDd4eCBkZXZpY2Ugb3Igd2Ugd2lsbCBhZGQgYSBuZXcgZHJpdmVy
IGZvciB0aGF0Pw0KICBGb3IgUUMgY2hpcCBvciBJbnRlbCBjaGlwLCBJIHNhdyB0aGV5IHNoYXJl
ZCBhIHNhbWUgZHJpdmVyIGZvciBkaWZmZXJlbnQgcGxhdGZvcm0sIHN1Y2ggYXMgUUMgc2R4MjQs
IHNkeDU1LCBzZDY1LiBJIGhvcGUgTWVkaWFUZWsgbWF5IGFsc28gdXNlIGl0cyB2ZW5kb3IgbmFt
ZSBvciBzb21ldGhpbmcgZWxzZSBvdGhlciB0aGFuIGEgcHJvZHVjdCBvciBzZXJpYWwgbmFtZSBh
cyBpdCdzIGRyaXZlciBuYW1lLg0KICAgU28gd2hhdCdzIHRoZSBwbGFubmluZyBvZiBNZWRpYVRl
az8NCg0K
