Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904696768E
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 00:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbfGLWds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 18:33:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34300 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbfGLWds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 18:33:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2D33914E01C3C;
        Fri, 12 Jul 2019 15:33:48 -0700 (PDT)
Date:   Fri, 12 Jul 2019 15:33:46 -0700 (PDT)
Message-Id: <20190712.153346.208176416382249475.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-tests: updated skbedit tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562862540-16509-1-git-send-email-mrv@mojatatu.com>
References: <1562862540-16509-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 15:33:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Thu, 11 Jul 2019 12:29:00 -0400

> - Added mask upper bound test case
> - Added mask validation test case
> - Added mask replacement case
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

New tests I'll allow still now, applied, thanks.
