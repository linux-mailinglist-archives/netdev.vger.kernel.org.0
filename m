Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8B984FD8A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 20:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfFWSZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 14:25:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43498 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfFWSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 14:25:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 70AA0126A1260;
        Sun, 23 Jun 2019 11:25:37 -0700 (PDT)
Date:   Sun, 23 Jun 2019 11:25:37 -0700 (PDT)
Message-Id: <20190623.112537.2211302797354603091.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Rasmus.Villemoes@prevas.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: introduce helpers for
 handling chip->reg_lock
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190620135034.24986-1-rasmus.villemoes@prevas.dk>
References: <20190620135034.24986-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Jun 2019 11:25:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Thu, 20 Jun 2019 13:50:42 +0000

> This is a no-op that simply moves all locking and unlocking of
> ->reg_lock into trivial helpers. I did that to be able to easily add
> some ad hoc instrumentation to those helpers to get some information
> on contention and hold times of the mutex. Perhaps others want to do
> something similar at some point, so this frees them from doing the
> 'sed -i' yoga, and have a much smaller 'git diff' while fiddling.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Applied.
