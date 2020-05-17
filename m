Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3D1D6C48
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 21:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgEQT1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 15:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQT1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 15:27:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95C3C061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 12:27:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66978128A0768;
        Sun, 17 May 2020 12:27:20 -0700 (PDT)
Date:   Sun, 17 May 2020 12:27:17 -0700 (PDT)
Message-Id: <20200517.122717.962160769152016283.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net-next] selftests: Drop 'pref medium' in route checks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200517180033.75775-1-dsahern@kernel.org>
References: <20200517180033.75775-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 May 2020 12:27:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun, 17 May 2020 12:00:33 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> The 'pref medium' attribute was moved in iproute2 to be near the prefix
> which is where it applies versus after the last nexthop. The nexthop
> tests were updated to drop the string from route checking, but it crept
> in again with the compat tests.
> 
> Fixes: 4dddb5be136a ("selftests: net: add new testcases for nexthop API compat mode sysctl")
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>

Applied, thank you.
