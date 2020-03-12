Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0A183CC1
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgCLWrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:47:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCLWrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:47:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9B401584239F;
        Thu, 12 Mar 2020 15:47:11 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:47:11 -0700 (PDT)
Message-Id: <20200312.154711.1843070627361339885.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     mrv@mojatatu.com, jhs@mojatatu.com, marcelo.leitner@gmail.com,
        vladbu@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] tc-testing: add ETS scheduler to tdc build
 configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dcff461f45a5dc4a403dcbe020caeee607e7c5dc.1584031891.git.dcaratti@redhat.com>
References: <dcff461f45a5dc4a403dcbe020caeee607e7c5dc.1584031891.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:47:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Thu, 12 Mar 2020 17:51:45 +0100

> add CONFIG_NET_SCH_ETS to 'config', otherwise test suites using this file
> to perform a full tdc run will encounter the following warning:
> 
>   ok 645 e90e - Add ETS qdisc using bands # skipped - "-----> teardown stage" did not complete successfully
> 
> Fixes: 82c664b69c8b ("selftests: qdiscs: Add test coverage for ETS Qdisc")
> Reported-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thank you.
