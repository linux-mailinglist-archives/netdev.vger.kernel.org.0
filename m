Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C98476F1
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 23:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfFPVOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 17:14:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52292 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfFPVOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 17:14:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ECCA151C3454;
        Sun, 16 Jun 2019 14:14:35 -0700 (PDT)
Date:   Sun, 16 Jun 2019 14:14:34 -0700 (PDT)
Message-Id: <20190616.141434.864681460861309977.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-tests: updated skbedit tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560630350-23799-1-git-send-email-mrv@mojatatu.com>
References: <1560630350-23799-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Jun 2019 14:14:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Sat, 15 Jun 2019 16:25:50 -0400

> - Added index upper bound test case
> - Added mark upper bound test case
> - Re-worded descriptions to few cases for clarity
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
