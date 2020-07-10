Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E179621B9D3
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgGJPrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:47:40 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51606
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726820AbgGJPrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 11:47:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2mFX3ERySx+kGHO2C7FSrOGAl/qfaLWWNSFfi1Egv+YtQUFNHQPG4KUKMB6xl/SlfEFDwHSNwBmu3MJm0vVTE8KNXphfDvNwZMNWGNlbILXZo+z8IogaL3dGoBPeh4b862+SibNruqcO32F9SgVA8gHeB2TkB+G8AEvMGRLzYn35L5cQ+3lnmgQiZM19h9f2a4EDJTPg7M0YOiJ/86D3wJ3cOay+odGTmpvg1exBEIQ9EF1fI0tY5T+USWvHluRqQ1JRtA2bngOD2TAtT6tW6I/ikL1i+30YkUB1LAU4WM1DuYuA5qwsHatt/vJh0Ab3TGjzVmS1hWfNiNNPQtV5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pV7Hc51t8c1yH1iPmtWmvQbm03aHYPkZeJVekqxklgg=;
 b=m6Kq8kZU4NEs1vhATvf1Q4lxHIhBUZDjGEHCV5BT3uEBln2nEN+cDa+Qgms9WGBD8dnctLHVSkC/k/P173U9OQORIVWOnFNgV56+CCDXFGN+cM/q6Cta8a9XSog2/1LNhHZG8IvMPlr9e7ub4J2VlpOY7EIuSMlP3AxcPWduZPKtmM1UgMigubzfuhgkkJLbSbnrcM2zNPPdi30RyhIzdaY53Na2kz3OPrnr8f177jpG/r9wG8IRqEvKRqriYmH/u2l2PIWoQg3Kb3H19QjUOU++CrqgqG4rCRQGnFwaknzORfrQens7aDAaRURwcyVDAFqbdXlgAaufIf+9sckYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pV7Hc51t8c1yH1iPmtWmvQbm03aHYPkZeJVekqxklgg=;
 b=RV3b/fBhDwpvaTA0G4ytBDqn/Ja4yH2BFGg7zieuWUaPj+6TKcz3NnHrwxioJmF7R9Sr3a+WhKdThV4yGVSBNqkLLoibSWL0AWtcr6MKYJclYbzgikjk6XOcVbZ5+FSxKzlJ6OOQLJVo1dGMLbi87gMjaKPDTnSxnl+7H1doavU=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5566.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 10 Jul
 2020 15:47:36 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 15:47:36 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
CC:     Tobias Waldekranz <tobias@waldekranz.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
Subject: Re: MDIO Debug Interface
Thread-Topic: MDIO Debug Interface
Thread-Index: AQHWVjuxE+YpZ9y1LkK4mNC1RWwIvQ==
Date:   Fri, 10 Jul 2020 15:47:36 +0000
Message-ID: <VI1PR0402MB3871B341615ED111B614CDE0E0650@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200709233337.xxneb7kweayr4yis@skbuf>
 <C42U7ICFS9TP.3PIIHGICUXOC4@wkz-x280> <20200710094517.fiaotxw2kuvosv5s@skbuf>
 <20200710133538.GF1014141@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.219.134]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 01a6fb26-bffa-4bf0-3b9e-08d824e891a2
