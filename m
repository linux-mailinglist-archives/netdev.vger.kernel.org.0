Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C879514F00
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358244AbiD2PSo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Apr 2022 11:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiD2PSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:18:41 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.109.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 173508A9EF
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:15:21 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2112.outbound.protection.outlook.com [104.47.22.112]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-SFZgvJlMOjmetu3FeMZa3Q-1; Fri, 29 Apr 2022 17:15:15 +0200
X-MC-Unique: SFZgvJlMOjmetu3FeMZa3Q-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0561.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Fri, 29 Apr 2022 15:15:14 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 15:15:14 +0000
Date:   Fri, 29 Apr 2022 17:15:13 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220429151513.GA28631@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <CAOMZO5B6nBH_fFGsg+EKZGTOqqTjztvpGNNCJ0wpbcTq+2vPDA@mail.gmail.com>
 <20220422160400.GA527505@francesco-nb.int.toradex.com>
In-Reply-To: <20220422160400.GA527505@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MR1P264CA0003.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::8) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47be9d3c-ce3a-4a7f-e617-08da29f30fbe
X-MS-TrafficTypeDiagnostic: ZRAP278MB0561:EE_
X-Microsoft-Antispam-PRVS: <ZRAP278MB05614A047A527CFC407DE430E2FC9@ZRAP278MB0561.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: M+yxIdBM/+qVkBWAMNv9kZO5sWPxRMgHkeDmNvl+14HoQWuRl/lchv1sdgs5xvMQlke/oFRLzBI8vV/179OuDU+U9PkPZuWRn6ESkPkg+gHz5z9CIqzZfGQ1gx/uqbrsF/9oQC3kDVWHW414rhgOIr5UL+BrKQkmxfzq8RF1aMCfEtQrZ1b0rnbQwSQ4qh/e5MmMJ+3yoOOvfN4viAaDcGD0e2JMsvZ0ncvy199ijuk5V22HdGF77HyLL6/h2am5ExhOyC23CMIv8x3HlYyZyYyOfha08zwpC/wSnSkGtM1+o6MbAh2JGQ1tOkRlS4dEF/B/OJomcHx/TGaxGyargGEeOESXeuwrkq5YzfjxSOCJyr6z1GqIkF+TE9n1E/j4YHH2frXXQWT1J5BmxjH1//vbUw6lyVxT2i+RdGlMSztNZ1NXa40WZb1PwZu6XA0oIjyk0qlDbYy9gfPquwQvrDLg79tJOaUWKzJDR0oBDwCo6beKGL95sWDd9gckDKBwd6OQ2ysJuwcI4Bp8k9MOYGJJvYFKWBNhWWesqfcMFDHAghWT5xeNJunxWoGUeHBRgrKz4s0sESAJYhUv703qaSfbJJ29uVHA2T/TsM/0/vSTMCvKZnw8QWdHp93ijJMjfsf3N7KJYhnqo3mAyCb+6u4gvyedj+o3r6IoPupT0FLVhZN9bn6M0NBboeRA8cW2sd0Yp0P1gTexFyMYbKx0Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(8676002)(316002)(52116002)(26005)(54906003)(4326008)(6916009)(6506007)(53546011)(6512007)(186003)(83380400001)(2906002)(8936002)(1076003)(66556008)(66476007)(66946007)(33656002)(5660300002)(86362001)(4744005)(7416002)(38350700002)(38100700002)(44832011);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c5aI+d6UFgSqNO5NgHdVtTzMdlTEJEQg97t7Hfj9Ys7koVLuCdNp25cO/FsR?=
 =?us-ascii?Q?xeAZ1c6XyauuxO8LBOHWOqbvyPYgR64U8lwGiL5v5Cbw7c2DWWgN1WPnBZnB?=
 =?us-ascii?Q?RGdi1UjnRWhNSaVbUf/W8iRqJ3akjtuYVZRjBQwHJjiKMCxFOj696wYF7QD1?=
 =?us-ascii?Q?aZqlmdyhc2ugNxsZUk4U03cR6xBbNbLs/oCGXME7+veCwC+SCpxNHpfI/mtI?=
 =?us-ascii?Q?kDzYt65lbGX63kpKa9gkpYd6VlTuu3dbqSsYA7dcTWn9lvqQOkpKx/dT+JTP?=
 =?us-ascii?Q?5JHFqX83y78day85JAeAijVhNXF+eMzQlmahUF8JEt79KiYgq41dpc7un+W/?=
 =?us-ascii?Q?79RNdweZs8d3STJ8gOhmSDdJlF7PMByW+txzxw1OcsTU+n1T3R25vtDNvXkb?=
 =?us-ascii?Q?3w9iLijNg0B4QhwRcFK3JKHyajyzATvhgqYHcXNhqJxXNARicmbMm7IFfblm?=
 =?us-ascii?Q?cgz4tTzZSTsFPPfdZ3x11NWA5O5qhDgs/ZFn5AF+y6T2HfdJzyQOzr/Poh8C?=
 =?us-ascii?Q?69HYu61zCi1OGQSmYWPXJnA0wVFNiFNgaJIVX5a/hbr3SUzjP6+K7WJRQPVk?=
 =?us-ascii?Q?sAqbFmztyTvUnDEP/wCnIcC3Pzx/qxzNeLYS1cncHEwFoa+rMDABfdG55ttC?=
 =?us-ascii?Q?NRz59vHXzj7zXMWLh4Zj75aEJaYjYdbD82F79e4vv5ElB9sRGvpBq9cPPfba?=
 =?us-ascii?Q?xRl1YekoadyFDl0VGkBD0BpcXZhAF6q3TI1MRuPUDDqETK55nkz8X9zL6chQ?=
 =?us-ascii?Q?JsE2HvdUqA7/RVEK3xpmmLAZ/C6I4vpFRnXLERRe4cDZWI0V51DT/blM0x8y?=
 =?us-ascii?Q?FFbHrzL87hH+DeD/AJmt4Bv2WM7PkqErI1hO8yUC6TBzY9UrqRpt5y370S+o?=
 =?us-ascii?Q?BPBGWWh05F0Zfm+ctKeaFfmCWMXcRZipwxgAdUohrKCHo7MtudCwrRXFP6La?=
 =?us-ascii?Q?201UAmyC+DDrtWlWzBrFKWfs4k/SfTdtkgC91DYoy020EhdZTquhoSXWjuAV?=
 =?us-ascii?Q?+SrleNu6p3tEIWaTelRs0n1WrO710AWycARtlvW5+xBTK6uc3flhGHViD2gR?=
 =?us-ascii?Q?ILvOV2HGNv2sHTAFN9InorxPYxHpS8Qr8r0d/8iywkcgGCBsTd4MYhX4aWRb?=
 =?us-ascii?Q?tdlXAmWocjQt/2rCqnSyOhEVd3syk1qX4PuVVjsMdgR6h8l3jmXBF9WZwCef?=
 =?us-ascii?Q?fon+G9KPBY61RhJn88geljkor/qkQJaZ01k1jCZENDwW5kUSrNjkkz0B1OkP?=
 =?us-ascii?Q?mpSJp7HgWuqGl90a1n2PTVxCdYh5xr4JgFsKwmPansfmp8XdXkolt4SCFig/?=
 =?us-ascii?Q?P5s5PtfX1VI9pRuCOVLk7J2BwN/bsa74LVJhN12YcMz0TuAmyAErirEmbXp7?=
 =?us-ascii?Q?79dpuUlxgG4eO8O+kdx8AGFBicTbfjL6E4+HnZ17DZkX/e3p3mIacRNtr2X5?=
 =?us-ascii?Q?/JVVqeDItgDyt7oBpPbd9SmrZvA0teFNZPUdd2D48hAV3M+xN5oj5Z/vgKT9?=
 =?us-ascii?Q?0UmtcD9DRwGPacNZPKdQrGRcXvLLiMCwAmYMTxbARrz5r9jfPE+9yAN36YaU?=
 =?us-ascii?Q?r+m5hQ9EYjmZm7jMFfBRdAWsIlshsdAuJ3DRDcdFYeEabYAbCh8YGUWWqVQX?=
 =?us-ascii?Q?R+7mEUiG6vXsyTsyXRoHQz+0U6yQ9Iw3xAhgYIosNrw8ha7KT2V1XUppinUh?=
 =?us-ascii?Q?n/vgxgy6tiRbT/rUbWd3mW1L0WWPdlSpQOM3ZoeMTRbRb4xKbEuqd4V7zbhQ?=
 =?us-ascii?Q?cObSkLbXMpWeom/cz6l9+bDm1dg3Bus=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47be9d3c-ce3a-4a7f-e617-08da29f30fbe
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 15:15:14.5401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWWthM7m0PKQisrvx2poxX/U5rBTfJR8DxaLFohMp0BjLCyr8hi+2C9bjpUjoAom1El4NNj70FcozNVXhRY4RX4H1Ows4WCPOLx86xX08Mk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0561
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CDE13A77 smtp.mailfrom=francesco.dolcini@toradex.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 06:04:00PM +0200, Francesco Dolcini wrote:
> On Fri, Apr 22, 2022 at 12:55:22PM -0300, Fabio Estevam wrote:
> > On Fri, Apr 22, 2022 at 12:26 PM Francesco Dolcini
> > <francesco.dolcini@toradex.com> wrote:
> > > What I can see from the code is that the timeout is coming from
> > > net/phy/micrel.c:kszphy_handle_interrupt().
> > 
> > For debugging purposes, could you try not to describe the Ethernet PHY
> > irq pin inside imx6qdl-apalis.dtsi?
> Yep, we'll try to see what's going on with polling instead that having the
> interrupt enabled.

So, I was not able to reproduce the issue polling the phy instead of
using interrupt. I gonna investigate more in the direction of a race
condition somewhere, unfortunately I had very limited time to work on
this in the last days.

Francesco

