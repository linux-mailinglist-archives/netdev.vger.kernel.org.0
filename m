Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFE42A764
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 01:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfEYXhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 19:37:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfEYXhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 19:37:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5C98F1500AE49;
        Sat, 25 May 2019 16:37:31 -0700 (PDT)
Date:   Sat, 25 May 2019 16:35:45 -0700 (PDT)
Message-Id: <20190525.163545.974576953807440461.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next] net: ethtool: Document get_rxfh_context and
 set_rxfh_context ethtool ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524100530.8445-1-maxime.chevallier@bootlin.com>
References: <20190524100530.8445-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 May 2019 16:37:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Fri, 24 May 2019 12:05:30 +0200

> ethtool ops get_rxfh_context and set_rxfh_context are used to create,
> remove and access parameters associated to RSS contexts, in a similar
> fashion to get_rxfh and set_rxfh.
> 
> Add a small descritopn of these callbacks in the struct ethtool_ops doc.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

As a doc fix, I'll put this into 'net'.

Thank you.
