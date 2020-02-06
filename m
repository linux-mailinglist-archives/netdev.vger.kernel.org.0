Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8141541E3
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 11:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgBFKae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 05:30:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57836 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgBFKae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 05:30:34 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C43E21495BCE8;
        Thu,  6 Feb 2020 02:30:32 -0800 (PST)
Date:   Thu, 06 Feb 2020 11:30:31 +0100 (CET)
Message-Id: <20200206.113031.422921004131131481.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: move rx_dropped and rx_errors in
 per-cpu stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <69df6b0f81a9078d240d2f94a97a77ca98876223.1580980267.git.lorenzo@kernel.org>
References: <69df6b0f81a9078d240d2f94a97a77ca98876223.1580980267.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Feb 2020 02:30:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Thu,  6 Feb 2020 10:14:39 +0100

> Move rx_dropped and rx_errors counters in mvneta_pcpu_stats in order to
> avoid possible races updating statistics
> 
> Fixes: 562e2f467e71 ("net: mvneta: Improve the buffer allocation method for SWBM")
> Fixes: dc35a10f68d3 ("net: mvneta: bm: add support for hardware buffer management")
> Fixes: c5aff18204da ("net: mvneta: driver for Marvell Armada 370/XP network unit")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied and queued up for -stable.
