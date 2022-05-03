Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C677C518974
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiECQRg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 3 May 2022 12:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiECQRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:17:34 -0400
Received: from de-smtp-delivery-213.mimecast.com (de-smtp-delivery-213.mimecast.com [194.104.111.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C6B435AB9
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 09:14:01 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2109.outbound.protection.outlook.com [104.47.22.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-32-3SV_NNOXPR2oxr_1hd36uQ-1; Tue, 03 May 2022 18:13:58 +0200
X-MC-Unique: 3SV_NNOXPR2oxr_1hd36uQ-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0371.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Tue, 3 May 2022 16:13:57 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::f465:3051:c795:3c2%9]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 16:13:57 +0000
Date:   Tue, 3 May 2022 18:13:56 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Andy Duan <fugang.duan@nxp.com>,
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
Message-ID: <20220503161356.GA35226@francesco-nb.int.toradex.com>
References: <20220422152612.GA510015@francesco-nb.int.toradex.com>
 <20220502170527.GA137942@francesco-nb.int.toradex.com>
 <YnAh9Q1lwz6Wu9R8@lunn.ch>
 <20220502183443.GB400423@francesco-nb.int.toradex.com>
In-Reply-To: <20220502183443.GB400423@francesco-nb.int.toradex.com>
X-ClientProxiedBy: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f813a9c-3a09-4d40-6017-08da2d1fed25
X-MS-TrafficTypeDiagnostic: GV0P278MB0371:EE_
X-Microsoft-Antispam-PRVS: <GV0P278MB03711855452086269E403541E2C09@GV0P278MB0371.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Ydmer0J20LaS0yF1gChQmVGM2/DuFO88o/wyB39mskDHQNZ2B7a27mpjBZ9mhKnYIy9FmnqXa227ykD5c8nhgbzR/UxeMBzBxdKsoa3m4HmBVMe/pa2+iPgc2ao4tSjL/7gMWYkpW1UP736F0sLgFnjryu7XGPH7EeXVnyU9vZ9R2yUxdQ2RXGLdjkXZkfMhqY6U5tXdu4QwTt7hYfAb1RPmhJe4m4lg/Ssgyotp6WXP91eKXVy0Lyod5d9MVtI44uDK2el2StWjM8YUPi3DDvoF6yCJm8SLfgKTWa7VxFVvJnBhWOubrTTRHMaWK9GVLWIQObG4+e8q8NBic049pTM2KJeP+ZfjoO7lqeFlEY9xdQUJf6ZjnBhauvmC80LY72NuGbYQHAzicp+92zopfAcXBhMkQzNqX6FEvc4H7TgyW03Qgzis/NtDC7Cfg/g2h5W4Olvgpvs/Jt3HSpUbOogBorLgi4uJP7yzJtRe6HFiQAeKXq7EZDCCGEWza/kIylrpOyVqvIyYDecoL4KzIlBsiDkP/FEU7H/HO7pxIbRgWvCaQ3Gqfb4eXQUbDzYPDAVdaYreS5oHCjDlxDZYSR35KfSNp8ieYSBTz+wkDh9BftFZ+irgwtg5vVoUO2Der+bUMcjY20UxO6FAZcTDG/CvqIThsMl6rmofsjYZSG6d6W1++Fl2Gw4bKRJZlUrSq9PYd6JEGsH13RjxDXx+iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(316002)(26005)(86362001)(6512007)(1076003)(6506007)(186003)(508600001)(38100700002)(52116002)(2906002)(8676002)(38350700002)(7416002)(6486002)(66946007)(66476007)(4326008)(5660300002)(33656002)(83380400001)(66556008)(8936002)(44832011);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yBOzgUYipZi2FpzOdqWy4jrB6LwFugmjlnvUK+Cea1Ijyo+JriLNjR7D1Zhs?=
 =?us-ascii?Q?BmToqKGtm2KduKJ5ke7VCQvvNCgR1Q1CPpklqFru6hQ/rDgBTyAPaXK6Aiu6?=
 =?us-ascii?Q?avlME1o2F/U+k1thKrqzHyqDNAIfboMwXH9ruCyzbmSZkq3ABWyeEujwnqr4?=
 =?us-ascii?Q?ymM1UZFBzZLloBPvjTYj2I9nIqSKkqzpd8RoigFOVUqQ+ccePxB2yHN1lr9s?=
 =?us-ascii?Q?CuyGo/5P7KUG0LmmFFiQalj7m5Hz97M8bvNxmmQ/cSLQn52rheHr7iF7HXj4?=
 =?us-ascii?Q?BiGhWUriLSkZkUYvZRdB5W9Zw2nzZh2qHpuTcT3JmXTM/c88k3zcDEr7BR9i?=
 =?us-ascii?Q?KahLDlnnzmCcPfRarxa6YuApgYXCZPpx5CTBASc0WHbSMHZLP+13ysaVnkz4?=
 =?us-ascii?Q?07wLrt7jAx+OPnVdZI+Jq9Wg3mVVwcA9Qs2g6fGeYp8xO8Y/hWGkdeeqB1MB?=
 =?us-ascii?Q?WpnhCIEQQfC/+QEUTA2jSJKiHn+MYTn3CUaQm6UPEQ6frfs/knEHv1pXUyc/?=
 =?us-ascii?Q?Olyn8Q5WGqWO7wRnerLha/4NqlMjEGNlztKV9qkmPaKnZGQDM4ncWczlkeXN?=
 =?us-ascii?Q?/Ud984vKie2dSW21u3ChwSreGo5lPGoVIa+NxivkFqsGxa92DwwQhjrbwTYN?=
 =?us-ascii?Q?pG0jrAC43ZVo0rlNnDyBkvNpjr+/CV3ATZ4dIv68sde77oi5C9q/NH3dTGx7?=
 =?us-ascii?Q?I/XZKZwgXEv/G97yOztEO/vh5dCDZNo7S2uZ6BpyzcrDqUs8+lxhLSH1TKQy?=
 =?us-ascii?Q?gRRDa3pilNhhs8dQqkSm+ApblQ/nGFMYL2cWqdnQuuCfPFpXowEulyGi1tMD?=
 =?us-ascii?Q?r4U3Z4rTIzIzP3Dy90/HoK3QfgzfcRm9lurMKoW2FYu9gMfyTvwZ46fIBP73?=
 =?us-ascii?Q?XkRv3OUkuerS4a8rKbHiGrMx8EDeP8ozUzefjrrMxU4Zc46YQok/RzCBOvUR?=
 =?us-ascii?Q?aoW3smrg7bc3Weq92VXNkFnqcjAsy4gppBVrWyDXIG0kr+uXhPKS46+9rwEe?=
 =?us-ascii?Q?8CKeVJIV98l4Rw3u0+5YgLlczDc0ehTmaVpkeFIuzGQgltbYbBuaJlra0Mmm?=
 =?us-ascii?Q?0eecGMpJH67U7KYrNI8JYGEq2wukBSgIa+CsPSvWIBIHyJWodVxGTBGZyJ0V?=
 =?us-ascii?Q?Wzo+OmpKW423V+iFfXFf7aeFSCSCRoBRAg10T9Rh2HAUnFkiU4idmASDtRRc?=
 =?us-ascii?Q?9d5ZcnxxPJTO9V5NFG1mkGkw1WCIikpL+bcHoHJ5GkIXxsOm82b6KmR+ydlh?=
 =?us-ascii?Q?xUx/enp7PujKUgrvobUU325cQXYk93pGpdX/ioiltMyPRegtIxaKloRCoG72?=
 =?us-ascii?Q?HRetfb5c2QxG2Bu7CY8qqw1T1nfguIlE897Mu61o/w4Be6mezGSwYlmIFExC?=
 =?us-ascii?Q?hKLffFQ10Fgpq+1KnWPKA4pQ2KmJOGgByUXIRYMVbWfFaeIeg35O7xhOIRvC?=
 =?us-ascii?Q?H0x6v2IfLW054gzYFmZIwZf7nOmAEF/WBadMER4+79kbdVsPeiXNCXIzPSUs?=
 =?us-ascii?Q?za+TwtH+TMY3zdI1GRDbuI/tCmpFZhj1Jw3sCzEhgFVNCfknY7zQ5fBSos5X?=
 =?us-ascii?Q?dTfsLB7p9y/n2phuSowu1dP01l+4rMuu7DWAJvo4NJHUmQuBlzeXxv6uOZR0?=
 =?us-ascii?Q?1SfDrx+Vd2Nb16sTI/M+ljNdFkai25YOqTf7uVTtKU00RsZs8JMKEK4g8oZC?=
 =?us-ascii?Q?SQFLg5j99Scfixh+0zg7khgN3LBJhSdPWeBXmcVk7mtIsOF30HgndWwEMsl8?=
 =?us-ascii?Q?NCd7GyVbqyMEVIJuMUaK6mJ5u3X8R6M=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f813a9c-3a09-4d40-6017-08da2d1fed25
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 16:13:57.3169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stqhmii+Nh8ZGLcYDCR/nriHjpt0vYqpk3u1IKVSyDTV6gzvDULMiQy9V2Sz0fQ06p8On1PrRAscwFFwpLKoHC6xVvvzlx/BTNuWTnIHYyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0371
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

Hello all,

On Mon, May 02, 2022 at 08:34:43PM +0200, Francesco Dolcini wrote:
> On Mon, May 02, 2022 at 08:24:53PM +0200, Andrew Lunn wrote:
> > > writing to this register could trigger a FEC_ENET_MII interrupt actually
> > > creating a race condition with fec_enet_mdio_read() that is called on
> > > link change also.
> > 
> > An unexpected interrupt will make this exit too early, and the read
> > will get invalid data. An unexpected interrupt would not cause a
> > timeout here, which is what you are reporting.
> 
> I guess I need to sleep on this, in the meantime I have a test running
> with the change I described running since a couple of hours.

After a long sleep it seems that my change did not solve the issue. I
also verified that writing to the FEC_MII_SPEED does not trigger any
FEC_ENET_MII interrupt on my specific case.

I guess that this could be still a real issue, but it's not my specific
problem.

At the moment I'm a little bit lost, what I have verified so far is the
following:

 - fec_enet_mdio_read()/_write() locking. This is just correct, with the
   mdio mutex.
 - potential race condition with FEC_ENET_MII interrupt while writing
   FEC_MII_SPEED in fec_restart(). Proved wrong by both a test and by the
   fact that I do not have an interrupt generated on my case.
 - increasing fec_enet_mdio_wait() timeout to 100ms does not help.
 - clk_ipg is always active, once the device is open the clock is always
   on (verified with runtime power management debugging)


I'm wondering could this be related to
fec_enet_adjust_link()->fec_restart() during a fec_enet_mdio_read()
and one of the many register write in fec_restart() just creates the
issue, maybe while resetting the FEC? Does this makes any sense?

Francesco


