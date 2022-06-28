Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7C455CE0C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344810AbiF1KSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbiF1KSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:18:07 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5649C74;
        Tue, 28 Jun 2022 03:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=iHCW4kNEa1z/GyknGrZoZXOa9/2qYzxqyCQLRUMg9Y0=; b=2iOKRsv293IWJK/kC1LT0zoc7c
        m7lnR+g8tpNS8E318vfCev/hRoddQP/yGkXZQ6WrchM6sActa9/BmwOxyZ9wRZQe9wcCLvDvF2XZW
        vyva9l3wv8WlkFlwod2Q/oWWNkkBGhkA14xhJkFq4z1WW7oDj58DVXdskChKybFJUAWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o68I3-008YGJ-J0; Tue, 28 Jun 2022 12:17:51 +0200
Date:   Tue, 28 Jun 2022 12:17:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Franklin Lin <franklin_lin@wistron.corp-partner.google.com>
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        franklin_lin@wistron.com
Subject: Re: [PATCH] drivers/net/usb/r8152: Enable MAC address passthru
 support
Message-ID: <YrrVT33IZ1hMkhw2@lunn.ch>
References: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628015325.1204234-1-franklin_lin@wistron.corp-partner.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:53:25AM +0800, Franklin Lin wrote:
> From: franklin_lin <franklin_lin@wistron.corp-partner.google.com>
> 
> Enable the support for providing a MAC address
> for a dock to use based on the VPD values set in the platform.

Maybe i'm missing it, but i don't see any code which verifies this
r8152 is actually in the dock, and not a USB ethernet dongle plugged
into some port of either the laptop or the dock itself.

     Andrew
