Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0878F1EAF7B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 21:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgFATOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 15:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgFATON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 15:14:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0AAEC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 12:14:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 01AED11D53F8B;
        Mon,  1 Jun 2020 12:14:12 -0700 (PDT)
Date:   Mon, 01 Jun 2020 12:14:12 -0700 (PDT)
Message-Id: <20200601.121412.1609606947040953222.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: suppress
 -Wmissing-prototypes in sja1105_vl.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200531182551.1515185-1-olteanv@gmail.com>
References: <20200531182551.1515185-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 12:14:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 31 May 2020 21:25:51 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Newer C compilers are complaining about the fact that there are no
> function prototypes in sja1105_vl.c for the non-static functions.
> Give them what they want.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
