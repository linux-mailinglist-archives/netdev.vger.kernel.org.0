Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93DA6190D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 03:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfGHB5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 21:57:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45046 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfGHB5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 21:57:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09A8A15288A2F;
        Sun,  7 Jul 2019 18:57:22 -0700 (PDT)
Date:   Sun, 07 Jul 2019 18:57:21 -0700 (PDT)
Message-Id: <20190707.185721.383185193925579054.davem@davemloft.net>
To:     lucasb@mojatatu.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 0/3] tc-testing: Add JSON verification and
 simple traffic generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
References: <1562201102-4332-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 18:57:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucas Bates <lucasb@mojatatu.com>
Date: Wed,  3 Jul 2019 20:44:59 -0400

> This patchset introduces JSON as a verification method in tdc and adds a new
> plugin, scapyPlugin, as a way to send traffic to test tc filters and actions.
> This version includes the patch signoffs missing in the previous submission.
> 
> The first patch adds the JSON verification to the core tdc script.
> 
> The second patch makes a change to the TdcPlugin module that will allow tdc
> plugins to examine the test case currently being executed, such that plugins
> can play a more active role in testing. This feature is needed for the
> new plugin.
> 
> The third patch adds the scapyPlugin itself, and an example test case file to
> demonstrate how the scapy block works.

Lucas, please address the feedback about using eval().

Thank you.
