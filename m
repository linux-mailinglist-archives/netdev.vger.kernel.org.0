Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C451B1E8C4B
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgE2XpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgE2XpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:45:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B50FC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:45:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0696128683F5;
        Fri, 29 May 2020 16:45:06 -0700 (PDT)
Date:   Fri, 29 May 2020 16:45:06 -0700 (PDT)
Message-Id: <20200529.164506.2200622965835884094.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: fix port mirroring for P/Q/R/S
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527164006.1080903-1-olteanv@gmail.com>
References: <20200527164006.1080903-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:45:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 19:40:06 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The dynamic configuration interface for the General Params and the L2
> Lookup Params tables was copy-pasted between E/T devices and P/Q/R/S
> devices. Nonetheless, these interfaces are bitwise different (and not to
> mention, located at different SPI addresses).
> 
> The driver is using dynamic reconfiguration of the General Parameters
> table for the port mirroring feature, which was therefore broken on
> P/Q/R/S.
> 
> Note that I don't think this patch can be backported very far to stable
> trees (since it conflicts with some other development done since the
> introduction of the driver).
> 
> Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Please fix the build errors reported by the kbuild robot.
