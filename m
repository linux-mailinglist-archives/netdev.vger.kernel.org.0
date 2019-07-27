Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D3C77BFE
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfG0VWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:22:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40358 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725263AbfG0VWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:22:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FBD71534E7AF;
        Sat, 27 Jul 2019 14:22:50 -0700 (PDT)
Date:   Sat, 27 Jul 2019 14:22:49 -0700 (PDT)
Message-Id: <20190727.142249.2284146913665444249.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     pabeni@redhat.com, marcelo.leitner@gmail.com, saeedm@mellanox.com,
        tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] mlx4/en_netdev: allow offloading VXLAN
 over VLAN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2beb05557960e04aa588ecc09e9ee5e5a19fc651.1564164688.git.dcaratti@redhat.com>
References: <2beb05557960e04aa588ecc09e9ee5e5a19fc651.1564164688.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jul 2019 14:22:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 26 Jul 2019 20:18:12 +0200

> ConnectX-3 Pro can offload transmission of VLAN packets with VXLAN inside:
> enable tunnel offloads in dev->vlan_features, like it's done with other
> NIC drivers (e.g. be2net and ixgbe).
> 
> It's no more necessary to change dev->hw_enc_features when VXLAN are added
> or removed, since .ndo_features_check() already checks for VXLAN packet
> where the UDP destination port matches the configured value. Just set
> dev->hw_enc_features when the NIC is initialized, so that overlying VLAN
> can correctly inherit the tunnel offload capabilities.
> 
> Changes since v1:
> - avoid flipping hw_enc_features, instead of calling netdev notifiers,
>   thanks to Saeed Mahameed
> - squash two patches into a single one
> 
> CC: Paolo Abeni <pabeni@redhat.com>
> CC: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
