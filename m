Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD51F462B0F
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 04:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbhK3Da4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 22:30:56 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:59304 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhK3Da4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 22:30:56 -0500
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 37ADD20222;
        Tue, 30 Nov 2021 11:27:30 +0800 (AWST)
Message-ID: <19ae1de8c72e72d61e6d2c149a275223c1c80d5d.camel@codeconstruct.com.au>
Subject: Re: [PATCH -next] mctp: test: use kfree_skb() instead of kfree()
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
Date:   Tue, 30 Nov 2021 11:27:29 +0800
In-Reply-To: <20211130031100.768032-1-yangyingliang@huawei.com>
References: <20211130031100.768032-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yang,

> Use kfree_skb() instead of kfree() to free sk_buff.

Thanks for the patch! We do already have this queued in -net though:

 https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=d85195654470

(which should percolate to net-next in due course too).

Cheers,


Jeremy
