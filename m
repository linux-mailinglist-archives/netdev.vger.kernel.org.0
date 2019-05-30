Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01809302C2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfE3T3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:29:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58828 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:29:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4312914DA812D;
        Thu, 30 May 2019 12:29:08 -0700 (PDT)
Date:   Thu, 30 May 2019 12:29:05 -0700 (PDT)
Message-Id: <20190530.122905.427002960025853686.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        Rasmus.Villemoes@prevas.se, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: fix handling of upper half
 of STATS_TYPE_PORT
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529070158.7040-1-rasmus.villemoes@prevas.dk>
References: <20190529070158.7040-1-rasmus.villemoes@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:29:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Wed, 29 May 2019 07:02:11 +0000

> Currently, the upper half of a 4-byte STATS_TYPE_PORT statistic ends
> up in bits 47:32 of the return value, instead of bits 31:16 as they
> should.
> 
> Fixes: 6e46e2d821bb ("net: dsa: mv88e6xxx: Fix u64 statistics")
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
> v2: include Fixes tag, use proper subject prefix.

Applied and queued up for -stable, thanks.
