Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DC77D196
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbfGaWys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:54:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45080 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfGaWys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:54:48 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 38EFA1264DFCF;
        Wed, 31 Jul 2019 15:54:47 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:54:46 -0400 (EDT)
Message-Id: <20190731.185446.1493596264763518954.davem@davemloft.net>
To:     lucasb@mojatatu.com
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        mleitner@redhat.com, vladbu@mellanox.com, dcaratti@redhat.com,
        kernel@mojatatu.com
Subject: Re: [PATCH v2 net-next 1/1] tc-testing: Clarify the use of tdc's
 -d option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564442292-4731-1-git-send-email-lucasb@mojatatu.com>
References: <1564442292-4731-1-git-send-email-lucasb@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:54:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucas Bates <lucasb@mojatatu.com>
Date: Mon, 29 Jul 2019 19:18:12 -0400

> The -d command line argument to tdc requires the name of a physical device
> on the system where the tests will be run. If -d has not been used, tdc
> will skip tests that require a physical device.
> 
> This patch is intended to better document what the -d option does and how
> it is used.
> 
> Signed-off-by: Lucas Bates <lucasb@mojatatu.com>

Applied.
