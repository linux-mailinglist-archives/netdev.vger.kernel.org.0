Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68C81E68F7
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391280AbgE1SBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388240AbgE1SA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:00:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025E8C08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 11:00:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D45F11928DD7;
        Thu, 28 May 2020 11:00:58 -0700 (PDT)
Date:   Thu, 28 May 2020 11:00:57 -0700 (PDT)
Message-Id: <20200528.110057.229359275144753365.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next] selftests: Add torture tests to nexthop tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528000344.57809-1-dsahern@kernel.org>
References: <20200528000344.57809-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:00:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 27 May 2020 18:03:44 -0600

> Add Nik's torture tests as a new set to stress the replace and cleanup
> paths.
> 
> Torture test created by Nikolay Aleksandrov and then I adapted to
> selftest and added IPv6 version.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>

Applied, thanks David.
