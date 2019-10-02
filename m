Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2895DC9361
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfJBVRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:17:45 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbfJBVRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:17:45 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D4821550C5DA;
        Wed,  2 Oct 2019 14:17:44 -0700 (PDT)
Date:   Wed, 02 Oct 2019 14:17:41 -0700 (PDT)
Message-Id: <20191002.141741.760314650556672160.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Remove unused __DSA_SKB_CB macro
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001191250.7337-1-olteanv@gmail.com>
References: <20191001191250.7337-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Oct 2019 14:17:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Tue,  1 Oct 2019 22:12:50 +0300

> The struct __dsa_skb_cb is supposed to span the entire 48-byte skb
> control block, while the struct dsa_skb_cb only the portion of it which
> is used by the DSA core (the rest is available as private data to
> drivers).
> 
> The DSA_SKB_CB and __DSA_SKB_CB helpers are supposed to help retrieve
> this pointer based on a skb, but it turns out there is nobody directly
> interested in the struct __dsa_skb_cb in the kernel. So remove it.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
