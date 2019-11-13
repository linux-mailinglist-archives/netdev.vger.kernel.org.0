Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A451FB470
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbfKMP6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:58:54 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38362 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfKMP6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:58:54 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Bryan.Whitehead@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="Bryan.Whitehead@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Bryan.Whitehead@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Bryan.Whitehead@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: coGPaDra5I5QfgTG3ebViLJ6hrzdRkHrhyXqPopxx4ctuzVQg/RTUiwTZftRhj0/6Mqwm0BrHu
 5h79a/EBXetdbCubEbHkiqMx0rbuoC/U19frCwHeRVP1CYKeIBxPu1pQ3bsW74Ovs4sjsWDY/Z
 0bpZrVC43r5TDW9JkKQbx+kxvmx0JqIO0F/rsGAPdeKyGMdwaYRtzuUiyxivsJa2E30gheqdxd
 /MCPqwqk61cZk4Qjp1m95ol0nv92CtxSAC3/3o3lSPFU7dHjocKhOe6ySkoSonXOwqaYqVTZIh
 YIQ=
X-IronPort-AV: E=Sophos;i="5.68,300,1569308400"; 
   d="scan'208";a="55309877"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Nov 2019 08:58:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 Nov 2019 08:58:46 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 13 Nov 2019 08:58:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8YVEzxnWSIEVhCsqyQM0bKYBmyrzl6cK5kHL/BQtDc+O8MkopsL7KXlHg9fcAhwPQWhgZ6ebmmu7PBozEvpFahtmn5+jaEH4yIMsp9R5/nAZ+gqS6opsMhrtpOdPNOwOQaaqdv1wYHKiwCKXXgMXI9MgR8Q1CNxOPVOfe/5F8ish5h1Xq3ceKccyi8grMz/RKOIGSMLSBBstIk1LMXNNJ2X1rIP1djg8OmUEhLMq5537KINKIDbD/meWL0gsLUXqhyZSTTJKiJ7bkP4yvv0O3yXuIKc4Iz2FlYj0GQhc55l8sMwkEnWoM+hq7zZ8nRP3CAmktmE4J3wJj/Pi3jcEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpO2ktbwKrcvK1OQMhj9BuMGbhSH+cUAeoroF3O7B40=;
 b=hriyTFpzR7edWlZ7Kc0CrGADQZl/EtwnRXBA6wdlIwoKMpXdbbmDoYuwa4iVJ/spA6FSEQVA7Fpi+sXxogsxfcTtTpVwQqYwycQyCguDhweVKChe8rXVS4Y7V82eB8jqGAI3kYOhciM2Z8QC1j1ns8zIM8VoOXLiLcH8A5Ey3Jn7j2YS2COfgmsd/szoBNp4f7oWlHA9F3h2UhNY3tLFeE3FY1vIH6gRLcMti6+eP6LRYEw2fQNTcIvD4Q/quPOAcBthbLG8c1h0vTN+Axl4/EKbIL7Sft5i0DLOZ9zUxgxu3kYlEnWTi76/KlVvF3EjFY0Di05NuGgQUmGmJ9U2hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpO2ktbwKrcvK1OQMhj9BuMGbhSH+cUAeoroF3O7B40=;
 b=oSHf1764pukZlENrdI1dQ3bZ7KKDyyKL7A6xyzcTTj4Fzh6//X65FrX5HpiaThHm2PzxmtuuFSOSznqOHOvQSJvJAfCNnbVVQlDIOC/KaaLsBdTDt2lJ0TVF9djR7a3Tcujhv0E38g1kK0dpYN1tNAKKkSru8fntLgKYmpBpJAI=
Received: from MN2PR11MB4333.namprd11.prod.outlook.com (10.255.90.25) by
 MN2PR11MB3584.namprd11.prod.outlook.com (20.178.251.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Wed, 13 Nov 2019 15:58:42 +0000
Received: from MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd]) by MN2PR11MB4333.namprd11.prod.outlook.com
 ([fe80::e82a:ef05:d8ca:4cd%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 15:58:42 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Topic: [PATCH v1 net-next] mscc.c: Add support for additional VSC PHYs
Thread-Index: AQHVmXJIiwJOwhRbeU+HRtKC5Z72x6eH//SAgAABu0CAATysgIAABQOg
Date:   Wed, 13 Nov 2019 15:58:42 +0000
Message-ID: <MN2PR11MB4333038C5259D3029CFC8477FA760@MN2PR11MB4333.namprd11.prod.outlook.com>
References: <1573574048-12251-1-git-send-email-Bryan.Whitehead@microchip.com>
 <20191112204031.GH10875@lunn.ch>
 <MN2PR11MB4333B89CD568C6B66C8C60E3FA770@MN2PR11MB4333.namprd11.prod.outlook.com>
 <20191113154007.GJ10875@lunn.ch>
In-Reply-To: <20191113154007.GJ10875@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b0ef302-7228-4ec0-9033-08d768525b59
x-ms-traffictypediagnostic: MN2PR11MB3584:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB35845EB68448B38745BF47F4FA760@MN2PR11MB3584.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(39860400002)(346002)(136003)(199004)(189003)(107886003)(4326008)(66446008)(66476007)(256004)(71200400001)(71190400001)(9686003)(229853002)(55016002)(14454004)(64756008)(76116006)(66066001)(66556008)(6246003)(6436002)(5660300002)(52536014)(66946007)(7736002)(6916009)(476003)(33656002)(7696005)(486006)(76176011)(11346002)(558084003)(446003)(316002)(54906003)(86362001)(478600001)(3846002)(6116002)(25786009)(2906002)(6506007)(8936002)(74316002)(81166006)(102836004)(81156014)(99286004)(26005)(305945005)(186003)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3584;H:MN2PR11MB4333.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fIJICtbzE3JrzAmqM0kFWc/eopkA8XeUKV2pDvn9lSaMUG8fnZAiEajUAjHHspox5bfcYiXgOjItOvbqHnhOOWbfyErbFcT6bbGhkQVTcNe6tdDV4lDk5wCZQQufhXeN4Liv05amjla+QnWGtxdA4iOm6aGWGtNMvfoNGLGcIN/IdQQxETeKzNSjGJF6MwgbAJDYh3FtbCm2SiCUe1jcOkVrkVWpWin/+epnVPDAm6j56ccuCnyTYkOP5SxTYDINGk7JWWHJfQR2tpFKLfv/FfrJieZstaAVJS2E35zoCvvUTiE7jhG+MN67xY983+LIH8PYxkwhLpVM/8n+2fPWicO8W2V4k8r/xQDuKKpOmSEyYiC+qQTL/RGq0O7d9kuVPKwh+Jc1cxc2gbCi5WllQ1Uj20ZQWkrqOMkawx1YBStE9y3OSMzJ9EdiJO6Px8Bb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0ef302-7228-4ec0-9033-08d768525b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 15:58:42.4728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rSNI488zA6BTfGmaoYxGq/VIwfUbsFU7lOriMmLsAkYi/W5S2BriaSYXEUWG9j8pJPDyp6Tp2CZ8m8i72wrVD6eSDL2Nc9m+smBfm9XvGs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Bryan
>=20
> You could add a WARN_ON(phydev->drv->phy_id_mask & 0xf); That should
> catch any new PHY breaking the assumption.
>=20
>     Andrew

Good idea, Thanks Andrew

