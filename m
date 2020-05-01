Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A55E1C0CFD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 06:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgEAEB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 00:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgEAEB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 00:01:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8385BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 21:01:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B7C11194622E;
        Thu, 30 Apr 2020 21:01:27 -0700 (PDT)
Date:   Thu, 30 Apr 2020 21:01:26 -0700 (PDT)
Message-Id: <20200430.210126.320572119645550621.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        nikolay@cumulusnetworks.com
Subject: Re: [PATCH net] ipv6: Use global sernum for dst validation with
 nexthop objects
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429184542.31170-1-dsahern@kernel.org>
References: <20200429184542.31170-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 21:01:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 29 Apr 2020 12:45:42 -0600

> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
 ...
> +static inline bool rt6_is_valid(const struct rt6_info *rt6)

Please don't use inline in foo.c files.

Thanks.
