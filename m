Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C195633F759
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbhCQRpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:31 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:58097
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232483AbhCQRpP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hd997BUrElwW2CreKuaYzYPrZ19fmR2J474XYWxlFeZDSqaDl49wBbaaxNCKcb5guhdu85G4PmJVhYP/O3sc8YKQNMDGNzzWoYMlrL5Iuhbkpi4XUbStd3y5K6Vav/DBag2SQLuoXo76KzhFHt0gPwUBsrZXWyRq/J0sm65Oz+pa6o4EklORQPMz6QYW5FhzKCZnuvVLAv+sWZaj7T5IiP3+F1R2cBmRKCtX5bojMK9JhgsKswrMwIWmDXqpjLg5dF891+zjXOr2O5AhP30M7E65NURuFGby8n40V8Bbg1ZeOrNtzjKruU0JISc985ckLvHEOjYXezhRf32kHb4yzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GgcDkJ3KXA+pTMpcEUf40v7I/gQHitYZMwDKqA5hao=;
 b=MkPMtR5InClHZ7n/FG46jNJwNX7zw6/8XJJxNTHXpYc8EXevanHD0nTy4ptm7QvWUaTLfnlTdf54YA3ktUSNgfUh/oa0LkB15MPmMJIHeRde+Q2pgQYTNYpQd1B9jXSLBLLWsN88kftBz3XtOH667h3I6sZwxxX6Wj12YGNRHQ3AvwY4SSaecN9l9pvXON7b2VHjgEDiRV7v+l67+yjGTddYwV6JRzge07Ul8ECRWEhXhcpwJF8uM1/b4tx7TukgPLLZYN6sceEVlAavGRaIl3RNxbYlkLk95b+CeZsYknJsDnChNB9VFZsb2igSr3VtL+yV87Z/axc5HBgwU1J1aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3GgcDkJ3KXA+pTMpcEUf40v7I/gQHitYZMwDKqA5hao=;
 b=dTka7u9k1dHAcoXkpJHtqYJSHzDg+Z6E3bFHU4wc5iOglXsmP7TJsZU9tDbRsGbPSCCUcxm+ZMjVFIY6YyS1XtzW8LhKE2eXJcWw2F7AKHUCha+lKWGCHOr1U67OvG0Leh6sYBgndoDCJTvdvULjhgPcbocVoBPwMXfqPLa/Drw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/5] Documentation: networking: switchdev: add missing "and" word
