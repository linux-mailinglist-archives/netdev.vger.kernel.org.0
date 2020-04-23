Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2394B1B52DE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 05:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDWDBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 23:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgDWDBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 23:01:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E722AC03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 20:01:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D28B127B6D7C;
        Wed, 22 Apr 2020 20:01:21 -0700 (PDT)
Date:   Wed, 22 Apr 2020 20:01:21 -0700 (PDT)
Message-Id: <20200422.200121.2186383316441917345.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: A few improvements to
 fib_nexthops.sh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422230822.72861-1-dsahern@kernel.org>
References: <20200422230822.72861-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 20:01:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 22 Apr 2020 17:08:22 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> Add nodad when adding IPv6 addresses and remove the sleep.
> 
> A recent change to iproute2 moved the 'pref medium' to the prefix
> (where it belongs). Change the expected route check to strip
> 'pref medium' to be compatible with old and new iproute2.
> 
> Add IPv4 runtime test with an IPv6 address as the gateway in
> the default route.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
