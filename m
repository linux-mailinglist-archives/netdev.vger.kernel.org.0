Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B30C211A088
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 02:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLKBch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 20:32:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51126 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfLKBch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 20:32:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 981B815039439;
        Tue, 10 Dec 2019 17:32:36 -0800 (PST)
Date:   Tue, 10 Dec 2019 17:32:36 -0800 (PST)
Message-Id: <20191210.173236.1849931419980155783.davem@davemloft.net>
To:     michael@walle.cc
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com
Subject: Re: [PATCH net-next] enetc: add software timestamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210001537.25630-1-michael@walle.cc>
References: <20191210001537.25630-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 17:32:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Tue, 10 Dec 2019 01:15:37 +0100

> Provide a software TX timestamp and add it to the ethtool query
> interface.
> 
> skb_tx_timestamp() is also needed if one would like to use PHY
> timestamping.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thanks.
