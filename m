Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6DEF58980
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfF0SIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:08:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57676 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfF0SIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 14:08:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9929F133E98DF;
        Thu, 27 Jun 2019 11:08:52 -0700 (PDT)
Date:   Thu, 27 Jun 2019 11:08:52 -0700 (PDT)
Message-Id: <20190627.110852.372215308913618999.davem@davemloft.net>
To:     maheshb@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, dja@axtens.net, mahesh@bandewar.net
Subject: Re: [PATCH next 3/3] blackhole_dev: add a selftest
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190622004539.92199-1-maheshb@google.com>
References: <20190622004539.92199-1-maheshb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Jun 2019 11:08:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mahesh Bandewar <maheshb@google.com>
Date: Fri, 21 Jun 2019 17:45:39 -0700

> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -4,8 +4,9 @@
>  CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
>  CFLAGS += -I../../../../usr/include/
>  
> +<<<<<<< HEAD
>  TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \

Ummm... yeah... might want to resolve this conflict...

:-)
