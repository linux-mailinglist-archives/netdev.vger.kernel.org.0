Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19BB812574D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLRW60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:58:26 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40396 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbfLRW60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:58:26 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 1C13EC008D;
        Wed, 18 Dec 2019 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576709905; bh=+qTzywm50kTuyoyihNSQtzaZ71TxQNvLwGvVdIQzmGc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=CTzlg/YogWZObWJAZA7FcvWzOYYryveScvU5GYqmxDYQ7ljc8Xk3KQRQLEqmB/jpS
         YQHEe5CK1YnvwgTuN6w4j2WCdpJl0Eeae43ME7FKn5olLBX+qkxRrRUnSH3lIOcoui
         rvNwWtyrIaA83luro4q62kZu9TPyav/wsRLC18eyw5P8SFVNk6JhRMDwoxHBsF+tDy
         8lON1vGPzrS/OywAnCnBssPNPTptnE03Lb+TPszjxJ/AyifMk6mmSr+q4zOyTRuDhw
         UCdapijEy+H2mb2n9nIKspV7X1TDyVrlPEbCALqNsfYq8RZ5frZkX22dJPMA2Sxp3r
         a/oBz9p1JqC7g==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 87324A007D;
        Wed, 18 Dec 2019 22:58:22 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 18 Dec 2019 14:58:08 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 18 Dec 2019 14:58:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkzwIzQRyJP1bpyDn/iRP4X8hKxohHKiva3Zgduyua6Ed6jP4dltd55A//sbGEV8Kfvfg0ZlWpgZYZ9LR652CdgmjTLtxu7UL5XKU7iW7Mf48J77pHL7ParO/woMHwWl9CvORNjCnSKB8rzQ+iyNbkdEo7vZ4c6qHvUpcjhG5uNmH74Heg39qiqsET7SXnd/d/DjLebzWBDmopmnS5r2lwuTQ304waSC7QZfXQpmM/4nO81I50qqU3LqLXOAdz51ssXMs4wFzo8c9NRV0qYwqhhl5mpMKfp+Ceu8eBro/VtLcTpP8N0wqkDrZ/8QUkk77UGOaYwiF/iuiDCh7C47Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qTzywm50kTuyoyihNSQtzaZ71TxQNvLwGvVdIQzmGc=;
 b=lqyU607ZRRnHvr51+Qa2/LT2NRReIhhqxQgUPwwh6UN9fVcZHq5KX+CiCd5GZQpDbUoRHD6BdoV1oZI4OEuQbKV4dMN8JEuKeTFM9hk0gsA1lv9BPjKx5usX+XOQKRcpzL2qOxglacw7DpdXFHTS+qgrOdCFS8Mx3inkSqhlW2oovsZVdSip6q7HJSO4rbs/Uj2J/KmjgO3bZ94hoICx9AhEhQn3WSedXNaxTQCkxq/6dTTbgw49AbRqsFOb+UWrnAGV3WOlXd2g3gq9GC6gy8DBPHxzyXJJhtH/DJafs8S1DOx/0sWs3/Z4DFYxifHUY38oD46YNnMfbjMzOL3jzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qTzywm50kTuyoyihNSQtzaZ71TxQNvLwGvVdIQzmGc=;
 b=a4cBc5+8WvSgRG4pQewlrsTa6znVmXVF7Vv198Gel3LvgEbqC/aPrNLEvZGmVMdwAc671qxTfx577U02LA5nA00vCOhB2MWhGyOcJnbTR2KQqvYFFtR+81H6AsUhJooIiU9vUlylhqGr8J2n8Q8dE6v4DVZq+bNjpJl3/vtnuq0=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3329.namprd12.prod.outlook.com (20.178.208.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Wed, 18 Dec 2019 22:58:06 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 22:58:06 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the net-next tree
Thread-Topic: linux-next: build failure after merge of the net-next tree
Thread-Index: AQHVtfMckJGbhj9DeECqpvEANajkfqfAe4tAgAAFb/A=
Date:   Wed, 18 Dec 2019 22:58:06 +0000
Message-ID: <BN8PR12MB326619ED786CB106BF6653A7D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20191219093218.1c1d06f2@canb.auug.org.au>
 <BN8PR12MB3266A7474D06616B7770AAEBD3530@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266A7474D06616B7770AAEBD3530@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [198.182.37.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24cd2b3e-c924-4917-1873-08d7840dbec7
x-ms-traffictypediagnostic: BN8PR12MB3329:
x-microsoft-antispam-prvs: <BN8PR12MB33294DFD462061EC65D9B889D3530@BN8PR12MB3329.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(376002)(366004)(346002)(189003)(199004)(9686003)(478600001)(66446008)(66946007)(64756008)(66476007)(76116006)(5660300002)(66556008)(316002)(33656002)(2940100002)(52536014)(55016002)(2906002)(54906003)(81166006)(110136005)(7696005)(558084003)(4326008)(81156014)(86362001)(26005)(186003)(966005)(8676002)(6506007)(71200400001)(8936002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3329;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uh6W2fHekCPtzLNsIWFpfSAPUhpox2kK7yyIskTsCrsg4xUk6cPDL5vfbkpJusTGqKr8B4PR5v+SnuaD0H52UtN/+3SX5NVH14VwDjysqOYKW3cH8b0zzwVjOHB8t3V2Qa9oB36Upx9vKLIu2DVMmj+aiVKN0RRdEm1RRezeCh2Q3ENdsC/4heIURUsyPSTfvN+h/83rfOJZwZhvVzG7eQY9H0286aMiKmp0qGI7Q2XWdxeL/XyVQ72veigGXmV9CesVDHaM877sAGtM66erL/KVCcaqtufIheqy8REfPi5gtcxF+To/4wauAvRW67KyrjzoyneWOuAzTEPrcsxgAaT5tb9yuo+dPt7oIIikO23ui6rHq0f9P3MfKtj6+MMFl5+kJJON0aBdIlOpPeL9M4Y4r4BT2vXKTbJGgjhMxohypngP/EV0l9RE0UtmWvpntqm6hq0L1fQnKsB1P9MFOPY83hSd1+CdQiNtYImHPWjY+2vxrgMbJVUwBzi+hyuhKhOaiRNXO4yPr7fHK4UR1fxkmDXDPpz3OQBL6jDNnZo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 24cd2b3e-c924-4917-1873-08d7840dbec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 22:58:06.5145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zEpOfN1gUe2/du7eXNgv6TdPLUz1ELalidUT44BXHWX6LJ5eQT4cpqpidoTEAGgEKktNxVd6UlZxypqhHbroPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3329
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>
Date: Dec/18/2019, 22:38:15 (UTC+00:00)

> I'll try to fix it still today.=20

Please check if following patch makes it work: https://marc.info/?l=3Dlinux
-netdev&m=3D157670971305055&w=3D2

Unfortunately, I don't have an ARM compiled tree right now to test.

---
Thanks,
Jose Miguel Abreu
