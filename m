Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5732E1C6C59
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgEFJBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:01:13 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:11519
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728940AbgEFJBL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 05:01:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSiWAFu63JUf5APVE9N4ToxfAWxYQhbsF3j7l5quhrI4U0fEMSJuAEpy3Zf1dJyob6ouSd0yjviIANMN7cRFzGTpk7UvwA2QYY3hjzO51JAPJhLwQUyOP+2USBijWviWNnp3L5bBiRYecI1Fre0ptzhFq1yEPc95M8QjOXG/egww/zKnqRrkZZ0WrM0AsxdBg2L0ee1s3idHArqAv6K1mPk+VNW4h3APkcdn0QWjKPasLc4ul1GUBbdLFUd8qYARk0TFS0Mt7Z/q39MxCjRVj/IY25of5MF08Q3kAoLlP4y8BOBtKsMFmhwciIJw1vv/JYIevKo7anuUQB1Zsj6ZbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TmngGAtUUC5JVgLmg6ST+bC8VQlUKVvOgwc8NPyGcY=;
 b=aUesOxzRSl6yBWc/eef5YxrjSAZowgZUgAuGh6LspbQcV4AoGJ2mbh4Ody64gqHCetV84Y90oqSfLZjqJIdIAx3I2MS3m8xIF76BHYLzZ6aFJ5R50gnyKWOz+Eq7Ju34ZnO1uG8bxqSWTDYQ9P4zPMoH2IHvQ90l5+6eiOJov7RzWxZDRFydFCE0WMcs3PgJpqT/mKKQWJyioXGlAT+J07nEC4KfBkaJQUwhuDInmSwIBnfxKuHNjJj/bi7aSmYvhyEHEOr6JAbhSb61Qu1JkwN9cDuzWysADUuRaUeWa8bZriDg/lYbl18u2eu2CjjgQzWgcWpBuWuKsuhkrGf8Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TmngGAtUUC5JVgLmg6ST+bC8VQlUKVvOgwc8NPyGcY=;
 b=k10N+HfHVD8GCHQ+EBqdpcuKR0tSB/XKYq19UKfRFxW+rIaAcpLjpixMRWMrspaZQ5WL51maL3noxpaR1i0GgYyK3rvxZ1wjkxC3Z0m2AWMvOHQ6Ndd7UDWAp1La6Sm5hx3LevEcCLXgcyFeqE4qkq8dhQ5QoskwjFtWomuqPmE=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6464.eurprd04.prod.outlook.com (2603:10a6:803:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 6 May
 2020 09:01:04 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 09:01:04 +0000
From:   Po Liu <Po.Liu@nxp.com>
To:     dsahern@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     vinicius.gomes@intel.com, stephen@networkplumber.org,
        davem@davemloft.net, vlad@buslov.dev, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, Po Liu <Po.Liu@nxp.com>
Subject: [v4,iproute2-next 2/2] iproute2-next: add gate action man page
Date:   Wed,  6 May 2020 16:40:20 +0800
Message-Id: <20200506084020.18106-2-Po.Liu@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506084020.18106-1-Po.Liu@nxp.com>
References: <20200503063251.10915-2-Po.Liu@nxp.com>
 <20200506084020.18106-1-Po.Liu@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0401CA0010.apcprd04.prod.outlook.com
 (2603:1096:3:1::20) To VE1PR04MB6496.eurprd04.prod.outlook.com
 (2603:10a6:803:11c::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.73) by SG2PR0401CA0010.apcprd04.prod.outlook.com (2603:1096:3:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Wed, 6 May 2020 09:01:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4866305-a06b-4f66-90e4-08d7f19c0171
X-MS-TrafficTypeDiagnostic: VE1PR04MB6464:|VE1PR04MB6464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6464513BFF05733BF7E39FB392A40@VE1PR04MB6464.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iP9kxEX/WKuITZWp/n+VcTkpQHoIfWpWTuULHBkbmMDhs10NNu/7IMqDjbW7xgZvCxvQQzGDQknWtLhnrl4N1Gf9eJoMIryGdKaAmSwAL7BqkixlaWoZu/xOY3EdNir0ZNyGThTwcdekmWhDEjEBhiDtzIsvx+Lhaus59Y7m3GFtxPKfo/vNSDNWFSiC/icfkvKU+k1IHsbgTNmeQ6QDehgxgDT/pJCcBjkA+0/lN5oU6NmYPIEeDDiJc74ZynHvRt60MV40bBLdcmfUKNSQbtbP4U5kqqLw3u5u7KHpLeeAyrxinheTnWikP31TLeJoeZZts5qvWFWA2xw3Xb+EjFkU5kMfcIBfIq0Umhcd9vM5aUESNXwL8zJu4/2210t5mGqIDWTwXPsMnyLVciJorXrA9v8c023vQ5K13CODq3ERdZAkQEp6ysd2RYHdqrdlmqIrp6bFrdRdDhjURBhFynkNanejKCWqieq0a2yPAZJaIt3+fWlYn0ub19HqfX05cuGGn0/Pa/wqN4E9ZvzaQRQ6Ti2D3NslKixFpUProRWQ0lcA2mVi6gLwO1J3Fw3C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(33430700001)(66556008)(66476007)(69590400007)(6506007)(26005)(16526019)(186003)(66946007)(6486002)(4326008)(6512007)(86362001)(52116002)(5660300002)(316002)(33440700001)(8676002)(2906002)(6666004)(1076003)(8936002)(36756003)(2616005)(956004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FLev8LlDGkTAYhKj6+rnDay32OHW2TQFG+DpHH/n7G8kZ/yS2ihzkqOCFrJM4xTKWaqLsVdvh0wK7Bd6lOX2wMgXCuJy5vR0wneQQjzAlmgtAAehPloZ8moZqHWQ89+LeEG10iHji2FY3ofIKUZXmxBD4Sa2moEiHhUeQcyDJnYB4QOJNyB95MZHnIWqdL3t7eKIz2r1rbSzhPxDKN8uXZyN/j5s5Pdi6CStxSaR6ZXxk9KuZvlL6mn/x0XafQQ5Hke4qphORryQGQd8OxFsoI8D3UJPTQnKnFNv+6Nfhxrr/bVqmJeAapsmbiPwNVM4AK4Bjt3retpUAlISnokp9eCKHu7X8zlM5+Sic92B76xy2szACCki9zfAa4n8eR32Ncyv7Gdb4vw/QCgvXnAMklrl3t1LLFpzxIXCuFGf8ttG6xw6TvBClahx351VyVIR9Gq0nzJj0UVYwB/RZaneqjWpKRn3MJxlNPDRw082WFI9TRRkipJEXZiYPB/0R/YQolRJAZ8TCCE/cod4bSb094+1OMrkKVzrj8VoCwIFTraYAZmYbIgZx96LyBkQhPVGUbRCSseXZyBxYxSvPJ9RG30D0USCa3fXUbztPD7C16RaGlxo+qDQ5dMiXMXYmN+hIbq5gvl/cCxqiO8DtppEJnQ8QyDnW4icN/c8H2/Dz+s/QucKwNG9cLN6e8m3ozzjMNZN0PyT034+/XRWYeVlrXNxHwMqfIencezqfgRRx4B/EmUYzbC5I1qO6axL4GfEt+KNrAVIgNEHlZWQV8ma3lS2z+R1kPF3qJFDgFI3+PE=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4866305-a06b-4f66-90e4-08d7f19c0171
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 09:01:04.0684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dK/4anAfeSJgKDiCXD623WumGoTrDjtOtQlC6+hIaw/M/OrQmHmLSc+UU2RobUR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to add the man page for the tc gate action.

Signed-off-by: Po Liu <Po.Liu@nxp.com>
---
 man/man8/tc-gate.8 | 123 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 man/man8/tc-gate.8

diff --git a/man/man8/tc-gate.8 b/man/man8/tc-gate.8
new file mode 100644
index 00000000..0f48d7f3
--- /dev/null
+++ b/man/man8/tc-gate.8
@@ -0,0 +1,123 @@
+.TH GATE 8 "12 Mar 2020" "iproute2" "Linux"
+.SH NAME
+gate \- Stream Gate Action
+.SH SYNOPSIS
+.B tc " ... " action gate
+.ti +8
+.B [ base-time
+BASETIME ]
+.B [ clockid
+CLOCKID ]
+.ti +8
+.B sched-entry
+<gate state> <interval 1> [ <internal priority> <max octets> ]
+.ti +8
+.B sched-entry
+<gate state> <interval 2> [ <internal priority> <max octets> ]
+.ti +8
+.B sched-entry
+<gate state> <interval 3> [ <internal priority> <max octets> ]
+.ti +8
+.B ......
+.ti +8
+.B sched-entry
+<gate state> <interval N> [ <internal priority> <max octets> ]
+
+.SH DESCRIPTION
+GATE action allows specified ingress frames can be passed at
+specific time slot, or be dropped at specific time slot. Tc filter
+filters the ingress frames, then tc gate action would specify which time
+slot and how many bytes these frames can be passed to device and
+which time slot frames would be dropped.
+Gate action also assign a base-time to tell when the entry list start.
+Then gate action would start to repeat the gate entry list cyclically
+at the start base-time.
+For the software simulation, gate action requires the user assign reference
+time clock type.
+
+.SH PARAMETERS
+
+.TP
+base-time
+.br
+Specifies the instant in nanoseconds, defining the time when the schedule
+starts. If 'base-time' is a time in the past, the schedule will start at
+
+base-time + (N * cycle-time)
+
+where N is the smallest integer so the resulting time is greater than
+"now", and "cycle-time" is the sum of all the intervals of the entries
+in the schedule. Without base-time specified, will default to be 0.
+
+.TP
+clockid
+.br
+Specifies the clock to be used by qdisc's internal timer for measuring
+time and scheduling events. Not valid if gate action is used for offloading
+filter.
+For example, tc filter command with
+.B skip_sw
+parameter.
+
+.TP
+sched-entry
+.br
+There may multiple
+.B sched-entry
+parameters in a single schedule. Each one has the format:
+
+sched-entry <gate state> <interval> [ <internal priority> <max octets> ]
+
+.br
+<gate state> means gate states. 'open' keep gate open, 'close' keep gate close.
+.br
+<interval> means how much nano seconds for this time slot.
+.br
+<internal priority> means internal priority value. Present of the
+internal receiving queue for this stream. "-1" means wildcard.
+<internal priority> and <max octets> can be omit default to be "-1" which both
+ value to be "-1" for this <sched-entry>.
+.br
+<max octets> means how many octets size for this time slot. Dropped
+if overlimited. "-1" means wildcard. <max octets> can be omit default to be
+"-1" which value to be "-1" for this <sched-entry>.
+.br
+Note that <internal priority> and <max octets> are nothing meaning for gate state
+is "close" in a "sched-entry". All frames are dropped when "sched-entry" with
+"close" state.
+
+.SH EXAMPLES
+
+The following example shows tc filter frames source ip match to the
+192.168.0.20 will keep the gate open for 200ms and limit the traffic to 8MB
+in this sched-entry. Then keep the traffic gate to be close for 100ms.
+Frames arrived at gate close state would be dropped. Then the cycle would
+run the gate entries periodically. The schedule will start at instant 200.0s
+using the reference CLOCK_TAI. The schedule is composed of two entries
+each of 300ms duration.
+
+.EX
+# tc qdisc add dev eth0 ingress
+# tc filter add dev eth0 parent ffff: protocol ip \\
+           flower skip_hw src_ip 192.168.0.20 \\
+           action gate index 2 clockid CLOCK_TAI \\
+           base-time 200000000000 \\
+           sched-entry open 200000000 -1 8000000 \\
+           sched-entry close 100000000
+
+.EE
+
+Following commands is an example to filter a stream source mac match to the
+10:00:80:00:00:00 icmp frames will be dropped at any time with cycle 200ms.
+With a default basetime 0 and clockid is CLOCK_TAI as default.
+
+.EX
+# tc qdisc add dev eth0 ingress
+# tc filter add dev eth0 parent ffff:  protocol ip \\
+	flower ip_proto icmp dst_mac 10:00:80:00:00:00 \\
+	action gate index 12 sched-entry close 200000000
+
+.EE
+
+.SH AUTHORS
+Po Liu <Po.Liu@nxp.com>
-- 
2.17.1

