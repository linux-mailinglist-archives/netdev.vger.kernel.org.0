Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D9563D19
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfGIVIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:08:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45586 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGIVID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:08:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14A9E14187BAF;
        Tue,  9 Jul 2019 14:08:03 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:08:00 -0700 (PDT)
Message-Id: <20190709.140800.430247967116331219.davem@davemloft.net>
To:     lucasb@mojatatu.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com
Subject: Re: [PATCH net-next 0/2] tc-testing: Add plugin for simple traffic
 generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
References: <1562636067-1338-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:08:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucas Bates <lucasb@mojatatu.com>
Date: Mon,  8 Jul 2019 21:34:25 -0400

> This series supersedes the previous submission that included a patch for test
> case verification using JSON output.  It adds a new tdc plugin, scapyPlugin, as
> a way to send traffic to test tc filters and actions.
> 
> The first patch makes a change to the TdcPlugin module that will allow tdc
> plugins to examine the test case currently being executed, so plugins can
> play a more active role in testing by accepting information or commands from
> the test case.  This is required for scapyPlugin to work.
> 
> The second patch adds scapyPlugin itself, and an example test case file to
> demonstrate how the scapy block works in the test cases.

So I'm going to apply this series for now, and I encourage you folks
to continue eval() and python knowledge discussion further.

Thanks.
