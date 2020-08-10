Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407FA241078
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 21:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgHJTa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 15:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgHJTKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 15:10:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC83AC061756;
        Mon, 10 Aug 2020 12:10:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13FEE12752967;
        Mon, 10 Aug 2020 11:53:37 -0700 (PDT)
Date:   Mon, 10 Aug 2020 12:10:21 -0700 (PDT)
Message-Id: <20200810.121021.1473385153484096771.davem@davemloft.net>
To:     doshir@vmware.com
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] vmxnet3: use correct tcp hdr length when
 packet is encapsulated
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200810165555.12523-1-doshir@vmware.com>
References: <20200810165555.12523-1-doshir@vmware.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Aug 2020 11:53:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ronak Doshi <doshir@vmware.com>
Date: Mon, 10 Aug 2020 09:55:55 -0700

> Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support") added support for encapsulation offload. However, while
> calculating tcp hdr length, it does not take into account if the
> packet is encapsulated or not.
> 
> This patch fixes this issue by using correct reference for inner
> tcp header.
> 
> Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>

Applied, thanks.
