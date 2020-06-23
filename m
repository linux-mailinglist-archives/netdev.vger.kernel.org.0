Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71758204802
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbgFWDlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgFWDlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:41:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5B3C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 20:41:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5806C120F93F8;
        Mon, 22 Jun 2020 20:41:23 -0700 (PDT)
Date:   Mon, 22 Jun 2020 20:41:22 -0700 (PDT)
Message-Id: <20200622.204122.1797376189541524592.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: Re: [PATCH net-next 0/5] Multicast improvement in Ocelot and Felix
 drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200621114603.119608-1-olteanv@gmail.com>
References: <20200621114603.119608-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 20:41:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 21 Jun 2020 14:45:58 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series makes some basic multicast forwarding functionality work for
> Felix DSA and for Ocelot switchdev. IGMP/MLD snooping in Felix is still
> missing, and there are other improvements to be made in the general area
> of multicast address filtering towards the CPU, but let's get these
> hardware-specific fixes out of the way first.

Series applied to net-next, thank you.
