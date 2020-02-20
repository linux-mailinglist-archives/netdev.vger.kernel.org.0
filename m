Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42FC91653B1
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgBTAkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:40:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49728 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgBTAkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:40:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB3B515BD950B;
        Wed, 19 Feb 2020 16:40:11 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:40:11 -0800 (PST)
Message-Id: <20200219.164011.1927016012983360173.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: updated tdc tests for basic
 filter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1582148276-6955-1-git-send-email-mrv@mojatatu.com>
References: <1582148276-6955-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:40:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Wed, 19 Feb 2020 16:37:56 -0500

> Added tests for 'u32' extended match rules for u8 alignment.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
