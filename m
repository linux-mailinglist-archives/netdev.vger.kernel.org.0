Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BCA33FBE5
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 00:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQXiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 19:38:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49664 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCQXhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 19:37:33 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F8C362BA5;
        Thu, 18 Mar 2021 00:37:25 +0100 (CET)
Date:   Thu, 18 Mar 2021 00:37:25 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: conntrack: Remove unused variable
 declaration
Message-ID: <20210317233725.GA2521@salvia>
References: <20210311055559.51572-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210311055559.51572-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 01:55:59PM +0800, YueHaibing wrote:
> commit e97c3e278e95 ("tproxy: split off ipv6 defragmentation to a separate
> module") left behind this.

Applied, thanks.
