Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1764178D08
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbgCDJDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:03:05 -0500
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:51136
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728387AbgCDJDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 04:03:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9ByMaz80G4uG4ck37yr9VHezHsxC3sb78cvy3yhSsPIWgmwVznjLad0YMHs1q7CmJKqVzKgwauWjZ4Pi704PJmMu2wktgyHYQQyEXvpLpz3i9SLBwD4ixeZW9owqnI8zQqyha8ybIPpYspDWTcNO6igSwaCKMAESEHMd5BYanSwijOkbt/kWvspZObJFVngtnLWIOn/uk1ZiPZYupaetrs6nwEbT8hCzurf3U7D/nAEwY9EU5Oi8dRdbb9SzRJf93jWiZsAEJvsB5FJ3kLltBbd4LzzyZ+8m2LeW+l++w8b4ACu8Ypq+Qk21FzOu2cZ0cUa1oDTf4Plp/h0om/CLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TFympW0IIO6eym00/RLRJbPBrNAfUvQ7TTuVZOFHzk=;
 b=HBVE6baHT8Tk+7pZ+Crd4lt3NsOQZOUUMGBbjTSInGPx4yUNwTZxB0uQNevvNsIWsvoPHggj0PWX4RoDwR5eIfKQk2TKcCpuExJJoQYey+4n+/c0CC7lMERaXcSahtWoeq9XG2Z6WEkXBFMXUW2l5Fga5ddZGWD08bAqGnocYdWS6uzgE15Y4qNfL1TGb6o1+8bgfIYQCXbYS3W687K2s0gIjimcoOgIUTroeqHpntab979otK4HD7N0QsB8ElmAWLkfLfxj3h9DuEriz0E6eSFHA12r0VFxpUqLIfgy5T9y8uci5qOmy/VJA6/AY8w6p2wT9o8ejB8yaU9wS78M6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1TFympW0IIO6eym00/RLRJbPBrNAfUvQ7TTuVZOFHzk=;
 b=NeDAyL4mmD/uqB+M/cBrdP1Ngb1fFIP5mD0pdTKZTNqFk17AuRkdGnMR5mcTIHYjxFtWxjxDaN7iuMGr7SRJjV1NtQZbjz0yX/VMqTaqjLcI8eYcaaTYxrRvJBzOHoq7btk7ke6X26WrxcnF4svqSc02J+KolJYwbDCUFGevYxA=
Received: from DM6PR12MB4331.namprd12.prod.outlook.com (2603:10b6:5:21a::20)
 by DM6PR12MB4467.namprd12.prod.outlook.com (2603:10b6:5:2a8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16; Wed, 4 Mar
 2020 09:03:01 +0000
Received: from DM6PR12MB4331.namprd12.prod.outlook.com
 ([fe80::21ec:b3dd:e820:bdf2]) by DM6PR12MB4331.namprd12.prod.outlook.com
 ([fe80::21ec:b3dd:e820:bdf2%7]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 09:03:00 +0000
From:   "Mancini, Jason" <Jason.Mancini@amd.com>
To:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Topic: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Index: AQHV8dW3tmU1vr37+0CwhBbrs7Fcuag30LmAgAAQz9yAAAL0gIAAMfBi
Date:   Wed, 4 Mar 2020 09:03:00 +0000
Message-ID: <DM6PR12MB433132A38F2AA6A5946B75CBE5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
References: <DM6PR12MB4331FD3C4EF86E6AF2B3EBC7E5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
        <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org>
 <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>,<4bd036de86c94545af3e5d92f0920ac2@realtek.com>
In-Reply-To: <4bd036de86c94545af3e5d92f0920ac2@realtek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Enabled=True;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_SetDate=2020-03-04T09:03:02.562Z;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Name=Internal
 Distribution
 Only;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_ContentBits=0;MSIP_Label_76546daa-41b6-470c-bb85-f6f40f044d7f_Method=Standard;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jason.Mancini@amd.com; 
x-originating-ip: [2601:647:4700:3270::7d1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 132a78cc-adad-48bc-1bd7-08d7c01ad741
x-ms-traffictypediagnostic: DM6PR12MB4467:
x-microsoft-antispam-prvs: <DM6PR12MB4467E639A7798CA3C86B6017E5E50@DM6PR12MB4467.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(189003)(199004)(4326008)(478600001)(2906002)(33656002)(7696005)(52536014)(6506007)(110136005)(86362001)(8936002)(4744005)(71200400001)(9686003)(81156014)(81166006)(5660300002)(55016002)(8676002)(66446008)(54906003)(186003)(64756008)(66476007)(66946007)(66574012)(91956017)(66556008)(316002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB4467;H:DM6PR12MB4331.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 842uvqcZLKPe3b2s+xRDupmsV2RGBR7p87VDzDwv8utTDxPbxgQXisrTusgpJHMxtZRnfvJhzc3MFyJYHp4pFmjpS1Rr8Q6WMp20bP2ddbX8utA96FV/nyk8QFL6SC64SA3zaTuGduNSRyEDdt5RiMifN+H0zps/0G7yw4MTlZYx+RjhWcS440cEMvh2x9oE3OqB54xR6WYgG1aMlU4pN46JNb+YMf2Fw4fVwtAyhJbUQ392Q8dXzmAtEzxI5gR71gaV8QUP10ArOh/LAzM8DMEomnrPZpFlIPjk0MasPbxbNcCBTO8CFuCjOu8i8wALKDdEu9IDFCiVj2FALp6EJUQam2XGIVRiX8gvXRiF2XqolXu/ZSQdA07CK2BHH6qQgzNEVUpk25CG1sOHuzweXmNpsyTZITI3LQnO/zvrPvkBksNqwsGx4eMzT7zpB7/o
x-ms-exchange-antispam-messagedata: LUQ4C+UgLR9mCt85/eNiCHd9OBRK8+IPdc8pyrV7f9Afi2ZoN2CbCce86+6CEN1Li8IDjxcyjy63p47ISjw5Wu05HOddsl1hum2/BZ92rXAx9oKI+ksaqamVnID1D4gzb53LtXC4LHCuYUTxTwu/3MO+3DDJUWZGDFTOIJnQr1I+FoGvJIs0kncTZWWNiVbe
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132a78cc-adad-48bc-1bd7-08d7c01ad741
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 09:03:00.8489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vfMM8ioGesR84qqRW0ylrPWIhFPC1Hh4epVOar++HDNi27MJvF3LuDvZ4Git125hHcUok2u5BTh6XtMEwWnkvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4467
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[AMD Official Use Only - Internal Distribution Only]

I tested Kalle's patch.  Laptop connects via 5GHz band by default.  Comcast=
 router still
crashed in a hurry.  I blocked (via NM.conf) the 5GHz mac of the router, an=
d rebooted
the laptop. Checked that the router was using 2.4 for the laptop.  Still hu=
ng the router!

What I've done temporarily is change the unlimited return value from 0 to 4=
000.
Somewhere around 5325 the Comcast router gets cranky/weird, and at 5350 it =
is
resetting the wifi stack (without resetting the entire router).

So there's no boot time flag to turn the feature off currently?

Jason
