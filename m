Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F59427F5A9
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732025AbgI3XGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:06:24 -0400
Received: from mail-am6eur05on2130.outbound.protection.outlook.com ([40.107.22.130]:8224
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730528AbgI3XGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 19:06:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJiMeClGkiVH4ibl/KAKve9g5KOZYH8Ug35YGj79vhjGIBqexns+bMT9x6+UTUZ49ihFqJuUEYxHBnTQA5ZUJXps8hKN45QDEPd0cetEpCTI3mTro/l4fcbEZMkZptTIjNSFQc2ETwXntgU9RijriO31QZXG7BbU8mPybcYTeVXhcCt3h6VPhr7UeRRny89+hO46AEkL0dZQupZyLWISJ9KLYmc4uPNaUcuvTz0sNYxi4Ol39yizoLLu+MHImiECYj3bx4pw1Jqwt7nafvxvzI0c6RKLM30IGVGolTS6w9eoRPkHUci59LTJXLFhSPPMOnec12ejpsCyxduO2Q85Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIdJqxLhKr/tt8MB5/L593xo3J4JFXoteB6dOpvjfiA=;
 b=azp0vPbCLhOjGsnqOxH16hxdVKPckv6Pxc3WBBzU0P2MDg6de/Wyf0Vd87e8gkeBu+S6N7Z4uaBB0xeV7qClYtg1/i8naunst62zACFSziGAFg1feHTwdrtRpstWDYo3Z8tEO0fBNYHMwnX1XOdlSqm1zP8BfTu1Sw8HK/P19KcxUBeqCCQnTIUkHwfO6+hgnDByv66wrAvD2+r+OYfAK0xBULHaPSnl2ZUwsc6qHx883qKUzkCYYX240A6QEhdJ5kBhmmw8Dpv7HGsc8sMsI6FnsTtvXs1X1kZlLpwifdFfDi9VW1FhF77uHOm2shClzeUY6Pa7uj+ZigVvBYtGIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIdJqxLhKr/tt8MB5/L593xo3J4JFXoteB6dOpvjfiA=;
 b=hVBd9uc+gRahf5FxTr7WQ1MqJPSuN1C9lKMcG0QK4O06acA7cuU+r0ltoZ9tp+8Yy+/8sH1y+NkoOvlYzGhPLb00d4UMbu33GkMPHt14gol8FgyWCFIsnOuVijia2BUJXfLzIgZVkWA5GtxJRPMaIPF0AdqGycMkkvGOv0eYYdg=
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0460.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:58::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.28; Wed, 30 Sep 2020 23:06:09 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 23:06:08 +0000
Date:   Thu, 1 Oct 2020 02:06:05 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20200930230605.GB13107@plvision.eu>
References: <20200929130446.0c2630d2@canb.auug.org.au>
 <20201001080916.1f006d72@canb.auug.org.au>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001080916.1f006d72@canb.auug.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM7PR03CA0002.eurprd03.prod.outlook.com
 (2603:10a6:20b:130::12) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM7PR03CA0002.eurprd03.prod.outlook.com (2603:10a6:20b:130::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Wed, 30 Sep 2020 23:06:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 178b945a-15cc-4815-f1a4-08d865956a97
X-MS-TrafficTypeDiagnostic: HE1P190MB0460:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB046093BCBD937534F863761095330@HE1P190MB0460.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55YbfEwL0gGrwRfhuzcApXXh4ycu/0KQot90muj4S8WaczVd4O7VJASqriJRBf5iwcZbqY7gHr1aAylqiiYqpxSlTYUFA7gKAFk+ATXosQGhnVIZHPtyfPiYw56r/XaryAG3v6BITp/KPVUv4w4bfnWFGR/iTA1qSpPHV8olgu4JTDgcOBcoXWnTjrWRM2QhKTK3T94N92neG7PF/6n47i4DuuUVFmVZDe4hF9i41KRlSxucM+nRC+RuEA8r51GvlRr8wvMO0FYeK9E6HSX9Uupu02pOoCv5AVg+G8h274SzGYjx8y5+MiAw6b6wriRXc/CgCw4S15VCtXiFEYznOkCmtgFmSBoKtls54RSQfFlKBvp5VPMnxkd/lEcJuqI+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39830400003)(136003)(366004)(55016002)(478600001)(16526019)(36756003)(86362001)(33656002)(4744005)(186003)(956004)(2616005)(8936002)(2906002)(66946007)(4326008)(8886007)(8676002)(1076003)(66556008)(54906003)(7696005)(52116002)(44832011)(6916009)(66476007)(26005)(83380400001)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sNdOQI9cGlJQv0mX+CgMHIrXN3E3jNR3BeHdgevQ8XfiAapnxrhbh+jq1LXj103BgzGbZY+MPSh0qR6anfs5twT+Dxxhuic97VoBGa3r+s+RFm+w3QWBad57QlJIgSKcFTBc5eIvuRutk1CD7LJP+bvr7E/rVq26QI+igchcyfu6H5W6Nz2gtx7kOyJEyBG6EindQT2d68rxjZBA+EcOph75STR1C9sMvw+586YCSjdkT4WlzG4t1hXnOArRsKLq6lDo0Wj/9eFdujeR1PoXZMqlwuuuthTzJPW4juFcvUxhrZO7KRLZCLtaqyO34MdXkDsRacSaj0Le0+ZHniNG1qgcr3NkhdFHsIX89hfDOUMsV/V3ttDLTfo4iW4/VvW7HVfgJg3iGg6L4zoIRiVbcZrOQwaoOJjmGO1psECwETedbraOWi4itle2JL+jllWKSsPzl4B1sEXsU7w17OAN1fSMV2TshP9KDiLaNjJIPE5FRczrh8TWtS8IMtujv7+gS4H2YG3QEImjd3FRXm/lQbCboaEzCfT2AN3kdYqKK+Q5WCFG7ZwJVbH7FhNCZpd59yrH0R+I7IgTcW1pQ7i/xoUr+KhaU1dHHSSBDLB21AXOzadQiAUh72qu0azcq0d3cACSqNqfP8N/rxYMcLbi9A==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 178b945a-15cc-4815-f1a4-08d865956a97
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 23:06:08.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQXN6wr2BMB1Z/1EieYlPN+XmfsaZGyvecKxKJ3VYiu0UfCjORU3t2fxUun3IxW/2UosdkDoL/QUZs+9LxUnSPKak1aslMf43Bcc6bNQAVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0460
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, Oct 01, 2020 at 08:09:16AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
[CUT]
> 
> I am still getting this build failure ...
> 
> -- 

I just 've checked linux-next/master and it builds fine at least with my custom
config, do/how I need to handle this case ?

I see the changes you applied already in linux-next/master.

> Cheers,
> Stephen Rothwell


