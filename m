Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEAE5EB8C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfGCS0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:26:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60486 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbfGCS0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:26:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4640140CFF5C;
        Wed,  3 Jul 2019 11:26:06 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:26:06 -0700 (PDT)
Message-Id: <20190703.112606.242654635432751506.davem@davemloft.net>
To:     lucasb@mojatatu.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, mleitner@redhat.com, vladbu@mellanox.com,
        dcaratti@redhat.com, kernel@mojatatu.com
Subject: Re: [PATCH net-next 0/3] tc-testing: Add JSON verification and
 simple traffic generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
References: <1562121681-9365-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:26:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This entire patch series lacks proper signoffs.
