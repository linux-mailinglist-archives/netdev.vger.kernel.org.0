Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3E20671F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389703AbgFWWUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388001AbgFWWUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:20:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36689C061573;
        Tue, 23 Jun 2020 15:20:11 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 215411294D25A;
        Tue, 23 Jun 2020 15:20:10 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:20:09 -0700 (PDT)
Message-Id: <20200623.152009.1181630031177940079.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, borisp@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jeffrey.t.kirsher@intel.com,
        kuba@kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bonding/xfrm: use real_dev instead of
 slave_dev
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623204001.55030-1-jarod@redhat.com>
References: <20200623204001.55030-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:20:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Tue, 23 Jun 2020 16:40:01 -0400

> Rather than requiring every hw crypto capable NIC driver to do a check for
> slave_dev being set, set real_dev in the xfrm layer and xso init time, and
> then override it in the bonding driver as needed. Then NIC drivers can
> always use real_dev, and at the same time, we eliminate the use of a
> variable name that probably shouldn't have been used in the first place,
> particularly given recent current events.
> 
> CC: Boris Pismenny <borisp@mellanox.com>
> CC: Saeed Mahameed <saeedm@mellanox.com>
> CC: Leon Romanovsky <leon@kernel.org>
> CC: Jay Vosburgh <j.vosburgh@gmail.com>
> CC: Veaceslav Falico <vfalico@gmail.com>
> CC: Andy Gospodarek <andy@greyhouse.net>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Steffen Klassert <steffen.klassert@secunet.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: netdev@vger.kernel.org
> Suggested-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Yes this is much nicer.

Applied, thank you.
