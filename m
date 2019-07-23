Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31F4671D2F
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 18:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfGWQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 12:57:45 -0400
Received: from mail-eopbgr1300138.outbound.protection.outlook.com ([40.107.130.138]:9961
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730940AbfGWQ5o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 12:57:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdHEJk3pYssr2KTb7y+DvdBi+PKHcsyPfKldZIt1C1A3o+0MnSAB14rUbpDOsVm5a62EkoWgJcXoGsiDIaiG60fTUHZCrsq3b9em4KCM9U26y3zvRst1t1TtnGPXDW7eoUgskLkHfHu1zDl57c0dQlTK/rD2c74VH57lUNZBJpz2PL+Io5aCAAcAfWGbdni/vox2Cl3UL3fYmlqY+6UvbmPA3kotkgM/2uMlxxheddygNP7WJ2Iy8lENMje3YAnLSQa/azjIpAohAIccD2e+1hQgSH2J0SWehYxBmzZk7edXqUqMbgx+dzFDu4p8IE+GJJCqHqUWYEIk6LndQF2G7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iPp536zxfNEFKZIA4Ez/GE1DT1wCFukpoPItHEt8KE=;
 b=TXyKb+5mcU0OBPq9HQIoIHwAYLa1EGCfz3oj5zYJCjRI7EciJkTbpENnCtVMTxkdn8wp2+aCl8gUS5UwBVrZgL1/m1VegewS+7BkeaNtIm3rZnlzaVfaTfSZPKqvZKQjPzCzpqR2yG/ne+oK6PSTkqwcdgZJ4L42MvUm+8og0KSM6N5/Pau2WSyI9FjmzzNnro6RtlIkK02nVLEnptdDoS9l1E73iqOCzx70160H2luJeN0rwwWcxhN+sBg3seXsAf1lxYxopmg6RDJoweH7BSRaul1XNNr4/eMIw5A/X25jm3FXRnaJSEVuzMzjwOJNGbZhu1245yrgqktkjZI+QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=microsoft.com;dmarc=pass action=none
 header.from=microsoft.com;dkim=pass header.d=microsoft.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8iPp536zxfNEFKZIA4Ez/GE1DT1wCFukpoPItHEt8KE=;
 b=iAi2HP2WxfIiAKVUmz1wDP0Mn2joIomuY6771ywi/oTwZNat2LX+0ezC+GhmSJCmVwMCVf9UYdnns7QutXX1kb3EqIjtanoNshFcoXd6Noc5iecGCXCAhLzS/JQVQ77bfrr32sGSxuxcY2imUDxxkC/wvnDTN3nChOTfBKg4RM0=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0124.APCP153.PROD.OUTLOOK.COM (10.170.188.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.0; Tue, 23 Jul 2019 16:57:38 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::383c:3887:faf8:650a%6]) with mapi id 15.20.2136.000; Tue, 23 Jul 2019
 16:57:38 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v1] hv_sock: Use consistent types for UUIDs
Thread-Topic: [PATCH v1] hv_sock: Use consistent types for UUIDs
Thread-Index: AQHVQXVAFHV3oWQ67UeAUCwaIbW8vKbYbANg
Date:   Tue, 23 Jul 2019 16:57:38 +0000
Message-ID: <PU1P153MB0169DBE17DE77953C3CA96FEBFC70@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <20190723163943.65991-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20190723163943.65991-1-andriy.shevchenko@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-07-23T16:57:36.9609153Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=7ebe2e46-3cc4-466f-aea1-babbe452aa1c;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2001:4898:80e8:1:a959:15fc:60f5:bfe3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b590be8b-5925-4407-44f3-08d70f8ede33
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0124;
x-ms-traffictypediagnostic: PU1P153MB0124:|PU1P153MB0124:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PU1P153MB0124EC6DAC4399AC790209A1BFC70@PU1P153MB0124.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(189003)(199004)(2906002)(6116002)(25786009)(110136005)(8676002)(10090500001)(7696005)(76176011)(11346002)(22452003)(316002)(2501003)(476003)(446003)(46003)(186003)(8990500004)(14454004)(102836004)(99286004)(6506007)(7736002)(74316002)(305945005)(33656002)(256004)(76116006)(9686003)(4744005)(53936002)(52536014)(81166006)(81156014)(6436002)(66946007)(55016002)(66476007)(66556008)(64756008)(66446008)(478600001)(71200400001)(71190400001)(8936002)(6246003)(5660300002)(486006)(229853002)(68736007)(86362001)(1511001)(10290500003);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0124;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1YSEqv/TyXEneglpHKk+b7k5kcxwKVMUnt+uLxu66yuBBeiTg3TwL6O7nwxHNiG57WyBUNwUZ1YR/q3YzE0t3VnlH5Cvb4NMOMKcdPCRgJyEXqVWtKUif9JAPWzJwFCG3Fh68Yz9SiKO1bMGhXV6bbjfFwT6tPmChEXHzDDLVtH2cWvUSDiJm+hF/cvfQSPW7bIzgGNpbd2UQB+UQodDGzvBz+EU4bdzFkGh+O2VKYdJ56Pofi0qLXEjO2F7aiSsl/yhW/BoJA6MJWI2KvEzWdI2rbd+HswnRBdPXiLlw9s+bL2KZna09OzLV5kNdiUeeC8UK9I2cSyyrxmohHvTPlOY73eNciGfn9SCBqwtoCIF14dCUJ4aLkAHdibg1SpTZV+DUUXdiCdwJWZv2VW5UBsUhWs2y7GxsLrV2Fv68EQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b590be8b-5925-4407-44f3-08d70f8ede33
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 16:57:38.0221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Andy Shevchenko
> Sent: Tuesday, July 23, 2019 9:40 AM
>=20
> The rest of Hyper-V code is using new types for UUID handling.
> Convert hv_sock as well.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

Looks good to me. Thanks, Andy!

Thanks,
-- Dexuan
