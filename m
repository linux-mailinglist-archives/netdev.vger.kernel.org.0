Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FEE1D6B95
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgEQRnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbgEQRnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 13:43:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ED2C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 10:43:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D84D21288DC14;
        Sun, 17 May 2020 10:43:47 -0700 (PDT)
Date:   Sun, 17 May 2020 10:43:33 -0700 (PDT)
Message-Id: <20200517.104333.2026819244321873676.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        assogba.emery@gmail.com
Subject: Re: [PATCH net] nexthop: Fix attribute checking for groups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517172632.75013-1-dsahern@kernel.org>
References: <20200517172632.75013-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 10:43:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun, 17 May 2020 11:26:32 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> For nexthop groups, attributes after NHA_GROUP_TYPE are invalid, but
> nh_check_attr_group starts checking at NHA_GROUP. The group type defaults
> to multipath and the NHA_GROUP_TYPE is currently optional so this has
> slipped through so far. Fix the attribute checking to handle support of
> new group types.
> 
> Fixes: 430a049190de ("nexthop: Add support for nexthop groups")
> Signed-off-by: ASSOGBA Emery <assogba.emery@gmail.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and queued up for -stable, thanks David.
