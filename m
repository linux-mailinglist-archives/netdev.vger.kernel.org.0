Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7DC2043BE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731038AbgFVWjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVWjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:39:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B75C061573;
        Mon, 22 Jun 2020 15:39:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 001211296A2B3;
        Mon, 22 Jun 2020 15:39:13 -0700 (PDT)
Date:   Mon, 22 Jun 2020 15:39:13 -0700 (PDT)
Message-Id: <20200622.153913.2174708105885098663.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jeffrey.t.kirsher@intel.com,
        kuba@kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v3 0/4] bonding: initial support for hardware
 crypto offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619143155.20726-1-jarod@redhat.com>
References: <20200619143155.20726-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 15:39:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 19 Jun 2020 10:31:51 -0400

> This is an initial functional implementation for doing pass-through of
> hardware encryption from bonding device to capable slaves, in active-backup
> bond setups. This was developed and tested using ixgbe-driven Intel x520
> interfaces with libreswan and a transport mode connection, primarily using
> netperf, with assorted connection failures forced during transmission. The
> failover works quite well in my testing, and overall performance is right
> on par with offload when running on a bare interface, no bond involved.
> 
> Caveats: this is ONLY enabled for active-backup, because I'm not sure
> how one would manage multiple offload handles for different devices all
> running at the same time in the same xfrm, and it relies on some minor
> changes to both the xfrm code and slave device driver code to get things
> to behave, and I don't have immediate access to any other hardware that
> could function similarly, but the NIC driver changes are minimal and
> straight-forward enough that I've included what I think ought to be
> enough for mlx5 devices too.
> 
> v2: reordered patches, switched (back) to using CONFIG_XFRM_OFFLOAD
> to wrap the code additions and wrapped overlooked additions.
> v3: rebase w/net-next open, add proper cc list to cover letter

Series applied, thanks.
