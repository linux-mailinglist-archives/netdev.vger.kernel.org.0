Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 425B21B703
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 15:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbfEMN2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 09:28:16 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57124 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728409AbfEMN2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 09:28:15 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 5E703B40059;
        Mon, 13 May 2019 13:28:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 13 May
 2019 06:28:11 -0700
Subject: Re: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
To:     Jianbo Liu <jianbol@mellanox.com>
CC:     netdev <netdev@vger.kernel.org>
References: <alpine.LFD.2.21.1905031607170.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190513125400.GB22355@mellanox.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <62a0f0f9-d576-baa6-f34d-f4875214ea7d@solarflare.com>
Date:   Mon, 13 May 2019 14:28:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513125400.GB22355@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24610.005
X-TM-AS-Result: No-6.325500-4.000000-10
X-TMASE-MatchedRID: wQVy7q402w1HxgMCfGKcWCa1MaKuob8Pt3aeg7g/usAM74Nf6tTB9hlN
        xiPQSlnnHs1w8gZBk/kZvCnM8BxzwDjyiNW7C0f6ylAqNTt8FdUS12tj9Zvd80uCjz4ggdtwoxt
        DFHee6qN2CkWqYrUAT1+24nCsUSFNExAtD/T72EbdB/CxWTRRu92KvEVWmYr1SeCj8LzdNRnLde
        sghCbMFcrJ8kuk54fO8dmNpBv+weaSSLQDr/4luQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.325500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24610.005
X-MDID: 1557754095-n5tlPjXGQHz6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2019 13:54, Jianbo Liu wrote:
> Could you please push to 5.1 and 5.0-stable? The original patch brought a bug
> in mlx5_core driver. Need your patch to fix.
>
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1615,7 +1615,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
>         if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CVLAN)) {
>                 struct flow_match_vlan match;
>
> -               flow_rule_match_vlan(rule, &match);
> +               flow_rule_match_cvlan(rule, &match);
>                 if (match.mask->vlan_id ||
>                     match.mask->vlan_priority ||
>                     match.mask->vlan_tpid) {
>
> Thanks!
My patch will be more easily accepted with a user in-tree, so could
 you give this fix a commit message and SOB?  Then I'll roll it into
 my next posting of this series, thanks!

-Ed
