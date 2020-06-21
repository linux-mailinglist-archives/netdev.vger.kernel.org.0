Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE96E202795
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgFUA0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbgFUA0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:26:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5C0C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:26:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 321A8120ED49C;
        Sat, 20 Jun 2020 17:26:00 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:25:59 -0700 (PDT)
Message-Id: <20200620.172559.784930447953613797.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com
Subject: Re: [PATCH net-next 00/12] Ocelot/Felix driver cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:26:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 20 Jun 2020 18:43:35 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Some of the code in the mscc felix and ocelot drivers was added while in
> a bit of a hurry. Let's take a moment and put things in relative order.
> 
> First 3 patches are sparse warning fixes.
> 
> Patches 4-9 perform some further splitting between mscc_felix,
> mscc_ocelot, and the common hardware library they share. Meaning that
> some code is being moved from the library into just the mscc_ocelot
> module.
> 
> Patches 10-12 refactor the naming conventions in the existing VCAP code
> (for tc-flower offload), since we're going to be adding some more code
> for VCAP IS1 (previous tentatives already submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200602051828.5734-1-xiaoliang.yang_1@nxp.com/),
> and that code would be confusing to read and maintain using current
> naming conventions.
> 
> No functional modification is intended. I checked that the VCAP IS2 code
> still works by applying a tc ingress filter with an EtherType key and
> 'drop' action.

This looks good, series applied, thanks.
