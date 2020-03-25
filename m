Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4103119257F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgCYK0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:26:44 -0400
Received: from mail-eopbgr20119.outbound.protection.outlook.com ([40.107.2.119]:41385
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726073AbgCYK0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 06:26:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXAZ7+F5Xi7ls+iMyjnZTmfGyiCDKihoIL66P5cWzFmIC0RxE2JEZF78nIq0TsFxUCaljGOENi9pinCwWXUaGGg31kBWIeZrj9gDweFtM3LFwb43udsnhWnh7PaLJtoUt/MyeZAeChLVue67XaYHi3KqvVdvk0MKp/l4iF+e35gs1SsPZIkVQ4tuMtVyyaCbsGs95aQ0ouK/CkXzkQJVavNR2rC2AoST+fc9XUN0DEJaZEiTzaBOqZbrbrZzmEagE/zqSgXmZfAYTYqtE/H4EsNh+x6c84pQM55hkIuZeL2wl/Ac1cn8oIM5rP60C0lM1PmkzbHADQgwo2tMBkFIWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9OFaaq0YZ8R4tYew57j491K0ovaXhMckrGYNHO/WsE=;
 b=GRiitVeiUoAHoa8er49m9H5FV3iu4nrrbcjGtj0ZQGLuBB+XdHtS2kP/9c2SzzhiuKHCg3EyCPRvaD/AuflUyvlhaLfZ+Z6H9IsCJVAN4jPG8oPTUL1nteImGoPWI7XEKj1Imrz8Rcdkn1BSRtiSSqsH/VqIGg8lcHkSC+qAMff9ugGO9b+fWl8Evns5PIpRC/qEdDygehPpN6zWw54jIhHeBBIfk8D6An5RUFKH6+wPv5r48nWoM2tBa0vo11Xu77YaMiZRvq6bXm9W+nEtGRG1Iaqfvjjtf7Lm3y4p7bnLnVYdDIW753qm8n4fvMcMG/991+1mSjoiwk/G3exyaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J9OFaaq0YZ8R4tYew57j491K0ovaXhMckrGYNHO/WsE=;
 b=x+GeK1q2Qon9ULWddf6qFmGo0Ug/CTBO7cXdWlj3QIsSXMgO15yjxR2c7Cjj9SUsjjojIxfvWx1+1kMqdxnBQ2+VZM9iAkKACq3WUGArFkGTZPn0Z1PI6CRmDn2Fv58wXg1VmUuoghgUghAqLtymIwHFDJ0lQbnfTLMPCEniyks=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
Received: from AM5P190MB0388.EURP190.PROD.OUTLOOK.COM (10.161.62.14) by
 AM5P190MB0434.EURP190.PROD.OUTLOOK.COM (10.161.92.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Wed, 25 Mar 2020 10:26:40 +0000
Received: from AM5P190MB0388.EURP190.PROD.OUTLOOK.COM
 ([fe80::a847:84e7:1e6a:e543]) by AM5P190MB0388.EURP190.PROD.OUTLOOK.COM
 ([fe80::a847:84e7:1e6a:e543%3]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 10:26:40 +0000
Date:   Wed, 25 Mar 2020 12:26:33 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] selftests/net/forwarding: define libs as
 TEST_PROGS_EXTENDED
Message-ID: <20200325102633.GA6391@plvision.eu>
References: <20200325084101.9156-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325084101.9156-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BEXP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::18)
 To AM5P190MB0388.EURP190.PROD.OUTLOOK.COM (2603:10a6:206:17::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by BEXP281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.18 via Frontend Transport; Wed, 25 Mar 2020 10:26:39 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4037802f-0b2d-4fb1-3721-08d7d0a70128
X-MS-TrafficTypeDiagnostic: AM5P190MB0434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM5P190MB04346995750683529DD0F8D495CE0@AM5P190MB0434.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39830400003)(366004)(376002)(346002)(66556008)(16526019)(1076003)(8886007)(36756003)(2616005)(26005)(316002)(186003)(6666004)(66574012)(956004)(33656002)(54906003)(66946007)(66476007)(8676002)(81166006)(81156014)(2906002)(4326008)(44832011)(55016002)(5660300002)(52116002)(7696005)(86362001)(508600001)(8936002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:AM5P190MB0434;H:AM5P190MB0388.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDomzYWjAGrFyOPPNC1Xp+wL+/rBpQaCXvcGBLxzJ++73t2BYLNFXWkTqKVA+t8WZIwdq9NxXI+k0irO+TjQI3uEtuuHcSZCEZB6Sv/PNZoIOdegn0nQ/nZn14DhEDwfsVSK+wtwfgTh15QeLYID9a8p7uBaz6IEpE37oLde0Jl3BR5Br6INXvi4gmOVck4kxsEz0L0+5D0lefO7L7UkjYHiCHGLlWgcNffvNvquHNDoDc5HcJS3tK3TVTacY3iX03rgRoXdZQtejYo66D1V5nGiIWApZWEXc3cx9SaZVCK441lQ4kCr4gaNeDORSG8t5mBUMrdiof8HLDe9ZWChS+fPTUDmbwATZIINfOP+Q5CA9UGerPPaZ1u8bcHgSnLba1n/ZvGxqZW7hu6XOgyW77ej3o5lnvD1h5xI4HPNetDVRh+dHWjrrF8kbUPzL8/Q
X-MS-Exchange-AntiSpam-MessageData: Sp1taziWLu+acKswYC1owv1J+m5xZkAP05Gr3ZUb/p2WXJPKUj//O9Ffn52jspn0DnDr0IdPQodtSRGVVXs/1KWUyV8LYOiuw1Yh+4f1ftYHkgA4eNdcSPoscVjgaiWLUZkGB1ASPi+oW8BHWfr9uQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4037802f-0b2d-4fb1-3721-08d7d0a70128
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 10:26:40.0539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lV7iIQF5Ai1/jahT0tOWi6KBRn2zdCkj+EfGEc/DkqfrcqvmRGEXi63lbKEJSsES1UsofnYM4nkvJKFYmdJ1xbXaoWwzYfvDPwdRUSUUNGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5P190MB0434
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin Liu,

On Wed, Mar 25, 2020 at 04:41:01PM +0800, Hangbin Liu wrote:
> The lib files should not be defined as TEST_PROGS, or we will run them
> in run_kselftest.sh.
> 
> Also remove ethtool_lib.sh exec permission.
> 
> Fixes: 81573b18f26d ("selftests/net/forwarding: add Makefile to install tests")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Thanks for fixing it, sorry for my mistake. Actually forwarding tests
requires interfaces list as runtime parameter or if it is defined in 
forwarding.config file, so may be they should not run by run_kselftest
at all and only added via TEST_PROGS_EXTENDED ?

> ---
>  .../testing/selftests/net/forwarding/Makefile | 31 ++++++++++---------
>  .../selftests/net/forwarding/ethtool_lib.sh   |  0
>  2 files changed, 16 insertions(+), 15 deletions(-)
>  mode change 100755 => 100644 tools/testing/selftests/net/forwarding/ethtool_lib.sh
> 
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
> index 44616103508b..250fbb2d1625 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -5,11 +5,7 @@ TEST_PROGS = bridge_igmp.sh \
>  	bridge_sticky_fdb.sh \
>  	bridge_vlan_aware.sh \
>  	bridge_vlan_unaware.sh \
> -	devlink_lib.sh \
> -	ethtool_lib.sh \
>  	ethtool.sh \
> -	fib_offload_lib.sh \
> -	forwarding.config.sample \
>  	gre_inner_v4_multipath.sh \
>  	gre_inner_v6_multipath.sh \
>  	gre_multipath.sh \
> @@ -21,8 +17,6 @@ TEST_PROGS = bridge_igmp.sh \
>  	ipip_hier_gre_key.sh \
>  	ipip_hier_gre_keys.sh \
>  	ipip_hier_gre.sh \
> -	ipip_lib.sh \
> -	lib.sh \
>  	loopback.sh \
>  	mirror_gre_bound.sh \
>  	mirror_gre_bridge_1d.sh \
> @@ -32,15 +26,11 @@ TEST_PROGS = bridge_igmp.sh \
>  	mirror_gre_changes.sh \
>  	mirror_gre_flower.sh \
>  	mirror_gre_lag_lacp.sh \
> -	mirror_gre_lib.sh \
>  	mirror_gre_neigh.sh \
>  	mirror_gre_nh.sh \
>  	mirror_gre.sh \
> -	mirror_gre_topo_lib.sh \
>  	mirror_gre_vlan_bridge_1q.sh \
>  	mirror_gre_vlan.sh \
> -	mirror_lib.sh \
> -	mirror_topo_lib.sh \
>  	mirror_vlan.sh \
>  	router_bridge.sh \
>  	router_bridge_vlan.sh \
> @@ -50,17 +40,12 @@ TEST_PROGS = bridge_igmp.sh \
>  	router_multipath.sh \
>  	router.sh \
>  	router_vid_1.sh \
> -	sch_ets_core.sh \
>  	sch_ets.sh \
> -	sch_ets_tests.sh \
> -	sch_tbf_core.sh \
> -	sch_tbf_etsprio.sh \
>  	sch_tbf_ets.sh \
>  	sch_tbf_prio.sh \
>  	sch_tbf_root.sh \
>  	tc_actions.sh \
>  	tc_chains.sh \
> -	tc_common.sh \
>  	tc_flower_router.sh \
>  	tc_flower.sh \
>  	tc_shblocks.sh \
> @@ -72,4 +57,20 @@ TEST_PROGS = bridge_igmp.sh \
>  	vxlan_bridge_1q.sh \
>  	vxlan_symmetric.sh
>  
> +TEST_PROGS_EXTENDED := devlink_lib.sh \
> +	ethtool_lib.sh \
> +	fib_offload_lib.sh \
> +	forwarding.config.sample \
> +	ipip_lib.sh \
> +	lib.sh \
> +	mirror_gre_lib.sh \
> +	mirror_gre_topo_lib.sh \
> +	mirror_lib.sh \
> +	mirror_topo_lib.sh \
> +	sch_ets_core.sh \
> +	sch_ets_tests.sh \
> +	sch_tbf_core.sh \
> +	sch_tbf_etsprio.sh \
> +	tc_common.sh
> +
>  include ../../lib.mk
> diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
> old mode 100755
> new mode 100644
> -- 
> 2.19.2
> 
