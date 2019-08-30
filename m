Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBFEA2B61
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfH3AYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:24:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55778 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfH3AYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:24:18 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EB75F153CC155;
        Thu, 29 Aug 2019 17:24:17 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:24:17 -0700 (PDT)
Message-Id: <20190829.172417.1953301798317414977.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix freeing unused
 SERDES IRQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828185511.21956-1-vivien.didelot@gmail.com>
References: <20190828185511.21956-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:24:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 28 Aug 2019 14:55:11 -0400

> Now mv88e6xxx does not enable its ports at setup itself and let
> the DSA core handle this, unused ports are disabled without being
> powered on first. While that is expected, the SERDES powering code
> was assuming that a port was already set up before powering it down,
> resulting in freeing an unused IRQ. The patch fixes this assumption.
> 
> Fixes: b759f528ca3d ("net: dsa: mv88e6xxx: enable SERDES after setup")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied, thank you.
