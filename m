Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8C32EB6B0
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbhAFAGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:06:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52452 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbhAFAGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:06:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id F22AD4CE685B6;
        Tue,  5 Jan 2021 16:05:21 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:05:21 -0800 (PST)
Message-Id: <20210105.160521.1279064249478522010.davem@davemloft.net>
To:     zhutong@amazon.com
Cc:     sashal@kernel.org, edumazet@google.com, vvs@virtuozzo.com,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] neighbour: Disregard DEAD dst in neigh_update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201230225415.GA490@ucf43ac461c9a53.ant.amazon.com>
References: <20201230225415.GA490@ucf43ac461c9a53.ant.amazon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:05:22 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhu <zhutong@amazon.com>
Date: Wed, 30 Dec 2020 17:54:23 -0500

> In 4.x kernel a dst in DST_OBSOLETE_DEAD state is associated
> with loopback net_device and leads to loopback neighbour. It
> leads to an ethernet header with all zero addresses.
> 
> A very troubling case is working with mac80211 and ath9k.
> A packet with all zero source MAC address to mac80211 will
> eventually fail ieee80211_find_sta_by_ifaddr in ath9k (xmit.c).
> As result, ath9k flushes tx queue (ath_tx_complete_aggr) without
> updating baw (block ack window), damages baw logic and disables
> transmission.
> 
> Signed-off-by: Tong Zhu <zhutong@amazon.com>

Please repost with an appropriate Fixes: tag.

Thanks.
