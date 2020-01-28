Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666FD14B361
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 12:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgA1LMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 06:12:14 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:37932 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgA1LMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 06:12:13 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9B4A5C05C5;
        Tue, 28 Jan 2020 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580209932; bh=W0f+hvTuFURU2yEfaQMohF/iI/XZM9iMsyvf5LvD8V4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=kj6hDhSAztHS60xbn4kQHfl/+a4Hk7HhRjz8QW1fiXNMSNfjniKj8fyDr8xZptjtX
         CtXG7NtpsRGpXp4qsndScSJ5EhSJIX+KDoi5wlV+CwBzr550DCDvbj6DwPJRvkA30d
         vLu05P5iN0w+j7nuPuZoclXxJkCPUrcRxs3kJ7rBfdG3AejdmpdvMluMgvNdG6w7pF
         xXPnY+HmyoeFx6pL4H7K1IYkXTTFyrCVLyjERGFmYV5GkLNpDbih111hfclX+yeL56
         7/NxWtVt84t8P2g9eteQVAy4303Un2Nk99s0l5TcMA8WL+God0YihjN1v+G7a7xpp3
         lBwhiasZIS98g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 65BBFA0085;
        Tue, 28 Jan 2020 11:12:10 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 28 Jan 2020 03:12:07 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 28 Jan 2020 03:12:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1iDAu6g5pUkI2fBAChNACQnTzBM73Ejtfeha66OASTCG64dnWT2YpjsRISRLx5WskoSEYhcI5TT0vDe0Y7KHt8nudiKWy280vb3xDC3zzy6L/SGEsBAH7APEuvpNe3AiLwh7yMLUJwrFPgQELzTURz03MIk/70wK2bXiJCdUuX9krAphQEKtAiTCXAIpGrKJ4UGpQBJq3emUuf5VnA80b9nQOcc+NDizCGTrp70JVHGPNl3qLW+EG0L53SiKNwU7eZl4Z+R3nKPOaoic9OKm+7CNJNPMGkv2O6V+rM/omTw3UYPjVwobGSNl/7C3SAa331U9GB4GtK+u6Sp0zS+Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0f+hvTuFURU2yEfaQMohF/iI/XZM9iMsyvf5LvD8V4=;
 b=hCqS/VgJuQ8s7bIskbIwHIf/V5M1fwMqbwDPJrp5CE2sKmWqyoJSUoOSTvKXiMCO63QN2AjRpw/JhKeaXGMHxIlZtC9hQ6Qh07+JnD4uUftVsQvrTbtf/T673UXvQ6zuiP+9jAQuP1w+63MOWJyyk+9TH0CZ4EEP0tVfDqlyqAVO/osu2nT59MNU2t4mBPCZmFS4dNBva/gvZSfHYL924Ms7SBpwpBOI7rpIk6oXnD6VloEUBEFAjuWdGwaCBxeyotmwrzcAIBUcwx1KLj2AjymncW8m2ePP8rzuf5rHdOFNoHI736/O+jSBM4tl4LTm1jvnctNXYoCjN5N5phPZ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0f+hvTuFURU2yEfaQMohF/iI/XZM9iMsyvf5LvD8V4=;
 b=iv6LD6IuyUYMMBC3UA6IH9riZNm0G970rTBq+nEy7ZpnAviLhgwPIEK7a6i68ewLCUqYOTvVAzqS1KYIz6jwQAqYZ0Jv4CaCi7LaqXOGad7avTUtnZTxnrmbBwZwNsZvnadkfexR+WhlK65RBnEqzpXYBCB2cu4FY8Q24NSIass=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2852.namprd12.prod.outlook.com (20.179.64.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Tue, 28 Jan 2020 11:12:05 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2665.026; Tue, 28 Jan 2020
 11:12:05 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Thread-Topic: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Thread-Index: AQHV1QJR/2IdLzxcIUOq2qgDmVwJ/6f+XbIAgAAEH1CAAALaAIAAJZ4AgAACOACAAAvjgIAAFngAgAAC9ACAADQJgIABBohw
Date:   Tue, 28 Jan 2020 11:12:05 +0000
Message-ID: <BN8PR12MB3266B69DA09E1CC215843C3CD30A0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
 <20200127112102.GT25745@shell.armlinux.org.uk>
 <BN8PR12MB3266714AE9EC1A97218120B3D30B0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200127114600.GU25745@shell.armlinux.org.uk>
 <20200127140038.GD13647@lunn.ch>
 <20200127140834.GW25745@shell.armlinux.org.uk>
 <20200127145107.GE13647@lunn.ch>
 <20200127161132.GX25745@shell.armlinux.org.uk>
 <20200127162206.GJ13647@lunn.ch>
 <c3e863b8-2143-fee3-bb0b-65699661d7ab@gmail.com>
In-Reply-To: <c3e863b8-2143-fee3-bb0b-65699661d7ab@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd5a00d-7b3d-43dd-5bf0-08d7a3e2e879
x-ms-traffictypediagnostic: BN8PR12MB2852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB28524A857613358DB0CA2C8DD30A0@BN8PR12MB2852.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(366004)(396003)(346002)(376002)(199004)(189003)(71200400001)(52536014)(478600001)(9686003)(7696005)(6916009)(966005)(66556008)(64756008)(66946007)(76116006)(66446008)(66476007)(55016002)(6506007)(86362001)(33656002)(26005)(186003)(8936002)(8676002)(7416002)(81166006)(5660300002)(81156014)(54906003)(4326008)(316002)(2906002)(558084003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2852;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dd+uE/6MaCMOdIdFYGkk+VTOm4cj2TPVINsQ9Y0NKQnO6eu0xzf0ms4XjqGDr2H2yYBrD1Vd5kFi95OZcPJ9mZ/QCie6MckAaYOtFQ3qO0nCiWeh5YnVt+FCDaEmnw6X94eRWxIURgOpRbu1WWQQIkSwNvIsvZvwdyAreifAvj2kvF509Pi+Ficu2tWa2QSQcaHKts2nVCj69CWIyILI1QUEE5Z4CCtgBWw35JF9DI2NR0yBEi5EN6UIbEcpPlCbBonrSk9Gmr3J9PtpnXCcG8BhHY/YpMjZyyWPMmMUqZavjOWFhW+L2kBIpjWB2d6jMBge9PeY33FdwteCWSpFBel4/MxGyUdmhtNDdBExJQeyIAXNj+OJd/NDzWAwLYR3lL98c3WHbOqmwjkZ8XnFtHVYaOECHTPcTcfLbs/weBGnfMjvDOkpc8/e+K/D62CJBA5r3FKXHPVv+wm0cfOyoReVqJ52FIx2Xm/74cn1dnskG/qCWpsMONxg4to0B0SitDHxnRH0QKwL5qFe4cHJhQ==
x-ms-exchange-antispam-messagedata: vCTQt8RCsE3yA3XY6rK5Yv2El2h0aCWjTbqPi0jwVpoM5yUCURNEengQGUXmw7N/pTbPl+3Rp8xVY29AJGDN2EPGRYJ94f65ahjtGoGJ+q4DEK/84G83WGZJQb6cq9PnenJI3fUV4j+y2xUeywxQWA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd5a00d-7b3d-43dd-5bf0-08d7a3e2e879
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2020 11:12:05.3428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ObqQDoKj8Y1IS8mgkSluNcDhs+FtxVS2R4Cq0IsDEQsJRxEN+45ZPtzlHkn9E9joK8AzYTp2fIGGyoIKsLbtjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2852
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsbCwNCg0KUGxlYXNlIGNoZWNrIGJlbGxvdyBmb3IgYW5vdGhlciBwb3NzaWJpbGl0
eS4gT24gdGhpcyBvbmUgSSBtb3ZlZCBhbG1vc3QgDQpldmVyeXRoaW5nIHRvIFBIWUxJTkssIGV4
Y2VwdCB0aGUgSFcgcmVsYXRlZCBsb2dpYyB3aGljaCBpcyBzdGlsbCBpbiBYUENTIA0KbW9kdWxl
Lg0KDQpodHRwczovL2dpdGh1Yi5jb20vam9hYnJldS9saW51eC9jb21taXRzL3N0bW1hYy1uZXh0
DQoNClRoYW5rcywNCkpvc2UgTWlndWVsIEFicmV1DQo=
