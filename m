Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F555251A2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353380AbiELPwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346693AbiELPwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:52:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90AA6163C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 08:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=51n4YUbkJC0azj654U72PYe6q8XhqGYBI3zKlmaMpRw=; b=POpJYT/6jH5ckcEQ0ezqHI83G0
        KoC8v9T7Zp5tyZ0wnapogx0DsyoONo6pZto4nEc1ZIDpy7ZNE2tbUcj/aysrlTJISmFVYizD2mc2m
        //uImTDtwIWTpqrEKqpIczRhQHVZl0CgyK/onswH4n01QLV3hvqfG1kB5q8O2Wgp9Q9k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npB6u-002TV0-6e; Thu, 12 May 2022 17:52:16 +0200
Date:   Thu, 12 May 2022 17:52:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/14] net: txgbe: Add build support for txgbe
 ethernet driver
Message-ID: <Yn0tML4HmEAnNARr@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511032659.641834-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Disable LRO if enabling ip forwarding or bridging
> +-------------------------------------------------
> +WARNING: The txgbe driver supports the Large Receive Offload (LRO) feature.
> +This option offers the lowest CPU utilization for receives but is completely
> +incompatible with *routing/ip forwarding* and *bridging*. If enabling ip
> +forwarding or bridging is a requirement, it is necessary to disable LRO using
> +compile time options as noted in the LRO section later in this document. The
> +result of not disabling LRO when combined with ip forwarding or bridging can be
> +low throughput or even a kernel panic.

Please could you tell us more. Is this a hardware/firmware issue? A
know bug in your driver you cannot find?

And why is it a compile time option, not ethtool -k?

> +ethtool
> +-------
> +The driver utilizes the ethtool interface for driver configuration and
> +diagnostics, as well as displaying statistical information. The latest
> +ethtool version is required for this functionality.

And will this still be true in 5 years time?

> +Disable GRO when routing/bridging
> +---------------------------------
> +Due to a known kernel issue, GRO must be turned off when routing/bridging. GRO
> +can be turned off via ethtool::

What kernel issue?

     Andrew
