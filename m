Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050DE45402
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 07:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfFNFcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 01:32:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37216 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfFNFcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 01:32:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8649814DD4FC8;
        Thu, 13 Jun 2019 22:32:42 -0700 (PDT)
Date:   Thu, 13 Jun 2019 22:32:39 -0700 (PDT)
Message-Id: <20190613.223239.468775158662850628.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-tests: updated fw with bind actions by
 reference use cases
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560261742-20962-1-git-send-email-mrv@mojatatu.com>
References: <1560261742-20962-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Jun 2019 22:32:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Tue, 11 Jun 2019 10:02:22 -0400

> Extended fw TDC tests with use cases where actions are pre-created and
> attached to a filter by reference, i.e. by action index.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
