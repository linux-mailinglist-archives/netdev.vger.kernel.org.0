Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFCDAB939
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392305AbfIFN2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:28:40 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:44774 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388106AbfIFN2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:28:40 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 45038C0DFE;
        Fri,  6 Sep 2019 13:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567776520; bh=7zCqNVeFWlgK8X+z31uu52zdzZOy1g2DPUWxyvHYoLo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cohVJmaZ4ixUHTOkQ/isKLDbOVfq8aAi+/Jyd4Yie3U8AG66Q3PHjs+XZk74NMzIZ
         SR/cUOMuv1/+7+xao0AfLGextVgb9aHmVZRVxdi3YXcRUZqVcUpDnIPUqOjLe+2WF+
         kKeB9fzFWVNjzebkxYLm2SxMP+DuoGL2/+AFjrlO1RJud34xyEFhR6C2oV0QD+BJAe
         OSLuWXdGtP4PvEtxsp1NtzBHcMP05RCe8SMDxniTaKwb+biJFV9qXXDbYIh8MLwpSY
         yinuRMYQsrPq7r3lXG+pZ/UrqFClYY/HQHY1jwlDvaNCRXNiej02Cjq/crgDuihE6f
         5Adsmu25HOJaw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B3DE9A005A;
        Fri,  6 Sep 2019 13:28:34 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 6 Sep 2019 06:28:34 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 6 Sep 2019 06:28:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh4Q9eC+4h4Rq1WZCZg5FKO8Y5N+v0DFckyHV7MWq9RgrbQVOHBJPZ8YCC/FNUYnkaR8cUmgfmoe9tw2E83kn9pi55UnVccIGONMwwfwf9qT3Xn/TuJ66wKX0Oqt6Sb02mqSp2YyCNuwzp25mX5nQTlOsfeP+RRPGYWiQ378ikxPKVD2olHhxTuOD8/jPXf8nUeDeHlDuwK40TWSGpnS34IcW16X+u3PIePG06ZNFmfAPncKjKzDMNwVYpI+ze4+w+Zgj48Dwz+4OYk5C7glSiTRLLaVuBgVrIlyOz/PMZb7kJLNY+askvIuh/itsOLTc3PpLcmBxuyyqlM9zL1iZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zCqNVeFWlgK8X+z31uu52zdzZOy1g2DPUWxyvHYoLo=;
 b=gDHlvUVR2tXYJUY8u4GxCOnBrsC18syEiPbs/3b8t/ZDnwrwlHs8YqPw7SnnX1PAXYSJOZVi3YpuQl+IVRqElJTykzRFoXKAfpmTlK0VNnR2GWPL0Z+Xq+KXVJRfvA2ctMv0g64ElWRHmPVk6OafTxXxh2HNyOEQTDalzDy1Fi8bD4Iz6upVciq/IKYJSWmCWVMXqfWwxPEnHHcZrD9rzG5MmPJ/KVM0idc5BGLCfuocJOqyDLTw6J/dH4vp9Zo/1MB1ZmIf0LE6xCIVO37vE4nw4rN0vRmVeXlIcj5NH09KRKXFvJR4Mma9DngDC6pWxOWBuVJC4edD2bNwksqfag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7zCqNVeFWlgK8X+z31uu52zdzZOy1g2DPUWxyvHYoLo=;
 b=LPu2atTs369oqdF/exmoltOT/JlTC6xKrhfgf1xEuMY7vTI4l2TY8iz22wZeUzh3MztdvxWOjPqT/dDRUdkZAb7RV2wNH7lBQBpYBzd+/yJTDagmC8NwGdhJWXc8RaR/V49v9HABIyPAVInNsDZVYgTZuhy08lkrBRQKNdvTImQ=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3332.namprd12.prod.outlook.com (20.178.209.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Fri, 6 Sep 2019 13:28:32 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2220.022; Fri, 6 Sep 2019
 13:28:32 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "weifeng.voon@intel.com" <weifeng.voon@intel.com>
Subject: RE: [RFC net-next v2 4/5] net: phy: introducing support for DWC xPCS
 logics for EHL & TGL
Thread-Topic: [RFC net-next v2 4/5] net: phy: introducing support for DWC xPCS
 logics for EHL & TGL
Thread-Index: AQHVXcjnVyQTnybW+EOKc+tPUlxVBKcesWvQ
Date:   Fri, 6 Sep 2019 13:28:32 +0000
Message-ID: <BN8PR12MB3266ADC38B505A739E24AB74D3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20190828174722.6726-1-boon.leong.ong@intel.com>
 <20190828174722.6726-5-boon.leong.ong@intel.com>
In-Reply-To: <20190828174722.6726-5-boon.leong.ong@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f65f9e3-36f4-4822-ab59-08d732ce1cec
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3332;
x-ms-traffictypediagnostic: BN8PR12MB3332:
x-microsoft-antispam-prvs: <BN8PR12MB333287B6BC2052D7AB96136DD3BA0@BN8PR12MB3332.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(189003)(199004)(6506007)(26005)(316002)(186003)(4744005)(110136005)(2501003)(54906003)(102836004)(476003)(6116002)(3846002)(486006)(11346002)(446003)(99286004)(7696005)(5660300002)(76176011)(229853002)(256004)(14444005)(2906002)(6246003)(81166006)(81156014)(8936002)(8676002)(55016002)(53936002)(64756008)(66946007)(66556008)(6436002)(76116006)(25786009)(66446008)(66476007)(9686003)(4326008)(33656002)(74316002)(2201001)(7736002)(52536014)(66066001)(305945005)(86362001)(478600001)(71200400001)(7416002)(14454004)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3332;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6eQz5ErqbyL/vNLfhv/gnofmurodYZnu1l5z1oZ5YfFe9L57jC18cHfaxpxyP3YnRcS/U/VHwFkmLTUoGJFqJn3+l+LER6OSrxFXLqrBTn3/MiQtRxlFTDyfDFwafGeNjsP+KlFdC+QcHLYxO7LjrKXJjHLUn1evLbvLoVG4LdQ66KJBTCTWZ9dGywHprmwaod+v0hjeE66W3brI8G0hO1okc9hFf1BMrz46wKELxJwQUXa1Qxxirb78hFYbtvv9DNMGWiMtXHMUJrMKpONQTvvjMui/yyl/NEDBUzbD5CPcQA0auGJsR3y5p5rAVK5cOjdj7S/+a0e8Oey3yra2AMb+No4nSSuUXkkqPkU8ehLV5P3jPujdFVUatUoL06vaibPTCajxNxKTDMh508UO+dszYpSO+b7TTNg5N6cwE1U=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f65f9e3-36f4-4822-ab59-08d732ce1cec
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 13:28:32.5389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DRj1yrH52EVVo7VS4bHZUtKlyTdP9esjaYfsM/sqAx+RG0A2LNxbJ0s21jX2WGId29z9wnkmZbaMivguEEOrcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3332
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>
Date: Aug/28/2019, 18:47:21 (UTC+00:00)

> xPCS is DWC Ethernet Physical Coding Sublayer that can be integrated with
> Ethernet MAC controller and acts as converter between GMII and SGMII.=20

You have to be careful here because xPCS supports much more than these=20
interfaces and speeds.

I would implement this thinking about the future integrations and=20
leaving margin for more speeds.

As for this being a converter I'm not sure about the implementation=20
logic because sometimes you can have a setup like:

MAC <-> xPCS <-> SERDES <-> SFP

SERDES and SFP may not require configuration nor even have MDIO access=20
so in my view the "PHY" would then be the xPCS, no ?

---
Thanks,
Jose Miguel Abreu
