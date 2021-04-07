Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8730C356619
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbhDGIJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:09:23 -0400
Received: from mail-co1nam11on2112.outbound.protection.outlook.com ([40.107.220.112]:3936
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344910AbhDGIJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 04:09:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L79eFf7xBnIzL3qFAtJIBrchBg36d5GQu/slXehZz4wztwQXnSkin/2QPDEBhw0RI/JV6eDpwLJo8kzxTmWINO5V2ALPDxKFFhPDOT55+49f+CEHKcGYd88stvnvQe8ecmKzyB9iECcRKiscit/Io+IREbHgTGIwLQ2wxyyYMScxCJVYn0aNuPYPOiq043AXhb0Fp0Hp1YMbs6A4NEXw7btNIZvWDwrm+r+YCdRxUhCLBqPqOxK7ahYztwkZItUs1Ca1dGNkeJKr8AVJpB36127Sb3IOl6Pl+UZQf9i+QJ0l8Fkbf8k93Nr0CtmVu4aWgjBEdjAtuQHZhunnbj9TeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IA55JUbY+LRBv9WFGbrWnPTXaccjjGX7berkyVP/tfU=;
 b=F2B99wpOWqZ2Dyl3hAOTNNlEtKanfCGdfL5cPjW+pWL2znK2n0mzkERFQzR+m55eY3B6LpE6nPx61KHG0ij0YWy9J1L9+Q8Yt31Em3ov2+Bl3vtJSkIHxu7s7PY7VTYKRWvYN4jWZsHHvcrTfyApFJO1HAs+o5jaNbd8EJUSDAddoi8qqxP6/jB8Pz+GHVTWizttqeze5xxxG8v/00vszzHiCZMySW6KffCoDw3vOiPP2Gw7+2ViPgDMXDfoEiIUYuOPPVv5zvFL7H9RBkO7NVlrkoyqkMnEEQL9MipTeGwxcpGUz94wF47xI6F7jHD/DW6v9zxvjUoLh3qi9TGRhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IA55JUbY+LRBv9WFGbrWnPTXaccjjGX7berkyVP/tfU=;
 b=Egx88NEmsG/0mHWZM0pgH30oB1iFJ3CLEwqkZiszFIeBvN43cuonMZKquOeqYGG28oL8RmQwVylATTuRoMJYdZYZWkJ7WaFbGIDbiiw9QBWxZr5T364CP/ZuK82Zs2vabO3Y8d7djEmqFk8FLRLMUeFafeS7YK2SKd34F6QgDWk=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0751.namprd21.prod.outlook.com
 (2603:10b6:300:76::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 08:09:00 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4042.006; Wed, 7 Apr 2021
 08:09:00 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     kernel test robot <lkp@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXK02fK9CYzM87fki9gwnmLmNhk6qoskrw
Date:   Wed, 7 Apr 2021 08:08:59 +0000
Message-ID: <MW2PR2101MB08922BFEFEBFA44744C5795BBF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <202104070929.mWRaVyO2-lkp@intel.com>
In-Reply-To: <202104070929.mWRaVyO2-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5bcc9357-5f5b-4cdf-9664-ec40a96c0fb3;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T08:03:09Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:b462:5488:6830:14b3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6cad607-0376-45fe-f73e-08d8f99c6660
x-ms-traffictypediagnostic: MWHPR21MB0751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0751E219CF01F7EA53453E92BF759@MWHPR21MB0751.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UBDiKD/HE6E3aWmk7QpqBC6+FoCcYsSBVaam0yKNVTbV1ZflbFc/vcnb8n9MogNId4tLvtlHvnHT8bZSdJneVXplerUdYx9cClvfArEP0QPhxy25fy8IRreSHNjhNSjKptZb4YJ1yF16DslkCIyMTjjlJ5kBAhrD4GDqMKZujaMKGhvDS3sDGIImcF5mhCjh6xSfUTx1oNshrDEXmRUrMRPuQJyHuE8OF51uU01ByvCX/Oju2X7hI41Sy2QWdX6fC6A6PUuc+Ru+7EAj06hS07GztruIEYLN/rqxWq4xIIgQiXuQWA7Q5Z5J98Dqj8qpGyqJaoidRrOrDWVgDMpbEZ0wqVyjaHB4WQl+58l4bt5imzxc0ikxbiZMaoERLz5zpOzHHjDw2lVNILLW+i1C9iDZZTOh0ftcgXTPLP4ThMM1QoUJLO5CuuASSER5WqwK78R5Tv/Ujf/rmT4ZavNVkgqsqqhmUM2Aw7SQyQm7kne738+Ey2aDQMColX0QJ2hIRaWBfVcwUyjosj53Swf98il4UUbbZUpJC7fUQI6c0+6CXO0SAEywhRxm6Ugo5qjntFuByiwTsvMhQAqQ5gary4L29IulEflH892hu/U3pL/hEmyYcDOIGhtpFIucOiJNInROhgeLWH/KsL2g+FgM6XFXQQAAyibcUkpb2VKRn9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(47530400004)(5660300002)(4326008)(52536014)(71200400001)(4744005)(82950400001)(82960400001)(2906002)(8990500004)(8936002)(55016002)(6506007)(9686003)(83380400001)(186003)(110136005)(54906003)(38100700001)(33656002)(76116006)(86362001)(10290500003)(7696005)(64756008)(316002)(8676002)(478600001)(66556008)(66476007)(66446008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aTKgbeBAIZyes9kbx0qvTFgU4b2DYrIoiy+Pa75DUSY0v/xBguEIgshYDsUQ?=
 =?us-ascii?Q?LO6Z9pX40sd4fTDZXEymBXm2gpFQoipK9/CGcbZRNI9Ra/CQCzdQmC4ax/u/?=
 =?us-ascii?Q?g4gmeuhdKBzNOpznL29JopV7FUGHxPNbTWwoE8rSUCJp4c0z7XWuxbmiOiDB?=
 =?us-ascii?Q?x52xxquTE9CvCOUXF+HJhrdcc2QumX6i4qTTZhpAzq1SdQLmDlqfZOfJHnfg?=
 =?us-ascii?Q?X3zVx1gmhQWaaL0YVqRKy7baABmXdzIXtBPtwhVjTphbcGiABqb5m7JoQ7FT?=
 =?us-ascii?Q?PVlYxHmPqqHM8Xq59h89IS9ZxE90a/tUmAvG27Adjj+KbuQ4MEs/IgEJj9n3?=
 =?us-ascii?Q?+vqi0BO/2/pygeC5L2F8VSCbseTgO1IMAJ7BpEPp8BnnptdJdiUUQHUfRrtj?=
 =?us-ascii?Q?Z3hAKFaUxpL1MtPk4fLHp/y/p84bYypqwgWcVtfmEXDSFxcoDfNP5TTqqlap?=
 =?us-ascii?Q?OfNBoXZufbsbEBy6gnNz3pgaMwlLnKyJ0e9CBOwMCMe0OeOKmQjG0dum3yva?=
 =?us-ascii?Q?q85aTU8aQhuWvbHrSnOYJ05UmlA7kosozbA586d3e3Z6Cv0j7iGKEV76nk5Y?=
 =?us-ascii?Q?12G4nnUGC5aUNsMaETCvllWsRG8sGwMcof0sR9Wz1wTS2+L7D7X8szGXm9wm?=
 =?us-ascii?Q?m7hz1gM9veZ/QV3UbC/4WO1+i9FxUs+AxO0Ho7T5cPUZShEmd3IfzngJw972?=
 =?us-ascii?Q?H2FolmTlSs7mWe7g48xun5biMWfNyjk+nCH5cI1jsDu5+jehT+hZ4lGHZOhr?=
 =?us-ascii?Q?YPKV+M85T1QvFAPnI9wTkan3fTslzGDzSkBaZgBrAQ37yfpPbOYW999q7fQu?=
 =?us-ascii?Q?KjO7U1cxtTiCQcXWMCeI2IQP/Za3fTlGPCkXxQIXyAtD17mO0utWhjAjpUwh?=
 =?us-ascii?Q?7jvtZ+0qbYFL5e0Y73GPZMooDSR4veJTQmnKJenB+iIp/u+CKdHYsbD4S2Et?=
 =?us-ascii?Q?+EcjN+PYqoD5/8igtn+vAJcOME5LKGi6E/4tf6RUFW+pg6iDMDqBTQig0ZL4?=
 =?us-ascii?Q?T5fHTtsxerpAqNxMTtdGLkWcOKv7ayUzgU/Sxal831RovM3Qi/nGR4rp404o?=
 =?us-ascii?Q?2gsyv3aRwT8Uc3f4G4mGfd0z6maP8t2YTRriHXLE3209l0joZVOxi8dgCmvb?=
 =?us-ascii?Q?AOCtUaFj17Gw12ZpduJI2pfdWBFJtyDQIi92pqzkecbWRnKSMB4zhxEeu1gO?=
 =?us-ascii?Q?R5SDCXsgD13HcoGFQ8zYBkYeKn6OkAdZ72Wojl7ZgIfrJXm05mzNRaEZkiCl?=
 =?us-ascii?Q?XlwM/6/LqvUhYrKtwbRPsDBIY4L0sJzvVt/LdftpmHnjEwzs43VT8hmHOS7M?=
 =?us-ascii?Q?Kuhy6fANpQvFXRwiivIa+RxQDjIw5kJscXsqz8K88szFX1GZMUNzYoIB0OhM?=
 =?us-ascii?Q?MyXkMfS9PRp0CK+Iz9TB1gEY+hz3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6cad607-0376-45fe-f73e-08d8f99c6660
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 08:08:59.9481
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pT2v45k7E5OlWnWTeYNEcPpd841CBnnmEFrg4N1qP9NK3IKA9iQS2oHO6VEpzFsa6ZnmuNAZfo9gI4aXk09F2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0751
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: kernel test robot <lkp@intel.com>
> Sent: Tuesday, April 6, 2021 6:31 PM
> ...
> Hi Dexuan,=20
> I love your patch! Perhaps something to improve:
>=20
> All warnings (new ones prefixed by >>):
>=20
>    drivers/pci/controller/pci-hyperv.c: In function 'hv_irq_unmask':
>    drivers/pci/controller/pci-hyperv.c:1220:2: error: implicit declaratio=
n of
> function 'hv_set_msi_entry_from_desc'
> [-Werror=3Dimplicit-function-declaration]
>     1220 |  hv_set_msi_entry_from_desc(&params->int_entry.msi_entry,
> msi_desc);

This build error looks strange, because the patch doesn't even touch the dr=
iver
drivers/pci/controller/pci-hyperv.c.

I'll try to repro the build failure, and the other 2 failures in 2 separate
emails, and figure out what's happening.

PS, I tested building the patch in a fresh Ubuntu 20.04 VM and it was succe=
ssful.

Thanks,
-- Dexuan
