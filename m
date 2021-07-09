Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4FB03C28CB
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhGISBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 14:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGISBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 14:01:37 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BC7C0613DD;
        Fri,  9 Jul 2021 10:58:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 1C3EA4D310818;
        Fri,  9 Jul 2021 10:58:51 -0700 (PDT)
Date:   Fri, 09 Jul 2021 10:58:47 -0700 (PDT)
Message-Id: <20210709.105847.2246373390622335461.davem@davemloft.net>
To:     vvs@virtuozzo.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH IPV6 v2 1/4] ipv6: allocate enough headroom in
 ip6_finish_output2()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4f6a2b28-a137-2e19-bf62-5a8767d0d0ac@virtuozzo.com>
References: <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
        <cover.1625818825.git.vvs@virtuozzo.com>
        <4f6a2b28-a137-2e19-bf62-5a8767d0d0ac@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 09 Jul 2021 10:58:51 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please do not use inline in foo.c files, let the compiler decde.

Thank you.

