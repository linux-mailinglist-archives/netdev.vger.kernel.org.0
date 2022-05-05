Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C77551C693
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382910AbiEER5u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 5 May 2022 13:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382914AbiEER5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:57:49 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01E6F54187
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:54:04 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2049.outbound.protection.outlook.com [104.47.22.49]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-6-zDcUBAUMOJuZZOJx4Ujm1g-1; Thu, 05 May 2022 19:54:02 +0200
X-MC-Unique: zDcUBAUMOJuZZOJx4Ujm1g-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0294.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:3d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Thu, 5 May 2022 17:54:01 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:54:01 +0000
Date:   Thu, 5 May 2022 19:54:00 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>, netdev@vger.kernel.org,
        Andy Duan <fugang.duan@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabio Estevam <festevam@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: FEC MDIO read timeout on linkup
Message-ID: <20220505175400.GA241061@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
 <20220502183443.GB400423@francesco-nb.int.toradex.com>
 <20220503161356.GA35226@francesco-nb.int.toradex.com>
 <YnGqF4/040/Y9RjS@lunn.ch>
 <20220505082901.GA195398@francesco-nb.int.toradex.com>
 <YnQMLLXsldQt5Pve@lunn.ch>
In-Reply-To: <YnQMLLXsldQt5Pve@lunn.ch>
X-ClientProxiedBy: MR1P264CA0002.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::7) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21ecca1c-aaec-4db4-7627-08da2ec03c90
X-MS-TrafficTypeDiagnostic: GVAP278MB0294:EE_
X-Microsoft-Antispam-PRVS: <GVAP278MB0294FD8CF0060A921D7AD4BCE2C29@GVAP278MB0294.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: U2x/yjSTxJRk8EqWlcaNH9G8BDGdw5Nd5umBa27jqy8qr708coMm7NFUfZCKYsG1RwGDu1lW2/KpC2Oc3r1+oC6ld/kUfLPZoqhMzy5zrnM8sQG1MZSMkf+YNucjQ32DeCQUd7r02TphJ8iUy9yCHF0udaZR9AnPZj7ay2TppotcflXMaU99s4xd98Go+M3CfDGUKKykzUrSB1qHQ0d/aUpT7Q3vUO9l6WMLQcsQOOwhvnPb86fSh4YcmN7ntGXjRUHnN4z3KjMngzfpVjpacD0QQ0Tg2zxsisng9Rqy5dl4/oFLm91eClUolJHEU844Cd0nEPHTSq9Li/nMk8Tc2yHoD9rcZrqBTD6VPlHBr8nQmXqLJBsmHX7zijv7ZRuxRVaMAC95NBB/UjqOD6iZa9gPA1cXrpSJyraYUvRBXiLrbBzuQ0yifCq2MvI/cnjDIU7hBW4N+h+75fhRaeV+XTra6hJlJeqq5Uifbz72i++zd6mbGVGF83f3GAK8G3iaDnISuHKzamOPZBcac9ekQycDUflyZOVUfbbWpfKFqsZ7LhaEIbMrqnzv53jPB3k326/tZ6J2itFvVh+XeMCQPhitV6Yxx7IONgb+qncclxkEhkJQspkCm9960sx9G0RzPii7G7PoFB/sIRn93pSbINT8dYnUzj9MI1lMFZ9V0Ndcs7SRX29w0HjWSWyMHI4vVH6MPdn84Je4x5yiJ2dXDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(136003)(346002)(366004)(39850400004)(376002)(66946007)(7416002)(66556008)(1076003)(4326008)(5660300002)(66476007)(8676002)(6486002)(186003)(54906003)(83380400001)(8936002)(6512007)(508600001)(33656002)(6916009)(26005)(44832011)(2906002)(52116002)(86362001)(38350700002)(38100700002)(316002)(6506007);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eazZZvaLohi1iMYxaJYbbTue7VboTdH/V47VugDpjie0wCtMonh3nUQaFxXq?=
 =?us-ascii?Q?AMJL2MwXwGbObpE7XBR8D4q6zGHeawkfytT4DUvE6VEzZXOjo1MTfreUJXKi?=
 =?us-ascii?Q?6xUR5DhGofZ1/sW3e30vQ94lXjWykh+DwGxg5dOiqKMp4djkZ1Cl/zwqj9mB?=
 =?us-ascii?Q?zjSW/jHPsJm0CuQvrVQQ103pgZX3ZYH0fDrXPgzglss9/qV+3PaMaLGWY5rT?=
 =?us-ascii?Q?Vez74bQVoq0pi6JqCazie/4ojqmJIXNClfKFQ4y5O0GxchrhMjuV9/kUQczk?=
 =?us-ascii?Q?0veSL7sHHMy9ClXO9L5BMls+ZjjKYL1sjBadXd4XTkE4aqBY8+2P86I7yfE/?=
 =?us-ascii?Q?0W82Ao6ut/jlS6WKl7H4S/xIhxLjrxKJur3eEn/n6cNtygHINSROchURo+qJ?=
 =?us-ascii?Q?GWZL9Bs3iyCxRbRcRf76jVyktL/ezpi55+wjSGl+1BXig9AE64+H5+HVdvui?=
 =?us-ascii?Q?X23qsUFCjrCgUKzSXHC8zAvv5MsfglrWx/p1/GUuHEPLzJxDlYeDuuZtoxkB?=
 =?us-ascii?Q?8QEMX11sMxyQ7Icr+IHEcN6DN2rnGhhexRZ6KnFGLpy507r8wXjCC6uDdatf?=
 =?us-ascii?Q?POxOhpEl6dDLhj+gMDj9NWCfHmOCeBOsngqoFH/h2n7+D44wW+XGn9rHBFKy?=
 =?us-ascii?Q?QBzjHS8bXi7p/xDOjO9En6tCv8m3obkoGNWOELZWfmFZBC+bVjYI8/9imtIU?=
 =?us-ascii?Q?YCnccIQpuB5beu+wCun1UudxnwcDYTd2DhkGla3yi79onxYK+97kZlXfy4On?=
 =?us-ascii?Q?mW02SwzBuW1bDtL52zZ4g5pi4nWXvuNzZQAROxrgOPnCtEEidpdgWxXFm5RA?=
 =?us-ascii?Q?/CV0Z1amoHyGR1SS6Vw9z2pvS+rKNrM4+J/iOP1SIt/O7lpOfRmssT6mPhRz?=
 =?us-ascii?Q?DqLhw/intI/pdWKrGoDfVSibG4TjbMcgP2H6zejQTywN/eQxMimJCqQn2wkw?=
 =?us-ascii?Q?QsXgpKX8RKEjeVLuQXtvqiBqKbXZPwLXKD+ahuOCPH+Z+SN8NiZD8F8DGWmH?=
 =?us-ascii?Q?ISIzpiC2BpeWjXNQaFfAihNvNApIesAAmkXHPgR7BEvPeVAUwNZMFPcIflyn?=
 =?us-ascii?Q?XspIfn2eVKRcGCNpMChs01OL2hG9mxRvbDtKL57uEohnkcBEHE0proVl4SFg?=
 =?us-ascii?Q?p2eR6XU5o7ymsNTnINyxkSVyYC4nk1omioEDTqnTnO509GZITKUCmW+EsFZ3?=
 =?us-ascii?Q?B/S1yR4FN956E3qhwmkLA/P+KaTnZsLDzeAs5VcG22VGNFgJM/gMJuhkT5pK?=
 =?us-ascii?Q?9/Wlbmsl/NslPmGUj59+loZTLmz2M0LtDDZWv/os9en5kuSyclsJTXkb/APh?=
 =?us-ascii?Q?zx18qlHiVsYU2T8IClc32/9GIJKJ7uBXPKwJ1MgC7ynBncgEtFP6dxlagkH1?=
 =?us-ascii?Q?VV6w5jhMzstLEtGSic/bU5m7b3HCvBoherJxKOoD5WJHsOC2bowqchwhz/y3?=
 =?us-ascii?Q?VjvqsArjLy4EQUQi/pIGivMUxlQdPUZHiUhALxypWM4MVPlDAIgL9MU+Tcv3?=
 =?us-ascii?Q?qwVfxNHG+3aiNTU6Ncwh9pSIyXnvZt04IRXXln8OWqbTB19kO/ypVG+oBKYI?=
 =?us-ascii?Q?JJ186XU9z20IwFAURpIoMUGlckhjV9zNV9q7TU+UIIzQb4cpBQsiMVBnmJ/s?=
 =?us-ascii?Q?eFKYfNu7MiaEdke6aORaFxPU9s3K1tOkcqNxkOGKBIOH6FgRSlR6iG67blQH?=
 =?us-ascii?Q?IUtr33eEdWOOtCPK7GxvOwv5YOEY8tOdK6eXy3qmkDiw4YSnZzUBHYCgGoXu?=
 =?us-ascii?Q?CkQjMi37vlLJ8YBoauQyovEzh0aFJHg=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ecca1c-aaec-4db4-7627-08da2ec03c90
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 17:54:01.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yxQrijQgVsziKuhHdYGj0hpGThHCtlhCs2wiUvjbn4Su/UydjIiBd7YZDe14xwz+XmwE9MjUStUMxo7/R8U6+pAYCffd+b5zA3lNu1oYGGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0294
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

