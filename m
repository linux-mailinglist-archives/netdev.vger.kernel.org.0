Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6EC4681D9
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354602AbhLDBrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhLDBrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:47:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E768C061751;
        Fri,  3 Dec 2021 17:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B8B162D86;
        Sat,  4 Dec 2021 01:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DD8C341C1;
        Sat,  4 Dec 2021 01:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638582214;
        bh=u56gr7zj5ULbDe9nL04VKFinW1g9P0pbmmGrQ/7dF20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VPFcuZv3RXZZYVOkfBw+JjB8YtFF4c7Mua6AAJCHo6l2ykzUqFhfafo7N624+t7u2
         uc9YmbiN/9OSYFSt8RHAejkbl9P/fCI1BNuriM8MpFZ2nORmV/rkhgJfIYcBBoXhnE
         JgTrBgYy69OwDfWu+jqbiZO7U27qCYOaz2s2R2XzZz3zNeDb8OtmIddkMc5JaMBzVu
         kREmf2KChf3N+kxK5vjWJJ6VexGifG95Zml6oE6hcRs/cKV7nmtCBUTBk6+dwC5LGY
         qxm1FouvyavOErOeROg77GDmV3iRWoOJtW0Gf2Y9GoEOCw1Pl1HdkXgjl81mvSKGaL
         IoBhBFWg8GXJA==
Date:   Fri, 3 Dec 2021 17:43:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 net-next 4/5] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <20211203174333.074d87b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211204010050.1013718-5-colin.foster@in-advantage.com>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
        <20211204010050.1013718-5-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Dec 2021 17:00:49 -0800 Colin Foster wrote:
> +#include <soc/mscc/ocelot_vcap.h>
> +#include "ocelot.h"

You need to include <soc/mscc/vsc7514_regs.h> here.

> +const u32 vsc7514_ana_regmap[] = {

