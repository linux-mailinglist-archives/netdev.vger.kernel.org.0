Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F52EA4AF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfJ3U0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:26:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45604 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfJ3U0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 16:26:07 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5523B14B4DFD2;
        Wed, 30 Oct 2019 13:26:06 -0700 (PDT)
Date:   Wed, 30 Oct 2019 13:26:03 -0700 (PDT)
Message-Id: <20191030.132603.660608420230887954.davem@davemloft.net>
To:     mrv@mojatatu.com
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next 1/1] tc-testing: fixed two failing pedit tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572462523-18279-1-git-send-email-mrv@mojatatu.com>
References: <1572462523-18279-1-git-send-email-mrv@mojatatu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 13:26:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>
Date: Wed, 30 Oct 2019 15:08:43 -0400

> Two pedit tests were failing due to incorrect operation
> value in matchPattern, should be 'add' not 'val', so fix it.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied.
