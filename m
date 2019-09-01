Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6976A47FC
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfIAGzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:55:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34846 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728811AbfIAGzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:55:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B47CB14CDDC58;
        Sat, 31 Aug 2019 23:47:52 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:47:52 -0700 (PDT)
Message-Id: <20190831.234752.1426223368664771629.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     liuhangbin@gmail.com, mrv@mojatatu.com, vladbu@mellanox.com,
        lucasb@mojatatu.com, nicolas.dichtel@6wind.com,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net] tc-testing: don't hardcode 'ip' in nsPlugin.py
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8ade839e21c5231d2d6b8690b39587f802642306.1567180765.git.dcaratti@redhat.com>
References: <8ade839e21c5231d2d6b8690b39587f802642306.1567180765.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:47:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 30 Aug 2019 18:51:47 +0200

> the following tdc test fails on Fedora:
> 
>  # ./tdc.py -e 2638
>   -- ns/SubPlugin.__init__
>  Test 2638: Add matchall and try to get it
>  -----> prepare stage *** Could not execute: "$TC qdisc add dev $DEV1 clsact"
>  -----> prepare stage *** Error message: "/bin/sh: ip: command not found"
>  returncode 127; expected [0]
>  -----> prepare stage *** Aborting test run.
> 
> Let nsPlugin.py use the 'IP' variable introduced with commit 92c1a19e2fb9
> ("tc-tests: added path to ip command in tdc"), so that the path to 'ip' is
> correctly resolved to the value we have in tdc_config.py.
> 
>  # ./tdc.py -e 2638
>   -- ns/SubPlugin.__init__
>  Test 2638: Add matchall and try to get it
>  All test results:
>  1..1
>  ok 1 2638 - Add matchall and try to get it
> 
> Fixes: 489ce2f42514 ("tc-testing: Restore original behaviour for namespaces in tdc")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied.
