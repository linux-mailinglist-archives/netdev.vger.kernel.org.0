Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D34B60CCB8
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiJYMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiJYMwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:52:23 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0383718390;
        Tue, 25 Oct 2022 05:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=fgBaYhpzxkIPhjY8+xXBsxybgtRGDrCyniTTz8MmD+Y=; b=LN
        hTv2WuhK7LZ5BbyUvAOWkWTnDJl4NKCGNEPpBe8yzO/B/L1dzRVtOY8rPKI/748fzCq54I/Jenynp
        8n6BkwufYKfWGAeGQP73HeCrr9Eve+zvj2z8rtR+BDtp76q/MjZ9rKDdIGfNwFjRqQ3nnmVQC8l7p
        dVcxdpY04qRc/R4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onJNJ-000X5M-86; Tue, 25 Oct 2022 14:49:45 +0200
Date:   Tue, 25 Oct 2022 14:49:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Juergen Borleis <jbe@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] net: fec: limit register access on i.MX6UL
Message-ID: <Y1fbaY6SSLppusvx@lunn.ch>
References: <20221024080552.21004-1-jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221024080552.21004-1-jbe@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 10:05:52AM +0200, Juergen Borleis wrote:
> Using 'ethtool -d […]' on an i.MX6UL leads to a kernel crash:
> 
>    Unhandled fault: external abort on non-linefetch (0x1008) at […]
> 
> due to this SoC has less registers in its FEC implementation compared to other
> i.MX6 variants. Thus, a run-time decision is required to avoid access to
> non-existing registers.
> 
> Signed-off-by: Juergen Borleis <jbe@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
