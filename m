Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1A3DDC49
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 17:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhHBPXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 11:23:16 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:55801 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235029AbhHBPXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 11:23:15 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id E6E1C580CB7;
        Mon,  2 Aug 2021 11:23:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 02 Aug 2021 11:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=h1Eq7O
        AnpvENWQb1PTCF+iVNX7OWS8rEGj8fuJ0u4vs=; b=LCi7zFlyvxxpGURjsqMB+V
        gNOVr8ofKhz09x8ju6D6ikV5eQA2M20LZdwPWMHZcRHGtU27lqCnMLznDpG1PWE/
        yYyTvsBQ65vLS5+PG4p2rkmbmFOdF8UC/7G7uFLwk2QjpzI+uyHDatDBq94Iz0Oa
        6MftU6DKYrgEhB4RMyC+fxGIYWKtQsqYiVTAs0iJfzSazzwQQGbiIaIV+/oVZViZ
        Q+tB8QRvNvfJpuebHRBmQelWa6bHTnu4/lVlJO5tdH2YJQ+TuS+jKgtzBfWWpMS8
        03T22ReQcZ4gOG45qCYQsyrmiLfI++9QbMTbXqMn0rSvCziLfNpukUd13WnCDcKQ
        ==
X-ME-Sender: <xms:2A0IYbset0vSbgx2TD3WOx2GLZYJ8seYCNaAMkAtnYbcDhoUe1-hxQ>
    <xme:2A0IYccz7oiFl_S9AdGuF9UOFcNRaBP0bZABafgYJVcISEa1e2KBTIKrobARJ2WRz
    dsSIwDc8UEl2Cg>
X-ME-Received: <xmr:2A0IYewtxZRgTl42--KtsBa5Y22EVRBj9244nQhvNfZ-1Vk8piSqACtiBnEg0UFjUd_wawes5L1jkiZgIznu_3LmeZNjhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddriedvgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:2A0IYaMBqsEmxbBdn_59qEBiLeIwWcO-ohyAnZrxqMWFl4gzK997aA>
    <xmx:2A0IYb_oYktVIALBj4CAPD-jzlpPnYLQB_v9OY4SK1D8-aFJ2qRPMg>
    <xmx:2A0IYaVPM6ltBvV8q9-8yLKFBOv-63qm7c2sftyjj7GYfUp2nYDHLA>
    <xmx:2Q0IYRezBhgboGWTyetfxFx8RGQMrNpp_TtMaR3o2V_2-Eo_aZ3r9Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Aug 2021 11:23:04 -0400 (EDT)
Date:   Mon, 2 Aug 2021 18:23:01 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next v2 4/4] net: marvell: prestera: Offload
 FLOW_ACTION_POLICE
Message-ID: <YQgN1djql6wOk8dc@shredder>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
 <20210802140849.2050-5-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802140849.2050-5-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 05:08:49PM +0300, Vadym Kochan wrote:
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> index e571ba09ec08..76f30856ac98 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> @@ -5,6 +5,8 @@
>  #include "prestera_acl.h"
>  #include "prestera_flower.h"
>  
> +#define PRESTERA_HW_TC_NUM	8
> +
>  static int prestera_flower_parse_actions(struct prestera_flow_block *block,
>  					 struct prestera_acl_rule *rule,
>  					 struct flow_action *flow_action,
> @@ -30,6 +32,11 @@ static int prestera_flower_parse_actions(struct prestera_flow_block *block,
>  		case FLOW_ACTION_TRAP:
>  			a_entry.id = PRESTERA_ACL_RULE_ACTION_TRAP;
>  			break;
> +		case FLOW_ACTION_POLICE:
> +			a_entry.id = PRESTERA_ACL_RULE_ACTION_POLICE;
> +			a_entry.police.rate = act->police.rate_bytes_ps;
> +			a_entry.police.burst = act->police.burst;

If packet rate based policing is not supported, an error should be
returned here with extack.

It seems the implementation assumes that each rule has a different
policer, so an error should be returned in case the same policer is
shared between different rules.

> +			break;
>  		default:
>  			NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
>  			pr_err("Unsupported action\n");
> @@ -110,6 +117,17 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (f->classid) {
> +		int hw_tc = __tc_classid_to_hwtc(PRESTERA_HW_TC_NUM, f->classid);
> +
> +		if (hw_tc < 0) {
> +			NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW TC");
> +			return hw_tc;
> +		}
> +
> +		prestera_acl_rule_hw_tc_set(rule, hw_tc);
> +	}

Not sure what this is. Can you show a command line example of how this
is used?

What about visibility regarding number of packets that were dropped by
the policer?
