Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BEB7214C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbfGWVIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:08:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36816 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbfGWVIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:08:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 640D8153BF135;
        Tue, 23 Jul 2019 14:08:34 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:08:34 -0700 (PDT)
Message-Id: <20190723.140834.403864886929380628.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: added tdc tests for [b|p]fifo
 qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1563908519-30111-1-git-send-email-mrv@mojatatu.com>
References: <1563908519-30111-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:08:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Tue, 23 Jul 2019 15:01:59 -0400

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Always love to see new tests...  Applied.
