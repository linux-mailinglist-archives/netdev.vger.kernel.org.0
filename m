Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24A7ABAFC
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405468AbfIFOeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:34:05 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:53300 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731109AbfIFOeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:34:05 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2FD87C2A80;
        Fri,  6 Sep 2019 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567780444; bh=kRJ5DvL6IpNYTFELAOkhqesXkXy6oF6p1KBQWyngUOk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YONL57vWuaA7iBOUkk/7SYdpWA/U7OTlZdLH+8hXA67bPrRYP1RQAZlV9mWfsdI2D
         jQDe7lUOvTQsuMH7xUXtTTLCyXK23HKhqd/Hj9NySu3nKPY+LXGhDn/WOTZh/p2i3v
         rFLE6SI84INIL0hSLXtzseHQ37Dcew7UpMJtrtWAwkBe5Ol4Kxxr3NxfyQAodCpaZy
         xxjILuUYAOCesCbDj56886WZD5HTq8eUs537DgQuP3OMx2qyrrkCbNNGtOd0CbUodV
         ySaKaPuT28TXlloNmX+CqdFgT1DT5mqGWJtE49ggD4OaD0Ci/1MYiMvN7IhdfgkLbI
         bd3rT8UfRPqCg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id A5829A0091;
        Fri,  6 Sep 2019 14:34:00 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 6 Sep 2019 07:34:00 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 6 Sep 2019 07:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7p2CWQBQpe4PUcC7qyqwJ1a02X3wbozdtFIC8fbKh3S52X7GtNu9PbXnNhSG3IM5DsYQSQI5SJc/GWR6WsdBOSKWQoSy74fw70OLmmjW8flExULORxCOYWrpTQ2flF8G6qD1WasGgygAqI2PGuLFj3am2LPjewBBVmAPxzxkC/ejF0jOApdcM6HK5CXuKTdhuRLG4F1IXkm+rydBgNeu8ZxuB1BLepFyzXXjHAih5VL8jiJiGjzHnRU3wocse0ByVQfLt5ucf4wWqUHF6M6W3BPIRUeZUjOrDdfgNNC+05Dkc0cjk/hNshDQsstjDdt9d5fZm7Oz/eQuOTrMhxqAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRJ5DvL6IpNYTFELAOkhqesXkXy6oF6p1KBQWyngUOk=;
 b=S0xZXdReeWDWWYajVEuqhlTnPQU5PUWxSWRmYbgWMzNoulsnyLplVFzV+fSev7sce7QP7S8Jjv3VCojsi2CaRgmoiIps0Es+qpdgyEPT1xjLteFPSlL8c4JcxQhEobGRRzjQi7wAaFo8i5zaZNrTAs+fPjIVaAUW1PpBQ+kvsuLOAX3xRqtk7AvhVry/bN9v77ytZsTVXW20GL7M32GOTvgI27srQasEMXYUeL1Wurr5xGWdIMhSS/V/KMNqv4Rwz5Geb1jGnbu1+X/f1t5ALQpV8xmr7jzTwS8FlUK2PiiDIXoqgVfzdqSKsEHXRLjXitLYve2XdbsQFiOAp8F0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRJ5DvL6IpNYTFELAOkhqesXkXy6oF6p1KBQWyngUOk=;
 b=fWPCXiG9Jiqzj1QzKUnDOI6K9MjMZl6WpoTadAe0RUWb2i8da0rb3VUhIDGngdGzInhU1K1hYzc6F1L7Q3Ax5XR3AnYT/pnySxeCCJoxoB29zFfrCVA7VVURK/QCUXuqNH0d5i43d+V9jTfoDs+lU8Tbavyyb8l70mwmj9Qv2zo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2883.namprd12.prod.outlook.com (20.179.64.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Fri, 6 Sep 2019 14:33:57 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2220.022; Fri, 6 Sep 2019
 14:33:57 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>
CC:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: RE: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Topic: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Index: AQHVY+JK/I8EakLq2kKZWKw46LM93qcepnJAgAAPcwCAAAGdUA==
Date:   Fri, 6 Sep 2019 14:33:57 +0000
Message-ID: <BN8PR12MB3266F79F6ECCCFCA6D844F4FD3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1567685130-8153-1-git-send-email-weifeng.voon@intel.com>
 <BN8PR12MB3266D427D1AB8E41B13441B6D3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190906142446.GA29611@lunn.ch>
In-Reply-To: <20190906142446.GA29611@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a340eecd-91ce-45e4-a5bb-08d732d7403d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB2883;
x-ms-traffictypediagnostic: BN8PR12MB2883:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB2883312387776B24786C3F1ED3BA0@BN8PR12MB2883.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(39860400002)(396003)(346002)(189003)(199004)(64756008)(66446008)(11346002)(53936002)(25786009)(476003)(316002)(2906002)(66476007)(66556008)(486006)(71190400001)(229853002)(76116006)(4326008)(5660300002)(52536014)(102836004)(55016002)(14454004)(99286004)(7736002)(6116002)(66946007)(6636002)(3846002)(6436002)(76176011)(305945005)(6506007)(66066001)(71200400001)(110136005)(7696005)(74316002)(186003)(81156014)(81166006)(8676002)(6246003)(8936002)(33656002)(54906003)(478600001)(26005)(9686003)(446003)(4744005)(86362001)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2883;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iRDd96H0kIeX9rTkzGAaLL0Jl7OSgQPinCFqk3/hyWFTapgw7QraFWUuzWFHNA8kgsXPBhtPth9kt1oCC+Chne/a7uLyuQaZaUyPU+E3C7IkgoxXvF2EaSQQdE/vsfX7g0if6VLGkdRZwrMacJgSx+v/qXvprB/aXXI0z4Emxr7Qc9yq3XQfOwlSCcpjsw5IsXQRazHD4T4AwMe8L/VGWEDgHCBNmYP98kXRcaLrO+zDL938R0NpaoiS8ygy3W5LdlMf36MeuYxgJsX+GyxB41RFqbPfEJvPBj5hH8+ws/TRSWBSHdZjrhkizWcexnLqGChUBOH07P7XlI+NpiGUxOlTj9pFs/wAMj37eG1aaf0pgFQDbVQqooM5UpDOtdIatMCqDcn9x3vSIHmg6PGjivktoOsA2CSyC4Ot8HAXFi8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a340eecd-91ce-45e4-a5bb-08d732d7403d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 14:33:57.1155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zydfw8QOKrbCebnylbzLFYV8GAvXCm2vdfG6w7DxqMtcHfXwurYP6GYybfl8ZvCpHO3yEz4/F2yJF1XUZ0yFQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2883
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sep/06/2019, 15:24:46 (UTC+00:00)

> On Fri, Sep 06, 2019 at 01:31:14PM +0000, Jose Abreu wrote:
> > From: Voon Weifeng <weifeng.voon@intel.com>
> > Date: Sep/05/2019, 13:05:30 (UTC+00:00)
> >=20
> > > DW EQoS v5.xx controllers added capability for interrupt generation
> > > when MDIO interface is done (GMII Busy bit is cleared).
> > > This patch adds support for this interrupt on supported HW to avoid
> > > polling on GMII Busy bit.
> >=20
> > Better leave the enabling of this optional because the support for it i=
s=20
> > also optional depending on the IP HW configuration.
>=20
> Hi Jose
>=20
> If there a register which indicates if this feature is part of the IP?

Yes. That would be SMASEL which is Bit 5 of register MAC_HW_Feature0.

---
Thanks,
Jose Miguel Abreu
