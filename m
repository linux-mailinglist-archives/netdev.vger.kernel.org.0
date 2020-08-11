Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7177D241F33
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 19:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgHKR27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 13:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729258AbgHKR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 13:28:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07142C06174A;
        Tue, 11 Aug 2020 10:28:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7DC112880A3D;
        Tue, 11 Aug 2020 10:12:11 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:28:56 -0700 (PDT)
Message-Id: <20200811.102856.864544731521589077.davem@davemloft.net>
To:     mjeanson@efficios.com
Cc:     dsahern@kernel.org, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: Add VRF icmp error route lookup test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200806185121.19688-1-mjeanson@efficios.com>
References: <42cb74c8-9391-cf4c-9e57-7a1d464f8706@gmail.com>
        <20200806185121.19688-1-mjeanson@efficios.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 10:12:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Jeanson <mjeanson@efficios.com>
Date: Thu,  6 Aug 2020 14:51:21 -0400

> The objective is to check that the incoming vrf routing table is selected
> to send an ICMP error back to the source when the ttl of a packet reaches 1
> while it is forwarded between different vrfs.
> 
> The first test sends a ping with a ttl of 1 from h1 to h2 and parses the
> output of the command to check that a ttl expired error is received.
> 
> [This may be flaky, I'm open to suggestions of a more robust approch.]
> 
> The second test runs traceroute from h1 to h2 and parses the output to
> check for a hop on r1.
> 
> Signed-off-by: Michael Jeanson <mjeanson@efficios.com>

This patch does not apply cleanly to the current net tree.
