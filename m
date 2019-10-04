Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFEDCC515
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbfJDVoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:44:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59374 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731223AbfJDVoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:44:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BF12E14F123BC;
        Fri,  4 Oct 2019 14:44:02 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:44:02 -0700 (PDT)
Message-Id: <20191004.144402.1481680815632953232.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: Add support for port
 mirroring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191004003347.17523-1-olteanv@gmail.com>
References: <20191004003347.17523-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:44:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri,  4 Oct 2019 03:33:47 +0300

> Amazingly, of all features, this does not require a switch reset.
> 
> Tested with:
> 
> tc qdisc add dev swp2 clsact
> tc filter add dev swp2 ingress matchall skip_sw \
> 	action mirred egress mirror dev swp3
> tc filter show dev swp2 ingress
> tc filter del dev swp2 ingress pref 49152
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
> Changes in v2:
> - Reworked the error message to print the mirror port correctly.

Applied.
