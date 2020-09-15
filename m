Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D27626B4D3
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgIOXc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgIOXcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:32:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A783C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:32:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2574A13B786AF;
        Tue, 15 Sep 2020 16:15:26 -0700 (PDT)
Date:   Tue, 15 Sep 2020 16:32:10 -0700 (PDT)
Message-Id: <20200915.163210.447023803079518343.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/5] nexthop: Small changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200915114103.88883-1-idosch@idosch.org>
References: <20200915114103.88883-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 16:15:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 15 Sep 2020 14:40:58 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patch set contains a few small changes that I split out of the RFC
> I sent last week [1]. Main change is the conversion of the nexthop
> notification chain to a blocking chain so that it could be reused by
> device drivers for nexthop objects programming in the future.
> 
> Tested with fib_nexthops.sh:
> 
> Tests passed: 164
> Tests failed:   0
> 
> [1] https://lore.kernel.org/netdev/20200908091037.2709823-1-idosch@idosch.org/

Series applied, thank you.
