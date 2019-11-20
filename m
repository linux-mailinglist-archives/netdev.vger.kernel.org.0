Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64616104488
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 20:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfKTTsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 14:48:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfKTTsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 14:48:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1A9E14C11065;
        Wed, 20 Nov 2019 11:48:11 -0800 (PST)
Date:   Wed, 20 Nov 2019 11:48:07 -0800 (PST)
Message-Id: <20191120.114807.1742983919272559405.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next V3 0/3] page_pool: API for numa node change
 handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120131512.65e38054@carbon>
References: <20191120001456.11170-1-saeedm@mellanox.com>
        <20191120131512.65e38054@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 11:48:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 20 Nov 2019 13:15:12 +0100

> On Wed, 20 Nov 2019 00:15:14 +0000
> Saeed Mahameed <saeedm@mellanox.com> wrote:
> 
>> Performance analysis and conclusions by Jesper [1]:
>> Impact on XDP drop x86_64 is inconclusive and shows only 0.3459ns
>> slow-down, as this is below measurement accuracy of system.
> 
> Yes, I have had time to micro-benchmark this (on Intel), and given I
> cannot demonstrate statistically significant slowdown, I'm going to
> accept this change to the fast-path of page_pool.
> 
> For series:
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Series applied.

> (I'm going to ack each patch, in-order to make patchwork pickup the
> ACK, and hopefully make this easier for DaveM).

Thanks Jesper.

I usually still look for replies to the introduction posting and collects
ACKs I find :-)
