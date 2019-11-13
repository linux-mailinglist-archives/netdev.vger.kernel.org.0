Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CD2FA76C
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfKMDkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:40:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54336 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfKMDkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:40:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FD7D154FF66A;
        Tue, 12 Nov 2019 19:40:33 -0800 (PST)
Date:   Tue, 12 Nov 2019 19:40:32 -0800 (PST)
Message-Id: <20191112.194032.230763417436958297.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: Introduced tdc tests for
 basic filter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573505730-2553-1-git-send-email-mrv@mojatatu.com>
References: <1573505730-2553-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Nov 2019 19:40:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Mon, 11 Nov 2019 15:55:30 -0500

> Added tests for 'cmp' extended match rules.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
