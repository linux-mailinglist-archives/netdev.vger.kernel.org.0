Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62FE125767
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 00:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfLRXIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 18:08:50 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:40770 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfLRXIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 18:08:49 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id CE144C008E;
        Wed, 18 Dec 2019 23:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576710528; bh=7rwpGpknN/g+CETjF0qfoXSCoaGGkWkTdhX4qZ2g8kM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=lea78K9Mt/015nY/LYZe6z9s/uh4pRqIdqfcGNpq2liNgMUb5WRaNbd1xobfm6siF
         9WMXIPkiCpGTZ2tlpv+Fsg6bmDH/nK3BTKRM8ZYvJWyxp65uy38F1fNnE2VDMqWTqa
         WP7FLESOWaHAOSB22lZgrhdzqHuh+b3wT7areNDoW5UhBDjhyb6E9oK5RXn+bev/B1
         xridsKindB9sBFmIvAWZD+uCcyX4RxaeuDfKP2D1QyynE/i3tkscV19u16vKaFL+oj
         3jtv5pLLYZ6e81N3aheIbViThcXAqTGALgeDVcAAo3K/uLNHuWplaQFacqa2STzl1/
         JwnLajiaHZcPQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 94FE0A0067;
        Wed, 18 Dec 2019 23:08:48 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 18 Dec 2019 15:08:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 18 Dec 2019 15:08:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIoEh1kwF8oUeXFuSaPzw0osm4awPkZP1Hp9OS6Cl4csLwpmBSuvMDCl2fQTy8EXDfd74VGG2j5dEdi2uq0wuj4Qs44gGjC3//ZYOEacMhLAHVcqtW2Z0/he0RrlnhudlyBs0DUh5jCuRPp4R7GuInjuEHT6ABGRHgPBpsoam6+PjkpH+u4tXWRa9BC/50fc9PL4WteWsYMsuekMZDqSenaZvCBQ7845TAY/B4tuKJHMd5FVqr47TNhXtIVNGw4bPI1vTpFeaMERPtc5PpSokcWsN9JAOAfUNHyffp3c4P27lvlbhN6Y+7ywaaXvV0cTzZbpT4rRgZlCw2EfdhpzQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rwpGpknN/g+CETjF0qfoXSCoaGGkWkTdhX4qZ2g8kM=;
 b=Ayly8HKnDZ9bes7ctCswh47c6mkU7wWb/DC4spCdhPVMaATgOitxl8Ub2iClXElf/j7kq74nCB0dPiqkuWdgSyNngrRjinEL4B2gQd+Oxu0oI7IwIVpYPnp6XmaCx1SoCfqTnH2V/LytRbD/Q4sp0hP2z8OUJkkE646jT5O+cL63w8WJSincTV0N0Fc4+W82Pd+666RnMRRKaXxDi5aKDB4vifkEij/XFDrPl1aKjPrp7NNvGjr1wSqg/D5F29nKrqW3V2IVYD5AcWZfOYPIy8hP6qWyb+tAoH/fZ778B3SA7JTwNWFD5cvRjEKGeXhZmSXQQtmfuqzlh4lmPiEMyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rwpGpknN/g+CETjF0qfoXSCoaGGkWkTdhX4qZ2g8kM=;
 b=OZ2O9KzdMK4kOZ/Ln163T8i9sLU4u01X5pX1k5AmvG2Ko4gH6m/8g7gCHRJr3AoHschlNGpkftJussX5C4RluqyMtag+DaWwGBdClZoea9FrtfiGChjeKEnSaDa5JVVi1MdY7Ica9brFOJndFbqVKvJCX93nK3aTmYp0iR9gB0c=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3140.namprd12.prod.outlook.com (20.178.209.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 23:08:46 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 23:08:46 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
Subject: RE: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Topic: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
Thread-Index: AQHVtOPaDcyycxk/7Eqs7zmpoaCgzqfAhW2AgAAAN3A=
Date:   Wed, 18 Dec 2019 23:08:45 +0000
Message-ID: <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
In-Reply-To: <874kxxck0m.fsf@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 952264aa-ac95-40e6-bde3-08d7840f3bfb
x-ms-traffictypediagnostic: BN8PR12MB3140:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3140455EAD14EF21F8827360D3530@BN8PR12MB3140.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(189003)(316002)(66556008)(8676002)(66476007)(8936002)(71200400001)(66446008)(2906002)(52536014)(33656002)(6506007)(64756008)(26005)(66946007)(76116006)(81156014)(81166006)(5660300002)(478600001)(55016002)(4326008)(9686003)(86362001)(110136005)(54906003)(7696005)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3140;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WOx/YN936UfkvksvV2lb6aCPgCwtMDDkNk5jXhnVdsSWgyPoC2VVRdKmPc7v48GvL4sPgEoJQWSfIqWTqRzcDDr2ZTQQJr5XA3F6FoCueGxHLVVtAMNW33fagDgkD5nDgeFVrKUyA0QhGvFPHtpzh7uTPCxo0SFEJO0hk0ihOIbtLAyrFsZCV/QspcMeJH6ArWpBTSlxSKb+wSkwALXBqRTl1emU3CgFkaQVRDBAk0ax62QYtCETChSsW2PVYbnlLijDFQ/D9PMRIbDWC/+d3mz+gBGC17kX5LtXhRAeIOCPkPVQxUWLC6dae2NiPpRYb0pRVp/+WXErMT0YfT+u50Yn0vkMX0u3Iwholbd+3VNdKjawRJzXf23WFL6b4pmSHp6j6FpJ1lxCOYC22DHfeAnlaBxBliQo8JM+lPW2EC8r2A8JQrKrLrWJwQqT54IK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 952264aa-ac95-40e6-bde3-08d7840f3bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 23:08:46.0655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWWJtVHiF86LWtsZl8OY3HosVGCv7UT4GghZIFuRRDrlKDaeCt6JMnMY5hCo7gyLaPgg3aaY7ESXV4NwnyxG+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3140
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Dec/18/2019, 23:05:13 (UTC+00:00)

> Hi Jose,
>=20
> Jose Abreu <Jose.Abreu@synopsys.com> writes:
>=20
> > Although this is already in kernel, currently the tool does not support
> > them. We need these commands for full TSN features which are currently
> > supported in Synopsys IPs such as QoS and XGMAC3.
> >
> > Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
>=20
> This patch looks good in itself.=20
>=20
> However, I feel that this is incomplete. At least the way I understand
> things, without specifying which traffic classes are going to be
> preemptible (or it's dual concept, express), I don't see how this is
> going to be used in practice. Or does the hardware have a default
> configuration, that all traffic classes are preemptible, for example.
>=20
> What am I missing here?

On our IPs Queue 0 is by preemptible and all remaining ones are express=20
by default.

The way I tested it is quite easy: send traffic from queue 0 and at same=20
time configure EST with SetAndHold for remaining queues. Which means=20
queue 0 traffic will be blocked while remaining ones are sending.

---
Thanks,
Jose Miguel Abreu
