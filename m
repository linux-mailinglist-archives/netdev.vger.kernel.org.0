Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8255EBFE3C
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 06:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfI0Ekb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 00:40:31 -0400
Received: from mail-eopbgr1310112.outbound.protection.outlook.com ([40.107.131.112]:7393
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfI0Ekb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 00:40:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4sgEAZgRNLOVdHIj5zWaVaNKRpwO3Ba/X3ly6fNPnkhVSd4Go5iDIkKHXvTlv6aI2zGcAWnVAp6xQon2qLK8PvwE63xuSUz1cU73xqh+W4OzqeOxrXKk/M8HsK+XgtQqpPy56NWkn48yHwL0e+Md0PyRFmAmwuKjVJW/fGPXr2QDoclsNfWuJiGeLD4a7fFRJDXujOQ0k4HFtFqyaV/duXhMpXDF4bi8A13ho+1ZcFu+vLS+Z+IUTJitqPb4zBGMkrJzRGIkplpo9CTWA+3LrXHzcLHj0qEr5cgpEkZCxj5nSlwKXHGJRzWwb+7fqo00y4snVG2MjPjX1IgvEhDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08zGUeCejk0tfmQ5mEK9h5I0rfhJCg6B7GpH66e4G0A=;
 b=iJrmZA1XlirDEhsH2a40fmEP9uYEWxOsTrXmco2oB3MqMurzigL36iQthf7zyeQJy+cIT5EEKqZPraRTCKX8dM+2MKij271+WeSc1iRiCERxuH0GCXnuc4YEyy9MKUEDn6OZTITfdk1yTc7fNP/q6YcZtkMaTSmDPIBpCUT/wB75wjk09UNOmFbjK8ERYF0ZlcKJMH5fRYRuqahnuU8sBHz6j2po3kcBqoFttu3Yb80cgJKqYzGKkGSQYGH+ltR6K5wmW8tpZsSHJ+ArroMFAlvAUBLq3b5jRSz24LRsCU0rSLuFb5cY8UqtIK7f52MwBe9OgCGUTHG1ZI7er0djBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08zGUeCejk0tfmQ5mEK9h5I0rfhJCg6B7GpH66e4G0A=;
 b=VOMw8KziowiDiTVl0qC1G/UMXFBgiY0FLIPqrJtJkcQ/esUErXx47rAa7/fiFhwKAOB5GMstpjBxdKSkSzCCjF7F4eYHGKE2hrlYIjeZpoiPJhECOZP0cTAUAfC9+7zbQmDk1Eq3K26DBSTWGtkaT4Aa0dMODjDuy/3+yzD/Yoo=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0106.APCP153.PROD.OUTLOOK.COM (10.170.188.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.5; Fri, 27 Sep 2019 04:40:21 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::fc44:a784:73e6:c1c2%7]) with mapi id 15.20.2327.009; Fri, 27 Sep 2019
 04:40:21 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kbuild test robot <lkp@intel.com>
CC:     "kbuild-all@01.org" <kbuild-all@01.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: [PATCH v2] hv_sock: Add the support of hibernation
Thread-Topic: [PATCH v2] hv_sock: Add the support of hibernation
Thread-Index: AQHVdOtkzE3gbmO4UUyucD7/Wp1oDqc+8UPg
Date:   Fri, 27 Sep 2019 04:40:21 +0000
Message-ID: <PU1P153MB01690611C58A440729DCEDC3BF810@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1569447243-27433-1-git-send-email-decui@microsoft.com>
 <201909271231.iD9JBAQs%lkp@intel.com>
In-Reply-To: <201909271231.iD9JBAQs%lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-09-27T04:40:19.7635383Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=451f68ff-6979-4edf-9a2f-55027fb90131;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:557a:f14b:ea25:465f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2dd5158-24b3-4eb5-ad9c-08d74304ce70
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: PU1P153MB0106:|PU1P153MB0106:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB010684D41F56DF3DCABC78E2BF810@PU1P153MB0106.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(11346002)(6116002)(10290500003)(71190400001)(71200400001)(6436002)(186003)(22452003)(46003)(8936002)(14454004)(9686003)(7736002)(305945005)(14444005)(316002)(6246003)(76176011)(2906002)(478600001)(256004)(99286004)(6916009)(5660300002)(66446008)(7696005)(81156014)(86362001)(64756008)(446003)(486006)(76116006)(8990500004)(66556008)(81166006)(107886003)(74316002)(66476007)(25786009)(66946007)(102836004)(8676002)(4326008)(55016002)(476003)(6506007)(229853002)(52536014)(33656002)(54906003)(10090500001)(4744005);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0106;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1vHcrT8Hod8CqY0+FlbF7oEgShkOl+//4dCXCasGk76LTNA6z2s4X+jZgSYP/pAaSLIjSoKzynLR0YTZ5o2FQ0IiZira6tBHxZ8KErCy+7Z9C3PedU8MUsMIKDz8L7Kbgx83JVLc58GIaMfOkIs0Tv42glLhI//jAHAMnK99dqs+pG+Bebeh5g5U/IUApOSWFZKAmshVW4SyHyty+WlmmJxCOiHzywhLbaV4lII9DSWVxQyD6M3TVlmP5R2Caj9ACArw4C1AiGZVTNL3qoAYFdD/6rpTiGxekZi5uVXLVxSv3iTe/fvFdFxXKUdFnki24Vpir3Y0lvbQtZ4N50W4oO6fz4o5rdoVzt1KV9UYF6oa8QJQaHKUB+h6EiJ+1KgMB+ArQr5pGWuML2x3+t/54m7q/TEVeAxrjnFpV3YWTbQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2dd5158-24b3-4eb5-ad9c-08d74304ce70
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 04:40:21.4727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8vSpqlc/fMmQnsmJwVW8ZVbc2BeBQlXarCB0EeXy3U+xArMwlInel6d1UzcX34uV++Wpenf1d6r9yhZ/Niq4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0106
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of kbuild test robot
> Sent: Thursday, September 26, 2019 9:19 PM
>=20
> Hi Dexuan,
>=20
> Thank you for the patch! Yet something to improve:
>=20
> >> net//vmw_vsock/hyperv_transport.c:970:3: error: 'struct hv_driver' has=
 no
> member named 'suspend'
>      .suspend =3D hvs_suspend,
>       ^~~~~~~

This is a false alarm. Your code base needs to be merged with the latest=20
Linus's tree, which has the prerequisite patch:
271b2224d42f ("Drivers: hv: vmbus: Implement suspend/resume for VSC drivers=
 for hibernation")

Thanks,
-- Dexuan
