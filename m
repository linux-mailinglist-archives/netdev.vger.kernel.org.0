Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263E01410C6
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgAQS2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:28:54 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12436 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQS2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:28:53 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e21fccc0000>; Fri, 17 Jan 2020 10:28:28 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 17 Jan 2020 10:28:49 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 17 Jan 2020 10:28:49 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 17 Jan
 2020 18:28:48 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 17 Jan 2020 18:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1wuTQhMyD4n8vsVeGXmg2P2Xz1vONO6s7k5TPNuc3aDtPwi8Xyu8kUI3BbldfNDLBAQRo40Ea7rSqNfry4y8cistdR3NTM+qWxNrwlgKQO7WiUnule9Hx3ZQmwrQaNhbhRshnL8UTX2cVAAGYycT4Vn9Wt9l2PRjRCAIx/xNXf13AAeAyQ8T394DES/nj7YD2+MxdRlQbW8ApANA9ozniydVjlz83nD5H30tcqTMzTWM85nGu+3jNARZW+W+YEPp3GMmF9JNCwxcav8ngz9w1PxDXA1BI6otUWFMi/DV4vBAsOBCiRPOjs4EMSHE3Ap0j7v3WKeJ0KEBAn8pdn4cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXp8th8oTg3lOaYCJo3W6fMFmjHuPFUGFdkHR2Ynbns=;
 b=H8iT1M+VWH6vzDPmU36wU1prch/eGNwO+gQwoeof+SmdFoT8P9PwmU4F9CT/dkMZhkRhAbUapwoF2MMIWZPJBs/Pa9ecVXNFeW0kXVIpcVf6E3LYHIn0Ue7LEUpY6tnEFwLKZOIV4sdjyB9TdN/KT0jP+AwN7Aet1aZtd+i0yQ3sFLkvBW02HZa230go9gyj6kVRbIy3y4Y72YcFuazd4B9KA4i2M6gzfN7eIoXroeMc6xrG8HuwILVHNDFDaUoAEI7NgAChJaVuJ5nHR1dhccDiDTnLwylDFJYCeHYBFcbLBGeglzsU2LRMn3fBUGdiDiOMb1L7afGnuVRRxreC+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BYAPR12MB2727.namprd12.prod.outlook.com (20.176.253.214) by
 BYAPR12MB3591.namprd12.prod.outlook.com (20.178.54.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 17 Jan 2020 18:28:47 +0000
Received: from BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::9c2:6e7d:37ee:5643]) by BYAPR12MB2727.namprd12.prod.outlook.com
 ([fe80::9c2:6e7d:37ee:5643%7]) with mapi id 15.20.2623.018; Fri, 17 Jan 2020
 18:28:47 +0000
