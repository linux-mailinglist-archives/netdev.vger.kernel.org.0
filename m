Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2B00AB945
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 15:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393302AbfIFNbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 09:31:23 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:44872 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388895AbfIFNbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 09:31:22 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2CC71C0E49;
        Fri,  6 Sep 2019 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567776682; bh=r/J7h3hQWCd/FLuDhDmVVL0Laohsi4xIcRX+g5VB/xw=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=P/y2iPq+CU47zGsGym7UbKe3q7LI9B/0To4TQJlcq0SzP4RgFH+qzAF/CfjYF+ATa
         rQSMI4Eq3017XmGojWCKBN4RlUsqCpBraLdIj7dbZXEnmHWeRryq3m1eEP3hDU7bkf
         WRH8DrQN7CWxjsjocq74XVA9yXOE9P+uVL5TJVtOC2hzz+FoUahcYjEU9Eee2dRjWE
         oxCgncVq6dWHF1IrSsQ3s0mf53i89TV6pgKkcqRtylUb14oJZ5WX8Q5WL+VexSBU6r
         RxePmPTGXkDhAuK02I/X8JI5dw1k157x/SrhmaojVHMfzmQf39yij23tTt3noTbRqi
         olQxiOBNXYXLg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3D4CEA005A;
        Fri,  6 Sep 2019 13:31:17 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 6 Sep 2019 06:31:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 6 Sep 2019 06:31:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZGK3ydP8BQHkYlLMjZkG84xhB2U8yYai168a+mz6xeFNAYmadqH/SnpW9z8/C6Yl7H/P5yt4qMGdNhDH/Z6U0O4gk59yt66fjx/t2ylpaGBzggP605nEQUYHqqDd3P/t4g5FXDpE/PEuCgSQ1JhKYla1g7ONh8aeTdkTfuJMFSQNQWMgDGR9pboCTXqkcgS9T3yNjj6vgUr4cyfMmxTFJXEyJqj7p/dwRgsqHbqVrukkaN/us/1FgKQDlWD59VaZqeRYFQf67EvpxkK6/W+OJcqcxlj1OoD8iGXAXiI1uTRORw343wDwLKq4q/TQPBIpVARHfyNHp1v8l1my9FDdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/J7h3hQWCd/FLuDhDmVVL0Laohsi4xIcRX+g5VB/xw=;
 b=IOEiG1GHh9kXcFfuQeXALXi+00CLR3pFAalbueVi2ojbDWXzjpVUMPaeiVye/3NC9I8rsbv3+tINUWNs0Zf2CI+bbT1+i20na3xKxsUSxcGVUgskOwHy9euz04rb5e4AOfXLdMfTPLoLT3RmxxAlOLDihY7IKwbshP5qkVziMQmRAtyn8dnMQvh4tLMd9u66U5zXPvGkYZ5+LANKxH5o6CruTOq2w1Y8L9QkRfV/ASZ/Eo1QZbCZxx3pWThsEc9dFhJfXcrLWuy82e7d/CEqub60adzCXBEKNjcudBG3sN1d9Ns/8+X3KkFH3V2W3pijdFa73Ys6Rhkmr77CTnQtqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/J7h3hQWCd/FLuDhDmVVL0Laohsi4xIcRX+g5VB/xw=;
 b=LUDrVaTK6h1+OE0+/YR6pZyOwZOTVK1Ct7J2jq+bg8csCkLiHML9bG0TKoG3msQmeN4Z17bjFbOZy3ylREs27C7lNyzMfGHbJ3uKHsDsyjQ+FF9MylpNujnVuWAp35dm1Mjnd0llulHZ5vZqyB+ZXzV0BALHR2bX25h4jYBgDOw=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB3252.namprd12.prod.outlook.com (20.179.66.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Fri, 6 Sep 2019 13:31:15 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::59fc:d942:487d:15b8%7]) with mapi id 15.20.2220.022; Fri, 6 Sep 2019
 13:31:15 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Voon Weifeng <weifeng.voon@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Giuseppe Cavallaro" <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: RE: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Topic: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Thread-Index: AQHVY+JK/I8EakLq2kKZWKw46LM93qcepnJA
Date:   Fri, 6 Sep 2019 13:31:14 +0000
Message-ID: <BN8PR12MB3266D427D1AB8E41B13441B6D3BA0@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <1567685130-8153-1-git-send-email-weifeng.voon@intel.com>
In-Reply-To: <1567685130-8153-1-git-send-email-weifeng.voon@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b2f2cb5-3701-4c6e-d549-08d732ce7dfe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR12MB3252;
x-ms-traffictypediagnostic: BN8PR12MB3252:
x-microsoft-antispam-prvs: <BN8PR12MB3252C6EB546DC466100188A6D3BA0@BN8PR12MB3252.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(346002)(136003)(39860400002)(189003)(199004)(478600001)(256004)(86362001)(486006)(476003)(186003)(11346002)(446003)(8676002)(81156014)(81166006)(8936002)(74316002)(305945005)(7736002)(4744005)(33656002)(71190400001)(71200400001)(52536014)(5660300002)(99286004)(66556008)(7696005)(2906002)(66446008)(64756008)(66476007)(66946007)(3846002)(6116002)(76116006)(54906003)(110136005)(316002)(6436002)(55016002)(9686003)(26005)(14454004)(76176011)(6506007)(102836004)(53936002)(25786009)(6246003)(229853002)(66066001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3252;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TUUrOQzL0AxEAKxrSAyWHngzknYkyKt+M8VDntuuK15th3AHo4jSJwwV35siWgnJCz5RmzZ5aFje+2ixqqPzjxgjhBQVtlE4yKRi8usI2N3jdNVN/BhkIuahc287wdM2dzplml0Ht8rsNbqEm6Pft8YtGGTM6g5ARV1O4F1M27nAlHKOcaJpnZxNHiHuD2E9h4cDxTCZfPm3dqzuiXkcsVPL13gnjen/nlwKXdE8pa/4JkFB66Y+5N861mIAVoylpyjXxC6bn0iSOmDFXPJRjzWcSphrEznt7rHmpf0nzaYb1IlX/OClhpB7pk7Q+1LnB50GaCgAMinjEXPGPmBB9HR9zogGUuFNx+qFhnaXp8T/zeVQU6KU651P7cVtg0FaOWw61/+CD/2hwwv0zj4IZQSdv2BVRitjQBJ4DXq2owg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2f2cb5-3701-4c6e-d549-08d732ce7dfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 13:31:15.4389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tqkWaS8fs2EZToQc3ikestr0l8oNCdCPJDQebUjrfKd/eO2KLBJKjq+bnMt9zS/mukaDdwlZdhRman5tTLLqcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3252
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Voon Weifeng <weifeng.voon@intel.com>
Date: Sep/05/2019, 13:05:30 (UTC+00:00)

> DW EQoS v5.xx controllers added capability for interrupt generation
> when MDIO interface is done (GMII Busy bit is cleared).
> This patch adds support for this interrupt on supported HW to avoid
> polling on GMII Busy bit.

Better leave the enabling of this optional because the support for it is=20
also optional depending on the IP HW configuration.

---
Thanks,
Jose Miguel Abreu
