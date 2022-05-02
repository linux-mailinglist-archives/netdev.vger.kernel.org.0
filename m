Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED0517698
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiEBSi0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 May 2022 14:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382231AbiEBSiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:38:20 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15146637F
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:34:50 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2104.outbound.protection.outlook.com [104.47.22.104]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-icAljOv2PAORPmBJ1qMVWg-1; Mon, 02 May 2022 20:34:45 +0200
X-MC-Unique: icAljOv2PAORPmBJ1qMVWg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0178.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:34::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Mon, 2 May 2022 18:34:44 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.014; Mon, 2 May 2022
 18:34:44 +0000
Date:   Mon, 2 May 2022 20:34:43 +0200
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
Message-ID: <20220502183443.GB400423@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
In-Reply-To: <YnAh9Q1lwz6Wu9R8@lunn.ch>
X-ClientProxiedBy: MR2P264CA0058.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::22) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 234525c3-b8ee-4493-e553-08da2c6a6dd8
X-MS-TrafficTypeDiagnostic: GV0P278MB0178:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB0178E700102BAD1972A211E1E2C19@GV0P278MB0178.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: tKwmTLbenvvDiRX2XojsPVqog8ftfxza4cVhNGBITUZx99Z/mVV8wPbN+7V9qnehmU+7lh0YkiGfMsUGGr4pqNpazHDuuN1O6z5PARUYbjKFFrX5MUg7JyUMHaYqz46LMXsMjFKD7Fj2IKnwLuub1L8A3QFJZQdbTIU+TjN5XUbXASgcrwUiWn2B2/HZaO9vMnzN4nKHQCsEk19G/hHYzR2oOrXmGdWovPxD29rzlPs0vDQLGJl/bafv26QZSqdiF1VspwsicbZV+cRQ2Ya7Giv+SfaiIoCruqz5nGpeHQLC96ycwiNJ2scLxXUAkrGvB7Bm9epsWriLEFDrPI5P0dHsa2EfR5IqXKSa2jpuvqHrrwddDQ2+JVf5v/vLA+WoV25VoGltpQavirEVkpWGnR3MDI7k8FEhXTMXtaQTVTgEVtLYuS76Zbiwg+D7rYGB3moYcmAW0g91+9NTbDELkH0wI4XdHTqhcuujEzWaqXtz8gnzD1RwjUpUsEhbLo3ubZYR4U7qH+x20yHKjQVblPINfO5TYWWzuv6m6LOeGM97VKe138TPDOODuaE60oN+w4ZkBgJRze4kRvLYmcBJXXonSmmZq4XP+g8Drmidxwx0O2PSCpC/75kHXZz02s+mCSK2VtGuA1FUxpPKauQllYcktdymJ3+EK1f0InkkUNl9VdKMG2KBPrdYfDOTDNzHCygCunQhF1EJ6qq9tko5Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(2906002)(86362001)(26005)(508600001)(38100700002)(38350700002)(6486002)(8936002)(52116002)(44832011)(5660300002)(8676002)(7416002)(4326008)(66556008)(66476007)(66946007)(33656002)(1076003)(316002)(186003)(54906003)(6916009);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sak4GDeMWeIln6jct89wK7ztACg/dCSSJ+AtlZy56jHyFI8T9nULEw3r2jav?=
 =?us-ascii?Q?AQCoHEup7uvU3+PFqyGey9C5+B2uP+iaxOv1FJAoqvhyZdvQvE9k4qrytFBN?=
 =?us-ascii?Q?xi8UvYxb5L2YWsVGivdE7gf0VrDQ+n5B11QmJxQ0WkdquaBzGnvnH9xGlmBV?=
 =?us-ascii?Q?I7F+1sP717vPIXMRCs9AadTs9rb8/KqyvQdjKYsGgHAPPrnCuAoMFQakX2zg?=
 =?us-ascii?Q?WDnycaabRDi9AoPCb1erTtq3eluSKtdrlZhtw+CiNIurnI1zjDMBrQhYT03k?=
 =?us-ascii?Q?kwZU2ILr4x4715y7pEgKd2cfhLNUgtrSg86Ml2/XIVnczTyMyKxaAJOaijo2?=
 =?us-ascii?Q?cyQZaXwdaKsEn0ueuOPRsB8IO91YNy2I9SoS4kuYN4YYPMCG2lJWZiq1grae?=
 =?us-ascii?Q?aQ2WaSAzL31pIPEANg+CEfgtpQBtVgc7l0WgtJ9QcIrOKDr8tv/YdXYlTs0q?=
 =?us-ascii?Q?0Aa3K9uZSpaL1chaG7ZpIF07edEHuVQ0mO40iD4f2K9DIBaMuOFQfhHw/s4Z?=
 =?us-ascii?Q?eD+9Sb7v81N1maNxAgNr8T0dKESRsqMeQ5ftoseokB9UpQTQqVCTXTxb/8ip?=
 =?us-ascii?Q?u3XOKPo3b+cMEFQkK5vtzpe8lEN7oSzgoekSOgygswOlgesvO7o60YGWOJg4?=
 =?us-ascii?Q?RGX/JVahZzOZklRCPpfVItmySyZB9LgxrMWXxe8YievmUTiSKuJsj83A9dbi?=
 =?us-ascii?Q?AZUZQ1AVAVetqcNMfJWU5lGmg9gWZXV6k2uet4tDuRzZUgrD39fmxz0M5rEJ?=
 =?us-ascii?Q?iOES1MMQ/RlTDK4SGlVLHYv4iMfVog54xQGh8udqIOhb01BK73lzyKnkycAO?=
 =?us-ascii?Q?607Umy+bQvAhLyVjAGZeP6wRvILBDC8iKCVnFUJjxytX+qG7yTqlalQZ4uSz?=
 =?us-ascii?Q?2DrsU0RLuHRhDjYWRxwRoL5PfN3NNosHMAMAz7+W5/oKL7CpOdeWsyX+Zebb?=
 =?us-ascii?Q?+CTw8+o84Bb1Olv8LnofWxNHOXdvOCJKB8hXrckReteWQ7W6mO2B1IxfO/K3?=
 =?us-ascii?Q?JtnBUIHT2ZedcIYJsjQkgZvpWXVkWyzdWfZRzIzKLnP4O66y0vr5Hvsf2nRv?=
 =?us-ascii?Q?GvK8jxiK8L+LhrlijXA9tpMMExCXkN+O3IwCiwf6fvs3d1CNI91c7ZBOS+9H?=
 =?us-ascii?Q?8PLx5JjjtZAiJmLzXv4wg0SbeLV2UTpEI+UjL8nCZEBwShC81E3KGgJ2iLMz?=
 =?us-ascii?Q?/vPh3fka4FFxYDf97c136BTkmJIUGNfOd0c6EtzJ6tyVrK/Pnq+y7mt6ZBFP?=
 =?us-ascii?Q?TujIPbOrvzDZh9pzINccJe4lZ/b94GuHxBZfLIP2+oWPLjYsajvd+6kMz7iI?=
 =?us-ascii?Q?6GYJNPQCwkYx9ss9nJWoLdgh54U34YPmmJbHxdzFgw69MOV3Kq4AG/UKZf1S?=
 =?us-ascii?Q?3YgHleAv4VJhH6g1RmPbEo3Ta3bcngVvSMGlfLanB/6DOAY4x3gLFHH42LGw?=
 =?us-ascii?Q?f+88bLWB5qRtB5x6bv4QS/4ZMSrkeHXksGwLS3GeSosoYIBSiaFjtiY/MS4a?=
 =?us-ascii?Q?GU/gUk9OTBfrWkcE78mdKn7as6Xz0n41mv0AWtNWYcGjbHkoR5CNMjK4CSww?=
 =?us-ascii?Q?eU6G1K/NyP3EzvuW6NITZCOo5LIH4Sl881Kb9GibvYI1zc//Ml3RA1yEUDH3?=
 =?us-ascii?Q?5UwZZJ4gbYmHyBl5tZ50J3hacjgq3CSLyAw7Agzjq8ZmscCRy5JavINSAMkl?=
 =?us-ascii?Q?BlMHc0uSz2qnaWrzFphBeUwLcuodz6OCxgPwFKgBM9KgNuvmsivyyJjwIESK?=
 =?us-ascii?Q?BlzC2LH/gS+W2mQRLe/gQY/KajCAW+o=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234525c3-b8ee-4493-e553-08da2c6a6dd8
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 18:34:44.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aHKh9ca0DQCoeA6O+o0dLw5YaoxVwpMYH2zBltnwxYW5GYbQTyJG3NnhYDrAqxYqb4Q80ZFavbYPfqg/6IbzyXzqyrJfXHh1M5F2hJoTPrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0178
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

On Mon, May 02, 2022 at 08:24:53PM +0200, Andrew Lunn wrote:
> > writing to this register could trigger a FEC_ENET_MII interrupt actually
> > creating a race condition with fec_enet_mdio_read() that is called on
> > link change also.
> 
> Another point to consider:
> 
> static int fec_enet_mdio_wait(struct fec_enet_private *fep)
> {
>         uint ievent;
>         int ret;
> 
>         ret = readl_poll_timeout_atomic(fep->hwp + FEC_IEVENT, ievent,
>                                         ievent & FEC_ENET_MII, 2, 30000);
> 
>         if (!ret)
>                 writel(FEC_ENET_MII, fep->hwp + FEC_IEVENT);
> 
>         return ret;
> }
> 
> An unexpected interrupt will make this exit too early, and the read
> will get invalid data. An unexpected interrupt would not cause a
> timeout here, which is what you are reporting.

yes, I had the exact same thought. Could it be that this creates some
kind of misalignments between the MDIO data and the related FEC
interrupt with the first early exist not triggering any error and the
second one triggering an infinite wait?

I guess I need to sleep on this, in the meantime I have a test running
with the change I described running since a couple of hours.

Francesco

