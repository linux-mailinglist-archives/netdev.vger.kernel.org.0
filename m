Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1258446DDE
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfFOCnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:43:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:43:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C1A21263F1F2;
        Fri, 14 Jun 2019 19:43:08 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:43:08 -0700 (PDT)
Message-Id: <20190614.194308.428822513461761521.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com
Subject: Re: [PATCH net-next v3] ipv4: Support multipath hashing on inner
 IP pkts for GRE tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190613183858.9892-1-ssuryaextr@gmail.com>
References: <20190613183858.9892-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Jun 2019 19:43:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Thu, 13 Jun 2019 14:38:58 -0400

> Multipath hash policy value of 0 isn't distributing since the outer IP
> dest and src aren't varied eventhough the inner ones are. Since the flow
> is on the inner ones in the case of tunneled traffic, hashing on them is
> desired.
> 
> This is done mainly for IP over GRE, hence only tested for that. But
> anything else supported by flow dissection should work.
> 
> v2: Use skb_flow_dissect_flow_keys() directly so that other tunneling
>     can be supported through flow dissection (per Nikolay Aleksandrov).
> v3: Remove accidental inclusion of ports in the hash keys and clarify
>     the documentation (Nikolay Alexandrov).
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>

Applied.
