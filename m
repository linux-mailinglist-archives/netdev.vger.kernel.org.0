Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7501126986D
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgINVzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgINVzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 17:55:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C3FC061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 14:55:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CE721273FF76;
        Mon, 14 Sep 2020 14:38:49 -0700 (PDT)
Date:   Mon, 14 Sep 2020 14:55:35 -0700 (PDT)
Message-Id: <20200914.145535.1102574282222096595.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        wenxu@ucloud.cn
Subject: Re: [PATCH net] ipv4: Initialize flowi4_multipath_hash in data path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913184339.35927-1-dsahern@kernel.org>
References: <20200913184339.35927-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 14:38:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun, 13 Sep 2020 12:43:39 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> flowi4_multipath_hash was added by the commit referenced below for
> tunnels. Unfortunately, the patch did not initialize the new field
> for several fast path lookups that do not initialize the entire flow
> struct to 0. Fix those locations. Currently, flowi4_multipath_hash
> is random garbage and affects the hash value computed by
> fib_multipath_hash for multipath selection.
> 
> Fixes: 24ba14406c5c ("route: Add multipath_hash in flowi_common to make user-define hash")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: wenxu <wenxu@ucloud.cn>

Applied and queued up for -stable, thanks David.
