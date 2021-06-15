Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDD53A82B0
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhFOO0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:26:46 -0400
Received: from mail-db8eur05on2092.outbound.protection.outlook.com ([40.107.20.92]:54369
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231363AbhFOOYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 10:24:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NijzreYf916WobTtxY+nbFx9Oge9ODDdcmH3/nyEfZVavIRFBgPJ/erAhxwUPq+oEGQoB5V+KQgGv47i1WFyZmRfJTFD1exPN/j5y0qbh9CAuEa03MC0wm0yTd6u9itbBUvyOpLFUs6XqUnGF2M8y3gaygUapDQOYwnjPWcZ9okCaL++JkI6o6j7hUem7Q+OVX/wstuzA1OeBb3DFuslxxGijcEG3p6/H1tGfPdr6iLcso5HTwoQ63HIhPpzEXmb2xmfWkM2O5jo0hP4YvvJwFxF/kpxNbEqw1qSKEPhJ9jYN3wi6Oxfg1/LqY5dFkbWyRmhbGIU4BIn/QdNY06fzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AhaGb9wRe2uDsglEUBeMWF0YD96LW7WVazPcTB8HNQ=;
 b=YgDGTDS2J7YAzErRzITMf03Z+LyZz568IR3i+jPS9CDpj71bDIyygOF+Dj0qPyEfFcnccLsaDpuvbaixo5T5jFk3NNvOx+pu8C+RBD/TBR+P3m8r9tpvbb3wE4NfGpHVZzzFJW4f38wzb6B3xcgk7XHHvvby+y+fBzk+h05r+yeNNtltCTw1In7HibeZD+GIWE4tEyaiaPjnjYFc5cks9C/NjcpzXk2BUPWrbkonaYjrkPkgdOEVvL1G6NPxTNW1jTVfW59soVHQfPMo5RIKLDPs816hTKpxQm+WLRyUONOQjyXZjZqvcvQfT0JKkzmKRZfKlGso8l+8XbtRBI+PXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AhaGb9wRe2uDsglEUBeMWF0YD96LW7WVazPcTB8HNQ=;
 b=mvZHheI7/AURt7yOOS9lv6k+W8xnxNASpZ+VT/KPBPeUfv8v91rXcScFF7jk2jnnezOFKFDhEexWSk33ia7ujmnxljHaT8vswtZuKtxDUr1ffYoOdi6bkOM+bhXskETLLEatnrd0k4+zzX6lvRJ5CqZ9q9ISPkDvzXGBUFT28lg=
Authentication-Results: lwn.net; dkim=none (message not signed)
 header.d=none;lwn.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0363.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:55::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Tue, 15 Jun 2021 14:22:27 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 14:22:27 +0000
Date:   Tue, 15 Jun 2021 17:22:24 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>, jiri@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, nikolay@nvidia.com,
        idosch@idosch.org, sfr@canb.auug.org.au, linux-doc@vger.kernel.org
Subject: Re: [PATCH] documentation: networking: devlink: fix prestera.rst
 formatting that causes build errors
Message-ID: <20210615142224.GA18219@plvision.eu>
References: <20210615134847.22107-1-oleksandr.mazur@plvision.eu>
 <87sg1jz00m.fsf@meer.lwn.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sg1jz00m.fsf@meer.lwn.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM0PR04CA0114.eurprd04.prod.outlook.com (2603:10a6:208:55::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Tue, 15 Jun 2021 14:22:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e3d5fc-3273-452b-6b97-08d93009009f
X-MS-TrafficTypeDiagnostic: HE1P190MB0363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB036324ECF88E222075CDEEC495309@HE1P190MB0363.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjvgBmgaZbvQL/VI5dX1ra6bpYX9zY1BttoG7vvEkgS9OeL0kQw6jStPiHktAU73iAmm9P8KF9EcbJOm3m4WQFaoN/n1LB6YJA4hk1zOESoDkfIh1YEcmlDbVP1icW/LIB9YqanTEJoJwf30fdX2FP4Cz/X3psUPG6kNib7aJtWBHWGmKXwE+tXzFpkFo8353eDm8EphcurUjLQ99X7V6fD3y3O9QVNA1zt7gk+tdISr2JPEYoBgj1T68FbKR1OTFTqBLjZhuj6GQ7RVW4ov1xoetQ3mTNuL7g2ViOr+u/qrCFwy9LP/Dl10SVIn0jEbvG5R4Z1yrddUfNx3wIw6dUYBkR0hbCxSSIar8TfWB6vDdqIr3ziaLhtvvKhe5tqAMKllfY6k1soU6u80c4c/8VlTuHbzAQj77Bvr2aYYLidN3K+j+n3EhzL2dFw+AwqxCtKw6E6HWVzW7lVIswNT2RUQszCnt65IsPdDW4aNficFtuVIW2q8p+kP6kw3hFMCt1AdO6UlRTlgx2T2+cfA36cNuwAKkF9Nu9J41fjNTNWiq+MprSiOj8Ohd7TrIsiz6kwN68AFWwDoPa/zKeKvcCIQPtgNIfcuGXdr+z/8gi52MLBS7nCdmSa1P0x9jvzfLSfQiLoy7LDBguunC/4wJLlaYFnbiBVew5n4Lbbl2zQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(39830400003)(376002)(346002)(366004)(5660300002)(2616005)(7696005)(86362001)(956004)(52116002)(83380400001)(26005)(16526019)(186003)(36756003)(38350700002)(316002)(38100700002)(8886007)(8936002)(478600001)(66476007)(7416002)(55016002)(8676002)(33656002)(66946007)(66556008)(6916009)(1076003)(2906002)(4326008)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E9M+eNWlx7JYpnl0tM1gKUdykO/nvcComEtleiFAU2TWIDqObv8xCFO248pO?=
 =?us-ascii?Q?G2yc1Lt08SOuAOA2LtCV8e7136/S7UArD7Fzbgx4+IeU7s2uYdJNXToO/756?=
 =?us-ascii?Q?XR9eBtr86CK2oVOjmLuLr7mIb6dQtIcqpEMoUmjPbbygPthTDOEmUds566Hp?=
 =?us-ascii?Q?un8tVy/xjVRr14Hgg1+gYXfzFi+a9GDMcBRSlp5JUAfHUpF4sPDaQIzlJ+tu?=
 =?us-ascii?Q?VxkDGUR3pNWvJU0L9VtridqIms9zRWNui3QYWIz4mYIIf5PYZT/sQgnJxEpJ?=
 =?us-ascii?Q?IAcPVk/KWKFOk3hevKfDgDYd0SBpOW5ZY3qZ43juIEOmTFJ345jmJ/VHBqKj?=
 =?us-ascii?Q?Xl0agb6PP3Xubh0qvoWavLN4+5+E2w4XXf0112q+Ju6cYN87rMPKzR1Tfb6K?=
 =?us-ascii?Q?/WJFJmCKjrxNVsIiO/T8IJujybgxzt6XAlEysXyIHX1xYewx1cfic8RnsIiz?=
 =?us-ascii?Q?nW8tL+wtFLYfoZtRU1JS1lJMdc/b95FevstwsWCE3ZF5k3ih5GmRLuKK/mi9?=
 =?us-ascii?Q?2ksV3460aSZxmMwF/MG4t5G1bHqz81dSuYlPZ94Gxa2xi6lvuOvCnAONVE8R?=
 =?us-ascii?Q?PPfj/hdNe34rfTeeZrHZfy8tYMp/8pFVfWz6jTDni/7DWTQYpo0yOVOy2SiS?=
 =?us-ascii?Q?f6lI1ezFK1AXr9D6v92S1inwaRJIElHo3KfXJOILTeFRzC5Iit6/uc0e6pve?=
 =?us-ascii?Q?2Um8YQWD0hrJfLIIrZPaLsvVCGPekd0ZQv7jDPZl8LHWc48VFBlMj1qVPY1i?=
 =?us-ascii?Q?+uGgeuOOgLdxwLkRIaq3zl7l60WwvRaOBdsMJKvSXlRaPwJ0DoTFBDzi6KWX?=
 =?us-ascii?Q?byO0PCoPLUoet/QoaLa/bx527x15ha79+rYJQyfMXiMTnzB43/oJwrtlWLl7?=
 =?us-ascii?Q?/fqSAvig4Tnxq2gxrqdZJsFy6xXirFpMz2zQ/rX6Q2/mRDlZUe1/hVHw3/25?=
 =?us-ascii?Q?gKKeK79aH+DA+jxvlLuMhK0TRLSkSZPTDDmgVf1RhE1axGP4jcAgU7ZaKB7l?=
 =?us-ascii?Q?nqi8zcmSWJd3MwLhOYypsbT0Ot2IRD67E6w90kHohG0PvaDN9ecjR2rHfigC?=
 =?us-ascii?Q?CrVKXox9ZQ7ccNVSar/9BDzOXaENSPXKWZBrcD66Fg8AfUftdHXFMMeMH1a4?=
 =?us-ascii?Q?2/4R5bGciyeVVphhPLgPu7oTOc4gIzeO9M5nlc5oAqWRa1e/sGqysAil/Ue0?=
 =?us-ascii?Q?TLa8f0CdiOe2QebpWAWnHaneiepDv3UmzZjPC4tCuDBwa7ZkpQ7rEE77ZOSx?=
 =?us-ascii?Q?d8KsXGDMXC+WqeZ1qgEwcmKT9srkhTq06I7JXSWE1AtnS/oiW1x9WphhcHZI?=
 =?us-ascii?Q?QAIjWkzLknrXFGUZ6dgZ9A8U?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e3d5fc-3273-452b-6b97-08d93009009f
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 14:22:27.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHsOQhR6THhqaA7OJjkjU4Jio3sEk/KgbNHSdAyh+e0Kle0hoYiRgQ1Q3cbm1H/Ugcu2APiKZdOe5powRHF6ucNNITZ2An4z13EwuGg/XbM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Tue, Jun 15, 2021 at 08:16:09AM -0600, Jonathan Corbet wrote:
> Oleksandr Mazur <oleksandr.mazur@plvision.eu> writes:
> 
> > Fixes: a5aee17deb88 ("documentation: networking: devlink: add prestera switched driver Documentation")
> >
> > Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> > ---
> >  Documentation/networking/devlink/devlink-trap.rst | 1 +
> >  Documentation/networking/devlink/index.rst        | 1 +
> >  Documentation/networking/devlink/prestera.rst     | 4 ++--
> >  3 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
> > index 935b6397e8cf..ef8928c355df 100644
> > --- a/Documentation/networking/devlink/devlink-trap.rst
> > +++ b/Documentation/networking/devlink/devlink-trap.rst
> > @@ -497,6 +497,7 @@ drivers:
> >  
> >    * :doc:`netdevsim`
> >    * :doc:`mlxsw`
> > +  * :doc:`prestera`
> 
> Please, rather than using :doc: tags, just give the file name:
> 
>   * Documentation/networking/dev-link/prestera
> 
> (and fix the others while you're in the neighborhood).  Our automarkup
> magic will make the links work in the HTML docs, and the result is more
> readable for people reading the plain text.
> 
> Thanks,
> 
> jon

In case if it is OK to do this what you proposed, would not it be better
to do this in separate patch ? (the reason is just to do
not mix the warnings fix and the better plain text navigation support).

Regards,
Vadym Kochan
