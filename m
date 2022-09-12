Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4D65B5A42
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 14:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiILMis convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 12 Sep 2022 08:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiILMiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 08:38:46 -0400
Received: from de-smtp-delivery-113.mimecast.com (de-smtp-delivery-113.mimecast.com [194.104.109.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2F221E06
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 05:38:44 -0700 (PDT)
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com
 (mail-zr0che01lp2108.outbound.protection.outlook.com [104.47.22.108]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-13-MHZtbONTPVWuzZJlKn8BRg-1; Mon, 12 Sep 2022 14:38:41 +0200
X-MC-Unique: MHZtbONTPVWuzZJlKn8BRg-1
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::8) by
 GVAP278MB0953.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:55::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Mon, 12 Sep 2022 12:38:40 +0000
Received: from ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b]) by ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 ([fe80::6c6d:333:ab23:3f5b%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 12:38:40 +0000
Date:   Mon, 12 Sep 2022 14:38:33 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
Message-ID: <20220912123833.GA4303@francesco-nb.int.toradex.com>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
 <20220912122857.b6g7r23esks43b3t@pengutronix.de>
In-Reply-To: <20220912122857.b6g7r23esks43b3t@pengutronix.de>
X-ClientProxiedBy: MR2P264CA0164.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::27) To ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: ZRAP278MB0495:EE_|GVAP278MB0953:EE_
X-MS-Office365-Filtering-Correlation-Id: 1652925d-7cc4-4c04-662b-08da94bbb864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: co/2NkAE6fouQzvaN451ao697FNKrJ6j9izNcA5jQMZvinPDg1V8ws4IEFJgKST58uJMWWTIVRSihiaoouE2a6RuRKI6o61kiEY11S3zdAIMK0+BqHmwjUWFp2BTcUhM6FPfahrU98jRZakL/JShiUHv27oq3sm/Mmg0Uvdr2cmRrRS6Jzx611n3XeHYOVMHWLzAoAnkS9MGh7Y/UvkBei4PuTEFKAGNclQgaCG1muo1mrUmJFhYkei8k0RaLDTtbE26aTQ2HJF59NxyBgFrJym75/fmjQLS33d/J1y6mUakS6m2rpcC2BNSKvsvq610hrkP55BZZ/5d3XMdo8ooVqrq+6A24zbSkjPTGANx6PGTztn3kwp1YUL9ScGzAdPE0ETwyOuer2aoHukj9E9ukic8IhCTQKnzkU5pNp3AOdW2UAcrF/12oFcKAWNX6/UaH21XB42RvhIReMO7oXO6qmlZyFXB9rMTNlr+VB4Sw2Jje9ehpKPxn1rJiaQqSHa3c7K/pednP+wMwM1wdYQzxs1fU2sVbev75nJdgwOhNNtjBK3uD9ZXUJelrcdWq6/NVKHBjN0WS21Hak0lkuw9HXU1uEddHv6kEBMihuIWjZCWuYcOYWuVQLWpAw13sovfLbpk43WlEjWdhEex/GQcK/eZ2mPEz6rufERcO0oOZ/TmMYRXVyuqhmq5Lo4BlxaGNWdnfIeDnnUBgqegRg6o96uflpcgnuYRmDxnuM2svmzett9sJeXxzOG3ymt/yqYaZuXtt0xKHaU3UUeJMOebQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39840400004)(376002)(396003)(346002)(53546011)(6666004)(6506007)(52116002)(478600001)(6486002)(6512007)(41300700001)(83380400001)(1076003)(26005)(186003)(44832011)(5660300002)(7416002)(8936002)(4744005)(316002)(2906002)(54906003)(8676002)(66476007)(4326008)(66556008)(38350700002)(6916009)(86362001)(38100700002)(66946007)(33656002);DIR:OUT;SFP:1102
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vN0wJXFw+qNVC4HB58KLJj1fVPUXvMcJ8eSfOAc+LXjJ10wfedWRFE7+ysIi?=
 =?us-ascii?Q?N0jr+9DkEFxIPsingKCOLChU05PSSI/vNFA5uBiuDw38NVw2K0tDy+gmJ6z+?=
 =?us-ascii?Q?wMMQbsLblD0v0ddfrPxBVgvO41pQhQAxxPO7Fn//6aaY8SBxgCTyzrfR5nqn?=
 =?us-ascii?Q?zL1m2nP+0sfOrY5d6CljxCTUxM/MxLJKw89RvzEZJdqFaEFjrF3p2hEjrVKK?=
 =?us-ascii?Q?HthFqVKiXyu8YyRrLeeKU88gz6rnvasVkp/ZG55elSCdZH9PfsT0ZFDH9Ik9?=
 =?us-ascii?Q?OROCEXM4bbDd1tjQeRSIPqxl8SAM57+u187svB8sJmilvZRVDZs18SoCDyUo?=
 =?us-ascii?Q?VnNJIou0Hb8f4e7obba1AVePlVmto8BxjIlJen7zZ9UtER5JABxA1Bg6oppI?=
 =?us-ascii?Q?IWYYuz7Dgmz6usrXFe8N0juE0B1B0pwkGjdcRNbnwso/YSELuuOFFKhn743W?=
 =?us-ascii?Q?6WMqUNUnsi69GfBDsM1jg0UXOB/pclEFCCZVhbJIHQqSeXNS4QTfsU7AmeUc?=
 =?us-ascii?Q?Wz49opjHB015Pk18F9cvvRbn7a7/fMcHBEtE9pyj6IwwuLEf/seAC+OHB/lZ?=
 =?us-ascii?Q?4LUn00qQfsOD7V5SkvnuQrux6iPoBeTH1RrsRbXDhf3mRBrc43WFHQKI0X8L?=
 =?us-ascii?Q?ZSxC/KwUEhJAfpLuA6CkBATFbO8Wmi7jLypsKYYWTX0bXrUoDdpDV4QCzS6G?=
 =?us-ascii?Q?3DSs/PvM3B0p/nyZKE1/ywK2xBGRQhxLJbmzO2LP3k+xMsthv30HTwb0W7lT?=
 =?us-ascii?Q?H1whtfmL7K2UHRlKVpY6oe++V8MtCl0Xgu7iNsflJlLAjzdTIDrm12GrOLMm?=
 =?us-ascii?Q?/HQevjnaAhHFxhE/9TqaInM8h2hgLtai5qqHqA7QlK9aSlz6NUQsbNvwswLJ?=
 =?us-ascii?Q?RzhIoIeVc9PS7PePEmlqeGBV1DU49lYKg2VayS443dtUqT+yE7DKxdQ1GRR7?=
 =?us-ascii?Q?yMDCkLsYdy4BtUDuomd+v5UUOo9txw6bij60puz50G+ED4W22yBdC1EqKR1R?=
 =?us-ascii?Q?/6zUAaw0uHn5FK8zJL26uXyp3agU5L775wrZp7WyDsUOffgEaYdfV9MxayOZ?=
 =?us-ascii?Q?zFUT5uOVNwmZeMAgocMDvNNZ2P08kNx2wXXdGITmIbQr8N4ZYradWf/871sY?=
 =?us-ascii?Q?EVfSl7rn4wR0CDifWLt4tGsUWtzzdMa4Kz/qb4wNwuLIoIpoYiMXnd49wu3M?=
 =?us-ascii?Q?6I+7z4X2Jd/jaYfjLYhaZof9csn7zISLZbNroNoJDF77qxo36IV+V7G2dOF3?=
 =?us-ascii?Q?YzfOJXPJ/C36rfW2C+e63E4nkfMimhiMKQhVsD5Sgd/+1UUV0uCOy5aF/I3P?=
 =?us-ascii?Q?uw03zoM3IIuGTtyzO6ZM8sDdzaSEhTPMUIHF0wHYIQxmcSRFv/+oECrPI5XP?=
 =?us-ascii?Q?D/SZURYQkp8cqZ8uZ5/CJqiJOq4kj25wKUWTfHlW48p+imdC0frIDJEdsgEM?=
 =?us-ascii?Q?x0FKKWQKmjbrdE3MWNtYCTZYCaQniMTOidHTWD2u/zTD0EMwojPsA4E8puWT?=
 =?us-ascii?Q?4qepfNfd8fRbP+31K8W0SLkfHPq7yZqEjONSHrlmsBrTgg3xfDIb2f/V6GLv?=
 =?us-ascii?Q?7K3H2nXmDe4XGKe0oYBJV/MQeaO7m+6r5/m43GOuaV90gKvMFig9aMZhUBzu?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1652925d-7cc4-4c04-662b-08da94bbb864
X-MS-Exchange-CrossTenant-AuthSource: ZRAP278MB0495.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 12:38:40.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYjjejOuj4vfiXiakWqUO8iDcQPkQc/b9ezXV0NJ8Das1xLEABGeGGwuWp3tEyh4a+N/YGeWQdGfR3LH5FYccyz6we699jmJGTB9hWHmR4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVAP278MB0953
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

On Mon, Sep 12, 2022 at 02:28:57PM +0200, Marc Kleine-Budde wrote:
> On 12.09.2022 09:01:41, Francesco Dolcini wrote:
> > Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
> > issues and we are at 6.0-rc5.
> > 
> > Francesco Dolcini (2):
> >   Revert "fec: Restart PPS after link state change"
> >   Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
> 
> Nitpick: I would revert "net: fec: Use a spinlock to guard
> `fep->ptp_clk_on`" first, as it's the newer patch.

Shame on me, I do 100% agree, I inverted the 2 patches last second.

Francesco

