Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDAE1B1563
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgDTTI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725896AbgDTTIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:08:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD4BC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:08:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E397D127EF344;
        Mon, 20 Apr 2020 12:08:52 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:08:52 -0700 (PDT)
Message-Id: <20200420.120852.1760351661811004198.davem@davemloft.net>
To:     lu@pplo.net
Cc:     sbrivio@redhat.com, netdev@vger.kernel.org, dsahern@gmail.com,
        sd@queasysnail.net
Subject: Re: [PATCH net-next] selftests: pmtu: implement IPIP, SIT and
 ip6tnl PMTU discovery tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419091651.22714-1-lu@pplo.net>
References: <20200419091651.22714-1-lu@pplo.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:08:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lourdes Pedrajas <lu@pplo.net>
Date: Sun, 19 Apr 2020 11:16:51 +0200

> Add PMTU discovery tests for these encapsulations:
> 
> - IPIP
> - SIT, mode ip6ip
> - ip6tnl, modes ip6ip6 and ipip6
> 
> Signed-off-by: Lourdes Pedrajas <lu@pplo.net>
> Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

Applied, thanks.
