Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077E3253A8C
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 01:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHZXD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgHZXD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 19:03:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C99C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 16:03:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D29FA1296EF73;
        Wed, 26 Aug 2020 15:47:10 -0700 (PDT)
Date:   Wed, 26 Aug 2020 16:03:56 -0700 (PDT)
Message-Id: <20200826.160356.2055371151990287137.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/7] ipv4: nexthop: Various improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
References: <20200826164857.1029764-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:47:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 26 Aug 2020 19:48:50 +0300

> This patch set contains various improvements that I made to the nexthop
> object code while studying it towards my upcoming changes.
> 
> While patches #4 and #6 fix bugs, they are not regressions (never
> worked). They also do not occur to me as critical issues, which is why I
> am targeting them at net-next.
> 
> Tested with fib_nexthops.sh:
> 
> Tests passed: 134
> Tests failed:   0

Series applied, thanks Ido.