On Thu, May 05, 2022 at 07:41:00PM +0200, Andrew Lunn wrote:
> On Thu, May 05, 2022 at 10:29:01AM +0200, Francesco Dolcini wrote:
> > Hello Andrew and all, I believe I finally found the problem and I'm
> > preparing a patch for it.
> > 
> > On Wed, May 04, 2022 at 12:17:59AM +0200, Andrew Lunn wrote:
> > > > I'm wondering could this be related to
> > > > fec_enet_adjust_link()->fec_restart() during a fec_enet_mdio_read()
> > > > and one of the many register write in fec_restart() just creates the
> > > > issue, maybe while resetting the FEC? Does this makes any sense?
> > > 
> > > phylib is 'single threaded', in that only one thing will be active at
> > > once for a PHY. While fec_enet_adjust_link() is being called, there
> > > will not be any read/writes occurring for that PHY.
> > 
> > I think this is not the whole story here. We can have a phy interrupt
> > handler that runs in its own context and it could be doing a MDIO
> > transaction, and this is exactly my case.
> > 
> > Thread 1 (phylib WQ)       | Thread 2 (phy interrupt)
> >                            |
> >                            | phy_interrupt()            <-- PHY IRQ
> > 	                   |  handle_interrupt()
> > 	                   |   phy_read()
> > 	                   |   phy_trigger_machine()
> > 	                   |    --> schedule WQ
> >                            |
> > 	                   |
> > phy_state_machine()        |                        
> >  phy_check_link_status()   |
> >   phy_link_change()        |
> >    phydev->adjust_link()   |
> >     fec_enet_adjust_link() | 
> >      --> FEC reset         | phy_interrupt()            <-- PHY IRQ
> > 	                   |  phy_read()
> > 	 	           |
> > 
> > To confirm this I have added a spinlock to detect this race condition
> > with just a trylock and a WARN_ON(1) when the locking is failing. On
> > "MDIO read timeout" acquiring the spinlock fails.
> > 
> > This is also in agreement with the fact that polling the PHY instead of
> > having the interrupt is working just fine.
> 
> Yes, that makes sense.
> 
> But i would fix this differently. The interrupt handler runs in a
> threaded interrupt. So it can use mutex. So it should actually take
> the phy mutex.

I was just about to send a patch with phy_lock_mdio_bus() in
fec_enet_adjust_link(), anyway, I'll send the version you proposed in a
bit.

Thanks,
Francesco

