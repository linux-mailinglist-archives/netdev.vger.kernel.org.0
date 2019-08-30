Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C22A2B5C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfH3AUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:20:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55736 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfH3AUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:20:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E3CD153CBC38;
        Thu, 29 Aug 2019 17:20:38 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:20:37 -0700 (PDT)
Message-Id: <20190829.172037.1845853820332664364.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: get serdes lane after
 lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190828162611.10064-1-vivien.didelot@gmail.com>
References: <20190828162611.10064-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 29 Aug 2019 17:20:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 28 Aug 2019 12:26:11 -0400

> This is a follow-up patch for commit 17deaf5cb37a ("net: dsa:
> mv88e6xxx: create serdes_get_lane chip operation").
> 
> The .serdes_get_lane implementations access the CMODE of a port,
> even though it is cached at the moment, it is safer to call them
> after the mutex is locked, not before.
> 
> At the same time, check for an eventual error and return IRQ_DONE,
> instead of blindly ignoring it.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied.
