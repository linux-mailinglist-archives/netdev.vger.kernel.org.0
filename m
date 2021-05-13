Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D437F2EA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 08:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhEMGVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 02:21:07 -0400
Received: from mail-bn8nam12on2128.outbound.protection.outlook.com ([40.107.237.128]:61408
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229748AbhEMGVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 02:21:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lndod1JBapdAQrDmceSB6+WJwmrAx8uk2g+9H6kt0acQ+60Sa8UER6RgY7SN4cvWd5RJuJdsjhAblmbphQADU2ngXvjLCziTtx/vdYGgDBUy9S4608F/7YzNOjUcTYzVhUubZdwG2ucZK0eTb+QZv9h0nWzZDe2UNTVisQZDluocglkzYmgJOV703jTwGFUL1a4s+MHUWJSi3b0DUVgZh9TaTlLQ7asMfjgLeEiUY1dpHEp49yk9phO4q8jbx6jrAA6VbxpZMDJmdq9jPTBagj8SohMv/4y1SQQK8m7R0bRFcxa31F5rhoWUGHBRubzOrwteEnZpM+nj+uIQ2PLmlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opFK5wTiCelMwY38QTVASFIZevxFCC0zBc15eKMa66M=;
 b=UWpHWbgueZjkydvRe7ilKa1xMiBU+ExksVmxGLI/a/14UoMyP6DQ1qoYdNSlQypN982W83uJb7SmqCssXTX3pP7cNCFmW7UA7SpFuPgl5E9wWj2dmzw5VihtzutMUfNOhZOUFdOsRhHvt8mlDNLhKrjmPkBSJxgLkJKPp7/7L1grPtMokCyUMOjEYgimjYc1AbSs7JmKNWtUncPFWZ1P2yUAZdY59J8ZAJvkeMTq6lneRAPsYvWFlYJ0Pp/h9dARtE7RPcqrNx5BUMePNvBNnl22BgnZ1y/DCEjIEFbpcDcXraXgUbHYft7d74IGnlbnCUzOilBWe1re6DCFncYTfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opFK5wTiCelMwY38QTVASFIZevxFCC0zBc15eKMa66M=;
 b=gzyN8W7SLTxNw0dwH8WT98kODGU84jkFrXS8f+vsuP7L2NxP1dHfmxMc7msIuS5TMTndlficQQKYA9spqcmZe+OIlkKPNp/hihfep6icMHGkMpSQALUrJq+SYWPCcDM8MpUdbP55glfkjTE8FtqPZAugYu4zTayg4YUSIT/RJMA=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0144.namprd21.prod.outlook.com
 (2603:10b6:300:78::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.8; Thu, 13 May
 2021 06:19:38 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.4150.012; Thu, 13 May 2021
 06:19:38 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Topic: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Index: AddHdN+snMbFwQLHQSmZ6J2vO7HZjQAM7kqQAAUT/wAAAJSsIA==
Date:   Thu, 13 May 2021 06:19:38 +0000
Message-ID: <MW2PR2101MB089257F49E8FAA00CDA63A61BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=356357d2-2a65-4b3e-86cf-03509df80d8d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-12T21:20:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:9d16:8ec9:e190:4c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27a88b79-695f-4788-ff73-08d915d71617
x-ms-traffictypediagnostic: MWHPR21MB0144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0144BD01AD41C8ED2B5F3921BF519@MWHPR21MB0144.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TmqNvjQf4q9jaU4wJCvwf616rXMrFSop+UyqgdVt3RILMHDHdkaVR+Ru1jw4h+ecOFeSe561TXsYGZ/hdoPqgWjvibMIqzwcbghk/yV9xpcbeJ3/9soU8UYeht976I5JxVh2f1i2chNUQpETfoOQ2jme4CpYfdSAy9ZRjCsEnlZFbZS0kWhoiQ6EZAogz84PXOfpCKlZ5iGWPLxvZ5vHie3lDJMksJb4dbqVnLtRcEpNpSxVm3CPVQGBPaFa/4tU3OrR/MhvVnPdaOw708RszrSHyG5Vx663TCwhVSfIc8Il2PrEkHsiKsvHfjHHs1Qmm/XvqlYK0aabXlE5QRST3c024AHpUT+dVo3Zbpg1q+UYitwFxbUCArxvklvnwJsc5tZDGdTjeseFa2nJRYoFfE9O2sRJjQwAD7kSCH57Sg8V7j2TGktL0ozPd4UAwEt+UsvjH/bGdxvL6cADSAt5+8isFDR4By0HZzvSywayLaG4JTnQJuPK1HvaRp0IJEbsLmX2y6RNsF6pDfyl4fV0o76dBkA9bAnpONW4HRAYQMUvN1RC+eNU16p5OnIMSQpOhsDNNHWS/XNHGKVz8jq3fPBN/6kYfyx8zb+sKAnW/uGNLHKmm2T+Wm2X7qTo+pm53XDhZLyZKfADieNEwGNjxvarrmsU+Y1hUAx3vQk0+8zfxlpmCgPJv9KdI/rvAqD7QkZeqnnxjzzVEMpIuV4a++Dga7DQIB4Bl+4V9s2HvsVL2M7Mxcr7O0vUvknpC1uLx4ToIqi5EJjXbIRBAs7IJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(8676002)(82950400001)(83380400001)(76116006)(9686003)(966005)(478600001)(6506007)(316002)(33656002)(186003)(8936002)(71200400001)(110136005)(66446008)(55016002)(4743002)(8990500004)(450100002)(86362001)(64756008)(38100700002)(66946007)(66476007)(66556008)(7696005)(10290500003)(4326008)(5660300002)(2906002)(52536014)(2940100002)(4744005)(54906003)(122000001)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?72PcqTQtFcXWTMYS6gq8NgJHQAal5A0DBcWXppt5L36tqLCBiGBguYrBshEW?=
 =?us-ascii?Q?eEdwJWsOYDX8xMMorWJGKqZKnoFkJ0PSR+xPGlTn7EkhSn5g1ZH7iqe5Nlc+?=
 =?us-ascii?Q?2XWdnkdBbdsapWTEj3KCkrrfS/DLYXO8JhZNAlCLNyN65zuIsEqfqry/owVT?=
 =?us-ascii?Q?PbBsa7YZWgg3kqrp86WX8ihYnoIPyjlY8acRzVOcL7sEbBTqd/UV8c9mrekW?=
 =?us-ascii?Q?seMq6CGf8l8vwxJn74SjIWi4EvmElNE9EPU/EepYdUsUvjHM3Nc5DkylM+lR?=
 =?us-ascii?Q?cVvc3DY7K3n4RDjqAcji+YaGOL6L8f2/0OU9DDDAUHn2OKNATmD2l6Qbj6pk?=
 =?us-ascii?Q?y+HRw3bXP9j2ucsWn6IxMVx4bk1YtYZiLD1EP24E/hcmSAiMZNb7v5zpt7lf?=
 =?us-ascii?Q?uNDugi16voHctOrjbQ9sXj0/x7lHppmeEpDqRd8ndeyIoB33MIlY+Xb1g5QL?=
 =?us-ascii?Q?WKn2/Ie8wdOo17LxnYXnYwMo4uiR8j/W1qGNCf2ye4rAqptB3NVolqT9wUsJ?=
 =?us-ascii?Q?Ho/yTE7+kAcvWt3UrSQXmG4fmn9nI3zVKE8wOm0nl5Z10Ow92ob+GME7adsk?=
 =?us-ascii?Q?82oZxQycfAnU1Ys6CQjeIaH2dsFKyGXFJPbeE6ZcVFMMmPQg2bjg9ZgW0CCO?=
 =?us-ascii?Q?QFCXvf34CH2qRd/xq0o0kWCDbflU4pyQrNBQb0scLHb0IlGfmipWhxxRDq4P?=
 =?us-ascii?Q?LKs67EF342RmF9FNKn+EL97IJeoDchCL20fqMytsUQPL8MsBLQZGKdw6x9Wx?=
 =?us-ascii?Q?ZS1wwYtujNPIUK6r/iYhxbIndg/pkkRiX5AyCXkTl0u3mxLDmnRrjNdqmHAF?=
 =?us-ascii?Q?uw97EQ5TphTf6of28Xho7tXzVn9Vv+gKA9dRWqmtMexNVZ484rvnQo5wNIKD?=
 =?us-ascii?Q?bPnq4LYWX+CsuLWAovpeJP4MFwSZJ99fm/6mOWm5YqZB2CKobDpbutUJOYKL?=
 =?us-ascii?Q?hc94FVz/hc5EApW5/eGqY4qvFUaBoNQ0/nefix8/?=
x-ms-exchange-antispam-messagedata-1: VLkQM4MUmxapTCYeVy0T/tmWh00WwMJ3+5UGDzkZHbejcxlpWqpbYAfmbRT2jo2D7EjPsZwGFi5K4m27gaS7IOzzIxhqQvWH9ZqzTtLthP2gFWjEt5ffJldvSjC++4a2TZVYSJuvwGAdtL0tFmWWmnu3ctO/TGHUDxy+DsVzgT9axm5qOK0dpUKfzD2s4mYWbAkdKz8VMR3kNNZoL6wkoy81fom6jwtLO0vPRxRYipsQlYJjca86lFgXLdld1AlV6AryU9R8KTWixYkXOR2MLaCmxO+UbHzLVXTud7T4XWt3u1wnaiP6VrjCtb3rI6IzJqpvl+kZpQMYh08n7pJG98av0qe3oQtlPc6P+yVNcbrOUH3/23+DtwrXmyS97glEcfivX6Coy2ye8AFx/dKhlKTp
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27a88b79-695f-4788-ff73-08d915d71617
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 06:19:38.1050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gu5nK4GcF1I1AVgHxo5pD/iDfxXOx7q/6YlXs0H4k3k3wRUedxwxbJS37RtCKjXZZguCL9aOA6+P+kKVV5mrWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Wednesday, May 12, 2021 11:02 PM

BTW, I found a similar report in 2019:

"
https://serverfault.com/questions/101022/error-applying-iptables-rules-usin=
g-iptables-restore
I stumbled upon this issue on Ubuntu 18.04. The netfilter-persistent
service failed randomly on boot while working ok when launched manually.
Turned out it was conflicting with sshguard service due to systemd trying
to load everything in parallel. What helped is to setting
ENABLE_FIREWALL=3D0 in /etc/default/sshguard and then adding sshguard chain
and rule manually to /etc/iptables/rules.v4 and /etc/iptables/rules.v6.
"

The above report provided a workaround.=20
I think we need a real fix.

Thanks,
-- Dexuan
