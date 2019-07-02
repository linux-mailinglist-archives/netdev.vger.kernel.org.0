Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A8B5C711
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGBCVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:21:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfGBCVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:21:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 711BA14DE97C4;
        Mon,  1 Jul 2019 19:21:04 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:21:03 -0700 (PDT)
Message-Id: <20190701.192103.547890746964431102.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: added tdc tests for prio qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1561757521-15439-1-git-send-email-mrv@mojatatu.com>
References: <1561757521-15439-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:21:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Fri, 28 Jun 2019 17:32:01 -0400

> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
