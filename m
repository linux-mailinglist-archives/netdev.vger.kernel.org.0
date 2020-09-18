Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5EE27078F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgIRUw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgIRUwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:52:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7066C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:52:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D5C31590C688;
        Fri, 18 Sep 2020 13:36:05 -0700 (PDT)
Date:   Fri, 18 Sep 2020 13:52:51 -0700 (PDT)
Message-Id: <20200918.135251.1990446034167845797.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, UNGLinuxDriver@microchip.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH v2 net 0/8] Bugfixes in Microsemi Ocelot switch driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918010730.2911234-1-olteanv@gmail.com>
References: <20200918010730.2911234-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:36:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 18 Sep 2020 04:07:22 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This is a series of 8 assorted patches for "net", on the drivers for the
> VSC7514 MIPS switch (Ocelot-1), the VSC9953 PowerPC (Seville), and a few
> more that are common to all supported devices since they are in the
> common library portion.

Series applied, thanks.
