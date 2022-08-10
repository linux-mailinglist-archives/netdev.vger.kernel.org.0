Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F3858EA22
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiHJJ4w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 10 Aug 2022 05:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiHJJ4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 05:56:51 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A69686EF07
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 02:56:50 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2107.outbound.protection.outlook.com [104.47.22.107]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-3-blpUV5TINEih5Jt8laNCvA-1; Wed, 10 Aug 2022 11:56:47 +0200
X-MC-Unique: blpUV5TINEih5Jt8laNCvA-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GV0P278MB0590.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:44::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Wed, 10 Aug 2022 09:56:46 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3510:6f55:f14a:380f]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3510:6f55:f14a:380f%8]) with mapi id 15.20.5504.022; Wed, 10 Aug 2022
 09:56:46 +0000
Date:   Wed, 10 Aug 2022 11:56:45 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Tim Harvey <tharvey@gateworks.com>
CC:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <20220810095645.GB6386@francesco-nb.int.toradex.com>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
In-Reply-To: <CAJ+vNU3bFNRiyhV_w_YWP+sjMTpU28PsX=BTkT7_Q=79=yR1gg@mail.gmail.com>
X-ClientProxiedBy: MRXP264CA0034.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:14::22) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf62bb04-c093-4a90-8aeb-08da7ab6a32e
X-MS-TrafficTypeDiagnostic: GV0P278MB0590:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: Awr1s6/LvRfNtp4OrsYnMuNY3mtbCcnTh1Bo2jPHcGQ7ebveFcgGchkNFuihRpaSarWsowwBod8CjU7DZNFIuF8pBHeEDFvRr9CDfvVM+yDYh0hx/cPNwop5Rhsgcxc52JSLJb88wn3o89PBFTJ48hvbfYAT870XIEfBGQyEVp7L1SprcMK/RnADw7up3t/iJewgGU0Rn8B/q/lsYy0k0Rp+6PLzuXibwvfVoCk03k00CT+uOAkEC1jlVBovK54uUQIPWVzhHShdFi18czTD4Z5GpzWUmaxHLK1C9+7E2Ug4UDgaaCdU23TTbhLwWEaQOBw6CPD3CxFj5DQMhz3iWrJxjgZ763dpdeeOVb+p3RhWY5AbhTCFA2hD61zLD07Q67hio8//w+FuRzZu46Q2/F37gfsOV3tqJ4STixkKJxFG/rAg57yWXlzSdzrxeWE7lfCzByz0/QOtpWYV46E/f6OF87B/rsYtucyyCZZ0T0Uj98lVZHbLymQ2jVtrgljSefExGM5vol+I2Ex8u/oMhwv4oy81Ixut1y10sA87sCRs1GEzzZ5yxDHLCHT3U2b5/wpiKIsbZOq15MSPmtonm0GcFizZB5I28v7A8SxD5VIs86rRSggy9lpJ/+BUL5ot/eL9t0OegjE9wiB6eLcQO8T5pXUTwGdKN1Cj/pDtyF1GDT1qMR6OSBR5272CRBkxIUNG+CWXVbgboeJ2L9fxc/+1+RfW2NlCwGHDwlgxOTkab2Cn67UOo1VEtGRpcaoFPfmYPoVTKlHWeBEp5Mbf8gvcxwPVWMkx+yhTyxhjsVcI9WQ8FjzDT2QXb18f38ti
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(66946007)(4326008)(66476007)(8676002)(66556008)(316002)(54906003)(33656002)(6916009)(86362001)(26005)(478600001)(186003)(1076003)(6512007)(6486002)(5660300002)(8936002)(53546011)(52116002)(6506007)(41300700001)(44832011)(2906002)(38350700002)(38100700002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?scxA5k0ql9bjFDDfxCa3YPSx54viea9nNIe5yL+1oNtIpre1iFYNt+zarE+K?=
 =?us-ascii?Q?kl5ACEKgOnI2ImVFcx1RxvSmHH2D4H4uVGTeqtMnb83xT9ExNBL0xTUhPrv6?=
 =?us-ascii?Q?R4PAHXjRxe/6T/CV9hbFr83mLC2EqHPh50Q/1iXB8aQqpUAR912ZPzXkm0Bf?=
 =?us-ascii?Q?bTrAdlMGBuzOX28uD+/SCXAdo6milHirDxj5fxzushJ958Kb2z6LyF6XsFMH?=
 =?us-ascii?Q?Lb/nUrGv1mD8pSNTTzLxRbmCgNLL8z+RSj2gEBb2yIgmurl2eeMmrDUltWec?=
 =?us-ascii?Q?SzP/HONSdZZK8lCfpKlQXcq0oR2JLO8rPL79Xye/C0pOWvj9IFquRH7yQMG+?=
 =?us-ascii?Q?keVN/LupGaYCgHzywBp2mQZw+htxmQYOkJPaiKB0hiOIhg9vnlzRizfF/SZy?=
 =?us-ascii?Q?YNnyu6iawAPHuJrnUOzu9o+Nu44+Cz1asfejb8zEjDn7nPuc0MDI1ImYlkRH?=
 =?us-ascii?Q?IsUyRRUuUktNVaoez9eTY1sRfgEEglH7BQMsTWFegmYgpSNDV6Q1Ylo0fXWe?=
 =?us-ascii?Q?m9i4sabesI82oCT3AIMabOaHFdIC6e3UtSEY3MfCl5769Ppy31tSAyit1yv/?=
 =?us-ascii?Q?kgMuuY0YNjrykQeYiZRHrLRczhRn0+PEr3ZMoOLT49d6wiiXwLn1Hfe5FYnA?=
 =?us-ascii?Q?J346Fhme+CqqkDkBECXprLMAnaWjeJii48WYUs4C0PVl0uD8LYI1EUlqPqn2?=
 =?us-ascii?Q?5vE8NYO7i4F8p1vD5QVYMfGpaiOEhmEaa9DS3/aCAz7ldsIVtqSiw7AQz3IH?=
 =?us-ascii?Q?Uuw49U2Vu9YNB8IaCA/4Sv6GcbG9hZLYu3Y3T7suWejkjw+tMiRZNRPgCI6O?=
 =?us-ascii?Q?H4P0MQxVxlyw/9nAoKA7PYCXQtsZYFyD7BP7aS0WUKFpxRtX1gHnDGPhpN8E?=
 =?us-ascii?Q?JmiaGBUOMSc/gPLUOj8wloWP0R43YYMQr4DHF4x18LfyjA2oPkUm7PpTDddL?=
 =?us-ascii?Q?QFlRRYvvphkX1DaGfo68IXEt7JcqdRUqpOmdFJelguV/3Mi7CMwlbANr7SI5?=
 =?us-ascii?Q?AiaxHHjvsCv79kWkv9rqknVLIkSyokQe1Lg0bsDzirAZ5U69X8m5f+yod3+y?=
 =?us-ascii?Q?KcbAb9seMOYCwHdgPd7qWSPd4Qej6e9ceWey7+AYeZGVLhr5aNdXl7XrDUsp?=
 =?us-ascii?Q?qhCiDRwC6NzrUqQYLpW0X3+QDXMgyku4oVP3pL9x4vOBiwwFj88mAMPZTLcO?=
 =?us-ascii?Q?niEWydrLLEVg3szTPbAR0nDv+e5IYGYs5xCSfyfzH9fHIhj0PiweqXBHcbz4?=
 =?us-ascii?Q?bB19XaqT+Hu4YPVoMLM35S/tsCUDRkfzedKFwLZA4zZ7gSjtRdQqFScHXn8i?=
 =?us-ascii?Q?m3s7PIYEdTJPPuaSwBnLmB0clxLpbtjolM8ltRm9bgpPBvxTcaRtOl1XiLy5?=
 =?us-ascii?Q?2/WkhhaGwmHV3RbviIh31ENFwt+NSte2tbD3htAxreXx/Euh+mCYvY+KJORJ?=
 =?us-ascii?Q?IhpslBZEsij4L/dqQF064M8qnDb2U/Bvpo1Ok501v/DrjsBT0/dmG/NE6rMf?=
 =?us-ascii?Q?x8K855DCE0lSab8OH30zJsC6DSHwOeldHZm99l7cWDrczhjf64ZsXIlPte89?=
 =?us-ascii?Q?O9tVGktq4IncQ4WvMJt9cwXCpmSgVOTzkgI4UhLB0EOyGM4ZoFX1zvGzA44N?=
 =?us-ascii?Q?Cw=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf62bb04-c093-4a90-8aeb-08da7ab6a32e
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 09:56:46.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +dBUi2YDed/Qy6FH4K0Q8cJs55Qna1qHp9Eua7WdUKqeWdP8/FwqKbNXAhBMD1rxOsnBJFJ13GoPweLssBnMGpEtK3y085ElIPk837EjOjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0590
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

On Tue, Aug 09, 2022 at 02:39:05PM -0700, Tim Harvey wrote:
> On Tue, Aug 9, 2022 at 2:31 PM Pali Rohár <pali@kernel.org> wrote:
> > On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
> > > On 8/8/22 5:45 PM, Michal Suchánek wrote:
> > > > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
> > > >> On Mon, 8 Aug 2022 23:09:45 +0200
> > > >> Michal Suchánek <msuchanek@suse.de> wrote:
> > > >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
> > > >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
> > > >> > > > Greetings,
> > > >> > > >
> > > >> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
> > > >> > > > aliases in Linux such as:
> > > >> > > >         aliases {
> > > >> > > >                 ethernet0 = &eqos;
> > > >> > > >                 ethernet1 = &fec;
> for ethernet<n>, gpio<n>, serial<n>, spi<n>, i2c<n>, mmc<n> etc. Where
> did this practice come from and why are we putting that in Linux dts
> files it if it's not used by Linux?

These aliases are used also to be sure that the MAC address assigned to
the network device is the same between Linux and U-Boot.

Francesco

