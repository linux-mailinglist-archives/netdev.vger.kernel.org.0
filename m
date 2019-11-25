Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBE21095CB
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKYWsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:48:50 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2550 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfKYWsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:48:50 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc5a4a0000>; Mon, 25 Nov 2019 14:48:42 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 14:48:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 14:48:47 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 22:48:47 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 22:48:47 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.54) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 25 Nov 2019 22:48:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Daqmrf1KOAR3gCgTAo7zBWFAPGwRrmvlbJVTKS1smpO8NsZ6lsIKHPow5e4xffUV0Y9sqxzQY5x2gAVyQu7gxrer4HExlAHaQx+fpRWppPmiL8sNSkBZMs4hFY+yIiN8c6xmqa7jBqPrS17aYFgUpPg0+q6IviUISRLMrN1kQIT2ZKR6gvFt65LLHp4D/Zgmdk//khDMmAYFRvjOeFBcqpKSga9HbdX5KY0R9Y0ah4DjJz4lHrnTlpyXnpn1kAcdDRUX+OaRIJpakKu55vncQckL55ofbc6jeM4z79NW+MY46HRXkqwtjPnYL3ZkWtxVVRc8Ne9HRJ2K6Os7l4ubTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1fOnadeQKNr1wFw/xffcmftqBpgWsJMdw2BD/LRNnU=;
 b=UkCfWOaDszDWKdlW0Tzv15DdLp7r2mmG4j34SsKb7F3WprZys/0Dr9rQInsUj2zgcMbwme3tPOSjFOgFGMW6CaG4P8GFl1+RTK0zKyJoEdMjoy4Fqlz08U9sr5mSAbgpcWVGXFatQ0NGMGCDVNaC++wNYHrSyx8T9fdOkYtgoaR5c8AwkCLu+GwbwT5/AgCoPNaUn2qAM1HHtcKzF3BvxTZsJ15XGPGZiWst3Dzld7vSaDn+NBmOSGItPTiOG0d9RLSJ/mH3HLeIR1Fjp09G/RcNDmDNYAT1bWYZK+PENQ2pL29Ia07OjMMID9m84QOaOooG19fabJLVu+S3pBSAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2727.namprd12.prod.outlook.com (20.176.253.214) by
 BYAPR12MB3622.namprd12.prod.outlook.com (20.178.53.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Mon, 25 Nov 2019 22:48:46 +0000
Received: from BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::8d3d:d3ba:cb91:c060]) by BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::8d3d:d3ba:cb91:c060%5]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 22:48:46 +0000
From:   Ajay Gupta <ajayg@nvidia.com>
To:     David Miller <davem@davemloft.net>,
        "ajaykuee@gmail.com" <ajaykuee@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: RE: [PATCH 0/2] net: stmmac: dwc-qos: ACPI device support 
Thread-Topic: [PATCH 0/2] net: stmmac: dwc-qos: ACPI device support 
Thread-Index: AQHVo9sq7y9rIt74v0esKmS7MzB+WqecefyAgAAC+/A=
Date:   Mon, 25 Nov 2019 22:48:45 +0000
Message-ID: <BYAPR12MB2727C21DF4F520A82272CCE4DC4A0@BYAPR12MB2727.namprd12.prod.outlook.com>
References: <20191125215115.12981-1-ajayg@nvidia.com>
 <20191125.143659.27849901302112844.davem@davemloft.net>
