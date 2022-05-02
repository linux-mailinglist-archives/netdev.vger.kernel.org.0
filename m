Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01003517681
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351611AbiEBS3O convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 May 2022 14:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386881AbiEBS2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:28:53 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBA44261E
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:25:19 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2048.outbound.protection.outlook.com [104.47.22.48]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-HD_0dQt8P8W-YsjPEUg9Dg-1; Mon, 02 May 2022 20:25:14 +0200
X-MC-Unique: HD_0dQt8P8W-YsjPEUg9Dg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0051.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:1e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Mon, 2 May 2022 18:25:13 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.014; Mon, 2 May 2022
 18:25:13 +0000
Date:   Mon, 2 May 2022 20:25:12 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org, Andy Duan <fugang.duan@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220502182512.GA400423@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAhFse2h0vN1FCM@lunn.ch>
In-Reply-To: <YnAhFse2h0vN1FCM@lunn.ch>
X-ClientProxiedBy: MR2P264CA0168.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::31) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 687768fb-ab0e-40dd-efe3-08da2c691930
X-MS-TrafficTypeDiagnostic: GV0P278MB0051:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB00511339D845BEE5360F4C47E2C19@GV0P278MB0051.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: qQP5w6VMRBtgKTiu2gD8a0shW6bPfLvR/yyWLjPKMEtSXnDFmMuWf+B4i1KG7YNHqRCKB5N+6tKir7EOX+0kxdd00tZmTNf/JhiLVIca0Gnc2a9JnzESiCwMUE77L8BGCIDNcK02pcku3m/WW4YXZO37/kjqDeA3+PuQhXejMnDN9QlFrErlPFI1jsftEXxemyaakKi8YL9Lfq7Gw/FcbgUbSnllMCG1dRn3ejRCpFZAAAHEedshs9vfYXztFZ5amBPd6PZnH+D9gRirMAM3pIBeFplKVdT/Qq1JIqmgu0YjofSrXNx3J2d/qoUymREe6UFdhP9f8R9VV1eUuvoqqVr/Onin2vtSksGDr1u9Kap4ZTVCFZK1C1Ypq9Wox0cuWwSCt3tpVg93JuFr/KGkzqnbPnkjRs8ctzt1bvpRzEDW9QNXEMX8zIlqiPjbtrBovH5I03t4+rNRQLBeB0Q0rcICPW1G8hBiVHQMMogAzDU/N/qHymzJHhBj278qijnvFXM9wy77pwDktpZlQohRlEtG438CqRhp8um/K6Vn2QsSunTRklDnAFa0rh9KsetO/u11WWWib4/mi1C2alQCvIQSY/w0wu1GEHbKoWGtN4IKFm4lHr5JwYLkq8egde+VRtsjde1S9Jrt4OoysUbxFn2H2H/OdArJ8d4252TzPCKeIwR4T5+bnLduQWB0twZP4LQ5UjUp/xSnVWspzsulZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(4001150100001)(52116002)(83380400001)(26005)(66946007)(4326008)(66556008)(44832011)(66476007)(6506007)(8676002)(86362001)(54906003)(5660300002)(6916009)(2906002)(316002)(38100700002)(38350700002)(7416002)(8936002)(186003)(33656002)(1076003)(508600001)(6486002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oGrm4MLWacP0f7UXoPQkz+FV1SirWfMM6LCU2Y2yo11a1joKPhXPpeLidJrI?=
 =?us-ascii?Q?2/0Gdq/OS7rRv6blZ4HFyj5cFRtYoWV5X72dIVP0lPWoF3qZAsvWBfxT9cEi?=
 =?us-ascii?Q?wNKK55isREgVBJsIWYUHBoRZt3x9rakhiETmEg9fYySOokZWY0ruWPZrUaq+?=
 =?us-ascii?Q?qkuG+ISwfg73msVxd6PF3eeQcvZgkYTqBx413pCtIivYf0I+Dl0fH2XAoya9?=
 =?us-ascii?Q?3Lg82iaEcX7gVHg/mxyDIrFLGz+LuGV8KxkwhEGYCDPcrraoaoGXwXccB5uz?=
 =?us-ascii?Q?G1iY/xim0i7RW8PnMeIGr9ORTM1Vu7QYw7AZUV90fkrhKntL0XAqXcBCIHfy?=
 =?us-ascii?Q?BxFNyvx2DJwuMDyWEu70XjIZRi4Q1BBSiEf0tuS2HEt9Uqk4fQDuTr5jW3CY?=
 =?us-ascii?Q?kRzAnf+JJzgVeD3yJJtdq5At7OWk2fGNjMm682pVHYZQpeH8urVYVPy8r504?=
 =?us-ascii?Q?fHELTqCnpDT1N+5Jf+shp+G4EEmjS1yIpfO9v9h4ty3gUgL/HiKpNYs3W1B7?=
 =?us-ascii?Q?T8Og9XfLxlXstIaz4ZXUHoz0+lOR3o9F0ncGSqQOMvPdiDc4801yZWw04y5g?=
 =?us-ascii?Q?UKPgltKVoXecN0MeuR5fuTB3Cs8rz/GhAiOA7tcNDTCvJJSch9zj2ges66CR?=
 =?us-ascii?Q?C5CyIQPMHu/THmckN4lbbQGsmODypW2cToatYVGXCogwDvC5r9SzQ8StiYxM?=
 =?us-ascii?Q?iKJXLyWOzWGhJ7Z9Jd4RG/riJRzbWNHNFrW82QqbcA7fzGAO01l4YEQaL6hr?=
 =?us-ascii?Q?fObEqpE5sT76IEK/IuzfVkDsrf/XSwIx9Zco547Mvy775QTDuc82N32yHty8?=
 =?us-ascii?Q?ho5suCxuvDMSUxpZ5JBhljoaGFObR/IwlCNtnZOTp8r0XZVYGFcqPjS5VNOz?=
 =?us-ascii?Q?VZwTtZxq2jVeAY+TtGOUrUduXjIACIaHFKvRNOVzKKPoRyY3HsOAC849atax?=
 =?us-ascii?Q?bkj0dmyI8+VQ/Mf14fhQnemlUnAMv4G2O9qNMgZMiOWycPwlRkSasHGZwkeA?=
 =?us-ascii?Q?9XdCqlrUsD1M35g6pTsXcwwaJdy9hgd+3OMRfTA7TMlu/X09VjjMFu12+j0E?=
 =?us-ascii?Q?h8KhVzNCbCozpx3tZTT3E0S4zsssKhFaafQDKu/9KZG6+ACniGlciIAW7Dgz?=
 =?us-ascii?Q?jbnADhWdEhcgLIwSRDq+tRfwAm8LtmyRgezYBFbt7oW7gT9/VTxYzOrINuGZ?=
 =?us-ascii?Q?JLoFiFY9KQbEEFbwZ7SAu9MGmDSpXgcMr5loB5wws2rLx8ViLfYYtC93Lw/V?=
 =?us-ascii?Q?fmxW59V7SwKkAVH0R/uPCmy1nuV+4J7A1GgzZkyDK7OKbZcY2TTifeelvo6o?=
 =?us-ascii?Q?ftXe5wObnLsL5ReAcPNhJQZXuO5JWAev1xU4NURIjkL5J4hrXihwNDHQEIQX?=
 =?us-ascii?Q?kqAu9KvGJ5LZMZuVmZCL/6JkWalrJz6I/8oyRu08UIuPWebOd8TEgt2UNg4t?=
 =?us-ascii?Q?QKEaaeqjPFah4nO3xHOad+9BPtG0iRLz3zU0SQLhO327EXzT1LQ/6E++EnDf?=
 =?us-ascii?Q?MF1ZHkVlXemS9LxqLVd+htRo+2Y5Lpv0JXIgKbtl4QbabdtDPZOgYmVp6B+Z?=
 =?us-ascii?Q?lEceL2KsxoE+pbNyjHsuoVIqKzK/5ApSzgg4YcildvfDA81F+o+kiswijowc?=
 =?us-ascii?Q?XtkyQufR8a3lGyXrLEWvl1uBqSizG8i++qFum6u03+jJUhZrZww8dI+b2PS7?=
 =?us-ascii?Q?2E+PvvGIOWXUPbprPTvLRUCV/dqP0esN9M0yjaVnQOuf3PzZhAa481Iw4tZT?=
 =?us-ascii?Q?ZTCW2Ex+2TFX2bOJx8S2HXbOvp4RQgM=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 687768fb-ab0e-40dd-efe3-08da2c691930
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 18:25:13.2641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csBV08OKp2IqJOX6MwOmGXVU88mdDJKzOoiAe+4PdM69HI9BmwAg+01tMm6PwclODfN5o8SHSXK0cC4mmTPOqv4UXEetFd/mGiFRsutElns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0051
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 08:21:10PM +0200, Andrew Lunn wrote:
> > Could it be that the issue is writing the MSCR in fec_restart(),
> > `writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED)`?
> > 
> > I do see the issue on link up/down event, when this function is actually
> > called.
> > 
> > >From what I can understand from the previous history:
> > 
> >   1e6114f51f9d (net: fec: fix MDIO probing for some FEC hardware blocks, 2020-10-28) 
> >   f166f890c8f0 (net: ethernet: fec: Replace interrupt driven MDIO with polled IO, 2020-05-02)
> > 
> > writing to this register could trigger a FEC_ENET_MII interrupt actually
> > creating a race condition with fec_enet_mdio_read() that is called on
> > link change also.
> 
> You should read the discussion from when this code was added.

Of course, I did it.

> Are you planning on adding:
> 
>        if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
>                 /* Clear MMFR to avoid to generate MII event by writing MSCR.
>                  * MII event generation condition:
>                  * - writing MSCR:
>                  *      - mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
>                  *        mscr_reg_data_in[7:0] != 0
>                  * - writing MMFR:
>                  *      - mscr[7:0]_not_zero
>                  */
>                 writel(0, fep->hwp + FEC_MII_DATA);
>         }
> 
> To other locations which change FEC_MII_SPEED?

Correct, plus the required locking since both fec_enet_mdio_read() and
_write() do write into the same registers.

Francesco

