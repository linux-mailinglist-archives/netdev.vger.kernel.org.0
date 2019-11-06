Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24737F1E57
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 20:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732027AbfKFTMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 14:12:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbfKFTMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 14:12:52 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1CB7F14B8F823;
        Wed,  6 Nov 2019 11:12:52 -0800 (PST)
Date:   Wed, 06 Nov 2019 11:12:51 -0800 (PST)
Message-Id: <20191106.111251.1218278888599515718.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated pedit TDC tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572990208-30003-1-git-send-email-mrv@mojatatu.com>
References: <1572990208-30003-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 11:12:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Tue,  5 Nov 2019 16:43:28 -0500

> Added tests for u8/u32 clear value, u8/16 retain value, u16/32 invert value,
> u8/u16/u32 preserve value and test for negative offsets.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
