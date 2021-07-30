Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BC93DBD72
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhG3RCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhG3RCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:02:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2515460BD3;
        Fri, 30 Jul 2021 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627664554;
        bh=nNQUqMcwW65qaswJyk4gakdxAFpLBoW+3Gh44w8NFL0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YJ9fXD+kiOe9WjEbAihw+haVqPoV4vr4olLd1C3hqVx7Arfmdi0ICFiULl5nYUQfe
         6AtTRWjD5I2jD52U4Hc9nhqYZ5YqtgmOwbfboCaJ7HdNmILHCO0lCxvxfoRSypNjk1
         5WRQIT9pTaWOcl1C/sob1kB4JG8Zmted7czcT1FQoA7oiekdBvhMJi0rwr918JQGKQ
         s4D2nWoQaS/rrDXHf6JeYj6Ro1Upa6AfnlYpbb0SGh0G8SWrWTtigxM1wLOELC738c
         srS1bHvvLru/pj/1UxVvjGjOEqR+CP1PxZvvaY74FJFkbPJef+uc+G4u07SrC0TJr3
         65VOw0PHa/joA==
Date:   Fri, 30 Jul 2021 10:02:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Subject: Re: [PATCH net-next 4/4] net: marvell: prestera: Offload
 FLOW_ACTION_POLICE
Message-ID: <20210730100233.14d18ccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730133925.18851-5-vadym.kochan@plvision.eu>
References: <20210730133925.18851-1-vadym.kochan@plvision.eu>
        <20210730133925.18851-5-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 16:39:25 +0300 Vadym Kochan wrote:
> -int prestera_hw_acl_rule_add(struct prestera_switch *sw,
> -			     struct prestera_acl_rule *rule,
> -			     u32 *rule_id)
> +int __prestera_hw_acl_rule_add(struct prestera_switch *sw,
> +			       struct prestera_acl_rule *rule,
> +			       u32 *rule_id)
>  {
>  	struct prestera_msg_acl_action *actions;
>  	struct prestera_msg_acl_match *matches;

> +int __prestera_hw_acl_rule_ext_add(struct prestera_switch *sw,
> +				   struct prestera_acl_rule *rule,
> +				   u32 *rule_id)

both should be static
