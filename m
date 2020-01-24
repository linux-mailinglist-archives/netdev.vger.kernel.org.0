Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F887147A03
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgAXJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:06:52 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:59790 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgAXJGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 04:06:52 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D80D6C05F9;
        Fri, 24 Jan 2020 09:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579856810; bh=B9/ix+mmZdCz/VXSDmoaZAfDiv67BVzD4gXN3dS/60Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=OFoQ1sChZPAiWGhaZwuZdmwJ11ekPMc4e0y3PmIsJ/dhbJ+F2sy3HR2pMAWGBSFl7
         514AdUFVULbqyc85dligEgNA64NwSboUh+40FSekyEP4qEx1mgqGmx4mJT651yAClf
         h6kEZaKtjqoY/mz5ILnUA3n/89sEzQPli460rAYRij9QexgIaCVqO2IAZyuLgP6GOZ
         Jvxie3kH7fT7Q3Ytc4L4LxhxB5dLmoU8CDzE/5zhY7XQG4p8DjBlFB0ZMq0EAw2k/Q
         JO9rdbrTK8xcTv6qQc8aPhbI/WPzcyZA+r8eywkF+ARsMj/JJS3rblKZdcfAHE2HQG
         RujL9sd4erkmg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2BF19A008A;
        Fri, 24 Jan 2020 09:06:47 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 24 Jan 2020 01:06:40 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 24 Jan 2020 01:06:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIgasLu9ykdjPTJzz6ECyi9reVwbu2daz4cIpjDUxDRk1xCg31ce2nofGkkGD2VA3nDD2OazRwsq1LmUsAt97GFtBAAfY573v5HmyF3f8S0iMKJvaJ/dPWxhKYphtLylgl60o52YO54nODSvONEr4bRGjneA4zsNtupQz8V8QvXmBz0daKZFUAY/Sd/fb9WMLZg+586R49mNUqBr9hPhrBQCNoikiIbmWQiaGxWBCC6tTqaO7R0nuFZZU1KB/zZouwb2vjGFF0dXZ9oIKFkQgFTgDNmk2+1CmNIZLx1bEDkeCjIWqIUWcz9kYOp+SZmTTnDmR8ywj+bXvO3bySkzYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ6tZH+lMeJ6McxmODpH4utPlwV/0M+XLYLcSMxQlYE=;
 b=gTzj4/Qv0ESaRRL0WKBnbZAtKlELPh268g1L93+7TxC9fBOUEyVdQyt3gJOVqy3Xhp7m7/iFqe67gre10+3k4I4LO+qxCzwrfUl363hgakWso8kkfs/vy3liKft0sjPM00aubPm85MDSXQ5t2SaSIFMZAY9Z3fenJqiHBoUSAy8CpZ70EpKz+kEuVKl3sQV6YDEHlDlkLUYr2U3fm/179kAp0JGqrLlF1VeeSk1hkTd9cFdDaWvh2jMVTW+3SsMlu76Iy6R0y0sjFmWCMqSW5prpuXV4f5ureJANZqBk3M4i+RWNWHHUnEIUkMg7pm1gMhnhnUNaDD8QqDKXLEdzWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ6tZH+lMeJ6McxmODpH4utPlwV/0M+XLYLcSMxQlYE=;
 b=BITs6njeVA3+yw56vEonftR6Me02RSBPsJ7TRziUTty7u6xEp37msBf4H/3iiQ+gJhYFsY0H2ha6uVtYcTfHiIj+CvFh+7A6ArX7UsuXCEphBG9gAiD34tkqDvx0Ouubra+esiepe7n/H2YLaWaCPgA6ikWbp5nd9VKt3vJl6Lg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3394.namprd12.prod.outlook.com (20.178.212.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Fri, 24 Jan 2020 09:06:38 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 09:06:38 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Tan, Tee Min" <tee.min.tan@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Joao Pinto" <Joao.Pinto@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Alexandru Ardelean" <alexandru.ardelean@analog.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3 1/5] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Topic: [PATCH net v3 1/5] net: stmmac: Fix incorrect location to set
 real_num_rx|tx_queues
Thread-Index: AQHV0QPdI0TP73liMkC6zs86z0tb/af2cgbQgAMURgCAAAEuIA==
Date:   Fri, 24 Jan 2020 09:06:38 +0000
Message-ID: <BN8PR12MB3266EC19F5E12FE94FF153E4D30E0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <20200122090936.28555-1-boon.leong.ong@intel.com>
 <20200122090936.28555-2-boon.leong.ong@intel.com>
 <BN8PR12MB3266F0534CE20CE906AA3C06D30C0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <AF233D1473C1364ABD51D28909A1B1B75C488EDC@pgsmsx114.gar.corp.intel.com>
In-Reply-To: <AF233D1473C1364ABD51D28909A1B1B75C488EDC@pgsmsx114.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4935d33f-db7d-4c3f-e1ff-08d7a0acb87e
x-ms-traffictypediagnostic: BN8PR12MB3394:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3394240809E66EC095599FA3D30E0@BN8PR12MB3394.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(346002)(376002)(39860400002)(189003)(199004)(7416002)(76116006)(4326008)(7696005)(6506007)(71200400001)(52536014)(9686003)(110136005)(81166006)(5660300002)(8936002)(81156014)(478600001)(33656002)(8676002)(66446008)(64756008)(2906002)(26005)(54906003)(66556008)(186003)(66946007)(55016002)(66476007)(86362001)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3394;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ET15XBS2zOx3O4bTd0xbkXQkOKBbXxUcKsqFmuQsytXZm6qcZtn6L36fQ1Q29TNL4hxxBojmML6ByhFTFVtI/wzPwGQpfKmAgTQpbbaVjWmd4fsF3TXGmmUs8O/4KP0Jz5scbIEHuaJLc2vvYvZn/RmHf3wk17/Pl1BbO3iiC7cElPxnoqSDhgnozarHKrJ18AKot/l3Fq783L9btfDujlC0SBj05HaJ5d4Q5Aj1bbDTyO1TH9dQaIv4WQJXCWpMZc1MROq9ul0sGpR2Bf0ax27POn5XP2vHtMsmjhMXP3Pf0SyAFSCZXWtewIDYcaCTr5IF0QWmtxT7oSH//0AVYt0JhNshJioMUiBULd5m0OtfoUxAEnTqqsHq5/xkLrdtWYihs2dbYOIDUZf4xNIeH7Q7zYarBDEC5DuSkh21GzYq0zQcLygHcxQPI/HpaV40
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4935d33f-db7d-4c3f-e1ff-08d7a0acb87e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 09:06:38.4537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FbPiWQ2F45ekCFb1grbzy+Zi1QViF0KEKdXE6OiOMX77Yu6jw32jp4n1rzceEr9PzuNouvqDdSN/NyayXj1TgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3394
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ong, Boon Leong <boon.leong.ong@intel.com>
Date: Jan/24/2020, 08:56:28 (UTC+00:00)

> >Why not use rtnl_is_locked() instead of the boolean ?
>=20
> We know that stmmac_open() is called with rtnl_mutex locked by caller.
> And, stmmac_resume() is called without rtnl_mutex is locked by caller.
> If we replace the boolean with rtnl_is_locked(), then we will have the
> following logics in stmmac_hw_setup():-
>=20
>      if (!rtnl_is_locked)   ---- (A)
>          rtnl_lock();
>      netif_set_real_num_rx_queues();
>      netif_set_real_num_tx_queues();
>      if (!rtnl_is_locked)   ---- (B)
>          rtnl_unlock();
>=20
> For stmmac_open(), (A) is false but (B) is true.=20
> So, the stmmac_open() exits with rtnl_mutex is released.
> Here, the above logic does not perserve the original rtnl_mutex
> is locked when stmmac_open() is called.
>=20
> For stmmac_resume(), (A) is true, and (B) is also true.
> So, the stmmac_resume() exits with rtnl_mutex is released.
> Here, the above logic works well as the original rtnl_mutex is released
> when stmmac_resume() is called.
> =20
> So, as far as I can see, the proposed boolean approach works fine for bot=
h
> stmmac_open() and stmmac_resume().
>=20
> Do you agree?=20

Can't you just wrap all the HW related logic in stmmac_resume() and=20
stmmac_suspend() with the rtnl lock ? Seems like the right thing to do and=
=20
you won't need the boolean.

---
Thanks,
Jose Miguel Abreu
