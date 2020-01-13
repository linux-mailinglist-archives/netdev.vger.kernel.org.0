Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7AD139287
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgAMNye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:54:34 -0500
Received: from sv2-smtprelay2.synopsys.com ([149.117.73.133]:37106 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgAMNye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:54:34 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2A9CA406A9;
        Mon, 13 Jan 2020 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578923673; bh=lxAOT2BkI85HKicR5fTKEbv9fn1ERxxwMdp9KHxtB8I=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=WbSBasEFSkKDfQSAz0/TS0BmQIHMNX8kj9tOe4otpgl4DZzKF9IwbdnXGgcDipFUY
         S6WCRLDd+Kv5oQ3b+oT6+SkRy8byaWhtj6SYrnpL1HLPyZP7PoYE6kRRb8a8gaJBgF
         KdvmR3/1K2k1s66uvMwMSuNH09rXLgpaIi0sRkr4/incOo5+gel9nGfUl2k8eFRuXa
         lmMB1mBo1nYEWc6P2i0GojksVsdhjnPqG3Sb+Q7EuQTZ8yNyvgt1nxlxA9xvijEcz2
         KOfMOdfXOB/FqNqnGW5pmD4o355R8d/Aj7kZuRfZO2BluvJOYMdY0uRWHSo+yOJaMv
         BgRYcSvxsrukQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id E2B48A0067;
        Mon, 13 Jan 2020 13:54:30 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 05:54:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 13 Jan 2020 05:54:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8N7BcyhIHgeKPUaWfiBpAzll0evjbxFm8NuHTnZRP2iNbnKrEmTDAtmtlf3DUmr/0sldOd1Xv1rXtOAlFpn8xiB0LJ4+isuNoP1NhPGHXwBnNBIxbzwGkDpEdte79C92pfwP/caDh0s3bPh/AFxoBcgiV/cl3wmk76vfQWHA+vaWXM9pyHG4co6j7gnXIATg98T3IOGlQU7lqLeslm2KLiQG7FLOwmLt5XdmVm21oRyA4yqx91U8vXw3wSyL5a0AjLto6jh7oQeaJ3RTv4k7HlMgksj6pLP292OKNWQf87vK3K13ICtSdbHzbOVVLTcjSzUqvTuR4Hs/nLutXFxSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxAOT2BkI85HKicR5fTKEbv9fn1ERxxwMdp9KHxtB8I=;
 b=EX/TiiUW/h++MfQtwmbm/4E0ZFW4LAuEi+iCxHCJwcpy3QD45mzOgu7pytZg1H9HUlsbzsPQcHZYx9C29pTZDLoeuuwMTPQ/XqO6st+KqTmxxjpNQ9YO66MLsyD3KbmYvsEbVevgYw++nt4BdConltHi/IZojL5+XxBYOaqqI42L/UeF0uJkb4nV+OkGuJLYbIDxSTBzYkUQP47RtH1eDlcS1VN5MJI6HY8Q9hr2Qd40wePf8OLNTak6sjGYOobgqiNpmQaEIwqQd9NVYrYHuaPdEqIuFuevwsGfYBWlDg0uuNbqod1qNgI6TDcs5MJUTRN/A0fzBDPVZ4no5wYJCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxAOT2BkI85HKicR5fTKEbv9fn1ERxxwMdp9KHxtB8I=;
 b=gtWCIm2lN4MLPLmwUKju++4IYlk6qnJhLsqLnxKCPDtWV67dgWsZYrTb8fEBIw0YDUZcw6GuY6MJC808822pXXC98i1tTzEW1odkbF4E2phPGT0pC33ao7iKOOFuVp36x25vtdhpSfzadZ1iC0A0lIUx0hHFGHVeeFHS5fPUIPo=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3331.namprd12.prod.outlook.com (20.178.211.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Mon, 13 Jan 2020 13:54:29 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 13:54:28 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSA=
Date:   Mon, 13 Jan 2020 13:54:28 +0000
Message-ID: <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
In-Reply-To: <20200113133845.GD11788@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee5c9f17-6dfe-4b66-6ea6-08d798301bde
x-ms-traffictypediagnostic: BN8PR12MB3331:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3331CD6367F4303DF7A4CF7BD3350@BN8PR12MB3331.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(136003)(366004)(39860400002)(189003)(199004)(86362001)(6916009)(54906003)(5660300002)(4744005)(316002)(52536014)(4326008)(478600001)(9686003)(33656002)(55016002)(26005)(2906002)(186003)(6506007)(66446008)(81166006)(81156014)(66556008)(8676002)(8936002)(66946007)(76116006)(66476007)(64756008)(7696005)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3331;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6T6zlvk1ghHDBR+q+6LH5k5uD/p3tNeoQO4dGvuuZiRZZb1nUGhv7DIEwN7iPWtFPpmFnkmV/fi0IMc4F9YuOUhdUIR7B9IE4lMz/LsAybGkgU55pqJci71qadUfPlUMAo3TuxxwVundYHXCCY7GJvZ4mq2o/O3Eo1sxoBaS4a3YOJ4tCjGIvnw6SPssIi6fDaOSWJsKqXxpz3kKGkDojs3U0PtdNNZ/sbNyqXsOatbLHyHfGjpIpJLu+TFwjYi9Q8ARahC8XmO6iiZq76MGl5hPSOFM8IZNov/xWX9IpVIALBcOPwwya63mmv2ENXeKRw4sIR5baojprPUvuBLFI8z3UPJ+Pwr/VasEux0XFZCffapGZWnEPJTZCn9VhJKKPWY4lm2Qqdtje485YmCjDsI4vPDTUUofeOTzJFA3Be8K0kFwHH0o5rCA7Lry5qhb
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5c9f17-6dfe-4b66-6ea6-08d798301bde
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 13:54:28.7390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RqNWv1qmvNsYvDR6mNGS4iNglYpyuYYXahNpFeWVWgdBTV0raaB3+EW8MPO87w7m9c3lnR6awTZPgZGz/HU2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3331
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Jan/13/2020, 13:38:45 (UTC+00:00)

> On Mon, Jan 13, 2020 at 02:11:08PM +0100, Jose Abreu wrote:
> > Adds the basic support for XPCS including support for USXGMII.
>=20
> Hi Jose
>=20
> Please could you describe the 'big picture'. What comes after the
> XPCS? An SFP? A copper PHY? How in Linux do you combine this PHY and
> whatever comes next using PHYLINK?
>=20
> Or do only support backplane with this, and the next thing in the line
> is the peers XPCS?

My current setup is this:

Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> QSFP+

The only piece that needs configuration besides XGMAC is the XPCS hereby=20
I "called" it a PHY ... Anyway, this is an RFC because I'm not entirely=20
sure about the approach. Hmm ?

---
Thanks,
Jose Miguel Abreu
