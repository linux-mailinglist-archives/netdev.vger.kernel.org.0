Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4010034F4A7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 00:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhC3WzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 18:55:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46520 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhC3WzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 18:55:00 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9238C63E55;
        Wed, 31 Mar 2021 00:54:45 +0200 (CEST)
Date:   Wed, 31 Mar 2021 00:54:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kadlec@netfilter.org
Subject: Re: [PATCH -next] netfilter: nftables: remove unnecessary
 spin_lock_init()
Message-ID: <20210330225456.GA14489@salvia>
References: <20210329135541.3304940-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210329135541.3304940-1-yangyingliang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 09:55:41PM +0800, Yang Yingliang wrote:
> The spinlock nf_tables_destroy_list_lock is initialized statically.
> It is unnecessary to initialize by spin_lock_init().

Applied, thanks.
