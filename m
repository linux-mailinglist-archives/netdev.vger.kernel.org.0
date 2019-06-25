Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7F55839
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfFYT5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:57:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49998 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfFYT5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:57:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3696126A208E;
        Tue, 25 Jun 2019 12:57:41 -0700 (PDT)
Date:   Tue, 25 Jun 2019 12:57:40 -0700 (PDT)
Message-Id: <20190625.125740.86510337174611950.davem@davemloft.net>
To:     lucasb@mojatatu.com
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        kernel@mojatatu.com
Subject: Re: [PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
References: <1561424427-9949-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 12:57:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucas Bates <lucasb@mojatatu.com>
Date: Mon, 24 Jun 2019 21:00:27 -0400

> This patch restores the original behaviour for tdc prior to the
> introduction of the plugin system, where the network namespace
> functionality was split from the main script.
> 
> It introduces the concept of required plugins for testcases,
> and will automatically load any plugin that isn't already
> enabled when said plugin is required by even one testcase.
> 
> Additionally, the -n option for the nsPlugin is deprecated
> so the default action is to make use of the namespaces.
> Instead, we introduce -N to not use them, but still create
> the veth pair.
> 
> buildebpfPlugin's -B option is also deprecated.
> 
> If a test cases requires the features of a specific plugin
> in order to pass, it should instead include a new key/value
> pair describing plugin interactions:
> 
>         "plugins": {
>                 "requires": "buildebpfPlugin"
>         },
> 
> A test case can have more than one required plugin: a list
> can be inserted as the value for 'requires'.
> 
> Signed-off-by: Lucas Bates <lucasb@mojatatu.com>

Applied.
