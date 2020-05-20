Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529B51DB7C5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgETPKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:10:47 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:21287
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbgETPKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 11:10:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ft7TFWHs+eiVrIKtAITEBMYjO/2Ka3DGgpQpBtsOOMOP2hLvzDWkv2VjXLZMhAEo8cjHMhGjx9f91SIqGLU6+5XW87zuUa/CSaQoOz7Uo+vglS46MGyv/RvoSdsqRo79xoItnUVFu01f1+QBDYr2/2IhMX7FTDUCYHP/8xyw83zAQ7OwSG2N/Fr55OXGueavBoQbAFDRoSv3sshOz689xKcj1LHX6NQPKvmLNQtfAqoEfYqdoO+TDUcu1vSxC3BEcWsUhs3NbWGHLKgErZmRWE8p0oOZHGVSRd9ZbUcYbUiDX/JTpQOdu/V8ZudAgglspK1Qg5wYh+AUChgPr1cv6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDfwD7sEMtGL7WAGk2qxmIl2qNZpku+yYsRizD9WUoQ=;
 b=hTTZz876aVNggnfJ0AzJa+zMwpEXisdM+UXsBlMLSYcDOYspjF3e9F7IiZxdlMYubkQd/Zomvyab6nAXcP42MuGwrdi1LwqfNsuxqLVgMUyTBT2M6Tg5OXUPSLkTAmB3ADp+MZB3nYcn+NksdZSikKlwGYEgxeCxe6euiCN52o3QtoxvfaMrFo45bPV3nzn2rSk1rASCMmBF3bdMcwDsBK82WahRFXQtYnILl+fybRbiCLhxuv+6uxy9JrS+yWl4C+imgcYszQRGJDd/cBtv18fgtj+HnOGI2ObBZxa/xrBYUy6qgmdS9lqJ5t3+aw3Paz9BSdxWmUgqNOkhf1kJxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDfwD7sEMtGL7WAGk2qxmIl2qNZpku+yYsRizD9WUoQ=;
 b=NafBWL92iSyUmi2y79Z4HokkfxEVj8qxSM8FrqDPPsHJEckgyVpmSQTloo60Y4RvjsFbiux/x0Fm1JPe7oMd9oBkYrsYZtVlFXybmc7eSE6jzRR9bdPWiDlZQ2x7eBULprE0GQRd3FEBWXqqt2iWmWbTmItCa7YIBkggOZUI6dc=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB2765.eurprd04.prod.outlook.com
 (2603:10a6:800:b0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Wed, 20 May
 2020 15:10:43 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3000.033; Wed, 20 May 2020
 15:10:42 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Topic: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffic
 classes
Thread-Index: AQHWKulbmiq87o7Yx0yuJ8Tm2Q7xY6iphgOAgAACOECAAAN2gIAAEXFggAAcYgCAAKFaYIAD5lUAgADH7GCAALvkAIAAGOkQgAAXEYCAASQ/sA==
Date:   Wed, 20 May 2020 15:10:42 +0000
Message-ID: <VI1PR0402MB3871686102702FC257853855E0B60@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200515184753.15080-1-ioana.ciornei@nxp.com>
        <20200515122035.0b95eff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387165B351F0DF0FA1E78BF4E0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515124059.33c43d03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB3871F0358FE1369A2F00621DE0BD0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200515152500.158ca070@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB38719FE975320D9E0E47A6F9E0BA0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200518123540.3245b949@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387101A0B3D3382B08DBE07CE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
        <20200519114342.331ff0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <VI1PR0402MB387192A5F1A47C6779D0958DE0B90@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200519143525.136d3c3c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e481adbc-1eca-4f2b-7b1d-08d7fccff6e6
x-ms-traffictypediagnostic: VI1PR0402MB2765:
x-microsoft-antispam-prvs: <VI1PR0402MB2765033C27804D38681C59B3E0B60@VI1PR0402MB2765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sxGdgQZS+3KheI/ICmJQS34dlr6Qwat+Z2f7Zdcb/u4qsh2Nc3XCykMVrHPiUiND1FDW7RtP3nLvYTLkvOHolEQgcm/OUTZtMy8fAyq22f4Tio9LPZdh5QaOjoTadkWkE6FEJCVg+xNCaigQ4I+rBWDrz2I3ZA9r7LDNe54DC2VcdfPoe/oPvm4ojy4K62kLxDf9VHeDLg9LVcD4OJQ219OaDiR1DiUSdrRGAyj4Zgmh9pymihvdJG3OtGXlxtHJL9mEigAVZj4U6lKYXvqlE3qfyHQg5mHK6t+4+tKDDdV78XJbT6qctP2gwaHM+NED/redb6YVsE9/jtdmqUvGZZEAUwQaeuadsq82RUny7wl9OSpr6lDIUM3tS4CkHMkXEnWeeQ+oE7KeY0pD7Y1B0w2IH6oCBdyjvmdoJ7E/D1e3GDn0hLykJ6GGTD+1piWM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(66446008)(64756008)(66556008)(6506007)(86362001)(7696005)(8676002)(66946007)(8936002)(71200400001)(52536014)(44832011)(316002)(66476007)(54906003)(6916009)(478600001)(5660300002)(9686003)(55016002)(2906002)(76116006)(4326008)(186003)(33656002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /5JrPoHg/Q/0e5ZPi/1zeC7mGZ7wYNUNo9QIOTHbaZi9b6yAOSNZ4KpT8yAdA+NqHD1r1a0FhTFDmG19fTKNtEbDVbs5tTFA+y4CgcHeNezfuLm7TXSLIKv90e7nHkj8iYr2INbK0fK4q8CtOM241U08AkrfKkepwRnUh15j3U5M2SDQzkTfYiFs3PN5IUIo4gQktoF9tQvLmrBFbNlPA4519AdBY2KtfPq1VB3XCn1DDl+LuQIUFOS5Bru9k6YPPrAyUKeeZ0MzMxlbsLzhatLBOw1kqN97HodEGp392BDhWdYlfk3Vet4OVsZ2qAWjhb/IoMX/SXxY5MvMnNV9MINU6HsAg5n6TTtXTAQpVYdrEzxRRNWu/yUp6V9vI//EWKzsbRexfEG+bTEzNv7Q5AuEyzOWV7RhgVfHP+RfZOKMrE+e7Y25Dzw5tjkzUIStLKzvlXR97LUp0wsqwgZEst/lrF19rYJbyDaqUiIXSVOcwfcpdvX/yixo2lrY08HU
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e481adbc-1eca-4f2b-7b1d-08d7fccff6e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 15:10:42.6524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJaVYnlpYh37kJubwsRsVWJRzMqskbzL8Gb+pSSPzFunD1SDsT2YK5ElLO9hYj/xjGpJgWdf3S+uDcR3hhjBMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH v2 net-next 0/7] dpaa2-eth: add support for Rx traffi=
c
> classes
>=20
> On Tue, 19 May 2020 20:58:50 +0000 Ioana Ciornei wrote:
> > > This needs to be well
> > > integrated with the rest of the stack, but I don't think TC qdisc off=
load is a fit.
> > > Given we don't have qdiscs on ingress. As I said a new API for this
> > > would most likely have to be created.
> >
> > For just assigning a traffic class based on packet headers a tc filter
> > with the skbedit priority action on ingress is enough (maybe even too
> > much since there are other drivers that have the same default prioritiz=
ation
> based on VLAN PCP).
> >
> > But you are correct that this would not be enough to cover all
> > possible use cases except for the most simple ones. There are
> > per-traffic class ingress policers, and those become tricky to support
> > since there's nothing that denotes the traffic class to match on, curre=
ntly. I see
> 2 possible approaches, each with its own drawbacks:
> > - Allow clsact to be classful, similar to mqprio, and attach filters to=
 its classes
> (each
> >   class would correspond to an ingress traffic class). But this would m=
ake the
> skbedit
> >   action redundant, since QoS classification with a classful clsact sho=
uld be
> done
> >   completely differently now. Also, the classful clsact would have to d=
eny
> qdiscs attached
> >   to it that don't make sense, because all of those were written with e=
gress in
> mind.
> > - Try to linearize the ingress filter rules under the classless clsact,=
 both the ones
> that
> >   have a skbedit action, and the ones that match on a skb priority in o=
rder to
> perform
> >   ingress policing. But this would be very brittle because the matching=
 order
> would depend
> >   on the order in which the rules were introduced:
> >   rule 1: flower skb-priority 5 action police rate 34Mbps # note: match=
ing on
> skb-priority doesn't exist (yet?)
> >   rule 2: flower vlan_prio 5 action skbedit priority 5
> >   In this case, traffic with VLAN priority 5 would not get rate-limited=
 to
> 34Mbps.
> >
> > So this is one of the reasons why I preferred to defer the hard
> > questions and start with something simple (which for some reason still =
gets
> pushback).
>=20
> You're jumping to classification while the configuration of the queues it=
self is
> still not defined. How does the user know how many queues there are to cl=
assify
> into?
>=20
> Does this driver has descriptor rings for RX / completion? How does it de=
cide
> which queue to pool at NAPI time?

DPAA2 has frame queues per each Rx traffic class and the decision from whic=
h queue
to pull frames from is made by the HW based on the queue priority within a =
channel
(there is one channel per each CPU).

If this should be modeled in software, then I assume there should be a NAPI=
 instance
for each traffic class and the stack should know in which order to call the=
 poll()
callbacks so that the priority is respected.

Ioana



