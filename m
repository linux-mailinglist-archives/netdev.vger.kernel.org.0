Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B44825FE
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbfHEUUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:20:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:20:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D455B154316C0;
        Mon,  5 Aug 2019 13:20:42 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:20:42 -0700 (PDT)
Message-Id: <20190805.132042.1186329327655280064.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: Add l2tp tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801235421.8344-1-dsahern@kernel.org>
References: <20190801235421.8344-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:20:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  1 Aug 2019 16:54:21 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Add IPv4 and IPv6 l2tp tests. Current set is over IP and with
> IPsec.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
> The ipsec tests expose a netdev refcount leak that I have not had
> time to track down, but the tests themselves are good.

Don't you need to add this to the Makefile too?