Date:   Wed, 17 Mar 2021 19:44:55 +0200
Message-Id: <20210317174458.2349642-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e18a86e-c862-4e6a-ed59-08d8e96c6b14
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7119754281D0B5B9396049A8E06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Kgw2VsRSnec+xad/KKu5+17VBuRZ46g2gBLCUJaP6PdGtduA4bfZI7x5tTKe7w6Cz2ETQn/XA4Hl5b0+UA+//VIfCHPl5LeeR7wUy1CioFtkcJWthL59rlf3GrVeu4g+Y1Cy0hzbdHUvSvfUlUaeGuYhfyQFNjL11xsSlCqaRfDRArzoyWxUhYg6bssi80+055ZumQzvgBWw7jN2h8XdGu07fziBHQGNJeZS3F191sgwXaUx1sUAU2ijEV7Ta717zmy6RYy1gKqNZbnha/n0WKBc1xzHE8+ijEEQhdNLBycok9MVJ+I4DgcQY04N5+Tx6miBOfm0z+GFBHOW7uVv3Q5Dj/D+6NtR+ZuZRPNMMTRryG0nFDnOEfAvl870u9gNCRPhC/+U7CP9wAz9qCPiS02HVNzA6Gzb41rAbn0vEWY0WwhzpPhtr0AVyMBqj/XSFfaq6U83/5iLjzA4EWVBGHab4DKdE9bftsbVsY15IxsLgsFxqiw61D6b2w0ES6f5M4oiW0JKS0zyIG5BusPQjjy3FaaLQfGroCw5liWA9ldWEeYYcfye6TGgdB81KUTHlpS9w5zdTtJF3rzu3vfe71ujE+PBJwzfyxQ0F2zuuITgfS8RgwcgUMBzyzm/Sgk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(8676002)(7416002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PoCTxDlKgRnvLKCZ14D2UAEVoFShA3/ZnWlvuZF2+442L7WwsgJh8h1WUGml?=
 =?us-ascii?Q?huA4K7dfAvb+JYzlCZg9H7cw8UcEtfawg/U/AMgtWQytk1a2+cFs4LgefQvF?=
 =?us-ascii?Q?DHulazMixf9w6jc9qxAJr8GX2N6xLIs41RbpP+Wvf9jVGbcbYWVWUvu88H0n?=
 =?us-ascii?Q?4Zz+IUhbj67R1OFHJPRIW8m1c/4XSIhnWj4Re+Y3C78AmXTTHvuJJhHJLn+L?=
 =?us-ascii?Q?TELfYt2oYOCk/wgiDULOO0v/2kfB+mkjjntxFA8VfJlwmPLiN/4xl9cOT5pU?=
 =?us-ascii?Q?tajF8PWevpKzaDcz0CZTHCp+3SEpLPpKCmXKdE2T8i7hQk2FS9cXEbZnn7U6?=
 =?us-ascii?Q?tNRzvBD9RB/EnGLEE60zmCziwkYVvaxbj6DBnGn0Yl2ZGwVDb3RXwFlOxEMK?=
 =?us-ascii?Q?pCQ4AaZx37BLWoOY8aUNmT8TscN5EuxowIIjUlGa0wYXw9rvm4cILjXneDGg?=
 =?us-ascii?Q?VRZXWNItCFXnG9sI6n7anwiUrZUaszt1wEhpxQUGHOFfy3728A6OReEHwsQy?=
 =?us-ascii?Q?PC6MPllF5L23Q8vXaSIAknfuu2GGEXYcisjgZgLyy5yCYWLw1BmEbVAqU3YN?=
 =?us-ascii?Q?lc5VdMU4WxCZUSDZr1/pjt2zxyx9m3WYiU/KBykhO7d0t7j4eARPCHxnMDbl?=
 =?us-ascii?Q?NhxsqaIn8Hkl1KY/BHfJq2wQKCJUD4z0X/wfTE42X2IPk81riGRYgQ3tiZy/?=
 =?us-ascii?Q?CciqxmvBkj4J2t9Tz4OKUKmQ7zntEWcwG5kJ3Ao7uEJFN/Xa77vOAtpcZcRG?=
 =?us-ascii?Q?WUK18MyQaiZ9dIYIAg/zq27Nff+VShmDt7T/qPKjM3wtjj2QV8OL+Bt54I7G?=
 =?us-ascii?Q?oZ+1BKwoAQZyQSIpShZqrzaTLHS8wv+pSHQPiYZ9gT9sqOFyqCrxEqV0xm9k?=
 =?us-ascii?Q?hW25syvdUnqyF+7D9YrtRMk8tWhUbej72Oa1sQGHh6RWXF4OghTL/CworGUW?=
 =?us-ascii?Q?0ssBLUeBOe5tpCZ9LzQi74xmHxP1Ck9rsmP1C0RiaE6LkkXgR0bK5pdWfYua?=
 =?us-ascii?Q?oVpLilRO4XfDM5bWehzJ8Hhsc85ebzMBYHY3MANHQgnN0V56YHnKHG3NnCZG?=
 =?us-ascii?Q?zax5ReHYmgXACP4CTTQBGL540hAHF8MeI4o5IyH2S60oqhN6hq+0PxvmlpQL?=
 =?us-ascii?Q?+k+qnnsVV+9c+cEdcUHa0Jb1mPqqI7GLAGeGhyLTrfB7tb7nmB1NWFmkSOtp?=
 =?us-ascii?Q?GwwFUVjgmkkxi9FVvWmQ6tRhvtlmAMBUh/Ec02hqa4vDydK4THrcFP2dZ60s?=
 =?us-ascii?Q?g63pXe/SIZX9R0Vj7QbRPqi1A+iRL2pQ/uELG1p3oYB+2TORShbJLC0RY1dL?=
 =?us-ascii?Q?+EXUTPBoMGSmwSOA9o3iIWPW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e18a86e-c862-4e6a-ed59-08d8e96c6b14
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:13.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dI5YQzHlHHkB83WLCGmLPgumxAu4ANH4+uSEEGKPvhclyhEBCK7DdeRVX55VYUN/d9DNVo+h0GKCht6GM7Q1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though this is clear from the context, it is nice to actually be
grammatically correct.

Fixes: 0f22ad45f47c ("Documentation: networking: switchdev: clarify device driver behavior")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/switchdev.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/switchdev.rst b/Documentation/networking/switchdev.rst
index aa78102c9fab..f1f4e6a85a29 100644
--- a/Documentation/networking/switchdev.rst
+++ b/Documentation/networking/switchdev.rst
@@ -523,7 +523,7 @@ as untagged packets, since the bridge device does not allow the manipulation of
 VID 0 in its database.
 
 When the bridge has VLAN filtering enabled and a PVID is not configured on the
-ingress port, untagged 802.1p tagged packets must be dropped. When the bridge
+ingress port, untagged and 802.1p tagged packets must be dropped. When the bridge
 has VLAN filtering enabled and a PVID exists on the ingress port, untagged and
 priority-tagged packets must be accepted and forwarded according to the
 bridge's port membership of the PVID VLAN. When the bridge has VLAN filtering
-- 
2.25.1

