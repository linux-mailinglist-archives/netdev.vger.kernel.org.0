Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BBC1DDB93
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730428AbgEVAEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEVAEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:04:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36E6C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:04:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CC18120ED486;
        Thu, 21 May 2020 17:04:20 -0700 (PDT)
Date:   Thu, 21 May 2020 17:04:19 -0700 (PDT)
Message-Id: <20200521.170419.723885053708627576.davem@davemloft.net>
To:     chrism@mellanox.com
Cc:     netdev@vger.kernel.org, yotam.gi@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH net-next] net: psample: Add tunnel support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519144520.9275-1-chrism@mellanox.com>
References: <20200519144520.9275-1-chrism@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:04:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <chrism@mellanox.com>
Date: Tue, 19 May 2020 22:45:20 +0800

> Currently, psample can only send the packet bits after decapsulation.
> The tunnel information is lost. Add the tunnel support.
> 
> If the sampled packet has no tunnel info, the behavior is the same as
> before. If it has, add a nested metadata field named PSAMPLE_ATTR_TUNNEL
> and include the tunnel subfields if applicable.
> 
> Increase the metadata length for sampled packet with the tunnel info.
> If new subfields of tunnel info should be included, update the metadata
> length accordingly.
> 
> Signed-off-by: Chris Mi <chrism@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks.
