Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DF91B528F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgDWCbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgDWCby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:31:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8E0C03C1AA
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 19:31:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7AB4C127AB838;
        Wed, 22 Apr 2020 19:31:54 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:31:53 -0700 (PDT)
Message-Id: <20200422.193153.2023213281063359246.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: Add tests for vrf and xfrms
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422004022.63954-1-dsahern@kernel.org>
References: <20200422004022.63954-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:31:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 21 Apr 2020 18:40:22 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> Add tests for vrf and xfrms with a second round after adding a
> qdisc. There are a few known problems documented with the test
> cases that fail. The fix is non-trivial; will come back to it
> when time allows.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks.
