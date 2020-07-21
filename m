Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94CF2274A9
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGUBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGUBiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:38:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28ACC061794;
        Mon, 20 Jul 2020 18:38:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9016811FFCC52;
        Mon, 20 Jul 2020 18:22:05 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:38:49 -0700 (PDT)
Message-Id: <20200720.183849.626605331445628040.davem@davemloft.net>
To:     cuibixuan@huawei.com
Cc:     stephen@networkplumber.org, kuba@kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jdmason@kudzu.us,
        christophe.jaillet@wanadoo.fr, john.wanghui@huawei.com
Subject: Re: [PATCH v2] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <866b4a34-cd4e-0120-904f-13669257a765@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
        <20200719100522.220a6f5a@hermes.lan>
        <866b4a34-cd4e-0120-904f-13669257a765@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:22:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>
Date: Mon, 20 Jul 2020 09:58:39 +0800

> Fix the warning: [-Werror=-Wframe-larger-than=]
> 
> drivers/net/ethernet/neterion/vxge/vxge-main.c:
> In function'VXGE_COMPLETE_VPATH_TX.isra.37':
> drivers/net/ethernet/neterion/vxge/vxge-main.c:119:1:
> warning: the frame size of 1056 bytes is larger than 1024 bytes
> 
> Dropping the NR_SKB_COMPLETED to 16 is appropriate that won't
> have much impact on performance and functionality.
> 
> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
> v2: Dropping the NR_SKB_COMPLETED to 16.

Applied.
