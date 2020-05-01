Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDA51C20CD
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgEAWkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgEAWkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:40:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74C7C061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:40:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3217914F9902D;
        Fri,  1 May 2020 15:40:35 -0700 (PDT)
Date:   Fri, 01 May 2020 15:40:34 -0700 (PDT)
Message-Id: <20200501.154034.2140916368639543304.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/2] net: dsa: mv88e6xxx: augment phylink
 support for 10G
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430082104.GO1551@shell.armlinux.org.uk>
References: <20200430082104.GO1551@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:40:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Thu, 30 Apr 2020 09:21:04 +0100

> This series adds phylink 10G support for the 88E6390 series switches,
> as suggested by Andrew Lunn.
> 
> The first patch cleans up the code to use generic definitions for the
> registers in a similar way to what was done with the initial conversion
> of 1G serdes support.
> 
> The second patch adds the necessary bits 10GBASE mode to the
> pcs_get_state() method.

Series applied, thanks.
