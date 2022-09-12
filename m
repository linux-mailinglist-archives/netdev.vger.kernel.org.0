Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A7F5B5504
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 09:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiILHHc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Sep 2022 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiILHHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 03:07:31 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.111.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEE42AC48
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 00:07:29 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2106.outbound.protection.outlook.com [104.47.22.106]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-28-c-1QKMbgMya7DU-pd9MFMQ-1; Mon, 12 Sep 2022 09:07:26 +0200
X-MC-Unique: c-1QKMbgMya7DU-pd9MFMQ-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZRAP278MB0964.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:48::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.20; Mon, 12 Sep 2022 07:07:25 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 07:07:24 +0000
Date:   Mon, 12 Sep 2022 09:07:23 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
CC:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
Message-ID: <20220912070723.GA98330@francesco-nb.int.toradex.com>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
In-Reply-To: <20220912070143.98153-1-francesco.dolcini@toradex.com>
X-ClientProxiedBy: MR2P264CA0079.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::19) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|ZRAP278MB0964:EE_
X-MS-Office365-Filtering-Correlation-Id: 84acbd93-a16c-4378-e152-08da948d71df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: vYIQPrLiSTbWTq4oWpHVi98UORgJV7GURduHH6MzAxqjjYE5aknMetqlgIAAqNqhxNqsPTyrgu2Mta/5qR/thqcYT3r7Ynsn8FlAuwWVa/dwzdAY19hwaYXMBPk80B9Z7AJLDU5qHRUTkLFJ+cHaeYXsnyN4RQ4NdM5opP2hdU0GJO5L4lrr2Gw5nD8SP/OT0AyfqaAsPWAYwAK2eYkrAL3bYBADzNpkJEjaGNHRmlf0ij7gp/ZWj9Qc/BnV//jKPjj/PUOB7IYf+uKdcTohvjcn4RF/sU7FiLGm6Ygi6NwC3VCd79KUUDUZiInZdpjsx7mLnMLA7fcbBMlozsZBtlwU3iIlAqL1YifWesoTSuijT+jdd5rOhwEhuUHFI1jnJuj/7z73YAmZiu/YOspmFmOBBkKs61XMta1dR6sDajbsXhQES7C+vX0LuBxRRYx6VTLMiPCbeFFb5BwqHJXYZGhm0UHErzGnnFkM14JMrpWSgPCjdGVV+iXAgcGjX8D0kjXDPLWetJULIIHmqz9KaiLk8tU9DlmYLn4RqPOsUZ4UV73zhkCeXxtqHoNhzICpzaREhEF/HzS9sQ5cvcnAkcVIZz/z+z8JRXAqO/WcV5mYxcwl47c5lGQ4BGr6Zs91J6BBsrcdoGypqraJUMZEoI6kpmAbBJFhRtXuk/59SFH7EFQQxTBIr8ZQqC2lgl8X9V7CgBvcVE7Ez2rSVSZ7LcoG/xlorvauhaE4rJKEMTzBdFoi5xfhtp9h7/bVc98rv+6Tbr2gIA3saaeoq/DA+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(366004)(39840400004)(376002)(136003)(1076003)(52116002)(6506007)(6486002)(6512007)(26005)(478600001)(186003)(2906002)(41300700001)(44832011)(4744005)(5660300002)(8936002)(7416002)(6916009)(54906003)(316002)(66556008)(66946007)(66476007)(8676002)(38100700002)(38350700002)(4326008)(33656002)(86362001);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D120YeeVLMIFcnCjWdWvcFkHknEi6a54dDZTU9DIdOletxDrbTj6a0Q3nv70?=
 =?us-ascii?Q?SZ5w6kQZrUWewAn441ISVvdPbcW+GYPYOTeM06oNEHQNAm5u8L9VVzaYqgda?=
 =?us-ascii?Q?ty60qqXnX7xubQ++zmRxiJOfIAF3xSjq34jvCRmkWUyGHu7pru1imxcV1kK8?=
 =?us-ascii?Q?Nkqi8VTxzMlqfRQ7zGAWK7e4oddpgKBiEwYiJzAFBHa1cYlQ7feo/L1C7N0T?=
 =?us-ascii?Q?2E+3fdeKqq6Q9vPPVDidSkR47BKXr6Obg4hN2IZ3AQyZz5+/h4Hgxs8tUUgl?=
 =?us-ascii?Q?PdRjEV7A6RVDagFXfSh6Clv5KMUcOZielC+JuaKFKKdjlrkwNWjm24C9zl3U?=
 =?us-ascii?Q?uLN6j55nOh3wi3n2ydNsLQOKOqNN3eqUTJ3nxZggHgPJtYAHtzn4YbrgOw9b?=
 =?us-ascii?Q?f/l2GztVsB9b/oqqzGFQbmwhabL1QPM2eJRPgVM1IKBb+gRMv78gWOshTMKs?=
 =?us-ascii?Q?KGC96D+N7AX7xdVK+JfQoF7n/YYxh13K3NMgcXMJkusjY/Ta5EI6RpXjfraB?=
 =?us-ascii?Q?I7FUkiJL6odZJg8DT8+CTPdTzaJLfE+Z+wXaxNpMBGDyqwlzPTbqteJjsw9x?=
 =?us-ascii?Q?l9Pda9Ngs7VWsFRpx2hXFfB75AoMm3psfjPtEHCrZzuaNNehai+7fwQ08Kjq?=
 =?us-ascii?Q?cQH6nko/I+D2rhLYaWJr+TgEpz9UQ/7qz1nt18tvfOTXusfvT2Gi2WjnX/Jz?=
 =?us-ascii?Q?83+ldZIl1XvfAmip/JnA3xCy/mgLZ3mzXeZlJVkPhuMK0HI5CAbHxJmezjQF?=
 =?us-ascii?Q?VgJZ+O1n9yZy86/XWAtrv5j3P6FtMoerBiTkz9JPzAQ1oGCnalU4yfY1wi/3?=
 =?us-ascii?Q?BWOESO0o7QupxUieXR8oyCTcfkhYBRl7y3dddetGFAy/nUciuHadcPjZbCPY?=
 =?us-ascii?Q?BQ5M1NqykCgKf0O2mzEJ5TaYGro9xCxUnQp9ZB8OCQBRb10gZsGgXxsbBYRl?=
 =?us-ascii?Q?jfxj3BQOFNUMmZHjOytZNTUMWulYLdY3rWR48Aom9K46PmFTKE7HDxLYFKiU?=
 =?us-ascii?Q?/oep0EnH7kCp144tlBrk82JNugYc/LHuBp3H9nLAJZFX+2YL0n5EcNJy7453?=
 =?us-ascii?Q?uIoBhe4H9q2vCxe2nf7XL5UyznZLdESWknOoIp8FkS/g0l0Zd5dBs3cD3pJO?=
 =?us-ascii?Q?aCBGuMcTkbSoyKL/im6spqECio38d+bdc1bXT2obxenAqUuW4C4mgScquUL5?=
 =?us-ascii?Q?VacMQJ4WO3BbswoxBwlpFGZkJzGWgY0SNzwLEvWZEw6oXsZIIfdgQQLlvT8t?=
 =?us-ascii?Q?ph9aQHOUPNjRAbDbfzdNDpNCUa2wy6PPU4Dkp7H/mEWzMakqD7dtcFwsxpet?=
 =?us-ascii?Q?TL53FC3RwfUOrdKpU895ffdLfPNXS/reeGfA5lYxYvaggNNx7l11oRf69mu+?=
 =?us-ascii?Q?tGFP+FtzJdDfdS1BRMd75v7NbZS7gOkJAhCSLZ3C62FWchRx6uXPMBAykfzQ?=
 =?us-ascii?Q?KvXCgYKDgDFFz5c9wVmgHXzxz/vFT1Y3VATwA58ulYwdmC8Wms56uyiiVFE/?=
 =?us-ascii?Q?J5wQQDHRav3o736XLixcWh+P+PivF8GZbN6V5GsuT7KoaSdBuFO3N2vOqTJ1?=
 =?us-ascii?Q?6tIDpHjK9uMwazpWkZlS+UoJfHp5v74vXtQnHIkpV9Oq2HA4XXu+IL0ribu8?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84acbd93-a16c-4378-e152-08da948d71df
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 07:07:24.8924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eb2S4jE0qtFm4aavx/bdvWDgO0WKxm3m2UUqhJtdthpSLRNDVPENNTTRQrMNbmr4yH8lajzLg70Y9bHV17pakOa8lW+deBHOMZJPBU16s4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0964
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

On Mon, Sep 12, 2022 at 09:01:41AM +0200, Francesco Dolcini wrote:
> Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
> issues and we are at 6.0-rc5.

Hello Csókás,
the net maintainers will decide how to proceed on this, IMO now we
should just revert both. In parallel you can work on a new patch to
handle the PTP issue you were trying to address.

BR,
Francesco

