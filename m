Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5E351588C
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380339AbiD2WlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiD2WlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:41:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7C09E9FA
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GIdZGOTwe32FZnpyghxODKp+HehFB3+mTPR8rOoeJ/s=; b=xf8vK0jCZ0nDQ6kW2jqjO0O35f
        64z5COcjT+wFYPL+ZSSKAGdVL7785vYrXqa3H9w/cSucE23IhHN2j0tthrSoKH3v1uYke6cAjhIwO
        5oCDroBiUF7Gn5ZRUJZbexiixkKQbdIwbcaC2yRNv2VSz6BWpzLadv6ZEMEbfJ4Npdvw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nkZFB-000YYu-1d; Sat, 30 Apr 2022 00:37:45 +0200
Date:   Sat, 30 Apr 2022 00:37:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nate Drude <nate.d@variscite.com>
Cc:     netdev@vger.kernel.org, michael.hennerich@analog.com,
        eran.m@variscite.com
Subject: Re: [PATCH 1/2] dt-bindings: net: adin: document adi,clk_rcvr_125_en
 property
Message-ID: <YmxouZJPpdCXhtLJ@lunn.ch>
References: <20220429184432.962738-1-nate.d@variscite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429184432.962738-1-nate.d@variscite.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 01:44:31PM -0500, Nate Drude wrote:
> Document device tree property to set GE_CLK_RCVR_125_EN (bit 5 of GE_CLK_CFG),
> causing the 125 MHz PHY recovered clock (or PLL clock) to be driven at
> the GP_CLK pin.

Hi Nate

Have you seen:

https://lore.kernel.org/netdev/20220419102709.26432-1-josua@solid-run.com/

	Andrew
