Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33F7E62CB8
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfGHXhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:37:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfGHXhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:37:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9C81112E4E44D;
        Mon,  8 Jul 2019 16:37:49 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:37:48 -0700 (PDT)
Message-Id: <20190708.163748.2001268775877600654.davem@davemloft.net>
To:     ssuryaextr@gmail.com
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        nikolay@cumulusnetworks.com, dsahern@gmail.com
Subject: Re: [PATCH net-next v2 0/3] net: Multipath hashing on inner L3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190706145519.13488-1-ssuryaextr@gmail.com>
References: <20190706145519.13488-1-ssuryaextr@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:37:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>
Date: Sat,  6 Jul 2019 10:55:16 -0400

> This series extends commit 363887a2cdfe ("ipv4: Support multipath
> hashing on inner IP pkts for GRE tunnel") to include support when the
> outer L3 is IPv6 and to consider the case where the inner L3 is
> different version from the outer L3, such as IPv6 tunneled by IPv4 GRE
> or vice versa. It also includes kselftest scripts to test the use cases.
> 
> v2: Clarify the commit messages in the commits in this series to use the
>     term tunneled by IPv4 GRE or by IPv6 GRE so that it's clear which
>     one is the inner and which one is the outer (per David Miller).

Series applied, thanks.