From:   Ajay Gupta <ajayg@nvidia.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Ajay Gupta <ajaykuee@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: RE: [PATCH] net: stmmac: platform: use generic device api
Thread-Topic: [PATCH] net: stmmac: platform: use generic device api
Thread-Index: AQHVzJm5YPylWrXNC0OEL/ItEl/L0afuh0CAgACnYgA=
Date:   Fri, 17 Jan 2020 18:28:47 +0000
Message-ID: <BYAPR12MB27279E65231B11985D3B68B5DC310@BYAPR12MB2727.namprd12.prod.outlook.com>
References: <20200116005645.14026-1-ajayg@nvidia.com>
 <BN8PR12MB3266A6A6A155AA7F3469CF94D3310@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266A6A6A155AA7F3469CF94D3310@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Enabled=True;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SiteId=43083d15-7273-40c1-b7db-39efd9ccc17a;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Owner=ajayg@nvidia.com;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_SetDate=2020-01-17T18:28:46.3421087Z;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Name=Unrestricted;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_ActionId=4cb59811-43b7-4a70-9c00-2650f462c98b;
 MSIP_Label_6b558183-044c-4105-8d9c-cea02a2a3d86_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ajayg@nvidia.com; 
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89678b7f-c6c6-4fbd-4685-08d79b7b1788
x-ms-traffictypediagnostic: BYAPR12MB3591:|BYAPR12MB3591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB35912F9D2335139E5037CDD5DC310@BYAPR12MB3591.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(316002)(4326008)(6506007)(71200400001)(54906003)(110136005)(26005)(53546011)(5660300002)(186003)(7696005)(2906002)(81156014)(81166006)(8676002)(107886003)(9686003)(4744005)(478600001)(8936002)(55016002)(33656002)(86362001)(66556008)(66476007)(66446008)(64756008)(76116006)(66946007)(52536014)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR12MB3591;H:BYAPR12MB2727.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: toi+3mLUT5tY0+AJ58f0Zq0m7K1bZuBQPUG+SwxRVjVlP5ZKflwF+6WFf0aGUwopxxvWrDJmJMSPsIcPHpejmY2BbLxW8gsnOC10e2PVqp9LFe+I9FOtm+JODiqfIW4dPot3sKjrLIW+gOZvZZuZxTV+PIuzZfs+iaVJPdLbFYMh5rVn+TzmVB5UOV5mo7MeWVJYmCF5w3/fuT4Ob0bLLVZd4SLcn1Gk559xL0fW8JaPOkgb8yPINryVuDVMgu9w5/Xhkxype3GvxZGWZfR5W/JH/wPI8MaGHkSkOvizS9CjJTIwI7eyqQ1BvDa3foRxr9FmR3z7mYoy2k19E1h7RSPZ+h2gXJRalLbHnh8S7TOHXFjOTl4aSkFb2oQsI2axTcpxAsntIJYs5nifabUl1mdCOziSlm8W10DPQtyQRmM1oPVqu79gwBMPPuTuLcq8g/FMmjHsTm5a7i0xgkH6mfK23/DnpzhYooxsT/553UBxVDWsHt+Xh+X6uqeQ8aDE
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 89678b7f-c6c6-4fbd-4685-08d79b7b1788
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 18:28:47.3174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: De/qoWw16ug0dlMjiD7kFmZa158FILqimSTUWRYU7obTUvQK4nBscefJGOYoz8WiVbZ0z7Lu2+yiYo+inzMpyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3591
X-OriginatorOrg: Nvidia.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1579285708; bh=GXp8th8oTg3lOaYCJo3W6fMFmjHuPFUGFdkHR2Ynbns=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-forefront-prvs:
         x-forefront-antispam-report:received-spf:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:MIME-Version:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
         Content-Language:Content-Type:Content-Transfer-Encoding;
        b=WTTZKLgbN8nWb8/JtJR/UdRaPoPREGIruzivylzX3IJGsviLUhNwqelzG8zwqle/r
         DGutAprxTa4tjOFNh1FE585+vjgt8xNGFrnl6LV6D3rEK2zMIElRqbQnizE5aBNdT+
         n6TmvBpjv9k/KobjaZ/PNPsVTIVd+9Q6zr68f8tNpY3qW3jgOjRZK+xwkiAoYZS1C9
         4AS1zcJhQ8HqhJ2VDglVBKyF+LICNc6PD0ekgUBOdNvMhfhWmdGlLB4Aw5zfFqcBWf
         dXbePAubLUbueTzJuR7fiHkxOezpk0C26/m3E5v284D+VpLit1Wf/9OoLxR52RBZXy
         o7TaVshlrZr+g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose

> -----Original Message-----
> From: Jose Abreu <Jose.Abreu@synopsys.com>
> Sent: Friday, January 17, 2020 12:29 AM
> To: Ajay Gupta <ajaykuee@gmail.com>; davem@davemloft.net
> Cc: netdev@vger.kernel.org; Thierry Reding <treding@nvidia.com>; Ajay
> Gupta <ajayg@nvidia.com>
> Subject: RE: [PATCH] net: stmmac: platform: use generic device api
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> Please cc' your patches according to "scripts/get_maintainer.pl" output.
Sure, will do that.
>  nvpublic
> ---
> Thanks,
> Jose Miguel Abreu
