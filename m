Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0611BCEDF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgD1VhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726760AbgD1VhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:37:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C886C03C1AD;
        Tue, 28 Apr 2020 14:37:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 968801210A3FB;
        Tue, 28 Apr 2020 14:37:02 -0700 (PDT)
Date:   Tue, 28 Apr 2020 14:37:01 -0700 (PDT)
Message-Id: <20200428.143701.1724441979704593049.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     jgg@mellanox.com, vfalico@gmail.com, andy@greyhouse.net,
        dsahern@kernel.org, maorg@mellanox.com, j.vosburgh@gmail.com,
        jiri@mellanox.com, kuba@kernel.org, dledford@redhat.com,
        alexr@mellanox.com, netdev@vger.kernel.org, leonro@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 00/16] Add support to get xmit slave
From:   David Miller <davem@davemloft.net>
In-Reply-To: <089adbfe7c89d8513a2c2ef49f82c390240c4e30.camel@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
        <089adbfe7c89d8513a2c2ef49f82c390240c4e30.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Apr 2020 14:37:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 28 Apr 2020 20:04:18 +0000

> Since this series has netdev bonding stuff + rdma + mlx5, I would like
> to get your ack before i merged it into mlx5 tree and send it to you
> and to the rdma folks in a pull request .. 
> 
> Please let me know if you are ok with this series and with the
> submission plan.

Yes, I am.

Acked-by: David S. Miller <davem@davemloft.net>