In-Reply-To: <20191125.143659.27849901302112844.davem@davemloft.net>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=ajayg@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2019-11-25T22:48:44.9262117Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_ActionId=175c54ef-f4ee-4a8d-ab56-741fd94b04b7;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ajayg@nvidia.com; 
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6177aec7-7a31-4fdf-0fe5-08d771f9a132
x-ms-traffictypediagnostic: BYAPR12MB3622:|BYAPR12MB3622:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3622418F54C1FD60B29E775EDC4A0@BYAPR12MB3622.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(13464003)(199004)(14454004)(66946007)(478600001)(66476007)(66556008)(64756008)(66446008)(966005)(2501003)(55016002)(86362001)(76176011)(316002)(7696005)(5660300002)(102836004)(8936002)(14444005)(256004)(54906003)(110136005)(2906002)(74316002)(229853002)(7736002)(305945005)(4743002)(33656002)(107886003)(26005)(3846002)(71190400001)(6116002)(186003)(4326008)(71200400001)(52536014)(6506007)(53546011)(99286004)(25786009)(66066001)(81166006)(76116006)(6306002)(8676002)(9686003)(81156014)(6436002)(4744005)(11346002)(446003)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR12MB3622;H:BYAPR12MB2727.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p06uwLiuTBxxeHiN+kdL+Q7awWaMBanCLlePEBH2hPw7NyMaAX0C97eGKCZk/iklpxQBxm5ywrVABUIr8dyklmUj3DLd6as6L8FwJiBBfdWpIHajai2toGV20zhFjpKRxwP7190ThlZyqU+91QUjAlCiqu36AuELrMiKg+TGUdcsBuhX0RO5vgvZD+3UQr9Gj1H1BcgQkQSKSiheJuWPm5Bo+vpfos0Uoo+Y6a2AP/wD/aC5ETwebPmi9G3pG4nkGNAUrNOptmWdqxvhJoE2cnSA3O6sCHY9+25Q0pmYvzrNtDuBoZLXmMb3jRuUJzbfAQaVqRoPZvhNQWntWvyXFnIWwp9x9mo5VYqriAJ4LYs+8A8GB1QQr1xf2P8S6Oc0XT5MIO3gu1NHAQAannp9+H47pWxoNjxrN1OL4klHCMBM0O1Ek926EjPAfvpW2taB1a0X0gmVWLStz1fq9npz2B115saczL6u2CzsXsTVonU=
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6177aec7-7a31-4fdf-0fe5-08d771f9a132
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 22:48:45.9853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NSswVRaZg80LczXQh6nPaEGPoYD/02ho5jcoW/iurLhtjNVkekd9xIT2+0TUKXd6HGTT3CXt/thv2Dp/BNZGOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3622
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574722122; bh=u1fOnadeQKNr1wFw/xffcmftqBpgWsJMdw2BD/LRNnU=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-purlcount:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-forefront-prvs:x-forefront-antispam-report:received-spf:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:MIME-Version:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=NjSnVEiQR9yZgKYbAgE4nz2slkub806Dpkpp+dugwCvpaSDrqz6jRYIEUqdyY1d2W
         oYwqpF1GozmIxoAfR0YAPnic9qbbiRSBaR9A0pqrYgjB+MhkjrHPU7epWgqsIIbARW
         1DQrupBgwLtU0P78eQfZ80/ekAhSK432JnBpwDlu9cvLl9W0SE6Zz0ruv+3MkZSe8J
         Y6CiPw4RwafthWfiVD97aDjayp9LjNOCA0/yX20gqyeosAk+YlqMzFbXcoZDj4EAlX
         vvI5b8idpXU4se/v0fPAPRkFAO4EF4OKWW+jhmZf3fmTgjYFu1ZtGl6A1W2lB50K3Y
         SDGVUpCe3HmQQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Monday, November 25, 2019 2:37 PM
> To: ajaykuee@gmail.com
> Cc: netdev@vger.kernel.org; Thierry Reding <treding@nvidia.com>; Ajay
> Gupta <ajayg@nvidia.com>
> Subject: Re: [PATCH 0/2] net: stmmac: dwc-qos: ACPI device support
>=20
> From: Ajay Gupta <ajaykuee@gmail.com>
> Date: Mon, 25 Nov 2019 13:51:13 -0800
>=20
> > These two changes are needed to enable ACPI based devices to use
> > stmmac driver. First patch is to use generic device api (device_*)
> > instead of device tree based api (of_*). Second patch avoids clock and
> > reset accesses for Tegra ACPI based devices. ACPI interface will be
> > used to access clock and reset for Tegra ACPI devices in later patches.
>=20
> This is a new feature, and thus only suitable for the net-next tree, whic=
h is
> closed right now as per:
>=20
> 	http://vger.kernel.org/~davem/net-next.html
>=20
> Resubmit this when the net-next tree opens back up.
Sure.=20

Thanks
> nvpublic
>=20
> Thank you.
