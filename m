Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF661491CB
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 22:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfFQU6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 16:58:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfFQU6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 16:58:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9B6B15130B18;
        Mon, 17 Jun 2019 13:58:21 -0700 (PDT)
Date:   Mon, 17 Jun 2019 13:58:21 -0700 (PDT)
Message-Id: <20190617.135821.1970853531857836652.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huhai@kylinos.cn
Subject: Re: [PATCH net-next] vhost_net: disable zerocopy by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617092054.12299-1-jasowang@redhat.com>
References: <20190617092054.12299-1-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Jun 2019 13:58:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Mon, 17 Jun 2019 05:20:54 -0400

> Vhost_net was known to suffer from HOL[1] issues which is not easy to
> fix. Several downstream disable the feature by default. What's more,
> the datapath was split and datacopy path got the support of batching
> and XDP support recently which makes it faster than zerocopy part for
> small packets transmission.
> 
> It looks to me that disable zerocopy by default is more
> appropriate. It cold be enabled by default again in the future if we
> fix the above issues.
> 
> [1] https://patchwork.kernel.org/patch/3787671/
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jason.
