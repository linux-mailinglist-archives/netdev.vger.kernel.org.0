Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C374626B08
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 19:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiKLS2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 13:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiKLS2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 13:28:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5779E6561;
        Sat, 12 Nov 2022 10:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YoY1f3uFXx3aJpzKVIF9IAK+7H0am1LUMJiBdQEgnv8=; b=D1aXkW++rXD8DNmwvfp+7jV7uW
        1vop3p2vBBY74Zo+ShgrMKWcwZjwuiR5SPqyKHG5NqCAXI9Hv6zGcKSOUy6wc0JO4yI8EID1qhYfY
        rlEhBfaX9lBTUf8fH3XKjbYID+1C6lFEIfWVhkmmvaMZc9i6CYVeUf3OsjoiJfyp2Uas=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otvEb-002CQS-8v; Sat, 12 Nov 2022 19:28:05 +0100
Date:   Sat, 12 Nov 2022 19:28:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
Subject: Re: [net-next PATCH 5/9] octeontx2-af: Add support for RPM FEC stats
Message-ID: <Y2/ltb01fuLlOXee@lunn.ch>
References: <20221112043141.13291-1-hkelam@marvell.com>
 <20221112043141.13291-6-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112043141.13291-6-hkelam@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 12, 2022 at 10:01:37AM +0530, Hariprasad Kelam wrote:
> RPM/CGX blocks support both RS-FEC and BASER modes.
> This patch adds support to display these FEC stats.
> 
> FEC stats are integrated to below file
> cat /sys/kernel/debug/cn10k/rpm/rpmx/lmacx/stats

And i assume also the official kernel API, ethtool get_fec_stats?

    Andrew
