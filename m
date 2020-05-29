Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519731E8C4C
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgE2XqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE2XqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:46:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F4DC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:46:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5328C12868409;
        Fri, 29 May 2020 16:46:23 -0700 (PDT)
Date:   Fri, 29 May 2020 16:46:22 -0700 (PDT)
Message-Id: <20200529.164622.144210175942532794.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: stop restoring VLANs
 from bridge
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527164134.1081548-1-olteanv@gmail.com>
References: <20200527164134.1081548-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:46:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 19:41:34 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Right now, our only tag_8021q user, sja1105, has the ability to restore
> bridge VLANs on its own, so this logic is unnecessary.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

The tagging code had no business doing this anyways I think.

Applied, thanks.
