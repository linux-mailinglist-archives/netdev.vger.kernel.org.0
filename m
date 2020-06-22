Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1898C204429
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgFVXBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731268AbgFVXBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:01:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7369C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:01:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9FD11129252AE;
        Mon, 22 Jun 2020 16:01:45 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:01:44 -0700 (PDT)
Message-Id: <20200622.160144.280907798570180848.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/3] Cosmetic cleanup in SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200620171832.3679837-1-olteanv@gmail.com>
References: <20200620171832.3679837-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:01:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 20 Jun 2020 20:18:29 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This removes the sparse warnings from the sja1105 driver and makes some
> structures constant.

Series applied, thanks.
