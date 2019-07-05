Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4E60DB0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbfGEWTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:19:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43356 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfGEWTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:19:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 481F615041436;
        Fri,  5 Jul 2019 15:19:23 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:19:22 -0700 (PDT)
Message-Id: <20190705.151922.1652415160614892448.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        nikolay@cumulusnetworks.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 1/3] ipv4: Multipath hashing on inner L3 needs
 to consider inner IPv6 pkts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190703151934.9567-2-ssuryaextr@gmail.com>
References: <20190703151934.9567-1-ssuryaextr@gmail.com>
        <20190703151934.9567-2-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:19:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Wed,  3 Jul 2019 11:19:32 -0400

> Commit 363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts
> for GRE tunnel") supports multipath policy value of 2, Layer 3 or inner
> Layer 3 if present, but it only considers inner IPv4. There is a use
> case of IPv6 over GRE over IPv4, thus add the ability to hash on inner
> IPv6 addresses.
> 
> Fixes: 363887a2cdfe ("ipv4: Support multipath hashing on inner IP pkts for GRE tunnel")
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

The wording in this commit message is very confusing.

If you say "IPv6 over GRE over IPv4" then IPv6 is the outer protocol
type, not the inner one.

You need to clarify or reword this commit message so that it is
understandable and matches the logic.

Thanks.
