Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF69169D1B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 05:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgBXEmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 23:42:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58966 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbgBXEmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 23:42:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CFB4714E83DD5;
        Sun, 23 Feb 2020 20:42:00 -0800 (PST)
Date:   Sun, 23 Feb 2020 20:41:58 -0800 (PST)
Message-Id: <20200223.204158.1171985923476223553.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated tdc tests for basic
 filter with u32 extended match rules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582485156-5632-1-git-send-email-mrv@mojatatu.com>
References: <1582485156-5632-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 20:42:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sun, 23 Feb 2020 14:12:36 -0500

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied, thank you.