x-ms-traffictypediagnostic: VI1PR04MB5566:
x-microsoft-antispam-prvs: <VI1PR04MB5566C26838FBFCB5F905B512E0650@VI1PR04MB5566.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qTZqth6z3itbHhjSl4TDtYOo11gurPC/6Y9Kd4M5gRe/7Oc5fxud8M3W6PZ300mp5vMKn1OYOxyV66/9SVlaPHzM0nKtKqFXsJsn7ULnESBlYzfe0vidlq+WQ75/vhcJVrK7osIhGZZsZDiD4r4IeI4pWBy4XUvqBYyQwN2GWUxZQbMJ9sHZlbr4V/lqEknrMVUH4XGCM0aVfPCQXtDgamgwSMunGzhTfIBu6/yYRfcJD5/C35lrRRrjrxGjCJDrA1EFYt/vRgbY3uxYHRBKTfeoCLrVn1PFa4d5PnB0TTHVfZMnvmjnsiiGblmJ/tc+dTWbwaFTzGFY2WA+rbnlZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(346002)(136003)(366004)(52536014)(2906002)(316002)(44832011)(4326008)(3480700007)(33656002)(26005)(7696005)(76116006)(66556008)(66476007)(64756008)(110136005)(66446008)(6506007)(53546011)(186003)(86362001)(54906003)(91956017)(66946007)(478600001)(83380400001)(71200400001)(7116003)(5660300002)(9686003)(8676002)(55016002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tRQz0VLMRHPwsSyHF7hQbkkFYzTCBpMK6PoljlJFDOmsn05KhLBPE0Ey1ku8U0Jqf4PraATpNLPZDaQbU+cVGYUwce/AObluEj0RjmRUG51hIWbrWLktWGKy1X+LhzM6PnvMdRkwXdKdmNp1fiXKkQzyLNKRVJOu3wxGku/gYu7kUiNKqGgNtJLW0r5etYb2OftEpfATGDcQE/89Sq+WqF6a5ZCUMcFJHtPJR6ngoY7W/QL7k/B6r0oIbPBlu5E4ti4RqoH80d6AL7HPkfChIQsutXXvrgEglRtKE71MUqcUoQKNcXOlRDLYJ3fZNn7OhWaFIS7W19AlqTXb8FlmHL5Y9eVnbpXKHzaeWOK4KvvRtZFF15WuwQGz+6nEghXPmbSAWR3pkReegnMX8fR1y5iKfUp+Z6eVXu3AuhEUsKBOhjexhy9plQbDTDJjvLKq3Juc6vAFUb1/QbwxKgptGbp0cTx3Eai7dD1Crh6ZUZzuiQed3Oqw6igMSW4L+hIi
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a6fb26-bffa-4bf0-3b9e-08d824e891a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 15:47:36.6632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Skfpvqvf5cfON/nssINNOUATz8W5EoAU43AXU35NsC88FkKOp/ITzaFNBneh4hOEDa+E+dJTANcxzEGICSDd/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5566
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 4:35 PM, Andrew Lunn wrote:=0A=
>> In principle there is nothing in this para-virtualization design that=0A=
>> would preclude a quirky quad PHY from being accessed in a=0A=
>> virtualization-safe mode. The main use case for PHY access in a VM is=0A=
>> for detecting when the link went down. Worst case, the QEMU host-side=0A=
>> driver could lie about the PHY ID, and could only expose the clause 22=
=0A=
>> subset of registers that could make it compatible with genphy. I don't=
=0A=
>> think this changes the overall approach about how MDIO devices would be=
=0A=
>> virtualized with QEMU.=0A=
> =0A=
> A more generic solution might be to fully virtualize the PHY. Let the=0A=
> host kernel drive the PHY, and QEMU can use /sys/bus/mdio_bus/devices,=0A=
> and uevents sent to user space. Ioana already added support for a PHY=0A=
> not bound to a MAC in phylink. You would need to add a UAPI for=0A=
> start/stop, and maybe a couple more operations, and probably export a=0A=
> bit more information.=0A=
=0A=
=0A=
You would still need a struct device to bind to that PHY and I am not =0A=
sure what device that might be since the userspace cannot provide one.=0A=
=0A=
> =0A=
> This would then solve the quad PHY situation, and any other odd=0A=
> setups. And all the VM would require is genphy, keeping it simple.=0A=
> =0A=
> 	Andrew=0A=
> =0A=
> =0A=
=0A=
How would the genphy driver work if there is no MDIO register map for it =
=0A=
to access? This suggestion seems something in between a software PHY and =
=0A=
hardware PHY. Also, it would work only on PHYs and not any other device =0A=
accessible over an MDIO bus (so you couldn't assign a DSA switch to a VM).=
=0A=
=0A=
Coming back to a point that you made earlier, even as we speak, with an =0A=
upstream kernel you can still have an userspace application accessing =0A=
devices on a MDIO bus. Since the MDIO controller is memory mapped you =0A=
just need some devmem commands wrapped-up in a nice script, no need for =0A=
a vendor patch over an upstream kernel for this.=0A=
=0A=
Ioana=0A=
