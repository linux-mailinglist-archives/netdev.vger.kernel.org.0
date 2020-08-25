Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2CA251929
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgHYNFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgHYNFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:05:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31810C061574;
        Tue, 25 Aug 2020 06:05:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DFA011E45763;
        Tue, 25 Aug 2020 05:48:16 -0700 (PDT)
Date:   Tue, 25 Aug 2020 06:04:59 -0700 (PDT)
Message-Id: <20200825.060459.1286154906360629138.davem@davemloft.net>
To:     linmiaohe@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: gain ipv4 mtu when mtu is not locked
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200825032028.50760-1-linmiaohe@huawei.com>
References: <20200825032028.50760-1-linmiaohe@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Aug 2020 05:48:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Date: Mon, 24 Aug 2020 23:20:28 -0400

> When mtu is locked, we should not obtain ipv4 mtu as we return immediately
> in this case and leave acquired ipv4 mtu unused.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Applied to net-next.
