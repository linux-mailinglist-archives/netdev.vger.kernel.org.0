Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3868589CA1
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 15:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbiHDN2N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 4 Aug 2022 09:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbiHDN2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 09:28:11 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B27615FD3
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 06:28:09 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2041.outbound.protection.outlook.com [104.47.22.41]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-9-lrQjHKw2NOG28SFoxBqjMg-1; Thu, 04 Aug 2022 15:28:06 +0200
X-MC-Unique: lrQjHKw2NOG28SFoxBqjMg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 ZR0P278MB0250.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:35::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.15; Thu, 4 Aug 2022 13:28:05 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3510:6f55:f14a:380f]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::3510:6f55:f14a:380f%8]) with mapi id 15.20.5504.015; Thu, 4 Aug 2022
 13:28:05 +0000
Date:   Thu, 4 Aug 2022 15:28:03 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Steven Whitehouse <swhiteho@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Christine caulfield <ccaulfie@redhat.com>
Subject: Re: DECnet - end of a era!
Message-ID: <20220804132803.GA428101@francesco-nb.int.toradex.com>
References: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
In-Reply-To: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
X-ClientProxiedBy: MR1P264CA0145.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::10) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bcb0121-1d9d-4b31-9faf-08da761d2983
X-MS-TrafficTypeDiagnostic: ZR0P278MB0250:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: L6Bvxje8fmOZi+wQzE8mMPc93xyfV+1200Y742jQCU21dNjbJx3UX4GDQtp/5fTM0D47fOVXF1cL10+3mk7HoJ0fSGkPFu6qej/XVvKZWuSVSw3FAEmA5uVk+9sr7bCaZrIRjKBhpl/JVr9v8SF121hvXBFdFJud7xMszZFi72SJMGDZgehfmDjKvAMmqB7NGUIl+VpnuKsyfuC/uG+STckv/gQG7m7kE7N5na88qXtCCWiiBP2+br8IZkLgqck2Bb+GiGreYueTSuLKJmaPl9G+/iwGYAnvwRR+k10SeljqPxfwCbrXagDPHE28TdtUeQkRNB1qxCLUiIXHx7XBU6xoxv+YAXpRY4tOX08X/ygI2vmECUyVqWBVH8McQgLMl7vNS9/nmWlDchd+ecY6ubX6zbJlRpNxeSQYo2v+ZQYaNiU3qKEqaWQX/m5sOxpI4yv1eg3tZJE+BlnHgf2ZCmZJm1hJ3MYSHHmfW2Ojq2mcjWb+EGJmXNJPJi/oSgQ0vXGl7ULSz9fFnX43r8XttplHZJbkQo2U99X7Qmu31stvfRJ89XJtFNI+BFMjfvZ+35GmynIDPhW/1ux6hUw3P7t9UgTOawtKNUaqMFMe/zymlwEx+7ZilS6/8oCty4x1RwzsUUhoXUvNdpOo9tbVGL6+Cyy8sU6AV0J0xNshTzbFI6j9D20tIhKAwcy0Daoy8GflsOLcYtFB9894iUJF9iE6zQC50NZa8YRNDo6J0PXh2kCd8OSTEOr0py+Ir4DqEt7AtKo34QjNFUeVPiQJzjVTDylhS9RWwKAzc9SVnDs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39840400004)(136003)(396003)(346002)(366004)(376002)(33656002)(52116002)(186003)(6506007)(41300700001)(2906002)(1076003)(26005)(6512007)(38100700002)(38350700002)(86362001)(4744005)(478600001)(6486002)(6916009)(54906003)(5660300002)(316002)(8936002)(66556008)(4326008)(8676002)(66946007)(66476007)(44832011);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z4noTTaMYue3JpKvjBDMQ81zYCuLQL93txKIPnNZ/QiqQfEEYiBXIUdaXSYQ?=
 =?us-ascii?Q?dJaFFBIX6S1XpNYeSTMhEV2c7NimWRB+deGwVqjXTRIFmuDjGzfVz8XKx6/F?=
 =?us-ascii?Q?wzmmFJZ6QzqI2ribJt7UCy/1E0Cx8LpMNz5xArcIQ7XraNlbPzVkJ0rDzO/j?=
 =?us-ascii?Q?KyBma7r5LjykNi3T0aIP3nBvbZm4Dt6UJ2mvfv+RaThNqWItQ4/XS0tvIzJQ?=
 =?us-ascii?Q?jKigkv/w71lp4/cH5S7OjV43J63EAkTNwROkjlL3+eQZMk+ivhgu/yWMLYX6?=
 =?us-ascii?Q?ai2UhV7yvss+S1oG+YeL2nySYQ5wPPYpZ0wu4jggRH9Y0JiTZxHkaHoT82A5?=
 =?us-ascii?Q?b5VBmrB3wim7xG/QHxhV3rEG/cJpj4qR7zBJC4zFJj5ahMT88UwEznXpavdz?=
 =?us-ascii?Q?ytVw5DwjdxYWMuSA6YB7G4D1l1LaoLSGQu7WRSfy2zfv3LSg/2T3HunTTkOq?=
 =?us-ascii?Q?2AFeBGxnkHQKUGtNFzDpkHmrs0zV8lIpoQ81sqF/0ELhsGGOvHrl+gKnn7jg?=
 =?us-ascii?Q?oXv7NPE5bHmBRWRM7kd54aI/GExXhyRCdiDdy6GiqMVuOLP6hZ6lKetMerbe?=
 =?us-ascii?Q?+2UJ13LMRiQktj3v/2o6WRaPzfZd6GzsgUAiIpMuBMn3/NE1BH/DBoGajChG?=
 =?us-ascii?Q?AyRgNP+64b7F5R+b279J0hlTQdonHkJGrGV7EFChVcTgcqtdkWtM9VPhvB+m?=
 =?us-ascii?Q?UTPnTrNu7FxO0WJRTbTVgjxr9SZS7hfG8VyINUhSPASSXxtN35rQ/LMcGewF?=
 =?us-ascii?Q?Q6ppT/J13lCU0079CdSM3YQimYGiuNPxVkgP9O8EH3rLThltCXN/iCN+5mQE?=
 =?us-ascii?Q?jPExaPDR7HJJhLNGQOWfoYBYhldISQM1kk7scsLmNiJwzuxsrEcGe/mzp6xP?=
 =?us-ascii?Q?mU/oduBy3KGCczj+lmUinhau2TgGGgxP4zPJienhZbOoRN45HbrDVyQ7Vi9+?=
 =?us-ascii?Q?bcFKm06omgGGXX+izhmxhsvZqfgYFSxY/C8bRn2tzThogNrqtAy2CAAoOLJY?=
 =?us-ascii?Q?gEuhFK/6AN/GWzjRJ31nZAatULH/yR0VriE/bKG1I1dvokPdjL01xkGSH1ZG?=
 =?us-ascii?Q?/A/W/Gpy24Jm3vOW5ZwHvpPhrP1BXtAx7+GqEJLfZ0AJg/lbOLVI8yuc0EQM?=
 =?us-ascii?Q?P0o5kSMbIdTWd5r+h9OOqT5AmDKW8AHd/oiNlsaFztofHzL5rDXzN2d6WJVw?=
 =?us-ascii?Q?KqcNfhOk9ChYSNhwBL+ZT6EHbfqNGNn07EiHWC9Yo0nUMusisC4f4JrBGNfP?=
 =?us-ascii?Q?w8NaQVibQMz64rFw8+ysrDMP7QI8raaKOsEniE8d7FPrvX0JngcoJAqaXZY5?=
 =?us-ascii?Q?odsXz8cdDKgFeH8hxD4rqMPcjvpqAaHDLvCk2E9WRdFab4ycYHmSXxEJlKc4?=
 =?us-ascii?Q?52grQVrpIstqmpIvxI+CX7nDeuIKfAiggggbIELKO3iSFRBQjnzc//4Uv85b?=
 =?us-ascii?Q?6soH/PYEs6vc8M/SgfYX2btO0W8v6azjEuf8wKg0Gq237rZZdMyQtdaXWTiJ?=
 =?us-ascii?Q?K2bwPTKtFAjYdypFs9TVH2BnGA47sCD5Ih+ZVEdZQG/sLiaY1KlP0lRRo7z+?=
 =?us-ascii?Q?LW0RE66wNs0PSKicftb7nVOD5VBCTapNqkyrCj6kOMlMjN1nb2Tjt4tyi/oY?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bcb0121-1d9d-4b31-9faf-08da761d2983
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 13:28:04.9904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qz2s6b4vLIa/Xy614ZSvaFfU64056dlhPxBRYntGPzj4GEaUa9Qq6Vmsu/fbwj/U4RA82P50qKc0jN+OunKZEX/s6rTyiZpUVZxQp8NNTGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0250
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

On Thu, Aug 04, 2022 at 11:19:27AM +0100, Steven Whitehouse wrote:
> Still, it would be shame to let that happen without mentioning
> some of the applications to which we have, over the time it was
> functional, that people have used it for...

You should contribute a couple of lines to the CREDITS file in addition
to this email ! :-)

Francesco

