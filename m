Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A1B68A809
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 04:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbjBDDzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 22:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjBDDzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 22:55:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEAE8A7F8;
        Fri,  3 Feb 2023 19:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D04A562025;
        Sat,  4 Feb 2023 03:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD55FC433D2;
        Sat,  4 Feb 2023 03:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675482901;
        bh=6PlJAfsPsnyJrye+5W4hS0mOiL7cK7fe+sQ9dsb/ga0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lb8KQ2eiXPy3w9hHRaamslL1XQiqWoZxVGz0BklvfeOc1cPRkLX2m8B+yDSgQoXZm
         lRB80vyMLl71mbKybU8dxZFjQwwyYTrBbcaja1jUC3brOScXadwTkZLq2egn5akZgT
         L0J6xrJVlQT2fYTpgusI9sO3JbAwvgcgLpJaLXucHnjMqSa9hyBftaaXK1zwGdx+18
         lfcZhImjOOMKSN33Lp4dDACIjE8HwgHBiJhd+21FxZvPCgNWMCL26s1bEq9CIJcJ0H
         401D1huIJzjzKzhOLGqd9/vo6NuUz55wylL9YmO1FIkaNHnBCvzrX5FrOOXbBgLNZW
         YcxiZXWHNTDrQ==
Date:   Fri, 3 Feb 2023 19:54:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next] net: mscc: ocelot: un-export unused regmap
 symbols
Message-ID: <20230203195459.6576e80a@kernel.org>
In-Reply-To: <20230204013439.4vfag2kbrwpwvnpr@skbuf>
References: <20230204001211.1764672-1-colin.foster@in-advantage.com>
        <20230204013439.4vfag2kbrwpwvnpr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 4 Feb 2023 03:34:39 +0200 Vladimir Oltean wrote:
> These can be unexported too:
> 
> extern const struct vcap_field vsc7514_vcap_es0_keys[];
> extern const struct vcap_field vsc7514_vcap_es0_actions[];
> extern const struct vcap_field vsc7514_vcap_is1_keys[];
> extern const struct vcap_field vsc7514_vcap_is1_actions[];
> extern const struct vcap_field vsc7514_vcap_is2_keys[];
> extern const struct vcap_field vsc7514_vcap_is2_actions[];
> 
> I guess we make exceptions for the 24 hour reposting rule when the patch
> has been reviewed?

FWIW I think that it's perfectly fine to skip the wait whenever
reviewer explicitly asks for a quick repost. The only person who's
judgment we don't trust is the author (including me not trusting
myself when I post my own patches).
