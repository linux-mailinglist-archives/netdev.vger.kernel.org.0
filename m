Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77D556489A
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 18:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiGCQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 12:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiGCQnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 12:43:22 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8C22BE6
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ncLD0gmmNhCEopi+WxfrHwMoFnVBvcejH+hI5ctvSiM=; b=q62aqkUj/lgV2HVSUlBY+ZNuMx
        6hbeHnKv4Juqck0p2oB1H09mQ8gcGKBFNVGe2fOHrEBflOKFyZs7keyneiIMPzbRPAqsCPKCKjs/L
        UoBR0hVdgKofEXyOP13HY10wD8r9Rxm+hGF+yve95HFubLKrbmlUyZLrywV8mjOJ0igk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o82gq-009AEE-9C; Sun, 03 Jul 2022 18:43:20 +0200
Date:   Sun, 3 Jul 2022 18:43:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tristram.Ha@microchip.com
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 2/2] net: phy: smsc: add EEE support to
 LAN8740/LAN8742 PHYs.
Message-ID: <YsHHKA5po1yRvw2Z@lunn.ch>
References: <1656802708-7918-1-git-send-email-Tristram.Ha@microchip.com>
 <1656802708-7918-3-git-send-email-Tristram.Ha@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1656802708-7918-3-git-send-email-Tristram.Ha@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 02, 2022 at 03:58:28PM -0700, Tristram.Ha@microchip.com wrote:
> From: Tristram Ha <Tristram.Ha@microchip.com>
> 
> EEE feature is enabled in LAN8740/LAN8742 during initialization.

EEE is auto-negotiated. Are you enabling the negotiation of it?

    Andrew
