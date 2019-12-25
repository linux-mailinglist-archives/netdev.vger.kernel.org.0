Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3F2912A520
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfLYAJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:09:46 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57932 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfLYAJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:09:45 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B5BB6154CCC27;
        Tue, 24 Dec 2019 16:09:44 -0800 (PST)
Date:   Tue, 24 Dec 2019 16:09:44 -0800 (PST)
Message-Id: <20191224.160944.944924950432766934.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix IP fragment location and
 behavior
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191220192422.22354-1-f.fainelli@gmail.com>
References: <20191220192422.22354-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Dec 2019 16:09:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 20 Dec 2019 11:24:21 -0800

> The IP fragment is specified through user-defined field as the first
> bit of the first user-defined word. We were previously trying to extract
> it from the user-defined mask which could not possibly work. The ip_frag
> is also supposed to be a boolean, if we do not cast it as such, we risk
> overwriting the next fields in CFP_DATA(6) which would render the rule
> inoperative.
> 
> Fixes: 7318166cacad ("net: dsa: bcm_sf2: Add support for ethtool::rxnfc")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied and queued up for -stable, thanks Florian.
