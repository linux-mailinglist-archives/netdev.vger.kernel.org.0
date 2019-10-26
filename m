Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB38E59E3
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfJZLJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:09:46 -0400
Received: from mail-eopbgr820051.outbound.protection.outlook.com ([40.107.82.51]:44069
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfJZLJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:09:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK9Mkt74n3+KGM0A1dwzyJuV4M/x7v+2Km6CnCyHWWvRRsLm/rYUQnCFYYUicBz8StX0385vbJ1Wqp0k3Oq93wVsfy4J5UFAsKh2IB4K4wXcgrWTi3AVjg3rP5aF/Xkk/AkM5wDtgXdr5MhDTgha7Im86kFD/NztKXmc3Zr7h8eXuPhp0wx/1XQoLxHy3lxgXl0/nejihpX+Ccjj0XkbDhAu8I9HhZ9dxNh6mr7yBheM5F/zHDtTSMLeGk227EM32MOCwjP7xWkaKclBuNlcQrJcUcuKSgyohZEQaD2FiTDa4aItzQC4KN+VM8YG0UkRPqgKz2XLudqbkSJO+QF9Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EXVZ9+xyl243oTuIv1EgFYYXSA1uYpJKvLdC2Pl/cc=;
 b=LtRrFO9XRGb3w+Y9YlOtfLLDg5Z3zIHVQwJF5KGoKwsxPAka2UnCN1vOVNCa4vAtXlR554cnnTNXlm5yq2JJE/9aa1/xKCcCOXrPc2+Ud4grrDTntl9Wmvyj2a9/YPfkChayOFLuguYpfbxf5L2YB9+V57aVTC0K0ffbNHhWZuNxRSlCiTE09cWBt1jNejMVZqDouJf09BYvqFCSe9XIE7jevG3g1FFWRv2v90szFTZaDLol82l4yNTbPDa1MAPQbgYjtMR/V41T5/uLM9G1MiGzGpVO3KcPc3JCx9lxSnjln3f72N6s5MUl8oDckuk0+eYAkGp+0YjoYIbPI5C1cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4EXVZ9+xyl243oTuIv1EgFYYXSA1uYpJKvLdC2Pl/cc=;
 b=5QzE+QYOmxR/1ibcaEcJgjWec71fi5sMC0fX1NDxgLN1DI8cepdkQ6XBdfrSl6Tql0IJrawMSjkCfviSr/0019c5jc/MhcSurHQCAKGXAPGBO291zGJRoSfS4ccqzqWtvSboGdyjf5zHdMww629rxROU646PxsWy3DRLauwtmSg=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 11:09:42 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Sat, 26 Oct 2019
 11:09:42 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Yuehaibing <yuehaibing@huawei.com>,
        Simon Horman <simon.horman@netronome.com>
CC:     Egor Pomozov <epomozov@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
Thread-Topic: [EXT] Re: [PATCH net-next] net: aquantia: Fix build error
 wihtout CONFIG_PTP_1588_CLOCK
Thread-Index: AQHVi+3ed0tWLuNdk0SV6APBpRGF5g==
Date:   Sat, 26 Oct 2019 11:09:42 +0000
Message-ID: <379afbe8-adb8-5209-ac65-8bb9fb92966a@aquantia.com>
References: <20191025133726.31796-1-yuehaibing@huawei.com>
 <20191026080929.GD31244@netronome.com>
 <4edcf4c4-b8fc-00a1-5f13-6c41a27eb4a5@huawei.com>
In-Reply-To: <4edcf4c4-b8fc-00a1-5f13-6c41a27eb4a5@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b67dfd8-cb2f-4002-6041-08d75a05006e
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ms-exchange-purlcount: 1
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB35876706AC6B4F8027EA630698640@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(386003)(6512007)(64756008)(66476007)(66946007)(110136005)(508600001)(6306002)(66446008)(3846002)(6116002)(36756003)(26005)(229853002)(76176011)(256004)(71190400001)(2906002)(71200400001)(99286004)(305945005)(66066001)(31686004)(6436002)(102836004)(6486002)(52116002)(86362001)(6506007)(31696002)(966005)(44832011)(316002)(4744005)(25786009)(8936002)(81156014)(8676002)(81166006)(5660300002)(476003)(2616005)(4326008)(54906003)(11346002)(486006)(6246003)(7736002)(446003)(186003)(14454004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o2LcqlE7AluwnNhmkhmV75xHmvtquFu68OPrlmULNY48XlL2fVDnZ/M1eVmJ3rSwag5mHczaSn1Vk9dd1PLWnbVUsRoePOr1moGr7VMhJIxVUmjyHCGk1urXXTCAj6ND2TeKldmfLRkPKO5pvKGlO9M987HWqeIeZ2ua1S/1gu5t2ntQEv2m4uZL18wgtffWC813guvX+R0KimrYtElToDU5JDNJWyRZf+ujFhVGi/2389XED67RPutU36mTA0wsnaddxeuBIHyf9lSLCbHyk4tlR7JWDDKe59Tw3kcrF2mtLzfJsxIctMoJH/AiBjOl2kDn445FO+vSvth9tAM5MRmtHlg8kzkupBNOwGZocyrEMVe9VrlrCVBEduG7zfbpOPf2DW1EV7T1UVw+zElwvzUB5UOUPxf3NzXfS3BYMf+BWWTeN5Fzy+d4wrdwsDCSCUY6+JwLYhnNDGr1RqGnGYNcPjsmSeu4I0HOeb/7Lw0=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <37DC56B85AFE804EA363494B5A28D8AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b67dfd8-cb2f-4002-6041-08d75a05006e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 11:09:42.7343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ymPd/620bwwT/tJLdWgRqsVvn5/aXzCRueAtISM7v8EuLyDyy9Z50iV1s91sxNdN9MMVvFgBsnatT4tBYrtpag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Hi YueHaibing,
>>
>> thanks for your patch.
>>
>> What is the motivation for not using the existing copy of this function?
>=20
> I'm not sure if PTP_1588_CLOCK is needed at this config,
> using the existing function need to PTP_1588_CLOCK is selected.

Hi YueHaibing,

Please checkout this patch: https://patchwork.ozlabs.org/patch/1184620/

It fixes the problem without duplicating the function.

Regards,
  Igor
